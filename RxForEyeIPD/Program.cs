using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authentication.Cookies;
using RxForEyeIPD.Components;
using RxForEyeIPD.Components.Pages.Settings.Account.CsScript;
using RxForEyeOPD.Extensions;
using Syncfusion.Blazor;
using System.Security.Claims;
using static RxForEyeIPD.Components.Pages.Settings.LocationMaster.Users.srvUsers;

var builder = WebApplication.CreateBuilder(args);

// Register Syncfusion license (you can use community/free trial license)
Syncfusion.Licensing.SyncfusionLicenseProvider.RegisterLicense("Ngo9BigBOggjHTQxAR8/V1JHaF5cWWdCf1FpRmJGdld5fUVHYVZUTXxaS00DNHVRdkdlWXxccnRQRGhcVkFwVkFWYEo=");


// Add services to the container.
builder.Services.AddRazorComponents()
    .AddInteractiveServerComponents();
builder.Services.AddSyncfusionBlazor();


/// Add service collections for interfaces and application services (Extensions Folder Files)
builder.Services.AddInterfaceApplicationServices();

builder.Services.AddHttpContextAccessor();

builder.Services.AddHttpClient();

builder.Services.AddAuthorization(options =>
{
    foreach (var policy in UserPolicy.GetPolicies())
    {
        options.AddPolicy(policy, e => e.RequireClaim(policy));
    }
});

builder.Services.AddAuthentication(CookieAuthenticationDefaults.AuthenticationScheme)
    .AddCookie(options =>
    {
        options.Cookie.Name = "auth_token";
        options.LoginPath = "/login";
        options.Cookie.MaxAge = TimeSpan.FromDays(1);
        options.AccessDeniedPath = "/access-denied";
        options.Cookie.HttpOnly = true;

        // Change 'Always' to 'SameAsRequest' so it works on your localhost
        options.Cookie.SecurePolicy = CookieSecurePolicy.SameAsRequest;

        options.Cookie.SameSite = SameSiteMode.Lax;
    });

builder.Services.AddCascadingAuthenticationState();

builder.Services.AddAuthorization(options =>
{
    foreach (var policy in UserPolicy.GetPolicies())
    {
        // Explicitly require the claim to be "true" to match your Login logic
        options.AddPolicy(policy, p => p.RequireClaim(policy, "true"));
    }
});
var app = builder.Build();

if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/Error", true);
    app.UseHsts();
}

app.UseHttpsRedirection();

app.UseStaticFiles();   // ✅ IMPORTANT
app.UseRouting();       // ✅ IMPORTANT

app.UseAuthentication(); // ✅ MUST be before authorization
app.UseAuthorization();





app.MapPost("/login-api", async (
    HttpContext http,
    IUsers usersService,
    IUserAccountPolicy userAccountPolicy,
    LoginViewModel model) =>
{
    var user = await usersService.AuthenticateUser(model.UserName, model.Password);

    if (user == null)
        return Results.Unauthorized();

    var claims = new List<Claim>
    {
        new Claim(ClaimTypes.Name, user.UserName),
        new Claim(ClaimTypes.NameIdentifier, user.UserId.ToString())
    };

    var policies = await userAccountPolicy.GetuserAccountPolicies(user.UserId);

    foreach (var p in policies)
    {
        claims.Add(new Claim(p.AssingnUserPolicy, "true"));
    }

    var identity = new ClaimsIdentity(claims, CookieAuthenticationDefaults.AuthenticationScheme);
    var principal = new ClaimsPrincipal(identity);

    await http.SignInAsync(principal); // ✅ REAL HTTP CONTEXT

    return Results.Ok();
});

app.UseAntiforgery();

app.MapRazorComponents<App>()
    .AddInteractiveServerRenderMode();

app.Run();
