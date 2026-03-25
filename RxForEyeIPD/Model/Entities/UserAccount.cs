using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace RxForEyeIPD.Model.Entities
{
    [Table("user_accounts")]
    public class UserAccount
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int Id { get; set; }

        [Column("user_name")]
        [MaxLength(100)]
        public string? UserName { get; set; }

        [Column("password")]
        [MaxLength(100)]
        public string? Password { get; set; }

        [Column("role")]
        [MaxLength(20)]
        public string? Role { get; set; }
    }
}
