use db_RxForEyeIPD
set nocount on

declare @TableNameString as varchar(50) = ''

declare @TableCreatorString varchar(4000) = '',  @TableName varchar (100), @EntityCreatorRow varchar(200), @Counter int = 2

if object_id ('TableCreatorFirst') is not null
drop table TableCreatorFirst

select * into TableCreatorFirst from OPENROWSET('Microsoft.ACE.OLEDB.12.0',  'Excel 8.0;HDR=YES;Database=E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Files\02. WithoutPrimaryAndWithForeignKey\TableCreateWithoutPrimaryAndWithForeignKey.xlsx', 'select * from [TblUser$]') 


if object_id ('TableCreator') is not null
drop table TableCreator

select ROW_NUMBER() OVER (ORDER BY Slno asc) as SlNo, Particulars, ColumnName, ValueType, Amount, Nullable, DefaultValue, ChildRow, Method, Tbl, Val, Txt, ValidationMessage into TableCreator from TableCreatorFirst order by SlNo asc


set @TableName = (select ColumnName from TableCreator where particulars = 'TableName')


set @TableCreatorString = (select 'IF EXIST "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\CsScript\" RMDIR /S /Q "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\CsScript\"')
EXEC xp_cmdshell @TableCreatorString

set @TableCreatorString = (select 'mkdir "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\CsScript\"')
EXEC xp_cmdshell @TableCreatorString

--Section : Create Table

set @TableCreatorString = (select 'echo using Microsoft.Data.SqlClient; >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\CsScript\\'+ @TableName +'.cs"') EXEC xp_cmdshell @TableCreatorString
set @TableCreatorString = (select 'echo using System.ComponentModel.DataAnnotations; >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\CsScript\\'+ @TableName +'.cs"') EXEC xp_cmdshell @TableCreatorString
set @TableCreatorString = (select 'echo using System.Data; >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\CsScript\\'+ @TableName +'.cs"') EXEC xp_cmdshell @TableCreatorString
set @TableCreatorString = (select 'echo using static RxForEyeIPD.Components.Pages.Settings.LocationMaster.'+ @TableName +'.srv'+ @TableName +'; /*Change The Path Above Accordingly*/ >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\CsScript\\'+ @TableName +'.cs"') EXEC xp_cmdshell @TableCreatorString

set @TableCreatorString = (select 'echo namespace RxForEyeIPD.Components.Pages.Settings.LocationMaster.'+ @TableName +' /*Change The Namespace Accordingly*/ >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\CsScript\\'+ @TableName +'.cs"') EXEC xp_cmdshell @TableCreatorString
set @TableCreatorString = (select 'echo { >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\CsScript\\'+ @TableName +'.cs"') EXEC xp_cmdshell @TableCreatorString
set @TableCreatorString = (select 'echo public class srv'+ @TableName +' >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\CsScript\\'+ @TableName +'.cs"') EXEC xp_cmdshell @TableCreatorString
set @TableCreatorString = (select 'echo { >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\CsScript\\'+ @TableName +'.cs"') EXEC xp_cmdshell @TableCreatorString



-- Class Entity

set @TableCreatorString = (select 'echo public class '+ @TableName +'Entity { >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\CsScript\\'+ @TableName +'.cs"')
EXEC xp_cmdshell @TableCreatorString

declare @TempSelectOne varchar(400) = ''

set @Counter = 2
declare @ValueType varchar(20) = '', @PassVarShortName varchar(20) = 'Pass'+ @TableName +''

while ((select (count(*) + 2) Total from TableCreator  where slno>1) > @Counter)
begin
	set @TableCreatorString = (select 'echo '+ (select ValidationMessage from TableCreator  where slno = @Counter) +' >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\CsScript\\'+ @TableName +'.cs"')

	EXEC xp_cmdshell @TableCreatorString

	set @ValueType = (select (CASE	WHEN ValueType = 'int' THEN 'int' 
									WHEN ValueType = 'bit' THEN 'bool'
									WHEN ValueType = 'decimal' THEN 'decimal'
									WHEN ValueType = 'float' THEN 'double'
									WHEN ValueType = 'real' THEN 'float'
									WHEN ValueType = 'char' THEN 'string?'
									WHEN ValueType = 'varchar' THEN 'string?'
									WHEN ValueType = 'nchar' THEN 'string?'
									WHEN ValueType = 'nvarchar' THEN 'string?'
									WHEN ValueType = 'DateTime' THEN 'DateTime'
									WHEN ValueType = 'varbinary' THEN 'byte[]'
									WHEN ValueType = 'image' THEN 'byte[]'
									ELSE '' end) 
									Result from TableCreator where Slno = @Counter)
	
	set @TempSelectOne = (select 'echo ' + (select 'public ' + @ValueType + ' ' + ColumnName  + ' {get; set;}' from TableCreator where slno >1 and SlNo = @Counter)  + ' >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\CsScript\\'+ @TableName +'.cs"')
	set @Counter += 1

	EXEC xp_cmdshell @TempSelectOne
end

set @TableCreatorString = (select 'echo } >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\CsScript\\'+ @TableName +'.cs"')
EXEC xp_cmdshell @TableCreatorString

-- Class Entity

