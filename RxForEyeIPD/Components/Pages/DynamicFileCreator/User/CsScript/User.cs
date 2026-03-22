using Microsoft.Data.SqlClient;
using System.ComponentModel.DataAnnotations;
using System.Data;
using static RxForEyeIPD.Components.Pages.Settings.LocationMaster.User.srvUser; /*Change The Path Above Accordingly*/
namespace RxForEyeIPD.Components.Pages.Settings.LocationMaster.User /*Change The Namespace Accordingly*/
{
    public class srvUser
    {
        public class UserEntity
        {
            public int UserId { get; set; }
            public int BranchId { get; set; }
            [Required(ErrorMessage = "User name is required.")]
            [StringLength(20, MinimumLength = 3, ErrorMessage = "VA RE must be at least 3 characters.")]
            public string? UserName { get; set; }
            [Required(ErrorMessage = "Email is required.")]
            [StringLength(20, MinimumLength = 10, ErrorMessage = "VA RE must be at least 10 characters.")]
            public string? UserEmail { get; set; }
            public byte[] UserImage { get; set; }
            public int CreatedBy { get; set; }
            public int UpdatedBy { get; set; }
            public int DeletedBy { get; set; }
            public DateTime CreatedAt { get; set; }
            public DateTime UpdatedAt { get; set; }
            public DateTime DeletedAt { get; set; }
            public string? IsActive { get; set; }
        }
        public interface IUser
        {
            Task<List<UserEntity>> GetAllUser();
            Task<UserEntity> GetUserById(int PassUserId);
            Task<List<UserEntity>> GetUserByBranchId(int BranchId);
            Task<int> CreateUser(UserEntity PassUser);
            Task<int> UpdateUser(UserEntity PassUser);
            Task<int> DeleteUser(UserEntity PassUser);
        }
        // builder.Services.AddScoped<IUser, UserRepository>(); // Add This line to program.cs file 
        public class UserRepository : IUser
        {
            private readonly string _ConStrRxForEyeIPD;
            public UserRepository(IConfiguration config)
            {
                _ConStrRxForEyeIPD = config.GetConnectionString("ConStrRxForEyeIPD")
                ?? throw new ArgumentNullException(nameof(config),
                "Connection string 'ConStrRxForEyeIPD' not found in configuration");
            }
            public async Task<List<UserEntity>> GetAllUser()
            {
                List<UserEntity> Userlist = new List<UserEntity>();
                using SqlConnection con = new SqlConnection(_ConStrRxForEyeIPD);
                using (SqlCommand cmd = new SqlCommand("ProcSelectAllUser", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    await con.OpenAsync();
                    using (SqlDataReader dr = await cmd.ExecuteReaderAsync())
                        while (await dr.ReadAsync())
                        {
                            Userlist.Add(new UserEntity
                            {
                                UserId = dr["UserId"] == DBNull.Value ? 0 : Convert.ToInt32(dr["UserId"]),
                                BranchId = Convert.ToInt32(dr["BranchId"]),
                                UserName = Convert.ToString(dr["UserName"]),
                                UserEmail = Convert.ToString(dr["UserEmail"]),
                                //UserImage = dr["UserImage"] == DBNull.Value ?  : (dr["UserImage"]), 
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
                    return Userlist;
                }
            }
            public async Task<UserEntity> GetUserById(int PassUserId)
            {
                using var con = new SqlConnection(_ConStrRxForEyeIPD);
                using var cmd = new SqlCommand("ProcSelectOneUser", con)
                {
                    CommandType = CommandType.StoredProcedure
                };
                cmd.Parameters.AddWithValue("@UserId", PassUserId);
                await con.OpenAsync();
                using var dr = await cmd.ExecuteReaderAsync();
                if (await dr.ReadAsync())
                    return MapUser(dr);
                throw new KeyNotFoundException($"PassUser with ID {PassUserId} not found");
            }
            public async Task<int> CreateUser(UserEntity PassUser)
            {
                using var con = new SqlConnection(_ConStrRxForEyeIPD);
                using var cmd = new SqlCommand("ProcInsertUser", con)
                {
                    CommandType = CommandType.StoredProcedure
                };
                cmd.Parameters.AddWithValue("@BranchId", PassUser.BranchId);
                cmd.Parameters.AddWithValue("@UserName", PassUser.UserName);
                cmd.Parameters.AddWithValue("@UserEmail", PassUser.UserEmail);
                cmd.Parameters.AddWithValue("@UserImage", PassUser.UserImage);
                cmd.Parameters.AddWithValue("@CreatedBy", PassUser.CreatedBy);
                await con.OpenAsync();
                return await cmd.ExecuteNonQueryAsync();
            }
            public async Task<int> UpdateUser(UserEntity PassUser)
            {
                using var con = new SqlConnection(_ConStrRxForEyeIPD);
                using var cmd = new SqlCommand("ProcUpdateUser", con)
                {
                    CommandType = CommandType.StoredProcedure
                };
                cmd.Parameters.AddWithValue("@UserId", PassUser.UserId);
                cmd.Parameters.AddWithValue("@BranchId", PassUser.BranchId);
                cmd.Parameters.AddWithValue("@UserName", PassUser.UserName);
                cmd.Parameters.AddWithValue("@UserEmail", PassUser.UserEmail);
                cmd.Parameters.AddWithValue("@UserImage", PassUser.UserImage);
                cmd.Parameters.AddWithValue("@UpdatedBy", PassUser.UpdatedBy);
                await con.OpenAsync();
                return await cmd.ExecuteNonQueryAsync();
            }
            public async Task<int> DeleteUser(UserEntity PassUser)
            {
                using var con = new SqlConnection(_ConStrRxForEyeIPD);
                using var cmd = new SqlCommand("ProcDeleteUser", con)
                {
                    CommandType = CommandType.StoredProcedure
                };
                cmd.Parameters.AddWithValue("@UserId", PassUser.UserId);
                cmd.Parameters.AddWithValue("@DeletedBy", PassUser.DeletedBy); // Pass logged-in user id later 
                await con.OpenAsync();
                return await cmd.ExecuteNonQueryAsync();
            }
            private UserEntity MapUser(SqlDataReader dr)
            {
                return new UserEntity
                {
                    BranchId = Convert.ToInt32(dr["BranchId"]),
                    UserName = Convert.ToString(dr["UserName"]),
                    UserEmail = Convert.ToString(dr["UserEmail"]),
                    //UserImage = dr["UserImage"] == DBNull.Value ?  : (dr["UserImage"]), 
                };
            }
            public async Task<List<UserEntity>> GetUserByBranchId(int BranchId)
            {
                List<UserEntity> Userlist = new List<UserEntity>();
                using SqlConnection con = new SqlConnection(_ConStrRxForEyeIPD);
                using (SqlCommand cmd = new SqlCommand("ProcSelectUsersByBranchId", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@BranchId", BranchId);
                    await con.OpenAsync();
                    using (SqlDataReader dr = await cmd.ExecuteReaderAsync())
                        while (await dr.ReadAsync())
                        {
                            Userlist.Add(new UserEntity
                            {
                                UserId = dr["UserId"] == DBNull.Value ? 0 : Convert.ToInt32(dr["UserId"]),
                                BranchId = Convert.ToInt32(dr["BranchId"]),
                                UserName = Convert.ToString(dr["UserName"]),
                                UserEmail = Convert.ToString(dr["UserEmail"]),
                                //UserImage = dr["UserImage"] == DBNull.Value ?  : (dr["UserImage"]), 
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
                    return Userlist;
                }
            }
        }
    }
}
