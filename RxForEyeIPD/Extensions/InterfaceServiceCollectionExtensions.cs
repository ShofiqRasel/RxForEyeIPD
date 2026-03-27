
using RxForEyeIPD.Components.Pages.DynamicFileCreator.BaseHospital.CsScript;
using RxForEyeIPD.Components.Pages.DynamicFileCreator.Users.CsScript;
using static RxForEyeIPD.Components.Pages.Settings.LocationMaster.BranchUnit.srvBranchUnit;
using static RxForEyeIPD.Components.Pages.Settings.LocationMaster.UserRole.srvUserRole;
using static RxForEyeIPD.Components.Pages.Settings.LocationMaster.Users.srvUsers;

namespace RxForEyeIPD.Extensions
{
    public static class InterfaceServiceCollectionExtensions
    {
        public static IServiceCollection AddInterfaceApplicationServices(this IServiceCollection services)
        {
            services.AddScoped<IBaseHospital, BaseHospitalRepository>();
            services.AddScoped<IBranchUnit, BranchUnitRepository>();
            services.AddScoped<IUsers, UsersRepository>();
            services.AddScoped<IBranchUnit, BranchUnitRepository>();
            services.AddScoped<IUserRole, UserRoleRepository>();
            services.AddScoped<IUserDTO, srvUserDTO>();
            return services;
        }
    }
}