-- Interface
        set @TableCreatorString = (select 'echo public interface I'+ @TableName +' >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\CsScript\\'+ @TableName +'.cs"') EXEC xp_cmdshell @TableCreatorString
        set @TableCreatorString = (select 'echo { >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\CsScript\\'+ @TableName +'.cs"') EXEC xp_cmdshell @TableCreatorString
            set @TableCreatorString = (select 'echo Task ^<List^<'+ @TableName +'Entity^>^> GetAll'+ @TableName +'(); >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\CsScript\\'+ @TableName +'.cs"') EXEC xp_cmdshell @TableCreatorString
            set @TableCreatorString = (select 'echo Task ^<'+ @TableName +'Entity^> Get'+ @TableName +'ById(int '+ @PassVarShortName +'Id); >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\CsScript\\'+ @TableName +'.cs"') EXEC xp_cmdshell @TableCreatorString
            set @TableCreatorString = (select 'echo Task ^<List^<'+ @TableName +'Entity^>^> Get'+ @TableName +'By'+(select ColumnName from TableCreator where Method = 'Yes' and Val != '.' and ChildRow != '.')+'(int '+(select ColumnName from TableCreator where Method = 'Yes' and Val != '.' and ChildRow != '.')+'); >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\CsScript\\'+ @TableName +'.cs"') EXEC xp_cmdshell @TableCreatorString
            set @TableCreatorString = (select 'echo Task ^<int^> Create'+ @TableName +'('+ @TableName +'Entity '+ @PassVarShortName +'); >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\CsScript\\'+ @TableName +'.cs"') EXEC xp_cmdshell @TableCreatorString
            set @TableCreatorString = (select 'echo Task ^<int^> Update'+ @TableName +'('+ @TableName +'Entity '+ @PassVarShortName +'); >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\CsScript\\'+ @TableName +'.cs"') EXEC xp_cmdshell @TableCreatorString
            set @TableCreatorString = (select 'echo Task ^<int^> Delete'+ @TableName +'('+ @TableName +'Entity '+ @PassVarShortName +'); >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\CsScript\\'+ @TableName +'.cs"') EXEC xp_cmdshell @TableCreatorString
        set @TableCreatorString = (select 'echo } >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\CsScript\\'+ @TableName +'.cs"') EXEC xp_cmdshell @TableCreatorString

		set @TableCreatorString = (select 'echo // builder.Services.AddScoped^<I'+ @TableName +', '+ @TableName +'Repository^>(); // Add This line to program.cs file >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\CsScript\\'+ @TableName +'.cs"')
		EXEC xp_cmdshell @TableCreatorString
-- Class Interface

