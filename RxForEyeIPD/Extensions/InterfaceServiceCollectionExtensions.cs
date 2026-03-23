
using RxForEyeIPD.Components.Pages.DynamicFileCreator.BaseHospital.CsScript;
using static RxForEyeIPD.Components.Pages.Settings.LocationMaster.BranchUnit.srvBranchUnit;
using static RxForEyeIPD.Components.Pages.Settings.LocationMaster.User.srvUser;

namespace RxForEyeOPD.Extensions
{
    public static class InterfaceServiceCollectionExtensions
    {
        public static IServiceCollection AddInterfaceApplicationServices(this IServiceCollection services)
        {
            services.AddScoped<IBaseHospital, BaseHospitalRepository>();
            services.AddScoped<IBranchUnit, BranchUnitRepository>();
            services.AddScoped<IUser, UserRepository>();
            services.AddScoped<IBranchUnit, BranchUnitRepository>();
            return services;
        }
    }
}
