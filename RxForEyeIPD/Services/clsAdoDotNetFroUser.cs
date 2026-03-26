using RxForEyeIPD.Model.Entities;
using Microsoft.Data.SqlClient;

namespace RxForEyeIPD.Services
{
    public class clsAdoDotNetFroUser(IConfiguration Configuration)
    {
        public async Task<UserAccount> GetUserDetail(string userName)
        {
            var userAccount = new UserAccount();

            try
            {
                string connectionString = Configuration.GetConnectionString("DefaultConnection")
                ?? throw new InvalidOperationException("Connection string not found.");

                string query = @"
            set dateformat dmy 
            select id, user_name, password, role from user_accounts where user_name = @userName";

                using SqlConnection con = new(connectionString);
                using SqlCommand cmd = new(query, con);
                cmd.Parameters.AddWithValue("@userName", userName);

                await con.OpenAsync();
                using SqlDataReader dr = await cmd.ExecuteReaderAsync();

                while (await dr.ReadAsync())
                {
                    userAccount.Id = Convert.ToInt32(dr["id"]);
                    userAccount.UserName = dr["user_name"]?.ToString() ?? "";
                    userAccount.Password = dr["password"]?.ToString() ?? "";
                    userAccount.Role = dr["role"]?.ToString() ?? "";
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error loading prescriptions: {ex.Message}");
            }

            return userAccount;
        }

        public async Task<List<UserAccountPolicy>> GetuserAccountPolicies(int userId)
        {
            var policies = new List<UserAccountPolicy>();
            try
            {
                string connectionString = Configuration.GetConnectionString("ConStrRxForEyeOPD")
                ?? throw new InvalidOperationException("Connection string not found.");
                string query = @"
            set dateformat dmy 
            select id, user_account_id, user_policy, is_enabled from user_account_policy where id = @id and is_enabled = 1";
                using SqlConnection con = new(connectionString);
                using SqlCommand cmd = new(query, con);
                cmd.Parameters.AddWithValue("@id", userId);
                await con.OpenAsync();
                using SqlDataReader dr = await cmd.ExecuteReaderAsync();
                while (await dr.ReadAsync())
                {
                    policies.Add(new UserAccountPolicy
                    {
                        Id = Convert.ToInt32(dr["id"]),
                        UserAccountId = Convert.ToInt32(dr["user_account_id"]),
                        UserPolicy = dr["user_policy"]?.ToString() ?? "",
                        IsEnabled = Convert.ToBoolean(dr["is_enabled"])
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
