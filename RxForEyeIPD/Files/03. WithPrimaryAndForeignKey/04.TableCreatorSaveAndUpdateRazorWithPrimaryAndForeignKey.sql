use db_RxForEyeOPD
set nocount on

declare @TableNameString as varchar(50) = ''


if object_id ('TableCreatorFirst') is not null
drop table TableCreatorFirst
go

select * into TableCreatorFirst from OPENROWSET('Microsoft.ACE.OLEDB.12.0',  'Excel 8.0;HDR=YES;Database=E:\DotNetCoreProjects\RxForEyeOPD\RxForEyeOPD\Files\03. WithPrimaryAndForeignKey\TableCreateWithPrimaryAndForeignKey.xlsx', 'select * from [TblUpazilaMaster$]') 

if object_id ('TableCreator') is not null
drop table TableCreator
go

select ROW_NUMBER() OVER (ORDER BY Slno asc) as SlNo, Particulars, ColumnName, ValueType, Amount, Nullable, DefaultValue, ChildRow, Method, Tbl, Val, Txt, ValidationMessage into TableCreator from TableCreatorFirst order by SlNo asc

declare @TableCreatorString varchar(4000) = '',  @TableName varchar (100), @EntityCreatorRow varchar(200), @Counter int = 2

set @TableName = (select ColumnName from TableCreator where particulars = 'TableName')


