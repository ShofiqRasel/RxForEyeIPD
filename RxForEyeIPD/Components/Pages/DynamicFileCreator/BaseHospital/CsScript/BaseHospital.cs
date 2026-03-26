using Microsoft.Data.SqlClient;
using System.ComponentModel.DataAnnotations;
using System.Data;

namespace RxForEyeIPD.Components.Pages.DynamicFileCreator.BaseHospital.CsScript
{
    public class BaseHospitalEntity
    {
        public int BaseHospitalId { get; set; }
        [Required(ErrorMessage = "A Base hospital name is required.")]
        [StringLength(100, MinimumLength = 6, ErrorMessage = "Base hospital name must be at least 6 characters.")]
        public string? BaseHospitalName { get; set; }
        public string? BaseHospitalContact { get; set; }
        public string? BaseHospitalEmail { get; set; }

        [Required(ErrorMessage = "Address is required")]
        [StringLength(100, MinimumLength = 6, ErrorMessage = "Base hospital address must be at least 6 characters.")]
        public string? BaseHospitalAddress { get; set; }
        public string? BaseHospitalDialogue { get; set; }
        public byte[]? BaseHospitalLogo { get; set; }
        public string ImagePreviewUrl { get; set; } = "Images/MiscImage/default-avatar.png";
        public string? BaseHospitalMessage { get; set; }
        public int CreatedBy { get; set; }
        public int UpdatedBy { get; set; }
        public int DeletedBy { get; set; }
        public DateTime CreatedAt { get; set; }
        public DateTime UpdatedAt { get; set; }
        public DateTime DeletedAt { get; set; }
        public string? IsActive { get; set; }
    }
    public interface IBaseHospital
    {
        Task<List<BaseHospitalEntity>> GetAllBaseHospital();
        Task<BaseHospitalEntity> GetBaseHospitalById(int PassBaseHospitalId);
        Task<int> CreateBaseHospital(BaseHospitalEntity PassBaseHospital);
        Task<int> UpdateBaseHospital(BaseHospitalEntity PassBaseHospital);
        Task<int> DeleteBaseHospital(BaseHospitalEntity PassBaseHospital);
    }
    // builder.Services.AddScoped<IBaseHospital, BaseHospitalRepository>(); // Add This line to program.cs file 
    public class BaseHospitalRepository : IBaseHospital
    {
        private readonly string _ConStrRxForEyeIPD;

