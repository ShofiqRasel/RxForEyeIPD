using Microsoft.Data.SqlClient;
using System.ComponentModel.DataAnnotations;
using System.Data;
using static RxForEyeIPD.Components.Pages.Settings.LocationMaster.Users.srvUsers; /*Change The Path Above Accordingly*/
namespace RxForEyeIPD.Components.Pages.Settings.LocationMaster.Users /*Change The Namespace Accordingly*/
{
    public class srvUsers
    {
        public class UsersEntity
        {
            public int UserId { get; set; }
            public int UserRoleId { get; set; }
            [Required(ErrorMessage = "User name is required.")]
            [StringLength(20, MinimumLength = 3, ErrorMessage = "VA RE must be at least 3 characters.")]
            public string? UserName { get; set; }
            [Required(ErrorMessage = "Email is required.")]
            [StringLength(20, MinimumLength = 10, ErrorMessage = "VA RE must be at least 10 characters.")]
            public string? UserEmail { get; set; }
            public byte[]? UserImage { get; set; }
            public string ImagePreviewUrl { get; set; } = "Images/MiscImage/default-avatar.png";
            public string? UserPassword { get; set; }
            public string? DeviceName { get; set; }
            public string? ScreenSize { get; set; }
            public string? Manufacturer { get; set; }
            public string? IpAddress { get; set; }
            public int? LockHours { get; set; } 
            public bool? RememberMe { get; set; }
            public int CreatedBy { get; set; }
            public int UpdatedBy { get; set; }
            public int DeletedBy { get; set; }
            public DateTime CreatedAt { get; set; }
            public DateTime UpdatedAt { get; set; }
            public DateTime DeletedAt { get; set; }
            public string? IsActive { get; set; }
        }
        public interface IUsers
        {
            Task<List<UsersEntity>> GetAllUsers();
            Task<UsersEntity> GetUsersById(int PassUsersId);
            Task<int> CreateUsers(UsersEntity PassUsers);
            Task<int> UpdateUsers(UsersEntity PassUsers);
            Task<int> DeleteUsers(UsersEntity PassUsers);
            Task<UsersEntity?> AuthenticateUser(string email, string plainPassword);
        }
        // builder.Services.AddScoped<IUsers, UsersRepository>(); // Add This line to program.cs file 
        public class UsersRepository : IUsers
        {
            private readonly string _ConStrRxForEyeIPD;
            public UsersRepository(IConfiguration config)
            {
                _ConStrRxForEyeIPD = config.GetConnectionString("ConStrRxForEyeIPD")
                ?? throw new ArgumentNullException(nameof(config),
                "Connection string 'ConStrRxForEyeIPD' not found in configuration");
            }
            public async Task<UsersEntity?> AuthenticateUser(string email, string plainPassword)
            {
                using var con = new SqlConnection(_ConStrRxForEyeIPD);
                // Use a specific proc or query to get the user by email
                using var cmd = new SqlCommand("SELECT * FROM Users WHERE UserEmail = @Email AND IsActive = 'Yes'", con);
                cmd.Parameters.AddWithValue("@Email", email);

                await con.OpenAsync();
                using var dr = await cmd.ExecuteReaderAsync();

                if (await dr.ReadAsync())
                {
                    string storedHash = dr["UserPassword"].ToString() ?? "";
                    bool isValid = BCrypt.Net.BCrypt.Verify(plainPassword, storedHash);

                    if (isValid)
                    {
                        return MapUsers(dr); // Return the full user object if match
                    }
                }

                return null; 
            }
            public async Task<List<UsersEntity>> GetAllUsers()
            {
                List<UsersEntity> Userslist = new List<UsersEntity>();
                using SqlConnection con = new SqlConnection(_ConStrRxForEyeIPD);
                using (SqlCommand cmd = new SqlCommand("ProcSelectAllUsers", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    await con.OpenAsync();
                    using (SqlDataReader dr = await cmd.ExecuteReaderAsync())
                        while (await dr.ReadAsync())
                        {
                            Userslist.Add(new UsersEntity
                            {
                                UserId = dr["UserId"] == DBNull.Value ? 0 : Convert.ToInt32(dr["UserId"]),
                                UserRoleId = Convert.ToInt32(dr["UserRoleId"]),
                                UserName = Convert.ToString(dr["UserName"]),
                                UserEmail = Convert.ToString(dr["UserEmail"]),
                                UserImage = dr["UserImage"] == DBNull.Value ? null : (byte[])dr["UserImage"],
                                UserPassword = string.Empty, //UserPassword = dr["UserPassword"] == DBNull.Value ? null : Convert.ToString(dr["UserPassword"]),// dr["UserPassword"] == DBNull.Value ? null : (byte[])dr["UserPassword"],
                                DeviceName = dr["DeviceName"] == DBNull.Value ? null : Convert.ToString(dr["DeviceName"]),
                                ScreenSize = dr["ScreenSize"] == DBNull.Value ? null : Convert.ToString(dr["ScreenSize"]),
                                Manufacturer = dr["Manufacturer"] == DBNull.Value ? null : Convert.ToString(dr["Manufacturer"]),
                                IpAddress = dr["IpAddress"] == DBNull.Value ? null : Convert.ToString(dr["IpAddress"]),
                                LockHours = dr["LockHours"] == DBNull.Value ? 0 : Convert.ToInt32(dr["LockHours"]),
                                RememberMe = dr["RememberMe"] == DBNull.Value ? false : Convert.ToBoolean(dr["RememberMe"]),
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
                    return Userslist;
                }
            }
            public async Task<UsersEntity> GetUsersById(int PassUsersId)
            {
                using var con = new SqlConnection(_ConStrRxForEyeIPD);
                using var cmd = new SqlCommand("ProcSelectOneUsers", con)
                {
                    CommandType = CommandType.StoredProcedure
                };
                cmd.Parameters.Add("@UserId", SqlDbType.Int).Value = PassUsersId;
                await con.OpenAsync();
                using var dr = await cmd.ExecuteReaderAsync();
                if (await dr.ReadAsync())
                    return MapUsers(dr);
                throw new KeyNotFoundException($"PassUsers with ID {PassUsersId} not found");
            }
            public async Task<UsersEntity> GetUserDetail(string userName)
            {
                var userAccount = new UsersEntity();
                try
                {
                    string query = @"
            set dateformat dmy 
            select id, user_name, password, role from user_accounts where user_name = @userName";

                    using SqlConnection con = new SqlConnection(_ConStrRxForEyeIPD);
                    using SqlCommand cmd = new(query, con);
                    cmd.Parameters.AddWithValue("@userName", userName);

                    await con.OpenAsync();
                    using SqlDataReader dr = await cmd.ExecuteReaderAsync();

                    while (await dr.ReadAsync())
                    {
                        userAccount.UserId = Convert.ToInt32(dr["UserId"]);
                        userAccount.UserName = dr["UserName"]?.ToString() ?? "";
                        userAccount.UserPassword = dr["UserPassword"]?.ToString() ?? "";
                        //userAccount.UserRoleId = dr["UserRoleId"]?.ToString() ?? "";
                    }
                }
                catch (Exception ex)
                {
                    Console.WriteLine($"Error loading prescriptions: {ex.Message}");
                }

                return userAccount;
            }
            public async Task<int> CreateUsers(UsersEntity PassUsers)
            {
                using var con = new SqlConnection(_ConStrRxForEyeIPD);
                using var cmd = new SqlCommand("ProcInsertUsers", con)
                {
                    CommandType = CommandType.StoredProcedure
                };
                cmd.Parameters.Add("@UserRoleId", SqlDbType.Int).Value = PassUsers.UserRoleId;
                cmd.Parameters.Add("@UserName", SqlDbType.NVarChar).Value = PassUsers.UserName ?? (object)DBNull.Value; ;
                cmd.Parameters.Add("@UserEmail", SqlDbType.VarChar).Value = PassUsers.UserEmail;
                cmd.Parameters.Add("@UserImage", SqlDbType.VarBinary).Value = PassUsers.UserImage ?? (object)DBNull.Value; ;

                string salt = BCrypt.Net.BCrypt.GenerateSalt(12); // 12 is the work factor
                string hashedPassword = BCrypt.Net.BCrypt.HashPassword(PassUsers.UserPassword, salt);

                cmd.Parameters.Add("@UserPassword", SqlDbType.VarChar).Value = hashedPassword;
                //cmd.Parameters.Add("@UserPassword", SqlDbType.VarChar).Value = PassUsers.UserPassword;
                cmd.Parameters.Add("@DeviceName", SqlDbType.VarChar).Value = PassUsers.DeviceName ?? (object) DBNull.Value;
                cmd.Parameters.Add("@ScreenSize", SqlDbType.VarChar).Value = PassUsers.ScreenSize ?? (object)DBNull.Value;
                cmd.Parameters.Add("@Manufacturer", SqlDbType.VarChar).Value = PassUsers.Manufacturer ?? (object)DBNull.Value;
                cmd.Parameters.Add("@IpAddress", SqlDbType.VarChar).Value = PassUsers.IpAddress ?? (object)DBNull.Value;
                cmd.Parameters.Add("@LockHours", SqlDbType.Int).Value = PassUsers.LockHours ?? (object)DBNull.Value;
                cmd.Parameters.Add("@RememberMe", SqlDbType.Bit).Value = PassUsers.RememberMe ?? (object)DBNull.Value; 
                cmd.Parameters.AddWithValue("@CreatedBy", PassUsers.CreatedBy);
                await con.OpenAsync();
                return await cmd.ExecuteNonQueryAsync();
            }
            public async Task<int> UpdateUsers(UsersEntity PassUsers)
            {
                using var con = new SqlConnection(_ConStrRxForEyeIPD);
                using var cmd = new SqlCommand("ProcUpdateUsers", con)
                {
                    CommandType = CommandType.StoredProcedure
                };
                cmd.Parameters.Add("@UserId", SqlDbType.Int).Value = PassUsers.UserId;
                cmd.Parameters.Add("@UserRoleId", SqlDbType.Int).Value = PassUsers.UserRoleId;
                cmd.Parameters.Add("@UserName", SqlDbType.NVarChar).Value = PassUsers.UserName ?? (object)DBNull.Value;
                cmd.Parameters.Add("@UserEmail", SqlDbType.VarChar).Value = PassUsers.UserEmail ?? (object)DBNull.Value;
                cmd.Parameters.Add("@UserImage", SqlDbType.VarBinary).Value = PassUsers.UserImage ?? (object)DBNull.Value;

                string salt = BCrypt.Net.BCrypt.GenerateSalt(12); // 12 is the work factor
                string hashedPassword = BCrypt.Net.BCrypt.HashPassword(PassUsers.UserPassword, salt);

                cmd.Parameters.Add("@UserPassword", SqlDbType.VarChar).Value = hashedPassword;
                //cmd.Parameters.Add("@UserPassword", SqlDbType.VarChar).Value = PassUsers.UserPassword ?? (object)DBNull.Value;
                
                cmd.Parameters.Add("@DeviceName", SqlDbType.VarChar).Value = PassUsers.DeviceName ?? (object)DBNull.Value;
                cmd.Parameters.Add("@ScreenSize", SqlDbType.VarChar).Value = PassUsers.ScreenSize ?? (object)DBNull.Value;
                cmd.Parameters.Add("@Manufacturer", SqlDbType.VarChar).Value = PassUsers.Manufacturer ?? (object)DBNull.Value;
                cmd.Parameters.Add("@IpAddress", SqlDbType.VarChar).Value = PassUsers.IpAddress ?? (object)DBNull.Value;
                cmd.Parameters.Add("@LockHours", SqlDbType.Int).Value = PassUsers.LockHours;
                cmd.Parameters.Add("@RememberMe", SqlDbType.Bit).Value = PassUsers.RememberMe;
                cmd.Parameters.AddWithValue("@UpdatedBy", PassUsers.UpdatedBy);
                await con.OpenAsync();
                return await cmd.ExecuteNonQueryAsync();
            }
            public async Task<int> DeleteUsers(UsersEntity PassUsers)
            {
                using var con = new SqlConnection(_ConStrRxForEyeIPD);
                using var cmd = new SqlCommand("ProcDeleteUsers", con)
                {
                    CommandType = CommandType.StoredProcedure
                };
                cmd.Parameters.Add("@UserId", SqlDbType.Int).Value = PassUsers.UserId;
                cmd.Parameters.AddWithValue("@DeletedBy", PassUsers.DeletedBy); // Pass logged-in user id later 
                await con.OpenAsync();
                return await cmd.ExecuteNonQueryAsync();
            }
            private UsersEntity MapUsers(SqlDataReader dr)
            {
                // 1. Create the entity object
                var entity = new UsersEntity
                {
                    UserId = dr["UserId"] == DBNull.Value ? 0 : Convert.ToInt32(dr["UserId"]),
                    UserRoleId = Convert.ToInt32(dr["UserRoleId"]),
                    UserName = Convert.ToString(dr["UserName"]),
                    UserEmail = Convert.ToString(dr["UserEmail"]),
                    UserImage = dr["UserImage"] == DBNull.Value ? null : (byte[])dr["UserImage"],

                    // DO NOT map UserPassword here if using Hashing. 
                    // Keep it null/empty so the UI doesn't show the secret hash.
                    //UserPassword = string.Empty,

                    DeviceName = dr["DeviceName"] == DBNull.Value ? null : Convert.ToString(dr["DeviceName"]),
                    ScreenSize = dr["ScreenSize"] == DBNull.Value ? null : Convert.ToString(dr["ScreenSize"]),
                    Manufacturer = dr["Manufacturer"] == DBNull.Value ? null : Convert.ToString(dr["Manufacturer"]),
                    IpAddress = dr["IpAddress"] == DBNull.Value ? null : Convert.ToString(dr["IpAddress"]),
                    LockHours = dr["LockHours"] == DBNull.Value ? 0 : Convert.ToInt32(dr["LockHours"]),
                    RememberMe = dr["RememberMe"] == DBNull.Value ? false : Convert.ToBoolean(dr["RememberMe"]),
                };

                // 2. Handle the Image Preview logic
                if (entity.UserImage != null)
                {
                    entity.ImagePreviewUrl = $"data:image/png;base64,{Convert.ToBase64String(entity.UserImage)}";
                }

                return entity;
            }
        }
    }
}