set @TableCreatorString = (select 'IF EXIST "E:\DotNetCoreProjects\RxForEyeOPD\RxForEyeOPD\Components\Pages\DynamicFileCreator\' + @TableName +'\ComponentScript\SaveAndUpdate\" RMDIR /S /Q "E:\DotNetCoreProjects\RxForEyeOPD\RxForEyeOPD\Components\Pages\DynamicFileCreator\' + @TableName +'\ComponentScript\SaveAndUpdate\"')
EXEC xp_cmdshell @TableCreatorString

set @TableCreatorString = (select 'mkdir "E:\DotNetCoreProjects\RxForEyeOPD\RxForEyeOPD\Components\Pages\DynamicFileCreator\' + @TableName +'\ComponentScript\SaveAndUpdate\"')
EXEC xp_cmdshell @TableCreatorString


set @TableCreatorString = (select 'echo @page "/Settings/LocationMaster/'+ @TableName +'/ComponentScript/SaveAndUpdate/SaveAndUpdate'+ @TableName +'/' + lower(@TableName) +'" >> "E:\DotNetCoreProjects\RxForEyeOPD\RxForEyeOPD\Components\Pages\DynamicFileCreator\' + @TableName +'\ComponentScript\SaveAndUpdate\SaveAndUpdate'+ upper(substring(@TableName, 1,1)) + substring(@TableName, 2,50) +'.razor"') EXEC xp_cmdshell @TableCreatorString
set @TableCreatorString = (select 'echo @page "/Settings/LocationMaster/'+ @TableName +'/ComponentScript/SaveAndUpdate/SaveAndUpdate'+ @TableName +'/' + lower(@TableName) +'/{Id:int}" >> "E:\DotNetCoreProjects\RxForEyeOPD\RxForEyeOPD\Components\Pages\DynamicFileCreator\' + @TableName +'\ComponentScript\SaveAndUpdate\SaveAndUpdate'+ upper(substring(@TableName, 1,1)) + substring(@TableName, 2,50) +'.razor"') EXEC xp_cmdshell @TableCreatorString
set @TableCreatorString = (select 'echo @rendermode InteractiveServer >> "E:\DotNetCoreProjects\RxForEyeOPD\RxForEyeOPD\Components\Pages\DynamicFileCreator\' + @TableName +'\ComponentScript\SaveAndUpdate\SaveAndUpdate'+ upper(substring(@TableName, 1,1)) + substring(@TableName, 2,50) +'.razor"') EXEC xp_cmdshell @TableCreatorString
set @TableCreatorString = (select 'echo @inject I'+ @TableName +' '+ lower(@TableName) +' >> "E:\DotNetCoreProjects\RxForEyeOPD\RxForEyeOPD\Components\Pages\DynamicFileCreator\' + @TableName +'\ComponentScript\SaveAndUpdate\SaveAndUpdate'+ upper(substring(@TableName, 1,1)) + substring(@TableName, 2,50) +'.razor"') EXEC xp_cmdshell @TableCreatorString
set @TableCreatorString = (select 'echo @inject NavigationManager Nav >> "E:\DotNetCoreProjects\RxForEyeOPD\RxForEyeOPD\Components\Pages\DynamicFileCreator\' + @TableName +'\ComponentScript\SaveAndUpdate\SaveAndUpdate'+ upper(substring(@TableName, 1,1)) + substring(@TableName, 2,50) +'.razor"') EXEC xp_cmdshell @TableCreatorString
set @TableCreatorString = (select 'echo ^<PageTitle^>'+ @TableName +'^<^/PageTitle^> >> "E:\DotNetCoreProjects\RxForEyeOPD\RxForEyeOPD\Components\Pages\DynamicFileCreator\' + @TableName +'\ComponentScript\SaveAndUpdate\SaveAndUpdate'+ upper(substring(@TableName, 1,1)) + substring(@TableName, 2,50) +'.razor"') EXEC xp_cmdshell @TableCreatorString
set @TableCreatorString = (select 'echo ^<h3^>'+ @TableName +'^<^/h3^> >> "E:\DotNetCoreProjects\RxForEyeOPD\RxForEyeOPD\Components\Pages\DynamicFileCreator\' + @TableName +'\ComponentScript\SaveAndUpdate\SaveAndUpdate'+ upper(substring(@TableName, 1,1)) + substring(@TableName, 2,50) +'.razor"') EXEC xp_cmdshell @TableCreatorString
set @TableCreatorString = (select 'echo ^<h3^>@(IsEditMode ? "Edit '+ @TableName +'" : "Add '+ @TableName +'")^<^/h3^> >> "E:\DotNetCoreProjects\RxForEyeOPD\RxForEyeOPD\Components\Pages\DynamicFileCreator\' + @TableName +'\ComponentScript\SaveAndUpdate\SaveAndUpdate'+ upper(substring(@TableName, 1,1)) + substring(@TableName, 2,50) +'.razor"') EXEC xp_cmdshell @TableCreatorString

set @TableCreatorString = (select 'echo ^<EditForm Model="'+ @TableName +'Entity" OnValidSubmit="HandleSubmit"^> >> "E:\DotNetCoreProjects\RxForEyeOPD\RxForEyeOPD\Components\Pages\DynamicFileCreator\' + @TableName +'\ComponentScript\SaveAndUpdate\SaveAndUpdate'+ upper(substring(@TableName, 1,1)) + substring(@TableName, 2,50) +'.razor"') EXEC xp_cmdshell @TableCreatorString
set @TableCreatorString = (select 'echo ^<DataAnnotationsValidator ^/^> >> "E:\DotNetCoreProjects\RxForEyeOPD\RxForEyeOPD\Components\Pages\DynamicFileCreator\' + @TableName +'\ComponentScript\SaveAndUpdate\SaveAndUpdate'+ upper(substring(@TableName, 1,1)) + substring(@TableName, 2,50) +'.razor"') EXEC xp_cmdshell @TableCreatorString

declare @ValueType varchar(20) = ''

set @Counter = 3

-- EditForm Body
	while ((select (count(*) + 3) Total from TableCreator  where particulars in ('Column')) > @Counter)
		begin
			
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
			-- EditForm Each control
				set @TableCreatorString = (select 'echo ^<div class="mb-2"^> >> "E:\DotNetCoreProjects\RxForEyeOPD\RxForEyeOPD\Components\Pages\DynamicFileCreator\' + @TableName +'\ComponentScript\SaveAndUpdate\SaveAndUpdate'+ upper(substring(@TableName, 1,1)) + substring(@TableName, 2,50) +'.razor"') EXEC xp_cmdshell @TableCreatorString
				set @TableCreatorString = (select 'echo ^<label^>'+ (select ColumnName from TableCreator where SlNo = @Counter) +'^<^/label^> >> "E:\DotNetCoreProjects\RxForEyeOPD\RxForEyeOPD\Components\Pages\DynamicFileCreator\' + @TableName +'\ComponentScript\SaveAndUpdate\SaveAndUpdate'+ upper(substring(@TableName, 1,1)) + substring(@TableName, 2,50) +'.razor"') EXEC xp_cmdshell @TableCreatorString
				
				if exists (select * from TableCreator where SlNo = @Counter and Method = 'Yes')
					begin
						-- Dropdown Section
						
						if (@ValueType = 'int' or @ValueType = 'decimal' or @ValueType = 'float')
							begin
								set @TableCreatorString = (select 'echo ^<SfDropDownList TValue="'+ @ValueType +'" TItem="'+ (select Tbl from TableCreator where SlNo = @Counter) +'Entity" Placeholder="Select '+ (select Txt from TableCreator where SlNo = @Counter) +'" DataSource="@'+ (select Txt from TableCreator where SlNo = @Counter) +'s" @bind-Value="@' + @TableName +'Entity.'+ (select Val from TableCreator where SlNo = @Counter) +'"^> >> "E:\DotNetCoreProjects\RxForEyeOPD\RxForEyeOPD\Components\Pages\DynamicFileCreator\' + @TableName +'\ComponentScript\SaveAndUpdate\SaveAndUpdate'+ upper(substring(@TableName, 1,1)) + substring(@TableName, 2,50) +'.razor"') EXEC xp_cmdshell @TableCreatorString
								set @TableCreatorString = (select 'echo ^<DropDownListFieldSettings Value="'+ (select Val from TableCreator where SlNo = @Counter) +'" Text="'+ (select Txt from TableCreator where SlNo = @Counter) +'"^>^<^/DropDownListFieldSettings^> >> "E:\DotNetCoreProjects\RxForEyeOPD\RxForEyeOPD\Components\Pages\DynamicFileCreator\' + @TableName +'\ComponentScript\SaveAndUpdate\SaveAndUpdate'+ upper(substring(@TableName, 1,1)) + substring(@TableName, 2,50) +'.razor"') EXEC xp_cmdshell @TableCreatorString
								
								if ((select ChildRow from TableCreator where SlNo = @Counter) != '.')
								 begin
									set @TableCreatorString = (select 'echo ^<DropDownListEvents TValue="'+ @ValueType +'" TItem="'+ (select Tbl from TableCreator where SlNo = @Counter) +'Entity" ValueChange="On'+ (select Tbl from TableCreator where SlNo = @Counter) +'Changed" ^/^> >> "E:\DotNetCoreProjects\RxForEyeOPD\RxForEyeOPD\Components\Pages\DynamicFileCreator\' + @TableName +'\ComponentScript\SaveAndUpdate\SaveAndUpdate'+ upper(substring(@TableName, 1,1)) + substring(@TableName, 2,50) +'.razor"') EXEC xp_cmdshell @TableCreatorString
								end
								set @TableCreatorString = (select 'echo ^<^/SfDropDownList^> >> "E:\DotNetCoreProjects\RxForEyeOPD\RxForEyeOPD\Components\Pages\DynamicFileCreator\' + @TableName +'\ComponentScript\SaveAndUpdate\SaveAndUpdate'+ upper(substring(@TableName, 1,1)) + substring(@TableName, 2,50) +'.razor"') EXEC xp_cmdshell @TableCreatorString
							end
				
							else
								begin
									set @TableCreatorString = (select 'echo ^<SfDropDownList TValue="string" TItem="'+ (select Tbl from TableCreator where SlNo = @Counter) +'Entity" Placeholder="Select '+ (select Txt from TableCreator where SlNo = @Counter) +'" DataSource="@'+ (select Txt from TableCreator where SlNo = @Counter) +'s" @bind-Value="@' + @TableName +'Entity.'+ (select Val from TableCreator where SlNo = @Counter) +'"^> >> "E:\DotNetCoreProjects\RxForEyeOPD\RxForEyeOPD\Components\Pages\DynamicFileCreator\' + @TableName +'\ComponentScript\SaveAndUpdate\SaveAndUpdate'+ upper(substring(@TableName, 1,1)) + substring(@TableName, 2,50) +'.razor"') EXEC xp_cmdshell @TableCreatorString
									set @TableCreatorString = (select 'echo ^<DropDownListEvents TValue="string" TItem="'+ (select Tbl from TableCreator where SlNo = @Counter) +'Entity" ValueChange="On'+ (select Tbl from TableCreator where SlNo = @Counter) +'Changed" ^/^> >> "E:\DotNetCoreProjects\RxForEyeOPD\RxForEyeOPD\Components\Pages\DynamicFileCreator\' + @TableName +'\ComponentScript\SaveAndUpdate\SaveAndUpdate'+ upper(substring(@TableName, 1,1)) + substring(@TableName, 2,50) +'.razor"') EXEC xp_cmdshell @TableCreatorString
									set @TableCreatorString = (select 'echo ^<DropDownListFieldSettings Value="'+ (select Val from TableCreator where SlNo = @Counter) +'" Text="'+ (select Txt from TableCreator where SlNo = @Counter) +'"^>^<^/DropDownListFieldSettings^> >> "E:\DotNetCoreProjects\RxForEyeOPD\RxForEyeOPD\Components\Pages\DynamicFileCreator\' + @TableName +'\ComponentScript\SaveAndUpdate\SaveAndUpdate'+ upper(substring(@TableName, 1,1)) + substring(@TableName, 2,50) +'.razor"') EXEC xp_cmdshell @TableCreatorString
									set @TableCreatorString = (select 'echo ^<^/SfDropDownList^> >> "E:\DotNetCoreProjects\RxForEyeOPD\RxForEyeOPD\Components\Pages\DynamicFileCreator\' + @TableName +'\ComponentScript\SaveAndUpdate\SaveAndUpdate'+ upper(substring(@TableName, 1,1)) + substring(@TableName, 2,50) +'.razor"') EXEC xp_cmdshell @TableCreatorString
								end
								
						-- Dropdown Section
					end
					
				else
					begin
						-- Non Dropdown Section
						if (@ValueType = 'int' or @ValueType = 'int' or @ValueType = 'decimal' or @ValueType = 'float')
							begin
								set @TableCreatorString = (select 'echo ^<InputNumber @bind-Value="'+ @TableName +'Entity.'+ (select ColumnName from TableCreator where SlNo = @Counter) +'" class="form-control" ^/^> >> "E:\DotNetCoreProjects\RxForEyeOPD\RxForEyeOPD\Components\Pages\DynamicFileCreator\' + @TableName +'\ComponentScript\SaveAndUpdate\SaveAndUpdate'+ upper(substring(@TableName, 1,1)) + substring(@TableName, 2,50) +'.razor"') EXEC xp_cmdshell @TableCreatorString
							end
				
						else
							begin
								set @TableCreatorString = (select 'echo ^<InputText @bind-Value="'+ @TableName +'Entity.'+ (select ColumnName from TableCreator where SlNo = @Counter) +'" class="form-control" ^/^> >> "E:\DotNetCoreProjects\RxForEyeOPD\RxForEyeOPD\Components\Pages\DynamicFileCreator\' + @TableName +'\ComponentScript\SaveAndUpdate\SaveAndUpdate'+ upper(substring(@TableName, 1,1)) + substring(@TableName, 2,50) +'.razor"') EXEC xp_cmdshell @TableCreatorString
							end
						-- Non Dropdown Section
					end

				
				
				
				
				set @TableCreatorString = (select 'echo ^<ValidationMessage For="@(() => '+ @TableName +'Entity.'+ (select ColumnName from TableCreator where SlNo = @Counter) +')" ^/^> >> "E:\DotNetCoreProjects\RxForEyeOPD\RxForEyeOPD\Components\Pages\DynamicFileCreator\' + @TableName +'\ComponentScript\SaveAndUpdate\SaveAndUpdate'+ upper(substring(@TableName, 1,1)) + substring(@TableName, 2,50) +'.razor"') EXEC xp_cmdshell @TableCreatorString
				set @TableCreatorString = (select 'echo ^<^/div^> >> "E:\DotNetCoreProjects\RxForEyeOPD\RxForEyeOPD\Components\Pages\DynamicFileCreator\' + @TableName +'\ComponentScript\SaveAndUpdate\SaveAndUpdate'+ upper(substring(@TableName, 1,1)) + substring(@TableName, 2,50) +'.razor"') EXEC xp_cmdshell @TableCreatorString
			-- EditForm Each control	
			
			if ((((select ChildRow from TableCreator where SlNo = @Counter) != '.') and (select Method from TableCreator where SlNo = @Counter) != '.'))
					begin
						set @TableCreatorString = (select 'echo  @* Check this code very carefully. Bcoz this method build the relationship between Primary Table and Foreign Table *@ >> "E:\DotNetCoreProjects\RxForEyeOPD\RxForEyeOPD\Components\Pages\DynamicFileCreator\' + @TableName +'\ComponentScript\SaveAndUpdate\SaveAndUpdate'+ upper(substring(@TableName, 1,1)) + substring(@TableName, 2,50) +'.razor"') EXEC xp_cmdshell @TableCreatorString
						set @TableCreatorString = (select 'echo  @code { >> "E:\DotNetCoreProjects\RxForEyeOPD\RxForEyeOPD\Components\Pages\DynamicFileCreator\' + @TableName +'\ComponentScript\SaveAndUpdate\SaveAndUpdate'+ upper(substring(@TableName, 1,1)) + substring(@TableName, 2,50) +'.razor"') EXEC xp_cmdshell @TableCreatorString
						set @TableCreatorString = (select 'echo  //'+ (select Txt from TableCreator where SlNo = @Counter) +'s = await '+ (select lower(Tbl) from TableCreator where SlNo = @Counter) +'.GetAll'+ (select Tbl from TableCreator where SlNo = @Counter) +'(); // add this line to OnInitilizeAsync >> "E:\DotNetCoreProjects\RxForEyeOPD\RxForEyeOPD\Components\Pages\DynamicFileCreator\' + @TableName +'\ComponentScript\SaveAndUpdate\SaveAndUpdate'+ upper(substring(@TableName, 1,1)) + substring(@TableName, 2,50) +'.razor"') EXEC xp_cmdshell @TableCreatorString
						set @TableCreatorString = (select 'echo private List^<'+ (select Tbl from TableCreator where SlNo = @Counter) +'Entity^> '+ (select Txt from TableCreator where SlNo = @Counter) +'s = new(); // List of Foreign Key Columns >> "E:\DotNetCoreProjects\RxForEyeOPD\RxForEyeOPD\Components\Pages\DynamicFileCreator\' + @TableName +'\ComponentScript\SaveAndUpdate\SaveAndUpdate'+ upper(substring(@TableName, 1,1)) + substring(@TableName, 2,50) +'.razor"') EXEC xp_cmdshell @TableCreatorString
						set @TableCreatorString = (select 'echo private List^<'+ (select Tbl from TableCreator where ChildRow = '.' and Method = 'Yes') +'Entity^> '+ (select Txt from TableCreator where ChildRow = '.' and Method = 'Yes') +'s = new(); // List of Foreign Key Columns >> "E:\DotNetCoreProjects\RxForEyeOPD\RxForEyeOPD\Components\Pages\DynamicFileCreator\' + @TableName +'\ComponentScript\SaveAndUpdate\SaveAndUpdate'+ upper(substring(@TableName, 1,1)) + substring(@TableName, 2,50) +'.razor"') EXEC xp_cmdshell @TableCreatorString
						
						
						set @TableCreatorString = (select 'echo private async Task On'+ (select Tbl from TableCreator where SlNo = @Counter) +'Changed(ChangeEventArgs^<int, '+ (select Tbl from TableCreator where SlNo = @Counter) +'Entity^> args) >> "E:\DotNetCoreProjects\RxForEyeOPD\RxForEyeOPD\Components\Pages\DynamicFileCreator\' + @TableName +'\ComponentScript\SaveAndUpdate\SaveAndUpdate'+ upper(substring(@TableName, 1,1)) + substring(@TableName, 2,50) +'.razor"') EXEC xp_cmdshell @TableCreatorString
						set @TableCreatorString = (select 'echo { >> "E:\DotNetCoreProjects\RxForEyeOPD\RxForEyeOPD\Components\Pages\DynamicFileCreator\' + @TableName +'\ComponentScript\SaveAndUpdate\SaveAndUpdate'+ upper(substring(@TableName, 1,1)) + substring(@TableName, 2,50) +'.razor"') EXEC xp_cmdshell @TableCreatorString
						set @TableCreatorString = (select 'echo int selected'+ (select val from TableCreator where SlNo = @Counter) +' = Convert.ToInt32(args.Value); >> "E:\DotNetCoreProjects\RxForEyeOPD\RxForEyeOPD\Components\Pages\DynamicFileCreator\' + @TableName +'\ComponentScript\SaveAndUpdate\SaveAndUpdate'+ upper(substring(@TableName, 1,1)) + substring(@TableName, 2,50) +'.razor"') EXEC xp_cmdshell @TableCreatorString
						set @TableCreatorString = (select 'echo ' + @TableName +'Entity.'+ (select val from TableCreator where SlNo = @Counter) +' = selected'+ (select val from TableCreator where SlNo = @Counter) +'; >> "E:\DotNetCoreProjects\RxForEyeOPD\RxForEyeOPD\Components\Pages\DynamicFileCreator\' + @TableName +'\ComponentScript\SaveAndUpdate\SaveAndUpdate'+ upper(substring(@TableName, 1,1)) + substring(@TableName, 2,50) +'.razor"') EXEC xp_cmdshell @TableCreatorString
						
						if ((select ChildRow from TableCreator where SlNo = @Counter) != '.')
							begin
								set @TableCreatorString = (select 'echo '+ (select Txt from TableCreator where ChildRow = '.' and Method = 'Yes') +'s = await '+ (select lower(Tbl) as Tbl from TableCreator where ChildRow = '.' and Method = 'Yes') +'.Get'+ (select Tbl from TableCreator where ChildRow = '.' and Method = 'Yes') +'By'+ (select Val from TableCreator where ChildRow != '.' and Method = 'Yes') +'(selected'+ (select Val from TableCreator where ChildRow != '.' and Method = 'Yes') +');  // List of Foreign Key columns >> "E:\DotNetCoreProjects\RxForEyeOPD\RxForEyeOPD\Components\Pages\DynamicFileCreator\' + @TableName +'\ComponentScript\SaveAndUpdate\SaveAndUpdate'+ upper(substring(@TableName, 1,1)) + substring(@TableName, 2,50) +'.razor"') EXEC xp_cmdshell @TableCreatorString
								set @TableCreatorString = (select 'echo ' + @TableName +'Entity.'+ (select Val from TableCreator where ChildRow = '.' and Method = 'Yes') +' = 0; // This is Foreign Table Foreign Key Column Name >> "E:\DotNetCoreProjects\RxForEyeOPD\RxForEyeOPD\Components\Pages\DynamicFileCreator\' + @TableName +'\ComponentScript\SaveAndUpdate\SaveAndUpdate'+ upper(substring(@TableName, 1,1)) + substring(@TableName, 2,50) +'.razor"') EXEC xp_cmdshell @TableCreatorString
							end	
						set @TableCreatorString = (select 'echo } >> "E:\DotNetCoreProjects\RxForEyeOPD\RxForEyeOPD\Components\Pages\DynamicFileCreator\' + @TableName +'\ComponentScript\SaveAndUpdate\SaveAndUpdate'+ upper(substring(@TableName, 1,1)) + substring(@TableName, 2,50) +'.razor"') EXEC xp_cmdshell @TableCreatorString
						set @TableCreatorString = (select 'echo } >> "E:\DotNetCoreProjects\RxForEyeOPD\RxForEyeOPD\Components\Pages\DynamicFileCreator\' + @TableName +'\ComponentScript\SaveAndUpdate\SaveAndUpdate'+ upper(substring(@TableName, 1,1)) + substring(@TableName, 2,50) +'.razor"') EXEC xp_cmdshell @TableCreatorString
						
					end
				set @Counter +=1
		end
-- EditForm Body

set @TableCreatorString = (select 'echo ^<button class="btn btn-primary" type="submit"^> >> "E:\DotNetCoreProjects\RxForEyeOPD\RxForEyeOPD\Components\Pages\DynamicFileCreator\' + @TableName +'\ComponentScript\SaveAndUpdate\SaveAndUpdate'+ upper(substring(@TableName, 1,1)) + substring(@TableName, 2,50) +'.razor"') EXEC xp_cmdshell @TableCreatorString
set @TableCreatorString = (select 'echo @(IsEditMode ? "Update" : "Save") >> "E:\DotNetCoreProjects\RxForEyeOPD\RxForEyeOPD\Components\Pages\DynamicFileCreator\' + @TableName +'\ComponentScript\SaveAndUpdate\SaveAndUpdate'+ upper(substring(@TableName, 1,1)) + substring(@TableName, 2,50) +'.razor"') EXEC xp_cmdshell @TableCreatorString
set @TableCreatorString = (select 'echo ^<^/button^> >> "E:\DotNetCoreProjects\RxForEyeOPD\RxForEyeOPD\Components\Pages\DynamicFileCreator\' + @TableName +'\ComponentScript\SaveAndUpdate\SaveAndUpdate'+ upper(substring(@TableName, 1,1)) + substring(@TableName, 2,50) +'.razor"') EXEC xp_cmdshell @TableCreatorString
set @TableCreatorString = (select 'echo ^<a class="btn btn-secondary ms-2" href="/Settings/LocationMaster/' + @TableName +'/ComponentScript/GridviewAndDelete/' + @TableName +'"^> >> "E:\DotNetCoreProjects\RxForEyeOPD\RxForEyeOPD\Components\Pages\DynamicFileCreator\' + @TableName +'\ComponentScript\SaveAndUpdate\SaveAndUpdate'+ upper(substring(@TableName, 1,1)) + substring(@TableName, 2,50) +'.razor"') EXEC xp_cmdshell @TableCreatorString
set @TableCreatorString = (select 'echo Cancel >> "E:\DotNetCoreProjects\RxForEyeOPD\RxForEyeOPD\Components\Pages\DynamicFileCreator\' + @TableName +'\ComponentScript\SaveAndUpdate\SaveAndUpdate'+ upper(substring(@TableName, 1,1)) + substring(@TableName, 2,50) +'.razor"') EXEC xp_cmdshell @TableCreatorString
set @TableCreatorString = (select 'echo ^<^/a^> >> "E:\DotNetCoreProjects\RxForEyeOPD\RxForEyeOPD\Components\Pages\DynamicFileCreator\' + @TableName +'\ComponentScript\SaveAndUpdate\SaveAndUpdate'+ upper(substring(@TableName, 1,1)) + substring(@TableName, 2,50) +'.razor"') EXEC xp_cmdshell @TableCreatorString
set @TableCreatorString = (select 'echo ^<^/EditForm^> >> "E:\DotNetCoreProjects\RxForEyeOPD\RxForEyeOPD\Components\Pages\DynamicFileCreator\' + @TableName +'\ComponentScript\SaveAndUpdate\SaveAndUpdate'+ upper(substring(@TableName, 1,1)) + substring(@TableName, 2,50) +'.razor"') EXEC xp_cmdshell @TableCreatorString



set @TableCreatorString = (select 'echo @code { >> "E:\DotNetCoreProjects\RxForEyeOPD\RxForEyeOPD\Components\Pages\DynamicFileCreator\' + @TableName +'\ComponentScript\SaveAndUpdate\SaveAndUpdate'+ upper(substring(@TableName, 1,1)) + substring(@TableName, 2,50) +'.razor"') EXEC xp_cmdshell @TableCreatorString
set @TableCreatorString = (select 'echo [Parameter] public int? Id { get; set; } >> "E:\DotNetCoreProjects\RxForEyeOPD\RxForEyeOPD\Components\Pages\DynamicFileCreator\' + @TableName +'\ComponentScript\SaveAndUpdate\SaveAndUpdate'+ upper(substring(@TableName, 1,1)) + substring(@TableName, 2,50) +'.razor"') EXEC xp_cmdshell @TableCreatorString
set @TableCreatorString = (select 'echo private ' + @TableName +'Entity ' + @TableName +'Entity = new(); >> "E:\DotNetCoreProjects\RxForEyeOPD\RxForEyeOPD\Components\Pages\DynamicFileCreator\' + @TableName +'\ComponentScript\SaveAndUpdate\SaveAndUpdate'+ upper(substring(@TableName, 1,1)) + substring(@TableName, 2,50) +'.razor"') EXEC xp_cmdshell @TableCreatorString
set @TableCreatorString = (select 'echo private bool IsEditMode = false; >> "E:\DotNetCoreProjects\RxForEyeOPD\RxForEyeOPD\Components\Pages\DynamicFileCreator\' + @TableName +'\ComponentScript\SaveAndUpdate\SaveAndUpdate'+ upper(substring(@TableName, 1,1)) + substring(@TableName, 2,50) +'.razor"') EXEC xp_cmdshell @TableCreatorString
set @TableCreatorString = (select 'echo protected override async Task OnInitializedAsync() >> "E:\DotNetCoreProjects\RxForEyeOPD\RxForEyeOPD\Components\Pages\DynamicFileCreator\' + @TableName +'\ComponentScript\SaveAndUpdate\SaveAndUpdate'+ upper(substring(@TableName, 1,1)) + substring(@TableName, 2,50) +'.razor"') EXEC xp_cmdshell @TableCreatorString
set @TableCreatorString = (select 'echo { >> "E:\DotNetCoreProjects\RxForEyeOPD\RxForEyeOPD\Components\Pages\DynamicFileCreator\' + @TableName +'\ComponentScript\SaveAndUpdate\SaveAndUpdate'+ upper(substring(@TableName, 1,1)) + substring(@TableName, 2,50) +'.razor"') EXEC xp_cmdshell @TableCreatorString
set @TableCreatorString = (select 'echo if ^(Id ^!^= null ^&^& Id ^> 0^) >> "E:\DotNetCoreProjects\RxForEyeOPD\RxForEyeOPD\Components\Pages\DynamicFileCreator\' + @TableName +'\ComponentScript\SaveAndUpdate\SaveAndUpdate'+ upper(substring(@TableName, 1,1)) + substring(@TableName, 2,50) +'.razor"') EXEC xp_cmdshell @TableCreatorString
set @TableCreatorString = (select 'echo { >> "E:\DotNetCoreProjects\RxForEyeOPD\RxForEyeOPD\Components\Pages\DynamicFileCreator\' + @TableName +'\ComponentScript\SaveAndUpdate\SaveAndUpdate'+ upper(substring(@TableName, 1,1)) + substring(@TableName, 2,50) +'.razor"') EXEC xp_cmdshell @TableCreatorString
set @TableCreatorString = (select 'echo IsEditMode = true; >> "E:\DotNetCoreProjects\RxForEyeOPD\RxForEyeOPD\Components\Pages\DynamicFileCreator\' + @TableName +'\ComponentScript\SaveAndUpdate\SaveAndUpdate'+ upper(substring(@TableName, 1,1)) + substring(@TableName, 2,50) +'.razor"') EXEC xp_cmdshell @TableCreatorString
set @TableCreatorString = (select 'echo ' + @TableName +'Entity = await '+ lower(@TableName) +'.Get' + @TableName +'ById(Id.Value); >> "E:\DotNetCoreProjects\RxForEyeOPD\RxForEyeOPD\Components\Pages\DynamicFileCreator\' + @TableName +'\ComponentScript\SaveAndUpdate\SaveAndUpdate'+ upper(substring(@TableName, 1,1)) + substring(@TableName, 2,50) +'.razor"') EXEC xp_cmdshell @TableCreatorString
set @TableCreatorString = (select 'echo } >> "E:\DotNetCoreProjects\RxForEyeOPD\RxForEyeOPD\Components\Pages\DynamicFileCreator\' + @TableName +'\ComponentScript\SaveAndUpdate\SaveAndUpdate'+ upper(substring(@TableName, 1,1)) + substring(@TableName, 2,50) +'.razor"') EXEC xp_cmdshell @TableCreatorString
set @TableCreatorString = (select 'echo else >> "E:\DotNetCoreProjects\RxForEyeOPD\RxForEyeOPD\Components\Pages\DynamicFileCreator\' + @TableName +'\ComponentScript\SaveAndUpdate\SaveAndUpdate'+ upper(substring(@TableName, 1,1)) + substring(@TableName, 2,50) +'.razor"') EXEC xp_cmdshell @TableCreatorString
set @TableCreatorString = (select 'echo { >> "E:\DotNetCoreProjects\RxForEyeOPD\RxForEyeOPD\Components\Pages\DynamicFileCreator\' + @TableName +'\ComponentScript\SaveAndUpdate\SaveAndUpdate'+ upper(substring(@TableName, 1,1)) + substring(@TableName, 2,50) +'.razor"') EXEC xp_cmdshell @TableCreatorString
set @TableCreatorString = (select 'echo ' + @TableName +'Entity = new ' + @TableName +'Entity(); >> "E:\DotNetCoreProjects\RxForEyeOPD\RxForEyeOPD\Components\Pages\DynamicFileCreator\' + @TableName +'\ComponentScript\SaveAndUpdate\SaveAndUpdate'+ upper(substring(@TableName, 1,1)) + substring(@TableName, 2,50) +'.razor"') EXEC xp_cmdshell @TableCreatorString
set @TableCreatorString = (select 'echo ' + @TableName +'Entity.CreatedBy = 1; // set your user id >> "E:\DotNetCoreProjects\RxForEyeOPD\RxForEyeOPD\Components\Pages\DynamicFileCreator\' + @TableName +'\ComponentScript\SaveAndUpdate\SaveAndUpdate'+ upper(substring(@TableName, 1,1)) + substring(@TableName, 2,50) +'.razor"') EXEC xp_cmdshell @TableCreatorString
set @TableCreatorString = (select 'echo } >> "E:\DotNetCoreProjects\RxForEyeOPD\RxForEyeOPD\Components\Pages\DynamicFileCreator\' + @TableName +'\ComponentScript\SaveAndUpdate\SaveAndUpdate'+ upper(substring(@TableName, 1,1)) + substring(@TableName, 2,50) +'.razor"') EXEC xp_cmdshell @TableCreatorString
set @TableCreatorString = (select 'echo } >> "E:\DotNetCoreProjects\RxForEyeOPD\RxForEyeOPD\Components\Pages\DynamicFileCreator\' + @TableName +'\ComponentScript\SaveAndUpdate\SaveAndUpdate'+ upper(substring(@TableName, 1,1)) + substring(@TableName, 2,50) +'.razor"') EXEC xp_cmdshell @TableCreatorString
set @TableCreatorString = (select 'echo private async Task HandleSubmit() >> "E:\DotNetCoreProjects\RxForEyeOPD\RxForEyeOPD\Components\Pages\DynamicFileCreator\' + @TableName +'\ComponentScript\SaveAndUpdate\SaveAndUpdate'+ upper(substring(@TableName, 1,1)) + substring(@TableName, 2,50) +'.razor"') EXEC xp_cmdshell @TableCreatorString
set @TableCreatorString = (select 'echo { >> "E:\DotNetCoreProjects\RxForEyeOPD\RxForEyeOPD\Components\Pages\DynamicFileCreator\' + @TableName +'\ComponentScript\SaveAndUpdate\SaveAndUpdate'+ upper(substring(@TableName, 1,1)) + substring(@TableName, 2,50) +'.razor"') EXEC xp_cmdshell @TableCreatorString
set @TableCreatorString = (select 'echo if (IsEditMode) >> "E:\DotNetCoreProjects\RxForEyeOPD\RxForEyeOPD\Components\Pages\DynamicFileCreator\' + @TableName +'\ComponentScript\SaveAndUpdate\SaveAndUpdate'+ upper(substring(@TableName, 1,1)) + substring(@TableName, 2,50) +'.razor"') EXEC xp_cmdshell @TableCreatorString
set @TableCreatorString = (select 'echo { >> "E:\DotNetCoreProjects\RxForEyeOPD\RxForEyeOPD\Components\Pages\DynamicFileCreator\' + @TableName +'\ComponentScript\SaveAndUpdate\SaveAndUpdate'+ upper(substring(@TableName, 1,1)) + substring(@TableName, 2,50) +'.razor"') EXEC xp_cmdshell @TableCreatorString
set @TableCreatorString = (select 'echo ' + @TableName +'Entity.UpdatedBy = 1; // set current user ID >> "E:\DotNetCoreProjects\RxForEyeOPD\RxForEyeOPD\Components\Pages\DynamicFileCreator\' + @TableName +'\ComponentScript\SaveAndUpdate\SaveAndUpdate'+ upper(substring(@TableName, 1,1)) + substring(@TableName, 2,50) +'.razor"') EXEC xp_cmdshell @TableCreatorString
set @TableCreatorString = (select 'echo ' + @TableName +'Entity.'+ (select ColumnName from TableCreator  where particulars in ('PrimaryID'))  +' = Id.Value; >> "E:\DotNetCoreProjects\RxForEyeOPD\RxForEyeOPD\Components\Pages\DynamicFileCreator\' + @TableName +'\ComponentScript\SaveAndUpdate\SaveAndUpdate'+ upper(substring(@TableName, 1,1)) + substring(@TableName, 2,50) +'.razor"') EXEC xp_cmdshell @TableCreatorString
set @TableCreatorString = (select 'echo await '+ lower(@TableName) +'.Update' + @TableName +'(' + @TableName +'Entity); >> "E:\DotNetCoreProjects\RxForEyeOPD\RxForEyeOPD\Components\Pages\DynamicFileCreator\' + @TableName +'\ComponentScript\SaveAndUpdate\SaveAndUpdate'+ upper(substring(@TableName, 1,1)) + substring(@TableName, 2,50) +'.razor"') EXEC xp_cmdshell @TableCreatorString
set @TableCreatorString = (select 'echo Nav.NavigateTo($"/Settings/LocationMaster/' + @TableName +'/ComponentScript/GridviewAndDelete/' + @TableName +'"); >> "E:\DotNetCoreProjects\RxForEyeOPD\RxForEyeOPD\Components\Pages\DynamicFileCreator\' + @TableName +'\ComponentScript\SaveAndUpdate\SaveAndUpdate'+ upper(substring(@TableName, 1,1)) + substring(@TableName, 2,50) +'.razor"') EXEC xp_cmdshell @TableCreatorString
set @TableCreatorString = (select 'echo  } >> "E:\DotNetCoreProjects\RxForEyeOPD\RxForEyeOPD\Components\Pages\DynamicFileCreator\' + @TableName +'\ComponentScript\SaveAndUpdate\SaveAndUpdate'+ upper(substring(@TableName, 1,1)) + substring(@TableName, 2,50) +'.razor"') EXEC xp_cmdshell @TableCreatorString
set @TableCreatorString = (select 'echo else >> "E:\DotNetCoreProjects\RxForEyeOPD\RxForEyeOPD\Components\Pages\DynamicFileCreator\' + @TableName +'\ComponentScript\SaveAndUpdate\SaveAndUpdate'+ upper(substring(@TableName, 1,1)) + substring(@TableName, 2,50) +'.razor"') EXEC xp_cmdshell @TableCreatorString
set @TableCreatorString = (select 'echo  { >> "E:\DotNetCoreProjects\RxForEyeOPD\RxForEyeOPD\Components\Pages\DynamicFileCreator\' + @TableName +'\ComponentScript\SaveAndUpdate\SaveAndUpdate'+ upper(substring(@TableName, 1,1)) + substring(@TableName, 2,50) +'.razor"') EXEC xp_cmdshell @TableCreatorString
set @TableCreatorString = (select 'echo ' + @TableName +'Entity.CreatedBy = 1; >> "E:\DotNetCoreProjects\RxForEyeOPD\RxForEyeOPD\Components\Pages\DynamicFileCreator\' + @TableName +'\ComponentScript\SaveAndUpdate\SaveAndUpdate'+ upper(substring(@TableName, 1,1)) + substring(@TableName, 2,50) +'.razor"') EXEC xp_cmdshell @TableCreatorString
set @TableCreatorString = (select 'echo await '+ lower(@TableName) +'.Create' + @TableName +'(' + @TableName +'Entity); >> "E:\DotNetCoreProjects\RxForEyeOPD\RxForEyeOPD\Components\Pages\DynamicFileCreator\' + @TableName +'\ComponentScript\SaveAndUpdate\SaveAndUpdate'+ upper(substring(@TableName, 1,1)) + substring(@TableName, 2,50) +'.razor"') EXEC xp_cmdshell @TableCreatorString
set @TableCreatorString = (select 'echo Nav.NavigateTo($"/Settings/LocationMaster/' + @TableName +'/ComponentScript/GridviewAndDelete/' + @TableName +'"); >> "E:\DotNetCoreProjects\RxForEyeOPD\RxForEyeOPD\Components\Pages\DynamicFileCreator\' + @TableName +'\ComponentScript\SaveAndUpdate\SaveAndUpdate'+ upper(substring(@TableName, 1,1)) + substring(@TableName, 2,50) +'.razor"') EXEC xp_cmdshell @TableCreatorString
set @TableCreatorString = (select 'echo } >> "E:\DotNetCoreProjects\RxForEyeOPD\RxForEyeOPD\Components\Pages\DynamicFileCreator\' + @TableName +'\ComponentScript\SaveAndUpdate\SaveAndUpdate'+ upper(substring(@TableName, 1,1)) + substring(@TableName, 2,50) +'.razor"') EXEC xp_cmdshell @TableCreatorString
set @TableCreatorString = (select 'echo } >> "E:\DotNetCoreProjects\RxForEyeOPD\RxForEyeOPD\Components\Pages\DynamicFileCreator\' + @TableName +'\ComponentScript\SaveAndUpdate\SaveAndUpdate'+ upper(substring(@TableName, 1,1)) + substring(@TableName, 2,50) +'.razor"') EXEC xp_cmdshell @TableCreatorString
set @TableCreatorString = (select 'echo } >> "E:\DotNetCoreProjects\RxForEyeOPD\RxForEyeOPD\Components\Pages\DynamicFileCreator\' + @TableName +'\ComponentScript\SaveAndUpdate\SaveAndUpdate'+ upper(substring(@TableName, 1,1)) + substring(@TableName, 2,50) +'.razor"') EXEC xp_cmdshell @TableCreatorString