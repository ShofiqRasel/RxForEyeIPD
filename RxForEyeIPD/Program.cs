using Microsoft.AspNetCore.Authentication.Cookies;
using RxForEyeIPD.Components;
using RxForEyeIPD.Components.Pages.Settings.Account.CsScript;
using RxForEyeOPD.Extensions;
using Syncfusion.Blazor;

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
        options.Cookie.HttpOnly = true; //prevent client-side scripts (javascript) from accessing the cookie
        options.Cookie.SecurePolicy = CookieSecurePolicy.Always; //ensure the cookie is only sent over HTTPS
        options.Cookie.SameSite = SameSiteMode.Lax;
    });

builder.Services.AddCascadingAuthenticationState();


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

app.UseAntiforgery();

app.MapRazorComponents<App>()
    .AddInteractiveServerRenderMode();

app.Run();
