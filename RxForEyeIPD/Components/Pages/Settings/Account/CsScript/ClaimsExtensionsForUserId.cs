using System.Security.Claims;

namespace RxForEyeIPD.Components.Pages.Settings.Account.CsScript
{
    public static class ClaimsExtensionsForUserId
    {
        public static int? GetUserId(this ClaimsPrincipal user)
        {
            var value = user.FindFirst(ClaimTypes.NameIdentifier)?.Value;
            return int.TryParse(value, out var id) ? id : null;
        }
    }
}
