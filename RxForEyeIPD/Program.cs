using RxForEyeIPD.Components;
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
//builder.Services.AddApplicationServices();
//builder.Services.AddIhmsServices();


//builder.Services.AddAuthorization(options =>
//{
//    foreach (var policy in UserPolicy.GetPolicies())
//    {
//        options.AddPolicy(policy, e => e.RequireClaim(policy));
//    }
//});

//builder.Services.AddAuthentication(CookieAuthenticationDefaults.AuthenticationScheme)
//    .AddCookie(options =>
//    {
//        options.Cookie.Name = "auth_token";
//        options.LoginPath = "/login";
//        options.Cookie.MaxAge = TimeSpan.FromDays(1);
//        options.AccessDeniedPath = "/access-denied";
//        options.Cookie.HttpOnly = true; //prevent client-side scripts (javascript) from accessing the cookie
//        options.Cookie.SecurePolicy = CookieSecurePolicy.Always; //ensure the cookie is only sent over HTTPS
//        options.Cookie.SameSite = SameSiteMode.Lax;
//    });

//builder.Services.AddCascadingAuthenticationState();


var app = builder.Build();

// Configure the HTTP request pipeline.
if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/Error", createScopeForErrors: true);
    // The default HSTS value is 30 days. You may want to change this for production scenarios, see https://aka.ms/aspnetcore-hsts.
    app.UseHsts();
}
app.UseStatusCodePagesWithReExecute("/not-found", createScopeForStatusCodePages: true);
app.UseHttpsRedirection();

app.UseAntiforgery();

app.MapStaticAssets();

//app.UseAuthentication();
//app.UseAuthorization();


app.MapRazorComponents<App>()
    .AddInteractiveServerRenderMode();

app.Run();
