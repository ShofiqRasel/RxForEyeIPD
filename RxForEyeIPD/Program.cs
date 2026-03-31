using Microsoft.AspNetCore.Authentication.Cookies;
using Microsoft.AspNetCore.HttpOverrides;
using RxForEyeIPD.Components;
using RxForEyeIPD.Components.Pages.DynamicFileCreator.Users.CsScript;
using RxForEyeIPD.Extensions;
using Syncfusion.Blazor;


var builder = WebApplication.CreateBuilder(args);

// Register Syncfusion license (you can use community/free trial license)
Syncfusion.Licensing.SyncfusionLicenseProvider.RegisterLicense("Ngo9BigBOggjHTQxAR8/V1JHaF5cWWdCf1FpRmJGdld5fUVHYVZUTXxaS00DNHVRdkdlWXxccnRQRGhcVkFwVkFWYEo=");


// Add services to the container.
builder.Services.AddRazorComponents()
    .AddInteractiveServerComponents();

builder.Services.AddSyncfusionBlazor();

builder.Services.AddInterfaceApplicationServices();

builder.Services.AddAuthorization(options =>
{
    foreach (var policy in UserPolicy.GetPolicies())
    {
        options.AddPolicy(policy, e => e.RequireClaim(policy));
    }
});

builder.Services.AddHttpContextAccessor();

//Example Code Block: Define a policy named "ManagementOnly" that requires EITHER Admin OR Manager OR CEO
//builder.Services.AddAuthorization(options =>
//{
//    // Define a policy named "ManagementOnly" that requires EITHER Admin OR Manager
//    options.AddPolicy("ManagementOnly", policy =>
//        policy.RequireRole("Admin", "Manager", "CEO"));
//});

//< AuthorizeView Policy = "ManagementOnly" >
//    < Authorized >
//        < button class= "btn btn-primary" > Manage Staff </ button >
//    </ Authorized >
//</ AuthorizeView >

builder.Services.AddAuthentication(CookieAuthenticationDefaults.AuthenticationScheme)
    .AddCookie(options =>
    {
        options.Cookie.Name = "auth_token";
        options.LoginPath = "/login";
        options.Cookie.MaxAge = TimeSpan.FromDays(1);
        options.AccessDeniedPath = "/access-denied";
        options.Cookie.HttpOnly = true; //prevent client-side scripts (javascript) from accessing the cookie
        //options.Cookie.SecurePolicy = CookieSecurePolicy.Always; //ensure the cookie is only sent over HTTPS
        options.Cookie.SecurePolicy = CookieSecurePolicy.SameAsRequest; //allow the cookie to be sent over HTTP during development, but require HTTPS in production
    });

builder.Services.AddCascadingAuthenticationState();


var app = builder.Build();

// Configure the HTTP request pipeline.
if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/Error", createScopeForErrors: true);
    // The default HSTS value is 30 days. You may want to change this for production scenarios, see https://aka.ms/aspnetcore-hsts.
    app.UseHsts();
}

// Configuration for Get IpAddress from Client
app.UseForwardedHeaders(new ForwardedHeadersOptions
{
    ForwardedHeaders = ForwardedHeaders.XForwardedFor | ForwardedHeaders.XForwardedProto
});
// Configuration for Get IpAddress from Client

app.UseHttpsRedirection();

app.UseStaticFiles();
app.UseAntiforgery();

app.UseAuthentication();   // 🔑 MUST come before authorization
app.UseAuthorization();

app.MapRazorComponents<App>()
    .AddInteractiveServerRenderMode();

app.Run();