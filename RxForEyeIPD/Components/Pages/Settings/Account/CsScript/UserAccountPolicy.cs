using Microsoft.Data.SqlClient;
using static RxForEyeIPD.Components.Pages.Settings.LocationMaster.Users.srvUsers;

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
   
    public class UserAccountPolicy
    {
        public int PolicyId { get; set; }
        public int UserId { get; set; }
        public string AssingnUserPolicy { get; set; } = string.Empty;

        public bool IsEnabled;
    }

    public interface IUserAccountPolicy
    {
        Task<UsersEntity> GetUserDetail(string userName);
        Task<List<UserAccountPolicy>> GetuserAccountPolicies(int UserId);
    }

    public class UserAccountPolicyService : IUserAccountPolicy
    {
        private readonly string _ConStrRxForEyeIPD;
        public UserAccountPolicyService(IConfiguration config)
        {
            _ConStrRxForEyeIPD = config.GetConnectionString("ConStrRxForEyeIPD")
            ?? throw new ArgumentNullException(nameof(config),
            "Connection string 'ConStrRxForEyeIPD' not found in configuration");
        }

        public async Task<UsersEntity> GetUserDetail(string userName)
        {
            var userAccount = new UsersEntity();

            try
            {
                string query = @"
            set dateformat dmy 
            select UserId, UserName, UserPassword, UserRoleId from Users where UserName = @userName";

                using var con = new SqlConnection(_ConStrRxForEyeIPD);
                using SqlCommand cmd = new(query, con);
                cmd.Parameters.AddWithValue("@userName", userName);

                await con.OpenAsync();
                using SqlDataReader dr = await cmd.ExecuteReaderAsync();

                while (await dr.ReadAsync())
                {
                    userAccount.UserId = Convert.ToInt32(dr["UserId"]);
                    userAccount.UserName = dr["UserName"]?.ToString() ?? "";
                    userAccount.UserPassword = dr["UserPassword"]?.ToString() ?? "";
                    userAccount.UserRoleId = Convert.ToInt32(dr["UserRoleId"]);
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error loading prescriptions: {ex.Message}");
            }

            return userAccount;
        }

        public async Task<List<UserAccountPolicy>> GetuserAccountPolicies(int UserId)
        {
            var userAccountPolicy = new List<UserAccountPolicy>();
            try
            {
                string query = @"
            set dateformat dmy 
            select PolicyId, UserId, AssingnUserPolicy, IsEnabled from UserAccountPolicy where UserId = @UserId and IsEnabled = 1";
                using var con = new SqlConnection(_ConStrRxForEyeIPD);
                using SqlCommand cmd = new(query, con);
                cmd.Parameters.AddWithValue("@UserId", UserId);
                await con.OpenAsync();
                using SqlDataReader dr = await cmd.ExecuteReaderAsync();
                while (await dr.ReadAsync())
                {
                    userAccountPolicy.Add(new UserAccountPolicy
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
            return userAccountPolicy;
        }

    }
}