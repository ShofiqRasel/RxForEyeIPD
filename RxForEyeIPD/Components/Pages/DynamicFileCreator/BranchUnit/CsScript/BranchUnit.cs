using Microsoft.Data.SqlClient;
using System.ComponentModel.DataAnnotations;
using System.Data;
using static RxForEyeIPD.Components.Pages.Settings.LocationMaster.BranchUnit.srvBranchUnit; /*Change The Path Above Accordingly*/
namespace RxForEyeIPD.Components.Pages.Settings.LocationMaster.BranchUnit /*Change The Namespace Accordingly*/
{
    public class srvBranchUnit
    {
        public class BranchUnitEntity
        {
            public int BranchUnitId { get; set; }
            public int BaseHospitalId { get; set; }

            [Required(ErrorMessage = "A Branch Unit name is required.")]
            [StringLength(100, MinimumLength = 6, ErrorMessage = "Branch Name must be at least 6 characters.")]
            public string? BranchUnitName { get; set; }
            public string? BranchUnitContact { get; set; }
            public string? BranchUnitEmail { get; set; }
            public string? BranchUnitAddress { get; set; }
            public string? BranchUnitDialogue { get; set; }
            public byte[]? BranchUnitLogo { get; set; }
            public string ImagePreviewUrl { get; set; } = "Images/MiscImage/default-avatar.png";

