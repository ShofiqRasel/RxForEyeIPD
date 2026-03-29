using Microsoft.Data.SqlClient;
using System.ComponentModel.DataAnnotations;
using System.Data;
using static RxForEyeIPD.Components.Pages.Settings.LocationMaster.Users.srvUsers;

namespace RxForEyeIPD.Components.Pages.DynamicFileCreator.Users.CsScript
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
        public DateTime? LockUpTo { get; set; } = DateTime.Now;
    }

    public class  UserAccessStatus
    {
        public string? DeviceId { get; set; }
        public string? IpAddress { get; set; }
        public string? LockUpTo { get;set; }
    }


    public interface IUserDTO
    {
        Task<List<string>> GetPoliciesAsync();
        Task<UserDTOEntity> GetUserDetail(string userName, string plainPassword);
        Task<UserAccessStatus> GetUserAccessStatus(int UserId);
        Task<List<UserAccountPolicy>> GetuserAccountPolicies(int userId);
        Task<int> UpdateLockUpTo(UsersEntity PassUsers);
        Task DeviceInfo(string deviceInfo, int UserId);
        Task DeviceIpAddress(string IpAddress, int UserId);
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
        SELECT u.UserId, u.UserName, u.UserPassword, ur.UserRoleName, u.LockUpTo 
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

                    DateTime? lockUpTo = dr["LockUpTo"] as DateTime?;
                    // Block the user ONLY if the lock time is still active (in the future)
                    if (lockUpTo != null && lockUpTo > DateTime.Now)
                    {
                        // You might want to log this or throw a specific exception like "Account Locked"
                        return null;
                    }

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

        public async Task<UserAccessStatus?> GetUserAccessStatus(int UserId)
        {
            try
            {
                string connectionString = Configuration.GetConnectionString("ConStrRxForEyeIPD")
                    ?? throw new InvalidOperationException("Connection string not found.");

                string query = @"
                select DeviceId, IpAddress, LockUpTo from Users where UserId = @UserId and IsActive = 'Yes'";

                using SqlConnection con = new(connectionString);
                using SqlCommand cmd = new(query, con);
                cmd.Parameters.AddWithValue("@UserId", UserId);

                await con.OpenAsync();
                using SqlDataReader dr = await cmd.ExecuteReaderAsync();

                if (await dr.ReadAsync())
                {
                    return new UserAccessStatus
                    {
                        DeviceId = dr["DeviceId"]?.ToString(),
                        IpAddress = dr["IpAddress"]?.ToString() ?? "",
                        LockUpTo = dr["LockUpTo"]?.ToString() ?? ""
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

        public async Task<int> UpdateLockUpTo(UsersEntity PassUsers)
        {
            string connectionString = Configuration.GetConnectionString("ConStrRxForEyeIPD")
                ?? throw new InvalidOperationException("Connection string not found.");

            using var con = new SqlConnection(connectionString);
            using var cmd = new SqlCommand("ProcLockTimeUpto", con)
            {
                CommandType = CommandType.StoredProcedure
            };
            cmd.Parameters.Add("@LockUpTo", SqlDbType.DateTime).Value = (object) PassUsers.LockUpTo ?? DBNull.Value;
            cmd.Parameters.Add("@UserId", SqlDbType.Int).Value = PassUsers.UserId;
            await con.OpenAsync();
            return await cmd.ExecuteNonQueryAsync();
        }

        public async Task DeviceInfo(string deviceInfo, int UserId)
        {
            string connectionString = Configuration.GetConnectionString("ConStrRxForEyeIPD")
                ?? throw new InvalidOperationException("Connection string not found.");

            using var con = new SqlConnection(connectionString);
            using var cmd = new SqlCommand("ProcDeviceInfo", con)
            {
                CommandType = CommandType.StoredProcedure
            };
            cmd.Parameters.Add("@DeviceInfo", SqlDbType.VarChar).Value = deviceInfo;
            cmd.Parameters.Add("@UserId", SqlDbType.Int).Value = UserId;

            await con.OpenAsync();
            await cmd.ExecuteNonQueryAsync();
        }

        public async Task DeviceIpAddress(string IpAddress, int UserId)
        {
            string connectionString = Configuration.GetConnectionString("ConStrRxForEyeIPD")
                ?? throw new InvalidOperationException("Connection string not found.");

            using var con = new SqlConnection(connectionString);
            using var cmd = new SqlCommand("ProcUpdateIpAddress", con)
            {
                CommandType = CommandType.StoredProcedure
            };
            cmd.Parameters.Add("@DeviceIpAddress", SqlDbType.VarChar).Value = IpAddress;
            cmd.Parameters.Add("@UserId", SqlDbType.Int).Value = UserId;

            await con.OpenAsync();
            await cmd.ExecuteNonQueryAsync();
        }
    }
}
