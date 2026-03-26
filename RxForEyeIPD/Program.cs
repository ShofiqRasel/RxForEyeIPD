using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authentication.Cookies;
using RxForEyeIPD.Components;
using RxForEyeIPD.Components.Pages.Settings.Account.CsScript;
using RxForEyeIPD.Services;
using Microsoft.AspNetCore.Authentication.Cookies;
using Microsoft.EntityFrameworkCore;

using RxForEyeIPD.Extensions;
using Syncfusion.Blazor;
using System.Security.Claims;
using static RxForEyeIPD.Components.Pages.Settings.LocationMaster.Users.srvUsers;
using RxForEyeIPD.Model;

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

builder.Services.AddAuthentication(CookieAuthenticationDefaults.AuthenticationScheme)
    .AddCookie(options =>
    {
        options.Cookie.Name = "auth_token";
        options.LoginPath = "/login";
        options.Cookie.MaxAge = TimeSpan.FromMinutes(30);
        options.AccessDeniedPath = "/access-denied";
        options.Cookie.HttpOnly = true; //prevent client-side scripts (javascript) from accessing the cookie
        options.Cookie.SecurePolicy = CookieSecurePolicy.Always; //ensure the cookie is only sent over HTTPS
    });

builder.Services.AddCascadingAuthenticationState();


builder.Services.AddScoped<clsAdoDotNetFroUser>();


var app = builder.Build();

// Configure the HTTP request pipeline.
if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/Error", createScopeForErrors: true);
    // The default HSTS value is 30 days. You may want to change this for production scenarios, see https://aka.ms/aspnetcore-hsts.
    app.UseHsts();
}

app.UseHttpsRedirection();

app.UseStaticFiles();
app.UseAntiforgery();

app.UseAuthentication();   // 🔑 MUST come before authorization
app.UseAuthorization();

app.MapRazorComponents<App>()
    .AddInteractiveServerRenderMode();

app.Run();