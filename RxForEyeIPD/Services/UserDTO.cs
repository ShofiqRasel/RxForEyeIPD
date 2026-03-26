using Microsoft.Data.SqlClient;
using System.ComponentModel.DataAnnotations;

namespace RxForEyeIPD.Services
{
    public class UserAccountPolicy
    {
        public int PolicyId { get; set; }

        public int UserId { get; set; }

        public string? AssingnUserPolicy { get; set; }

        public bool IsEnabled { get; set; }
    }

    public class LoginViewModel
    {
        [Required(AllowEmptyStrings = false, ErrorMessage = "Please Enter User Name")]
        public string UserName { get; set; } = string.Empty;

        [Required(AllowEmptyStrings = false, ErrorMessage = "Please Enter Password")]
        public string Password { get; set; } = string.Empty;
    }

    public class UserDTOEntity
    {
        public int UserId { get; set; }
        [Required(AllowEmptyStrings = false, ErrorMessage = "Please Enter User Name")]
        public string UserName { get; set; } = string.Empty;
        public string UserRole { get; set; } = string.Empty;
    }

    public interface IUserDTO
    {
        Task<List<string>> GetPoliciesAsync();
        Task<UserDTOEntity> GetUserDetail(string userName, string plainPassword);
        Task<List<UserAccountPolicy>> GetuserAccountPolicies(int userId);
    }
    public class srvUserDTO(IConfiguration Configuration): IUserDTO
    {
        public async Task<List<string>> GetPoliciesAsync()
        {
            var policies = new List<string>();

            string connectionString = Configuration.GetConnectionString("ConStrRxForEyeIPD")
                ?? throw new InvalidOperationException("Connection string not found.");

            string query = @"
            set dateformat dmy 
            select PolicyName FROM UserPolicy where IsActive='Yes'";

            using SqlConnection con = new(connectionString);
            using SqlCommand cmd = new(query, con);

            await con.OpenAsync();
            using var dr = await cmd.ExecuteReaderAsync();

            while (await dr.ReadAsync())
            {
                policies.Add(dr["PolicyName"].ToString()!);
            }

            return policies;
        }

        public async Task<UserDTOEntity?> GetUserDetail(string userName, string plainPassword)
        {
            try
            {
                string connectionString = Configuration.GetConnectionString("ConStrRxForEyeIPD")
                    ?? throw new InvalidOperationException("Connection string not found.");

                string query = @"
        SELECT u.UserId, u.UserName, u.UserPassword, ur.UserRoleName 
        FROM Users u
        INNER JOIN UserRole ur ON u.UserRoleId = ur.UserRoleId
        WHERE u.UserName = @userName AND u.IsActive = 'Yes'";

                using SqlConnection con = new(connectionString);
                using SqlCommand cmd = new(query, con);
                cmd.Parameters.AddWithValue("@userName", userName);

                await con.OpenAsync();
                using SqlDataReader dr = await cmd.ExecuteReaderAsync();

                if (await dr.ReadAsync())
                {
                    string storedHash = dr["UserPassword"]?.ToString() ?? "";

                    // ✅ verify password
                    if (!BCrypt.Net.BCrypt.Verify(plainPassword, storedHash))
                        return null;

                    // ✅ return valid user
                    return new UserDTOEntity
                    {
                        UserId = Convert.ToInt32(dr["UserId"]),
                        UserName = dr["UserName"]?.ToString() ?? "",
                        UserRole = dr["UserRoleName"]?.ToString() ?? ""
                    };
                }

                return null; // user not found
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error: {ex.Message}");
                return null;
            }
        }
        public async Task<List<UserAccountPolicy>> GetuserAccountPolicies(int userId)
        {
            var policies = new List<UserAccountPolicy>();
            try
            {
                string connectionString = Configuration.GetConnectionString("ConStrRxForEyeIPD")
                ?? throw new InvalidOperationException("Connection string not found.");
                string query = @"
            set dateformat dmy 
            select PolicyId, UserId, AssingnUserPolicy, IsEnabled from UserAccountPolicy where UserId = @id and IsEnabled = 1";
                using SqlConnection con = new(connectionString);
                using SqlCommand cmd = new(query, con);
                cmd.Parameters.AddWithValue("@id", userId);
                await con.OpenAsync();
                using SqlDataReader dr = await cmd.ExecuteReaderAsync();
                while (await dr.ReadAsync())
                {
                    policies.Add(new UserAccountPolicy
                    {
                        PolicyId = Convert.ToInt32(dr["PolicyId"]),
                        UserId = Convert.ToInt32(dr["UserId"]),
                        AssingnUserPolicy = dr["AssingnUserPolicy"]?.ToString() ?? "",
                        IsEnabled = Convert.ToBoolean(dr["IsEnabled"])
                    });
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error loading prescriptions: {ex.Message}");
            }
            return policies;
        }
    }
}
