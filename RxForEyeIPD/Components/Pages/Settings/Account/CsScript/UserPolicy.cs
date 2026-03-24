namespace RxForEyeIPD.Components.Pages.Settings.Account.CsScript
{
    public class UserPolicy
    {
        public const string VIEW_PRODUCT = "VIEW_PRODUCT";
        public const string ADD_PRODUCT = "ADD_PRODUCT";
        public const string EDIT_PRODUCT = "EDIT_PRODUCT";
        public const string DELETE_PRODUCT = "DELETE_PRODUCT";

        public static List<string> GetPolicies()
        {
            return new List<string>
            {
                VIEW_PRODUCT,
                ADD_PRODUCT,
                EDIT_PRODUCT,
                DELETE_PRODUCT
            };

        }
    }
}
