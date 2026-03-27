namespace RxForEyeIPD.Components.Pages.DynamicFileCreator.Users.CsScript
{
    public class UserPolicy
    {
        public const string ViewPermission = "ViewPermission";
        public const string AddPermission = "AddPermission";
        public const string EditPermission = "EditPermission";
        public const string DeletePermission = "DeletePermission";
   

    public static List<string> GetPolicies()
        {
            return new List<string>
            {
                ViewPermission,
                AddPermission,
                EditPermission,
                DeletePermission
            };

        }
    }
}