-- Class Interface Methods
        set @TableCreatorString = (select 'echo public class '+ @TableName +'Repository : I'+ @TableName +' >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\CsScript\\'+ @TableName +'.cs"') EXEC xp_cmdshell @TableCreatorString
        set @TableCreatorString = (select 'echo { >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\CsScript\\'+ @TableName +'.cs"') EXEC xp_cmdshell @TableCreatorString
            set @TableCreatorString = (select 'echo private readonly string _ConStrRxForEyeIPD; >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\CsScript\\'+ @TableName +'.cs"') EXEC xp_cmdshell @TableCreatorString

            set @TableCreatorString = (select 'echo public '+ @TableName +'Repository(IConfiguration config) >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\CsScript\\'+ @TableName +'.cs"') EXEC xp_cmdshell @TableCreatorString
            set @TableCreatorString = (select 'echo { >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\CsScript\\'+ @TableName +'.cs"') EXEC xp_cmdshell @TableCreatorString
            set @TableCreatorString = (select 'echo _ConStrRxForEyeIPD = config.GetConnectionString("ConStrRxForEyeIPD") >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\CsScript\\'+ @TableName +'.cs"') EXEC xp_cmdshell @TableCreatorString
            set @TableCreatorString = (select 'echo ?? throw new ArgumentNullException(nameof(config), >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\CsScript\\'+ @TableName +'.cs"') EXEC xp_cmdshell @TableCreatorString
            set @TableCreatorString = (select 'echo "Connection string ''ConStrRxForEyeIPD'' not found in configuration"); >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\CsScript\\'+ @TableName +'.cs"') EXEC xp_cmdshell @TableCreatorString
            set @TableCreatorString = (select 'echo } >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\CsScript\\'+ @TableName +'.cs"') EXEC xp_cmdshell @TableCreatorString

			set @TableCreatorString = (select 'echo public async Task^<List^<'+ @TableName +'Entity^>^> GetAll'+ @TableName +'() >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\CsScript\\'+ @TableName +'.cs"') EXEC xp_cmdshell @TableCreatorString
            set @TableCreatorString = (select 'echo { >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\CsScript\\'+ @TableName +'.cs"') EXEC xp_cmdshell @TableCreatorString
                
                set @TableCreatorString = (select 'echo List^<'+ @TableName +'Entity^> '+ @TableName +'list = new List^<'+ @TableName +'Entity^>(); >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\CsScript\\'+ @TableName +'.cs"') EXEC xp_cmdshell @TableCreatorString

                set @TableCreatorString = (select 'echo using SqlConnection con = new SqlConnection(_ConStrRxForEyeIPD); >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\CsScript\\'+ @TableName +'.cs"') EXEC xp_cmdshell @TableCreatorString
                
                
                set @TableCreatorString = (select 'echo using (SqlCommand cmd = new SqlCommand("ProcSelectAll' + @TableName +'", con)) >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\CsScript\\'+ @TableName +'.cs"') EXEC xp_cmdshell @TableCreatorString
                set @TableCreatorString = (select 'echo { >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\CsScript\\'+ @TableName +'.cs"') EXEC xp_cmdshell @TableCreatorString
                set @TableCreatorString = (select 'echo cmd.CommandType = CommandType.StoredProcedure; >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\CsScript\\'+ @TableName +'.cs"') EXEC xp_cmdshell @TableCreatorString

                set @TableCreatorString = (select 'echo await con.OpenAsync(); >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\CsScript\\'+ @TableName +'.cs"') EXEC xp_cmdshell @TableCreatorString
                set @TableCreatorString = (select 'echo  using (SqlDataReader dr = await cmd.ExecuteReaderAsync()) >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\CsScript\\'+ @TableName +'.cs"') EXEC xp_cmdshell @TableCreatorString

                set @TableCreatorString = (select 'echo while (await dr.ReadAsync()) >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\CsScript\\'+ @TableName +'.cs"') EXEC xp_cmdshell @TableCreatorString
                set @TableCreatorString = (select 'echo { >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\CsScript\\'+ @TableName +'.cs"') EXEC xp_cmdshell @TableCreatorString
                set @TableCreatorString = (select 'echo ' + @TableName +'list.Add(new ' + @TableName +'Entity >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\CsScript\\'+ @TableName +'.cs"') EXEC xp_cmdshell @TableCreatorString
                set @TableCreatorString = (select 'echo { >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\CsScript\\'+ @TableName +'.cs"') EXEC xp_cmdshell @TableCreatorString
                --set @TableCreatorString = (select 'echo '+ @TableName +'list.Add(Map'+ @TableName +'(dr)); >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\CsScript\\'+ @TableName +'.cs"')  EXEC xp_cmdshell @TableCreatorString
                ------------------ New working area
                set @TableCreatorString = (select 'echo '+ (select ColumnName from TableCreator  where particulars in ('Column') and Slno = 2) +' = dr.GetInt32(dr.GetOrdinal("'+ (select ColumnName from TableCreator  where particulars in ('Column') and Slno = 2) +'")), >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\CsScript\\'+ @TableName +'.cs"') EXEC xp_cmdshell @TableCreatorString
                    
					-- working area
					declare @ColumnName varchar(50) = '', @Nullability varchar(10) = ''
						set @Counter = 2

					while ((select (count(*) + 2) Total from TableCreator  where particulars in ('PrimaryID',  'Column')) > @Counter)
					begin


					set @Nullability = (select (CASE	WHEN ValueType = 'int' THEN '0' 
									WHEN ValueType = 'bit' THEN 'false'
									WHEN ValueType = 'decimal' THEN '0.0'
									WHEN ValueType = 'float' THEN '0.0'
									WHEN ValueType = 'real' THEN '0'
									WHEN ValueType = 'char' THEN 'null'
									WHEN ValueType = 'varchar' THEN 'null'
									WHEN ValueType = 'nchar' THEN 'null'
									WHEN ValueType = 'nvarchar' THEN 'null'
									WHEN ValueType = 'DateTime' THEN 'null'
									--WHEN ValueType = 'varbinary' THEN 'byte[]'
									--WHEN ValueType = 'image' THEN 'byte[]'
									ELSE '' end) 
									Result from TableCreator where Slno = @Counter)

					set @ValueType = (select (CASE	WHEN ValueType = 'int' THEN 'Convert.ToInt32' 
									WHEN ValueType = 'bit' THEN 'Convert.ToBoolean'
									WHEN ValueType = 'decimal' THEN 'Convert.ToDecimal'
									WHEN ValueType = 'float' THEN 'Convert.ToDouble'
									WHEN ValueType = 'real' THEN 'Convert.ToSingle'
									WHEN ValueType = 'char' THEN 'Convert.ToString'
									WHEN ValueType = 'varchar' THEN 'Convert.ToString'
									WHEN ValueType = 'nchar' THEN 'Convert.ToString'
									WHEN ValueType = 'nvarchar' THEN 'Convert.ToString'
									WHEN ValueType = 'DateTime' THEN 'Convert.ToDateTime'
									--WHEN ValueType = 'varbinary' THEN 'byte[]'
									--WHEN ValueType = 'image' THEN 'byte[]'
									ELSE '' end) 
									Result from TableCreator where Slno = @Counter)

						set @ColumnName = (select ColumnName from TableCreator  where particulars in ('PrimaryID',  'Column') and Slno = @Counter)

						if((select Nullable from TableCreator  where particulars in ('Column') and Slno = @Counter) = 'Not Null')
							begin
								set @TableCreatorString = (select 'echo '+ @ColumnName +' = '+ @ValueType +'(dr["'+ @ColumnName +'"]), >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\CsScript\\'+ @TableName +'.cs"') EXEC xp_cmdshell @TableCreatorString
							end
						else
							begin
								set @TableCreatorString = (select 'echo '+ @ColumnName +' = dr["'+ @ColumnName +'"] == DBNull.Value ? '+ @Nullability + ' : '+ @ValueType +'(dr["'+ @ColumnName +'"]), >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\CsScript\\'+ @TableName +'.cs"') EXEC xp_cmdshell @TableCreatorString
							end
							set @Counter +=1
					end
					  -- working area
					set @TableCreatorString = (select 'echo CreatedBy = Convert.ToInt32(dr["CreatedBy"]), >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\CsScript\\'+ @TableName +'.cs"') EXEC xp_cmdshell @TableCreatorString
                    set @TableCreatorString = (select 'echo UpdatedBy = dr["UpdatedBy"] == DBNull.Value ? 0 : Convert.ToInt32(dr["UpdatedBy"]), >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\CsScript\\'+ @TableName +'.cs"') EXEC xp_cmdshell @TableCreatorString
                    set @TableCreatorString = (select 'echo DeletedBy = dr["DeletedBy"] == DBNull.Value ? 0 : Convert.ToInt32(dr["DeletedBy"]), >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\CsScript\\'+ @TableName +'.cs"') EXEC xp_cmdshell @TableCreatorString
                    set @TableCreatorString = (select 'echo CreatedAt = Convert.ToDateTime(dr["CreatedAt"]), >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\CsScript\\'+ @TableName +'.cs"') EXEC xp_cmdshell @TableCreatorString
                    set @TableCreatorString = (select 'echo UpdatedAt = dr["UpdatedAt"] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime(dr["UpdatedAt"]), >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\CsScript\\'+ @TableName +'.cs"') EXEC xp_cmdshell @TableCreatorString
                    set @TableCreatorString = (select 'echo DeletedAt = dr["DeletedAt"] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime(dr["DeletedAt"]), >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\CsScript\\'+ @TableName +'.cs"') EXEC xp_cmdshell @TableCreatorString
                    set @TableCreatorString = (select 'echo IsActive = dr["IsActive"].ToString() >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\CsScript\\'+ @TableName +'.cs"') EXEC xp_cmdshell @TableCreatorString
                
                
                ------------------ New working area
                
                
                set @TableCreatorString = (select 'echo } >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\CsScript\\'+ @TableName +'.cs"') EXEC xp_cmdshell @TableCreatorString
                set @TableCreatorString = (select 'echo ); >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\CsScript\\'+ @TableName +'.cs"') EXEC xp_cmdshell @TableCreatorString
                set @TableCreatorString = (select 'echo } >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\CsScript\\'+ @TableName +'.cs"') EXEC xp_cmdshell @TableCreatorString
                set @TableCreatorString = (select 'echo return '+ @TableName +'list; >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\CsScript\\'+ @TableName +'.cs"') EXEC xp_cmdshell @TableCreatorString
				set @TableCreatorString = (select 'echo } >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\CsScript\\'+ @TableName +'.cs"') EXEC xp_cmdshell @TableCreatorString
                set @TableCreatorString = (select 'echo } >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\CsScript\\'+ @TableName +'.cs"') EXEC xp_cmdshell @TableCreatorString
				


            set @TableCreatorString = (select 'echo public async Task^<'+ @TableName +'Entity^> Get'+ @TableName +'ById(int '+ @PassVarShortName +'Id) >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\CsScript\\'+ @TableName +'.cs"') EXEC xp_cmdshell @TableCreatorString
            set @TableCreatorString = (select 'echo { >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\CsScript\\'+ @TableName +'.cs"') EXEC xp_cmdshell @TableCreatorString
                set @TableCreatorString = (select 'echo using var con = new SqlConnection(_ConStrRxForEyeIPD); >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\CsScript\\'+ @TableName +'.cs"') EXEC xp_cmdshell @TableCreatorString
				set @TableCreatorString = (select 'echo using var cmd = new SqlCommand("ProcSelectOne'+ @TableName +'", con) >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\CsScript\\'+ @TableName +'.cs"') EXEC xp_cmdshell @TableCreatorString
                set @TableCreatorString = (select 'echo { >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\CsScript\\'+ @TableName +'.cs"') EXEC xp_cmdshell @TableCreatorString
                    set @TableCreatorString = (select 'echo CommandType = CommandType.StoredProcedure >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\CsScript\\'+ @TableName +'.cs"') EXEC xp_cmdshell @TableCreatorString
                set @TableCreatorString = (select 'echo }; >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\CsScript\\'+ @TableName +'.cs"') EXEC xp_cmdshell @TableCreatorString
				

                set @TableCreatorString = (select 'echo cmd.Parameters.AddWithValue("@'+ (select ColumnName from TableCreator where particulars in ('PrimaryID')) +'", '+ @PassVarShortName +'Id); >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\CsScript\\'+ @TableName +'.cs"') EXEC xp_cmdshell @TableCreatorString

                set @TableCreatorString = (select 'echo await con.OpenAsync(); >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\CsScript\\'+ @TableName +'.cs"') EXEC xp_cmdshell @TableCreatorString
                set @TableCreatorString = (select 'echo using var dr = await cmd.ExecuteReaderAsync(); >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\CsScript\\'+ @TableName +'.cs"') EXEC xp_cmdshell @TableCreatorString

                set @TableCreatorString = (select 'echo if (await dr.ReadAsync()) >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\CsScript\\'+ @TableName +'.cs"') EXEC xp_cmdshell @TableCreatorString
                    set @TableCreatorString = (select 'echo return Map'+ @TableName +'(dr); >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\CsScript\\'+ @TableName +'.cs"') EXEC xp_cmdshell @TableCreatorString

                set @TableCreatorString = (select 'echo throw new KeyNotFoundException($"'+ @PassVarShortName +' with ID {'+ @PassVarShortName +'Id} not found"); >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\CsScript\\'+ @TableName +'.cs"') EXEC xp_cmdshell @TableCreatorString
            set @TableCreatorString = (select 'echo } >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\CsScript\\'+ @TableName +'.cs"') EXEC xp_cmdshell @TableCreatorString

            set @TableCreatorString = (select 'echo public async Task^<int^> Create'+ @TableName +'('+ @TableName +'Entity '+ @PassVarShortName +') >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\CsScript\\'+ @TableName +'.cs"') EXEC xp_cmdshell @TableCreatorString
            set @TableCreatorString = (select 'echo { >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\CsScript\\'+ @TableName +'.cs"') EXEC xp_cmdshell @TableCreatorString
                set @TableCreatorString = (select 'echo using var con = new SqlConnection(_ConStrRxForEyeIPD); >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\CsScript\\'+ @TableName +'.cs"') EXEC xp_cmdshell @TableCreatorString
                set @TableCreatorString = (select 'echo using var cmd = new SqlCommand("ProcInsert'+ @TableName +'", con) >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\CsScript\\'+ @TableName +'.cs"') EXEC xp_cmdshell @TableCreatorString
                set @TableCreatorString = (select 'echo { >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\CsScript\\'+ @TableName +'.cs"') EXEC xp_cmdshell @TableCreatorString
                    set @TableCreatorString = (select 'echo CommandType = CommandType.StoredProcedure >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\CsScript\\'+ @TableName +'.cs"') EXEC xp_cmdshell @TableCreatorString
                set @TableCreatorString = (select 'echo }; >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\CsScript\\'+ @TableName +'.cs"') EXEC xp_cmdshell @TableCreatorString
				
				-- working area
				set @Counter = 3

				while ((select (count(*) + 3) Total from TableCreator  where particulars in ('Column')) > @Counter)
				begin
					set @TableCreatorString = (select 'echo cmd.Parameters.AddWithValue("@'+ (select ColumnName from TableCreator where particulars in ('Column') and SlNo = @Counter) +'", '+ @PassVarShortName +'.'+ (select ColumnName from TableCreator where particulars in ('Column') and SlNo = @Counter) +'); >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\CsScript\\'+ @TableName +'.cs"') 
					EXEC xp_cmdshell @TableCreatorString
					set @Counter +=1
                end
				
				-- working area
				
				set @TableCreatorString = (select 'echo cmd.Parameters.AddWithValue("@CreatedBy", '+ @PassVarShortName +'.CreatedBy); >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\CsScript\\'+ @TableName +'.cs"') EXEC xp_cmdshell @TableCreatorString

                set @TableCreatorString = (select 'echo await con.OpenAsync(); >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\CsScript\\'+ @TableName +'.cs"') EXEC xp_cmdshell @TableCreatorString
                set @TableCreatorString = (select 'echo return await cmd.ExecuteNonQueryAsync(); >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\CsScript\\'+ @TableName +'.cs"') EXEC xp_cmdshell @TableCreatorString
            set @TableCreatorString = (select 'echo } >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\CsScript\\'+ @TableName +'.cs"') EXEC xp_cmdshell @TableCreatorString

            set @TableCreatorString = (select 'echo public async Task^<int^> Update'+ @TableName +'('+ @TableName +'Entity '+ @PassVarShortName +') >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\CsScript\\'+ @TableName +'.cs"') EXEC xp_cmdshell @TableCreatorString
            set @TableCreatorString = (select 'echo { >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\CsScript\\'+ @TableName +'.cs"') EXEC xp_cmdshell @TableCreatorString
                set @TableCreatorString = (select 'echo using var con = new SqlConnection(_ConStrRxForEyeIPD); >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\CsScript\\'+ @TableName +'.cs"') EXEC xp_cmdshell @TableCreatorString
                set @TableCreatorString = (select 'echo using var cmd = new SqlCommand("ProcUpdate'+ @TableName +'", con) >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\CsScript\\'+ @TableName +'.cs"') EXEC xp_cmdshell @TableCreatorString
                set @TableCreatorString = (select 'echo { >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\CsScript\\'+ @TableName +'.cs"') EXEC xp_cmdshell @TableCreatorString
                    set @TableCreatorString = (select 'echo CommandType = CommandType.StoredProcedure >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\CsScript\\'+ @TableName +'.cs"') EXEC xp_cmdshell @TableCreatorString
                set @TableCreatorString = (select 'echo }; >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\CsScript\\'+ @TableName +'.cs"') EXEC xp_cmdshell @TableCreatorString

                set @TableCreatorString = (select 'echo cmd.Parameters.AddWithValue("@'+ (select ColumnName from TableCreator where particulars in ('PrimaryID')) +'", '+ @PassVarShortName +'.'+ (select ColumnName from TableCreator where particulars in ('PrimaryID')) +'); >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\CsScript\\'+ @TableName +'.cs"') EXEC xp_cmdshell @TableCreatorString
                
				-- working area
				set @Counter = 3

				while ((select (count(*) + 3) Total from TableCreator  where particulars in ('Column')) > @Counter)
				begin
					set @TableCreatorString = (select 'echo cmd.Parameters.AddWithValue("@'+ (select ColumnName from TableCreator where particulars in ('Column') and SlNo = @Counter) +'", '+ @PassVarShortName +'.'+ (select ColumnName from TableCreator where particulars in ('Column') and SlNo = @Counter) +'); >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\CsScript\\'+ @TableName +'.cs"') 
					EXEC xp_cmdshell @TableCreatorString
					set @Counter +=1
                end
				
				-- working area
				
				set @TableCreatorString = (select 'echo cmd.Parameters.AddWithValue("@UpdatedBy", '+ @PassVarShortName +'.UpdatedBy); >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\CsScript\\'+ @TableName +'.cs"') EXEC xp_cmdshell @TableCreatorString

                set @TableCreatorString = (select 'echo await con.OpenAsync(); >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\CsScript\\'+ @TableName +'.cs"') EXEC xp_cmdshell @TableCreatorString
                set @TableCreatorString = (select 'echo return await cmd.ExecuteNonQueryAsync(); >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\CsScript\\'+ @TableName +'.cs"') EXEC xp_cmdshell @TableCreatorString
            set @TableCreatorString = (select 'echo } >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\CsScript\\'+ @TableName +'.cs"') EXEC xp_cmdshell @TableCreatorString

            set @TableCreatorString = (select 'echo public async Task^<int^> Delete'+ @TableName +'('+ @TableName +'Entity '+ @PassVarShortName +') >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\CsScript\\'+ @TableName +'.cs"') EXEC xp_cmdshell @TableCreatorString
            set @TableCreatorString = (select 'echo { >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\CsScript\\'+ @TableName +'.cs"') EXEC xp_cmdshell @TableCreatorString
                set @TableCreatorString = (select 'echo using var con = new SqlConnection(_ConStrRxForEyeIPD); >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\CsScript\\'+ @TableName +'.cs"') EXEC xp_cmdshell @TableCreatorString
                set @TableCreatorString = (select 'echo using var cmd = new SqlCommand("ProcDelete'+ @TableName +'", con) >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\CsScript\\'+ @TableName +'.cs"') EXEC xp_cmdshell @TableCreatorString
                set @TableCreatorString = (select 'echo { >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\CsScript\\'+ @TableName +'.cs"') EXEC xp_cmdshell @TableCreatorString
                    set @TableCreatorString = (select 'echo CommandType = CommandType.StoredProcedure >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\CsScript\\'+ @TableName +'.cs"') EXEC xp_cmdshell @TableCreatorString
                set @TableCreatorString = (select 'echo }; >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\CsScript\\'+ @TableName +'.cs"') EXEC xp_cmdshell @TableCreatorString

                set @TableCreatorString = (select 'echo cmd.Parameters.AddWithValue("@'+ (select ColumnName from TableCreator where particulars in ('PrimaryID')) +'", '+ @PassVarShortName +'.'+ (select ColumnName from TableCreator where particulars in ('PrimaryID')) +'); >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\CsScript\\'+ @TableName +'.cs"') EXEC xp_cmdshell @TableCreatorString
                set @TableCreatorString = (select 'echo cmd.Parameters.AddWithValue("@DeletedBy", '+ @PassVarShortName +'.DeletedBy); // Pass logged-in user id later >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\CsScript\\'+ @TableName +'.cs"') EXEC xp_cmdshell @TableCreatorString

                set @TableCreatorString = (select 'echo await con.OpenAsync(); >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\CsScript\\'+ @TableName +'.cs"') EXEC xp_cmdshell @TableCreatorString
                set @TableCreatorString = (select 'echo return await cmd.ExecuteNonQueryAsync(); >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\CsScript\\'+ @TableName +'.cs"') EXEC xp_cmdshell @TableCreatorString
            set @TableCreatorString = (select 'echo } >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\CsScript\\'+ @TableName +'.cs"') EXEC xp_cmdshell @TableCreatorString

            set @TableCreatorString = (select 'echo private '+ @TableName +'Entity Map'+ @TableName +'(SqlDataReader dr) >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\CsScript\\'+ @TableName +'.cs"') EXEC xp_cmdshell @TableCreatorString
            set @TableCreatorString = (select 'echo { >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\CsScript\\'+ @TableName +'.cs"') EXEC xp_cmdshell @TableCreatorString
                set @TableCreatorString = (select 'echo return new '+ @TableName +'Entity >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\CsScript\\'+ @TableName +'.cs"') EXEC xp_cmdshell @TableCreatorString
                set @TableCreatorString = (select 'echo { >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\CsScript\\'+ @TableName +'.cs"') EXEC xp_cmdshell @TableCreatorString
                    
					
					set @TableCreatorString = (select 'echo '+ (select ColumnName from TableCreator  where particulars in ('Column') and Slno = 2) +' = dr.GetInt32(dr.GetOrdinal("'+ (select ColumnName from TableCreator  where particulars in ('Column') and Slno = 2) +'")), >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\CsScript\\'+ @TableName +'.cs"') EXEC xp_cmdshell @TableCreatorString
                    
					-- working area
					set @ColumnName = ''
					set @Nullability = ''
						set @Counter = 3

					while ((select (count(*) + 3) Total from TableCreator  where particulars in ('Column')) > @Counter)
					begin


					set @Nullability = (select (CASE	WHEN ValueType = 'int' THEN '0' 
									WHEN ValueType = 'bit' THEN 'false'
									WHEN ValueType = 'decimal' THEN '0.0'
									WHEN ValueType = 'float' THEN '0.0'
									WHEN ValueType = 'real' THEN '0'
									WHEN ValueType = 'char' THEN 'null'
									WHEN ValueType = 'varchar' THEN 'null'
									WHEN ValueType = 'nchar' THEN 'null'
									WHEN ValueType = 'nvarchar' THEN 'null'
									WHEN ValueType = 'DateTime' THEN 'null'
									--WHEN ValueType = 'varbinary' THEN 'byte[]'
									--WHEN ValueType = 'image' THEN 'byte[]'
									ELSE '' end) 
									Result from TableCreator where Slno = @Counter)

					set @ValueType = (select (CASE	WHEN ValueType = 'int' THEN 'Convert.ToInt32' 
									WHEN ValueType = 'bit' THEN 'Convert.ToBoolean'
									WHEN ValueType = 'decimal' THEN 'Convert.ToDecimal'
									WHEN ValueType = 'float' THEN 'Convert.ToDouble'
									WHEN ValueType = 'real' THEN 'Convert.ToSingle'
									WHEN ValueType = 'char' THEN 'Convert.ToString'
									WHEN ValueType = 'varchar' THEN 'Convert.ToString'
									WHEN ValueType = 'nchar' THEN 'Convert.ToString'
									WHEN ValueType = 'nvarchar' THEN 'Convert.ToString'
									WHEN ValueType = 'DateTime' THEN 'Convert.ToDateTime'
									--WHEN ValueType = 'varbinary' THEN 'byte[]'
									--WHEN ValueType = 'image' THEN 'byte[]'
									ELSE '' end) 
									Result from TableCreator where Slno = @Counter)

						set @ColumnName = (select ColumnName from TableCreator  where particulars in ('Column') and Slno = @Counter)

						if((select Nullable from TableCreator  where particulars in ('Column') and Slno = @Counter) = 'Not Null')
							begin
								set @TableCreatorString = (select 'echo '+ @ColumnName +' = '+ @ValueType +'(dr["'+ @ColumnName +'"]), >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\CsScript\\'+ @TableName +'.cs"') EXEC xp_cmdshell @TableCreatorString
							end
						else
							begin
								set @TableCreatorString = (select 'echo '+ @ColumnName +' = dr["'+ @ColumnName +'"] == DBNull.Value ? '+ @Nullability + ' : '+ @ValueType +'(dr["'+ @ColumnName +'"]), >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\CsScript\\'+ @TableName +'.cs"') EXEC xp_cmdshell @TableCreatorString
							end
							set @Counter +=1
					end
					  -- working area
					--set @TableCreatorString = (select 'echo CreatedBy = Convert.ToInt32(dr["CreatedBy"]), >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\CsScript\\'+ @TableName +'.cs"') EXEC xp_cmdshell @TableCreatorString
     --               set @TableCreatorString = (select 'echo UpdatedBy = dr["UpdatedBy"] == DBNull.Value ? 0 : Convert.ToInt32(dr["UpdatedBy"]), >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\CsScript\\'+ @TableName +'.cs"') EXEC xp_cmdshell @TableCreatorString
     --               set @TableCreatorString = (select 'echo DeletedBy = dr["DeletedBy"] == DBNull.Value ? 0 : Convert.ToInt32(dr["DeletedBy"]), >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\CsScript\\'+ @TableName +'.cs"') EXEC xp_cmdshell @TableCreatorString
     --               set @TableCreatorString = (select 'echo CreatedAt = Convert.ToDateTime(dr["CreatedAt"]), >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\CsScript\\'+ @TableName +'.cs"') EXEC xp_cmdshell @TableCreatorString
     --               set @TableCreatorString = (select 'echo UpdatedAt = dr["UpdatedAt"] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime(dr["UpdatedAt"]), >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\CsScript\\'+ @TableName +'.cs"') EXEC xp_cmdshell @TableCreatorString
     --               set @TableCreatorString = (select 'echo DeletedAt = dr["DeletedAt"] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime(dr["DeletedAt"]), >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\CsScript\\'+ @TableName +'.cs"') EXEC xp_cmdshell @TableCreatorString
     --               set @TableCreatorString = (select 'echo IsActive = dr["IsActive"].ToString() >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\CsScript\\'+ @TableName +'.cs"') EXEC xp_cmdshell @TableCreatorString
                set @TableCreatorString = (select 'echo }; >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\CsScript\\'+ @TableName +'.cs"') EXEC xp_cmdshell @TableCreatorString
            set @TableCreatorString = (select 'echo } >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\CsScript\\'+ @TableName +'.cs"') EXEC xp_cmdshell @TableCreatorString
        
        