            public string? BranchUnitMessage { get; set; }
            public int CreatedBy { get; set; }
            public int UpdatedBy { get; set; }
            public int DeletedBy { get; set; }
            public DateTime CreatedAt { get; set; }
            public DateTime UpdatedAt { get; set; }
            public DateTime DeletedAt { get; set; }
            public string? IsActive { get; set; }
        }
        public interface IBranchUnit
        {
            Task<List<BranchUnitEntity>> GetAllBranchUnit();
            Task<BranchUnitEntity> GetBranchUnitById(int PassBranchUnitId);
            Task<int> CreateBranchUnit(BranchUnitEntity PassBranchUnit);
            Task<int> UpdateBranchUnit(BranchUnitEntity PassBranchUnit);
            Task<int> DeleteBranchUnit(BranchUnitEntity PassBranchUnit);
        }
        // builder.Services.AddScoped<IBranchUnit, BranchUnitRepository>(); // Add This line to program.cs file 
        public class BranchUnitRepository : IBranchUnit
        {
            private readonly string _ConStrRxForEyeIPD;
            public BranchUnitRepository(IConfiguration config)
            {
                _ConStrRxForEyeIPD = config.GetConnectionString("ConStrRxForEyeIPD")
                ?? throw new ArgumentNullException(nameof(config),
                "Connection string 'ConStrRxForEyeIPD' not found in configuration");
            }
            public async Task<List<BranchUnitEntity>> GetAllBranchUnit()
            {
                List<BranchUnitEntity> BranchUnitlist = new List<BranchUnitEntity>();
                using SqlConnection con = new SqlConnection(_ConStrRxForEyeIPD);
                using (SqlCommand cmd = new SqlCommand("ProcSelectAllBranchUnit", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    await con.OpenAsync();
                    using (SqlDataReader dr = await cmd.ExecuteReaderAsync())
                        while (await dr.ReadAsync())
                        {
                            BranchUnitlist.Add(new BranchUnitEntity
                            {
                                BranchUnitId = dr["BranchUnitId"] == DBNull.Value ? 0 : Convert.ToInt32(dr["BranchUnitId"]),
                                BaseHospitalId = Convert.ToInt32(dr["BaseHospitalId"]),
                                BranchUnitName = Convert.ToString(dr["BranchUnitName"]),
                                BranchUnitContact = dr["BranchUnitContact"] == DBNull.Value ? null : Convert.ToString(dr["BranchUnitContact"]),
                                BranchUnitEmail = dr["BranchUnitEmail"] == DBNull.Value ? null : Convert.ToString(dr["BranchUnitEmail"]),
                                BranchUnitAddress = Convert.ToString(dr["BranchUnitAddress"]),
                                BranchUnitDialogue = dr["BranchUnitDialogue"] == DBNull.Value ? null : Convert.ToString(dr["BranchUnitDialogue"]),
                                BranchUnitLogo = dr["BranchUnitLogo"] == DBNull.Value ? null : (byte[])dr["BranchUnitLogo"],
                                BranchUnitMessage = dr["BranchUnitMessage"] == DBNull.Value ? null : Convert.ToString(dr["BranchUnitMessage"]),
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
                    return BranchUnitlist;
                }
            }
            public async Task<BranchUnitEntity> GetBranchUnitById(int PassBranchUnitId)
            {
                using var con = new SqlConnection(_ConStrRxForEyeIPD);
                using var cmd = new SqlCommand("ProcSelectOneBranchUnit", con)
                {
                    CommandType = CommandType.StoredProcedure
                };
                cmd.Parameters.Add("@BranchUnitId", SqlDbType.Int).Value = PassBranchUnitId;
                await con.OpenAsync();
                using var dr = await cmd.ExecuteReaderAsync();
                if (await dr.ReadAsync())
                    return MapBranchUnit(dr);
                throw new KeyNotFoundException($"PassBranchUnit with ID {PassBranchUnitId} not found");
            }
            public async Task<int> CreateBranchUnit(BranchUnitEntity PassBranchUnit)
            {
                using var con = new SqlConnection(_ConStrRxForEyeIPD);
                using var cmd = new SqlCommand("ProcInsertBranchUnit", con)
                {
                    CommandType = CommandType.StoredProcedure
                };
                cmd.Parameters.Add("@BaseHospitalId", SqlDbType.Int).Value = PassBranchUnit.BaseHospitalId;
                cmd.Parameters.Add("@BranchUnitName", SqlDbType.NVarChar).Value = PassBranchUnit.BranchUnitName;
                cmd.Parameters.Add("@BranchUnitContact", SqlDbType.VarChar).Value = PassBranchUnit.BranchUnitContact;
                cmd.Parameters.Add("@BranchUnitEmail", SqlDbType.VarChar).Value = PassBranchUnit.BranchUnitEmail;
                cmd.Parameters.Add("@BranchUnitAddress", SqlDbType.VarChar).Value = PassBranchUnit.BranchUnitAddress;
                cmd.Parameters.Add("@BranchUnitDialogue", SqlDbType.VarChar).Value = PassBranchUnit.BranchUnitDialogue;
                cmd.Parameters.Add("@BranchUnitLogo", SqlDbType.VarBinary).Value = PassBranchUnit.BranchUnitLogo;
                cmd.Parameters.Add("@BranchUnitMessage", SqlDbType.VarChar).Value = PassBranchUnit.BranchUnitMessage;
                cmd.Parameters.AddWithValue("@CreatedBy", PassBranchUnit.CreatedBy);
                await con.OpenAsync();
                return await cmd.ExecuteNonQueryAsync();
            }
            public async Task<int> UpdateBranchUnit(BranchUnitEntity PassBranchUnit)
            {
                using var con = new SqlConnection(_ConStrRxForEyeIPD);
                using var cmd = new SqlCommand("ProcUpdateBranchUnit", con)
                {
                    CommandType = CommandType.StoredProcedure
                };
                cmd.Parameters.Add("@BranchUnitId", SqlDbType.Int).Value = PassBranchUnit.BranchUnitId;
                cmd.Parameters.Add("@BaseHospitalId", SqlDbType.Int).Value = PassBranchUnit.BaseHospitalId;
                cmd.Parameters.Add("@BranchUnitName", SqlDbType.NVarChar).Value = PassBranchUnit.BranchUnitName ?? (object)DBNull.Value;
                cmd.Parameters.Add("@BranchUnitContact", SqlDbType.VarChar).Value = PassBranchUnit.BranchUnitContact ?? (object)DBNull.Value;
                cmd.Parameters.Add("@BranchUnitEmail", SqlDbType.VarChar).Value = PassBranchUnit.BranchUnitEmail ?? (object)DBNull.Value;
                cmd.Parameters.Add("@BranchUnitAddress", SqlDbType.VarChar).Value = PassBranchUnit.BranchUnitAddress ?? (object)DBNull.Value;
                cmd.Parameters.Add("@BranchUnitDialogue", SqlDbType.VarChar).Value = PassBranchUnit.BranchUnitDialogue ?? (object)DBNull.Value;
                cmd.Parameters.Add("@BranchUnitLogo", SqlDbType.VarBinary).Value = PassBranchUnit.BranchUnitLogo ?? (object)DBNull.Value;
                cmd.Parameters.Add("@BranchUnitMessage", SqlDbType.VarChar).Value = PassBranchUnit.BranchUnitMessage ?? (object)DBNull.Value;
                cmd.Parameters.AddWithValue("@UpdatedBy", PassBranchUnit.UpdatedBy);
                await con.OpenAsync();
                return await cmd.ExecuteNonQueryAsync();
            }
            public async Task<int> DeleteBranchUnit(BranchUnitEntity PassBranchUnit)
            {
                using var con = new SqlConnection(_ConStrRxForEyeIPD);
                using var cmd = new SqlCommand("ProcDeleteBranchUnit", con)
                {
                    CommandType = CommandType.StoredProcedure
                };
                cmd.Parameters.Add("@BranchUnitId", SqlDbType.Int).Value = PassBranchUnit.BranchUnitId;
                cmd.Parameters.AddWithValue("@DeletedBy", PassBranchUnit.DeletedBy); // Pass logged-in user id later 
                await con.OpenAsync();
                return await cmd.ExecuteNonQueryAsync();
            }
            private BranchUnitEntity MapBranchUnit(SqlDataReader dr)
            {
                return new BranchUnitEntity
                {
                    BaseHospitalId = Convert.ToInt32(dr["BaseHospitalId"]),
                    BranchUnitName = Convert.ToString(dr["BranchUnitName"]),
                    BranchUnitContact = dr["BranchUnitContact"] == DBNull.Value ? null : Convert.ToString(dr["BranchUnitContact"]),
                    BranchUnitEmail = dr["BranchUnitEmail"] == DBNull.Value ? null : Convert.ToString(dr["BranchUnitEmail"]),
                    BranchUnitAddress = Convert.ToString(dr["BranchUnitAddress"]),
                    BranchUnitDialogue = dr["BranchUnitDialogue"] == DBNull.Value ? null : Convert.ToString(dr["BranchUnitDialogue"]),
                    BranchUnitLogo = dr["BranchUnitLogo"] == DBNull.Value ? null : (byte[])dr["BranchUnitLogo"],
                    BranchUnitMessage = dr["BranchUnitMessage"] == DBNull.Value ? null : Convert.ToString(dr["BranchUnitMessage"]),
                };
            }
        }
    }
}
