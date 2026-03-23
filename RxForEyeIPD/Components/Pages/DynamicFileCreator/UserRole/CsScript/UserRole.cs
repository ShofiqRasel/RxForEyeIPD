using Microsoft.Data.SqlClient;
using System.ComponentModel.DataAnnotations;
using System.Data;
using static RxForEyeIPD.Components.Pages.Settings.LocationMaster.UserRole.srvUserRole; /*Change The Path Above Accordingly*/
namespace RxForEyeIPD.Components.Pages.Settings.LocationMaster.UserRole /*Change The Namespace Accordingly*/
{
    public class srvUserRole
    {
        public class UserRoleEntity
        {
            public int UserRoleId { get; set; }
            [Required(ErrorMessage = "User rolename is required.")]
            [StringLength(20, MinimumLength = 2, ErrorMessage = "Userrole must be at least 2 characters.")]
            public string? UserRoleName { get; set; }
            public int CreatedBy { get; set; }
            public int UpdatedBy { get; set; }
            public int DeletedBy { get; set; }
            public DateTime CreatedAt { get; set; }
            public DateTime UpdatedAt { get; set; }
            public DateTime DeletedAt { get; set; }
            public string? IsActive { get; set; }
        }
        public interface IUserRole
        {
            Task<List<UserRoleEntity>> GetAllUserRole();
            Task<UserRoleEntity> GetUserRoleById(int PassUserRoleId);
            Task<int> CreateUserRole(UserRoleEntity PassUserRole);
            Task<int> UpdateUserRole(UserRoleEntity PassUserRole);
            Task<int> DeleteUserRole(UserRoleEntity PassUserRole);
        }
        // builder.Services.AddScoped<IUserRole, UserRoleRepository>(); // Add This line to program.cs file 
        public class UserRoleRepository : IUserRole
        {
            private readonly string _ConStrRxForEyeIPD;
            public UserRoleRepository(IConfiguration config)
            {
                _ConStrRxForEyeIPD = config.GetConnectionString("ConStrRxForEyeIPD")
                ?? throw new ArgumentNullException(nameof(config),
                "Connection string 'ConStrRxForEyeIPD' not found in configuration");
            }
            public async Task<List<UserRoleEntity>> GetAllUserRole()
            {
                List<UserRoleEntity> UserRolelist = new List<UserRoleEntity>();
                using SqlConnection con = new SqlConnection(_ConStrRxForEyeIPD);
                using (SqlCommand cmd = new SqlCommand("ProcSelectAllUserRole", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    await con.OpenAsync();
                    using (SqlDataReader dr = await cmd.ExecuteReaderAsync())
                        while (await dr.ReadAsync())
                        {
                            UserRolelist.Add(new UserRoleEntity
                            {
                                UserRoleId = dr["UserRoleId"] == DBNull.Value ? 0 : Convert.ToInt32(dr["UserRoleId"]),
                                UserRoleName = Convert.ToString(dr["UserRoleName"]),
                                CreatedBy = Convert.ToInt32(dr["CreatedBy"]),
                                UpdatedBy = dr["UpdatedBy"] == DBNull.Value ? 0 : Convert.ToInt32(dr["UpdatedBy"]),
                                DeletedBy = dr["DeletedBy"] == DBNull.Value ? 0 : Convert.ToInt32(dr["DeletedBy"]),
                                CreatedAt = Convert.ToDateTime(dr["CreatedAt"]),
                                UpdatedAt = dr["UpdatedAt"] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime(dr["UpdatedAt"]),
                                DeletedAt = dr["DeletedAt"] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime(dr["DeletedAt"]),
                                IsActive = dr["IsActive"].ToString()
                            }
                            );
                        }
                    return UserRolelist;
                }
            }
            public async Task<UserRoleEntity> GetUserRoleById(int PassUserRoleId)
            {
                using var con = new SqlConnection(_ConStrRxForEyeIPD);
                using var cmd = new SqlCommand("ProcSelectOneUserRole", con)
                {
                    CommandType = CommandType.StoredProcedure
                };
                cmd.Parameters.Add("@UserRoleId", SqlDbType.Int).Value = PassUserRoleId;
                await con.OpenAsync();
                using var dr = await cmd.ExecuteReaderAsync();
                if (await dr.ReadAsync())
                    return MapUserRole(dr);
                throw new KeyNotFoundException($"PassUserRole with ID {PassUserRoleId} not found");
            }
            public async Task<int> CreateUserRole(UserRoleEntity PassUserRole)
            {
                using var con = new SqlConnection(_ConStrRxForEyeIPD);
                using var cmd = new SqlCommand("ProcInsertUserRole", con)
                {
                    CommandType = CommandType.StoredProcedure
                };
                cmd.Parameters.Add("@UserRoleName", SqlDbType.VarChar).Value = PassUserRole.UserRoleName;
                cmd.Parameters.AddWithValue("@CreatedBy", PassUserRole.CreatedBy);
                await con.OpenAsync();
                return await cmd.ExecuteNonQueryAsync();
            }
            public async Task<int> UpdateUserRole(UserRoleEntity PassUserRole)
            {
                using var con = new SqlConnection(_ConStrRxForEyeIPD);
                using var cmd = new SqlCommand("ProcUpdateUserRole", con)
                {
                    CommandType = CommandType.StoredProcedure
                };
                cmd.Parameters.Add("@UserRoleId", SqlDbType.Int).Value = PassUserRole.UserRoleId;
                cmd.Parameters.Add("@UserRoleName", SqlDbType.VarChar).Value = PassUserRole.UserRoleName ?? (object)DBNull.Value;
                cmd.Parameters.AddWithValue("@UpdatedBy", PassUserRole.UpdatedBy);
                await con.OpenAsync();
                return await cmd.ExecuteNonQueryAsync();
            }
            public async Task<int> DeleteUserRole(UserRoleEntity PassUserRole)
            {
                using var con = new SqlConnection(_ConStrRxForEyeIPD);
                using var cmd = new SqlCommand("ProcDeleteUserRole", con)
                {
                    CommandType = CommandType.StoredProcedure
                };
                cmd.Parameters.Add("@UserRoleId", SqlDbType.Int).Value = PassUserRole.UserRoleId;
                cmd.Parameters.AddWithValue("@DeletedBy", PassUserRole.DeletedBy); // Pass logged-in user id later 
                await con.OpenAsync();
                return await cmd.ExecuteNonQueryAsync();
            }
            private UserRoleEntity MapUserRole(SqlDataReader dr)
            {
                return new UserRoleEntity
                {
                    UserRoleName = Convert.ToString(dr["UserRoleName"]),
                };
            }
        }
    }
}