-- Dropdown Zone
 
if exists (select * from TableCreator where ChildRow != '.')
 begin
				set @TableCreatorString = (select 'echo public async Task ^<List^<'+ @TableName +'Entity^>^> Get'+ @TableName +'By'+(select ColumnName from TableCreator where Method = 'Yes' and Val != '.'and ChildRow != '.')+'(int '+(select ColumnName from TableCreator where Method = 'Yes' and Val != '.' and ChildRow != '.')+') >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\CsScript\\'+ @TableName +'.cs"') EXEC xp_cmdshell @TableCreatorString
				set @TableCreatorString = (select 'echo { >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\CsScript\\'+ @TableName +'.cs"') EXEC xp_cmdshell @TableCreatorString
				set @TableCreatorString = (select 'echo List^<'+ @TableName +'Entity^> '+ @TableName +'list = new List^<'+ @TableName +'Entity^>(); >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\CsScript\\'+ @TableName +'.cs"') EXEC xp_cmdshell @TableCreatorString
				set @TableCreatorString = (select 'echo using SqlConnection con = new SqlConnection(_ConStrRxForEyeIPD); >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\CsScript\\'+ @TableName +'.cs"') EXEC xp_cmdshell @TableCreatorString
                set @TableCreatorString = (select 'echo using (SqlCommand cmd = new SqlCommand("ProcSelect'+ @TableName + 'sBy'+(select ColumnName from TableCreator where Method = 'Yes' and Val != '.' and ChildRow != '.')+'", con)) >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\CsScript\\'+ @TableName +'.cs"') EXEC xp_cmdshell @TableCreatorString
                set @TableCreatorString = (select 'echo { >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\CsScript\\'+ @TableName +'.cs"') EXEC xp_cmdshell @TableCreatorString
                set @TableCreatorString = (select 'echo cmd.CommandType = CommandType.StoredProcedure; >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\CsScript\\'+ @TableName +'.cs"') EXEC xp_cmdshell @TableCreatorString
                set @TableCreatorString = (select 'echo cmd.Parameters.AddWithValue("@'+(select ColumnName from TableCreator where Method = 'Yes' and Val != '.' and ChildRow != '.')+'", '+(select ColumnName from TableCreator where Method = 'Yes' and Val != '.' and ChildRow != '.')+'); >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\CsScript\\'+ @TableName +'.cs"') EXEC xp_cmdshell @TableCreatorString

                set @TableCreatorString = (select 'echo await con.OpenAsync(); >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\CsScript\\'+ @TableName +'.cs"') EXEC xp_cmdshell @TableCreatorString
                set @TableCreatorString = (select 'echo  using (SqlDataReader dr = await cmd.ExecuteReaderAsync()) >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\CsScript\\'+ @TableName +'.cs"') EXEC xp_cmdshell @TableCreatorString

                set @TableCreatorString = (select 'echo while (await dr.ReadAsync()) >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\CsScript\\'+ @TableName +'.cs"') EXEC xp_cmdshell @TableCreatorString
                set @TableCreatorString = (select 'echo { >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\CsScript\\'+ @TableName +'.cs"') EXEC xp_cmdshell @TableCreatorString
                set @TableCreatorString = (select 'echo ' + @TableName +'list.Add(new ' + @TableName +'Entity >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\CsScript\\'+ @TableName +'.cs"') EXEC xp_cmdshell @TableCreatorString
                set @TableCreatorString = (select 'echo { >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\CsScript\\'+ @TableName +'.cs"') EXEC xp_cmdshell @TableCreatorString
                --set @TableCreatorString = (select 'echo '+ @TableName +'list.Add(Map'+ @TableName +'(dr)); >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\CsScript\\'+ @TableName +'.cs"')  EXEC xp_cmdshell @TableCreatorString
                ------------------ New working area
                set @TableCreatorString = (select 'echo '+ (select ColumnName from TableCreator  where particulars in ('Column') and Slno = 2) +' = dr.GetInt32(dr.GetOrdinal("'+ (select ColumnName from TableCreator  where particulars in ('Column') and Slno = 2) +'")), >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\CsScript\\'+ @TableName +'.cs"') EXEC xp_cmdshell @TableCreatorString
                    
					-- working area
						set @Counter = 2

					while ((select (count(*) + 2) Total from TableCreator  where particulars in ('PrimaryID',  'Column')) > @Counter)
					begin


					set @Nullability = (select (CASE	WHEN ValueType = 'int' THEN '0' 
									WHEN ValueType = 'bit' THEN 'false'
									WHEN ValueType = 'decimal' THEN '0.0'
									WHEN ValueType = 'float' THEN '0.0'
									WHEN ValueType = 'real' THEN '0'
									WHEN ValueType = 'char' THEN 'null'
									WHEN ValueType = 'varchar' THEN 'null'
									WHEN ValueType = 'nchar' THEN 'null'
									WHEN ValueType = 'nvarchar' THEN 'null'
									WHEN ValueType = 'DateTime' THEN 'null'
									--WHEN ValueType = 'varbinary' THEN 'byte[]'
									--WHEN ValueType = 'image' THEN 'byte[]'
									ELSE '' end) 
									Result from TableCreator where Slno = @Counter)

					set @ValueType = (select (CASE	WHEN ValueType = 'int' THEN 'Convert.ToInt32' 
									WHEN ValueType = 'bit' THEN 'Convert.ToBoolean'
									WHEN ValueType = 'decimal' THEN 'Convert.ToDecimal'
									WHEN ValueType = 'float' THEN 'Convert.ToDouble'
									WHEN ValueType = 'real' THEN 'Convert.ToSingle'
									WHEN ValueType = 'char' THEN 'Convert.ToString'
									WHEN ValueType = 'varchar' THEN 'Convert.ToString'
									WHEN ValueType = 'nchar' THEN 'Convert.ToString'
									WHEN ValueType = 'nvarchar' THEN 'Convert.ToString'
									WHEN ValueType = 'DateTime' THEN 'Convert.ToDateTime'
									--WHEN ValueType = 'varbinary' THEN 'byte[]'
									--WHEN ValueType = 'image' THEN 'byte[]'
									ELSE '' end) 
									Result from TableCreator where Slno = @Counter)

						set @ColumnName = (select ColumnName from TableCreator  where particulars in ('PrimaryID',  'Column') and Slno = @Counter)

						if((select Nullable from TableCreator  where particulars in ('Column') and Slno = @Counter) = 'Not Null')
							begin
								set @TableCreatorString = (select 'echo '+ @ColumnName +' = '+ @ValueType +'(dr["'+ @ColumnName +'"]), >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\CsScript\\'+ @TableName +'.cs"') EXEC xp_cmdshell @TableCreatorString
							end
						else
							begin
								set @TableCreatorString = (select 'echo '+ @ColumnName +' = dr["'+ @ColumnName +'"] == DBNull.Value ? '+ @Nullability + ' : '+ @ValueType +'(dr["'+ @ColumnName +'"]), >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\CsScript\\'+ @TableName +'.cs"') EXEC xp_cmdshell @TableCreatorString
							end
							set @Counter +=1
					end
					  -- working area
					set @TableCreatorString = (select 'echo CreatedBy = Convert.ToInt32(dr["CreatedBy"]), >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\CsScript\\'+ @TableName +'.cs"') EXEC xp_cmdshell @TableCreatorString
                    set @TableCreatorString = (select 'echo UpdatedBy = dr["UpdatedBy"] == DBNull.Value ? 0 : Convert.ToInt32(dr["UpdatedBy"]), >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\CsScript\\'+ @TableName +'.cs"') EXEC xp_cmdshell @TableCreatorString
                    set @TableCreatorString = (select 'echo DeletedBy = dr["DeletedBy"] == DBNull.Value ? 0 : Convert.ToInt32(dr["DeletedBy"]), >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\CsScript\\'+ @TableName +'.cs"') EXEC xp_cmdshell @TableCreatorString
                    set @TableCreatorString = (select 'echo CreatedAt = Convert.ToDateTime(dr["CreatedAt"]), >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\CsScript\\'+ @TableName +'.cs"') EXEC xp_cmdshell @TableCreatorString
                    set @TableCreatorString = (select 'echo UpdatedAt = dr["UpdatedAt"] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime(dr["UpdatedAt"]), >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\CsScript\\'+ @TableName +'.cs"') EXEC xp_cmdshell @TableCreatorString
                    set @TableCreatorString = (select 'echo DeletedAt = dr["DeletedAt"] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime(dr["DeletedAt"]), >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\CsScript\\'+ @TableName +'.cs"') EXEC xp_cmdshell @TableCreatorString
                    set @TableCreatorString = (select 'echo IsActive = dr["IsActive"].ToString() >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\CsScript\\'+ @TableName +'.cs"') EXEC xp_cmdshell @TableCreatorString
                
                
                ------------------ New working area
                
                
                set @TableCreatorString = (select 'echo } >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\CsScript\\'+ @TableName +'.cs"') EXEC xp_cmdshell @TableCreatorString
                set @TableCreatorString = (select 'echo ); >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\CsScript\\'+ @TableName +'.cs"') EXEC xp_cmdshell @TableCreatorString
                set @TableCreatorString = (select 'echo } >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\CsScript\\'+ @TableName +'.cs"') EXEC xp_cmdshell @TableCreatorString
                set @TableCreatorString = (select 'echo return '+ @TableName +'list; >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\CsScript\\'+ @TableName +'.cs"') EXEC xp_cmdshell @TableCreatorString
				set @TableCreatorString = (select 'echo } >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\CsScript\\'+ @TableName +'.cs"') EXEC xp_cmdshell @TableCreatorString
                set @TableCreatorString = (select 'echo } >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\CsScript\\'+ @TableName +'.cs"') EXEC xp_cmdshell @TableCreatorString
                end
-- Dropdown Zone
                
			
		set @TableCreatorString = (select 'echo } >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\CsScript\\'+ @TableName +'.cs"') EXEC xp_cmdshell @TableCreatorString
    set @TableCreatorString = (select 'echo } >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\CsScript\\'+ @TableName +'.cs"') EXEC xp_cmdshell @TableCreatorString
set @TableCreatorString = (select 'echo } >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\CsScript\\'+ @TableName +'.cs"') EXEC xp_cmdshell @TableCreatorString

-- Class Interface Methods



-- Method for foreign dropdown


-- Method for foreign dropdown



--int			Convert.ToInt32(value)
--bit			Convert.ToBoolean(value)
--decimal		Convert.ToDecimal(value)
--float			Convert.ToDouble(value)
--real			Convert.ToSingle(value)
--char			Convert.ToString(value)
--varchar		Convert.ToString(value)
--nchar			Convert.ToString(value)
--nvarchar		Convert.ToString(value)
--ntext			Convert.ToString(value)
--datetime		Convert.ToDateTime(value)
--smalldatetime	Convert.ToDateTime(value)
--date			Convert.ToDateTime(value)     

--string columnName = dr["ColumnName"] == DBNull.Value ? null : (string)dr["ColumnName"];