        public BaseHospitalRepository(IConfiguration config)
        {
            _ConStrRxForEyeIPD = config.GetConnectionString("ConStrRxForEyeIPD")
            ?? throw new ArgumentNullException(nameof(config),
            "Connection string 'ConStrRxForEyeIPD' not found in configuration");
        }
        public async Task<List<BaseHospitalEntity>> GetAllBaseHospital()
        {
            List<BaseHospitalEntity> BaseHospitallist = new List<BaseHospitalEntity>();
            using SqlConnection con = new SqlConnection(_ConStrRxForEyeIPD);
            using (SqlCommand cmd = new SqlCommand("ProcSelectAllBaseHospital", con))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                await con.OpenAsync();
                using (SqlDataReader dr = await cmd.ExecuteReaderAsync())
                    while (await dr.ReadAsync())
                    {
                        BaseHospitallist.Add(new BaseHospitalEntity
                        {
                            BaseHospitalId = dr["BaseHospitalId"] == DBNull.Value ? 0 : Convert.ToInt32(dr["BaseHospitalId"]),
                            BaseHospitalName = Convert.ToString(dr["BaseHospitalName"]),
                            BaseHospitalContact = dr["BaseHospitalContact"] == DBNull.Value ? null : Convert.ToString(dr["BaseHospitalContact"]),
                            BaseHospitalEmail = dr["BaseHospitalEmail"] == DBNull.Value ? null : Convert.ToString(dr["BaseHospitalEmail"]),
                            BaseHospitalAddress = Convert.ToString(dr["BaseHospitalAddress"]),
                            BaseHospitalDialogue = dr["BaseHospitalDialogue"] == DBNull.Value ? null : Convert.ToString(dr["BaseHospitalDialogue"]),
                            BaseHospitalLogo = dr["BaseHospitalLogo"] == DBNull.Value ? null : (byte[])dr["BaseHospitalLogo"],
                            BaseHospitalMessage = dr["BaseHospitalMessage"] == DBNull.Value ? null : Convert.ToString(dr["BaseHospitalMessage"]),
                            CreatedBy = Convert.ToInt32(dr["CreatedBy"]),
                            UpdatedBy = dr["UpdatedBy"] == DBNull.Value ? 0 : Convert.ToInt32(dr["UpdatedBy"]),
                            DeletedBy = dr["DeletedBy"] == DBNull.Value ? 0 : Convert.ToInt32(dr["DeletedBy"]),
                            CreatedAt = Convert.ToDateTime(dr["CreatedAt"]),
                            UpdatedAt = dr["UpdatedAt"] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime(dr["UpdatedAt"]),
                            DeletedAt = dr["DeletedAt"] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime(dr["DeletedAt"]),
                            IsActive = dr["IsActive"].ToString()
                        });
                    }
                return BaseHospitallist;
            }
        }
        public async Task<BaseHospitalEntity> GetBaseHospitalById(int PassBaseHospitalId)
        {
            using var con = new SqlConnection(_ConStrRxForEyeIPD);
            using var cmd = new SqlCommand("ProcSelectOneBaseHospital", con)
            {
                CommandType = CommandType.StoredProcedure
            };
            cmd.Parameters.AddWithValue("@BaseHospitalId", PassBaseHospitalId);
            await con.OpenAsync();
            using var dr = await cmd.ExecuteReaderAsync();
            if (await dr.ReadAsync())
                return MapBaseHospital(dr);
            throw new KeyNotFoundException($"PassBaseHospital with ID {PassBaseHospitalId} not found");
        }
        public async Task<int> CreateBaseHospital(BaseHospitalEntity PassBaseHospital)
        {
            using var con = new SqlConnection(_ConStrRxForEyeIPD);
            using var cmd = new SqlCommand("ProcInsertBaseHospital", con)
            {
                CommandType = CommandType.StoredProcedure
            };
            cmd.Parameters.AddWithValue("@BaseHospitalName", PassBaseHospital.BaseHospitalName ?? (object)DBNull.Value);
            cmd.Parameters.AddWithValue("@BaseHospitalContact", PassBaseHospital.BaseHospitalContact ?? (object)DBNull.Value);
            cmd.Parameters.AddWithValue("@BaseHospitalEmail", PassBaseHospital.BaseHospitalEmail ?? (object)DBNull.Value);
            cmd.Parameters.AddWithValue("@BaseHospitalAddress", PassBaseHospital.BaseHospitalAddress ?? (object)DBNull.Value);
            cmd.Parameters.AddWithValue("@BaseHospitalDialogue", PassBaseHospital.BaseHospitalDialogue ?? (object)DBNull.Value);
            cmd.Parameters.Add("@BaseHospitalLogo", SqlDbType.VarBinary).Value = PassBaseHospital.BaseHospitalLogo ?? (object)DBNull.Value;
            cmd.Parameters.AddWithValue("@BaseHospitalMessage", PassBaseHospital.BaseHospitalMessage ?? (object)DBNull.Value);
            cmd.Parameters.AddWithValue("@CreatedBy", PassBaseHospital.CreatedBy);
            await con.OpenAsync();
            int isSuccess = 0;
            isSuccess = cmd.ExecuteNonQuery();
            return isSuccess;
        }
        public async Task<int> UpdateBaseHospital(BaseHospitalEntity PassBaseHospital)
        {
            using var con = new SqlConnection(_ConStrRxForEyeIPD);
            using var cmd = new SqlCommand("ProcUpdateBaseHospital", con)
            {
                CommandType = CommandType.StoredProcedure
            };
            cmd.Parameters.AddWithValue("@BaseHospitalId", PassBaseHospital.BaseHospitalId);
            cmd.Parameters.AddWithValue("@BaseHospitalName", PassBaseHospital.BaseHospitalName);
            cmd.Parameters.AddWithValue("@BaseHospitalContact", PassBaseHospital.BaseHospitalContact);
            cmd.Parameters.AddWithValue("@BaseHospitalEmail", PassBaseHospital.BaseHospitalEmail);
            cmd.Parameters.AddWithValue("@BaseHospitalAddress", PassBaseHospital.BaseHospitalAddress);
            cmd.Parameters.AddWithValue("@BaseHospitalDialogue", PassBaseHospital.BaseHospitalDialogue);
            cmd.Parameters.AddWithValue("@BaseHospitalLogo", PassBaseHospital.BaseHospitalLogo);
            cmd.Parameters.AddWithValue("@BaseHospitalMessage", PassBaseHospital.BaseHospitalMessage);
            cmd.Parameters.AddWithValue("@UpdatedBy", PassBaseHospital.UpdatedBy);
            await con.OpenAsync();
            return await cmd.ExecuteNonQueryAsync();
        }
        public async Task<int> DeleteBaseHospital(BaseHospitalEntity PassBaseHospital)
        {
            using var con = new SqlConnection(_ConStrRxForEyeIPD);
            using var cmd = new SqlCommand("ProcDeleteBaseHospital", con)
            {
                CommandType = CommandType.StoredProcedure
            };
            cmd.Parameters.AddWithValue("@BaseHospitalId", PassBaseHospital.BaseHospitalId);
            cmd.Parameters.AddWithValue("@DeletedBy", PassBaseHospital.DeletedBy); // Pass logged-in user id later 
            await con.OpenAsync();
            int isSuccess = 0;
            isSuccess = await cmd.ExecuteNonQueryAsync();
            return isSuccess;
        }
        private BaseHospitalEntity MapBaseHospital(SqlDataReader dr)
        {
            return new BaseHospitalEntity
            {
                BaseHospitalName = Convert.ToString(dr["BaseHospitalName"]),
                BaseHospitalContact = dr["BaseHospitalContact"] == DBNull.Value ? null : Convert.ToString(dr["BaseHospitalContact"]),
                BaseHospitalEmail = dr["BaseHospitalEmail"] == DBNull.Value ? null : Convert.ToString(dr["BaseHospitalEmail"]),
                BaseHospitalAddress = Convert.ToString(dr["BaseHospitalAddress"]),
                BaseHospitalDialogue = dr["BaseHospitalDialogue"] == DBNull.Value ? null : Convert.ToString(dr["BaseHospitalDialogue"]),
                BaseHospitalLogo = dr["BaseHospitalLogo"] as byte[],
                BaseHospitalMessage = dr["BaseHospitalMessage"] == DBNull.Value ? null : Convert.ToString(dr["BaseHospitalMessage"]),
            };
        }
    }
}
