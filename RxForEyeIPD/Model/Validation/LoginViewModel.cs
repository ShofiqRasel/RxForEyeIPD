using System.ComponentModel.DataAnnotations;

namespace RxForEyeIPD.Model.Validation
{
    public class LoginViewModel
    {
        [Required(AllowEmptyStrings=false, ErrorMessage ="Please Enter User Name")]
        public string? UserName { get; set; }

        [Required(AllowEmptyStrings = false, ErrorMessage = "Please Enter Password")]
        public string? Password { get; set; }
    }
}
