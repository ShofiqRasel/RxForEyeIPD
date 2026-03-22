use db_RxForEyeIPD
set nocount on

declare @TableNameString as varchar(50) = ''

declare @TableCreatorString varchar(4000) = '',  @TableName varchar (100), @EntityCreatorRow varchar(200), @Counter int = 2

if object_id ('TableCreatorFirst') is not null
drop table TableCreatorFirst

select * into TableCreatorFirst from OPENROWSET('Microsoft.ACE.OLEDB.12.0',  'Excel 8.0;HDR=YES;Database=E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Files\01. WithoutPrimaryAndForeignKey\TableCreateWithoutPrimaryAndForeignKey.xlsx', 'select * from [TblBaseHospital$]') 

if object_id ('TableCreator') is not null
drop table TableCreator

select ROW_NUMBER() OVER (ORDER BY Slno asc) as SlNo, Particulars, ColumnName, ValueType, Amount, Nullable, DefaultValue, ValidationMessage into TableCreator from TableCreatorFirst order by SlNo asc


set @TableName = (select ColumnName from TableCreator where particulars = 'TableName')


set @TableCreatorString = (select 'IF EXIST "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\ComponentScript\SaveAndUpdate\" RMDIR /S /Q "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\ComponentScript\SaveAndUpdate\"')
EXEC xp_cmdshell @TableCreatorString

set @TableCreatorString = (select 'mkdir "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\ComponentScript\SaveAndUpdate\"')
EXEC xp_cmdshell @TableCreatorString


set @TableCreatorString = (select 'echo @page "/Settings/LocationMaster/'+ @TableName +'/ComponentScript/SaveAndUpdate/SaveAndUpdate'+ @TableName +'/' + lower(@TableName) +'" >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\ComponentScript\SaveAndUpdate\SaveAndUpdate'+ upper(substring(@TableName, 1,1)) + substring(@TableName, 2,50) +'.razor"') EXEC xp_cmdshell @TableCreatorString
set @TableCreatorString = (select 'echo @page "/Settings/LocationMaster/'+ @TableName +'/ComponentScript/SaveAndUpdate/SaveAndUpdate'+ @TableName +'/' + lower(@TableName) +'/{Id:int}" >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\ComponentScript\SaveAndUpdate\SaveAndUpdate'+ upper(substring(@TableName, 1,1)) + substring(@TableName, 2,50) +'.razor"') EXEC xp_cmdshell @TableCreatorString
set @TableCreatorString = (select 'echo @rendermode InteractiveServer >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\ComponentScript\SaveAndUpdate\SaveAndUpdate'+ upper(substring(@TableName, 1,1)) + substring(@TableName, 2,50) +'.razor"') EXEC xp_cmdshell @TableCreatorString
set @TableCreatorString = (select 'echo @inject I'+ @TableName +' '+ lower(@TableName) +' >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\ComponentScript\SaveAndUpdate\SaveAndUpdate'+ upper(substring(@TableName, 1,1)) + substring(@TableName, 2,50) +'.razor"') EXEC xp_cmdshell @TableCreatorString
set @TableCreatorString = (select 'echo @inject NavigationManager Nav >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\ComponentScript\SaveAndUpdate\SaveAndUpdate'+ upper(substring(@TableName, 1,1)) + substring(@TableName, 2,50) +'.razor"') EXEC xp_cmdshell @TableCreatorString
set @TableCreatorString = (select 'echo ^<PageTitle^>'+ @TableName +'^<^/PageTitle^> >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\ComponentScript\SaveAndUpdate\SaveAndUpdate'+ upper(substring(@TableName, 1,1)) + substring(@TableName, 2,50) +'.razor"') EXEC xp_cmdshell @TableCreatorString
set @TableCreatorString = (select 'echo ^<h3^>'+ @TableName +'^<^/h3^> >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\ComponentScript\SaveAndUpdate\SaveAndUpdate'+ upper(substring(@TableName, 1,1)) + substring(@TableName, 2,50) +'.razor"') EXEC xp_cmdshell @TableCreatorString
set @TableCreatorString = (select 'echo ^<h3^>@(IsEditMode ? "Edit '+ @TableName +'" : "Add '+ @TableName +'")^<^/h3^> >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\ComponentScript\SaveAndUpdate\SaveAndUpdate'+ upper(substring(@TableName, 1,1)) + substring(@TableName, 2,50) +'.razor"') EXEC xp_cmdshell @TableCreatorString

set @TableCreatorString = (select 'echo ^<EditForm Model="'+ @TableName +'Entity" OnValidSubmit="HandleSubmit"^> >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\ComponentScript\SaveAndUpdate\SaveAndUpdate'+ upper(substring(@TableName, 1,1)) + substring(@TableName, 2,50) +'.razor"') EXEC xp_cmdshell @TableCreatorString
set @TableCreatorString = (select 'echo ^<DataAnnotationsValidator ^/^> >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\ComponentScript\SaveAndUpdate\SaveAndUpdate'+ upper(substring(@TableName, 1,1)) + substring(@TableName, 2,50) +'.razor"') EXEC xp_cmdshell @TableCreatorString

declare @ValueType varchar(20) = ''

set @Counter = 3

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
			
			
			
				set @TableCreatorString = (select 'echo ^<div class="mb-2"^> >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\ComponentScript\SaveAndUpdate\SaveAndUpdate'+ upper(substring(@TableName, 1,1)) + substring(@TableName, 2,50) +'.razor"') EXEC xp_cmdshell @TableCreatorString
				set @TableCreatorString = (select 'echo ^<label^>' + @TableName +'^<^/label^> >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\ComponentScript\SaveAndUpdate\SaveAndUpdate'+ upper(substring(@TableName, 1,1)) + substring(@TableName, 2,50) +'.razor"') EXEC xp_cmdshell @TableCreatorString
				
				if (@ValueType = 'int' or @ValueType = 'int' or @ValueType = 'decimal' or @ValueType = 'float')
					begin
						set @TableCreatorString = (select 'echo ^<InputNumber @bind-Value="'+ @TableName +'Entity.'+ (select ColumnName from TableCreator where SlNo = @Counter) +'" class="form-control" ^/^> >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\ComponentScript\SaveAndUpdate\SaveAndUpdate'+ upper(substring(@TableName, 1,1)) + substring(@TableName, 2,50) +'.razor"') EXEC xp_cmdshell @TableCreatorString
					end
				
				else
					begin
						set @TableCreatorString = (select 'echo ^<InputText @bind-Value="'+ @TableName +'Entity.'+ (select ColumnName from TableCreator where SlNo = @Counter) +'" class="form-control" ^/^> >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\ComponentScript\SaveAndUpdate\SaveAndUpdate'+ upper(substring(@TableName, 1,1)) + substring(@TableName, 2,50) +'.razor"') EXEC xp_cmdshell @TableCreatorString
					end
					
				
				
				
				set @TableCreatorString = (select 'echo ^<ValidationMessage For="@(() => '+ @TableName +'Entity.'+ (select ColumnName from TableCreator where SlNo = @Counter) +')" ^/^> >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\ComponentScript\SaveAndUpdate\SaveAndUpdate'+ upper(substring(@TableName, 1,1)) + substring(@TableName, 2,50) +'.razor"') EXEC xp_cmdshell @TableCreatorString
				set @TableCreatorString = (select 'echo ^<^/div^> >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\ComponentScript\SaveAndUpdate\SaveAndUpdate'+ upper(substring(@TableName, 1,1)) + substring(@TableName, 2,50) +'.razor"') EXEC xp_cmdshell @TableCreatorString
				set @Counter +=1
            end
				 
            

set @TableCreatorString = (select 'echo ^<button class="btn btn-primary" type="submit"^> >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\ComponentScript\SaveAndUpdate\SaveAndUpdate'+ upper(substring(@TableName, 1,1)) + substring(@TableName, 2,50) +'.razor"') EXEC xp_cmdshell @TableCreatorString
set @TableCreatorString = (select 'echo @(IsEditMode ? "Update" : "Save") >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\ComponentScript\SaveAndUpdate\SaveAndUpdate'+ upper(substring(@TableName, 1,1)) + substring(@TableName, 2,50) +'.razor"') EXEC xp_cmdshell @TableCreatorString
set @TableCreatorString = (select 'echo ^<^/button^> >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\ComponentScript\SaveAndUpdate\SaveAndUpdate'+ upper(substring(@TableName, 1,1)) + substring(@TableName, 2,50) +'.razor"') EXEC xp_cmdshell @TableCreatorString
set @TableCreatorString = (select 'echo ^<a class="btn btn-secondary ms-2" href="/Settings/LocationMaster/' + @TableName +'/ComponentScript/GridviewAndDelete/' + @TableName +'"^> >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\ComponentScript\SaveAndUpdate\SaveAndUpdate'+ upper(substring(@TableName, 1,1)) + substring(@TableName, 2,50) +'.razor"') EXEC xp_cmdshell @TableCreatorString
set @TableCreatorString = (select 'echo Cancel >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\ComponentScript\SaveAndUpdate\SaveAndUpdate'+ upper(substring(@TableName, 1,1)) + substring(@TableName, 2,50) +'.razor"') EXEC xp_cmdshell @TableCreatorString
set @TableCreatorString = (select 'echo ^<^/a^> >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\ComponentScript\SaveAndUpdate\SaveAndUpdate'+ upper(substring(@TableName, 1,1)) + substring(@TableName, 2,50) +'.razor"') EXEC xp_cmdshell @TableCreatorString
set @TableCreatorString = (select 'echo ^<^/EditForm^> >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\ComponentScript\SaveAndUpdate\SaveAndUpdate'+ upper(substring(@TableName, 1,1)) + substring(@TableName, 2,50) +'.razor"') EXEC xp_cmdshell @TableCreatorString



set @TableCreatorString = (select 'echo @code { >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\ComponentScript\SaveAndUpdate\SaveAndUpdate'+ upper(substring(@TableName, 1,1)) + substring(@TableName, 2,50) +'.razor"') EXEC xp_cmdshell @TableCreatorString
set @TableCreatorString = (select 'echo [Parameter] public int? Id { get; set; } >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\ComponentScript\SaveAndUpdate\SaveAndUpdate'+ upper(substring(@TableName, 1,1)) + substring(@TableName, 2,50) +'.razor"') EXEC xp_cmdshell @TableCreatorString
set @TableCreatorString = (select 'echo private ' + @TableName +'Entity ' + @TableName +'Entity = new(); >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\ComponentScript\SaveAndUpdate\SaveAndUpdate'+ upper(substring(@TableName, 1,1)) + substring(@TableName, 2,50) +'.razor"') EXEC xp_cmdshell @TableCreatorString
set @TableCreatorString = (select 'echo private bool IsEditMode = false; >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\ComponentScript\SaveAndUpdate\SaveAndUpdate'+ upper(substring(@TableName, 1,1)) + substring(@TableName, 2,50) +'.razor"') EXEC xp_cmdshell @TableCreatorString
set @TableCreatorString = (select 'echo protected override async Task OnInitializedAsync() >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\ComponentScript\SaveAndUpdate\SaveAndUpdate'+ upper(substring(@TableName, 1,1)) + substring(@TableName, 2,50) +'.razor"') EXEC xp_cmdshell @TableCreatorString
set @TableCreatorString = (select 'echo { >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\ComponentScript\SaveAndUpdate\SaveAndUpdate'+ upper(substring(@TableName, 1,1)) + substring(@TableName, 2,50) +'.razor"') EXEC xp_cmdshell @TableCreatorString
set @TableCreatorString = (select 'echo if ^(Id ^!^= null ^&^& Id ^> 0^) >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\ComponentScript\SaveAndUpdate\SaveAndUpdate'+ upper(substring(@TableName, 1,1)) + substring(@TableName, 2,50) +'.razor"') EXEC xp_cmdshell @TableCreatorString
set @TableCreatorString = (select 'echo { >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\ComponentScript\SaveAndUpdate\SaveAndUpdate'+ upper(substring(@TableName, 1,1)) + substring(@TableName, 2,50) +'.razor"') EXEC xp_cmdshell @TableCreatorString
set @TableCreatorString = (select 'echo IsEditMode = true; >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\ComponentScript\SaveAndUpdate\SaveAndUpdate'+ upper(substring(@TableName, 1,1)) + substring(@TableName, 2,50) +'.razor"') EXEC xp_cmdshell @TableCreatorString
set @TableCreatorString = (select 'echo ' + @TableName +'Entity = await '+ lower(@TableName) +'.Get' + @TableName +'ById(Id.Value); >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\ComponentScript\SaveAndUpdate\SaveAndUpdate'+ upper(substring(@TableName, 1,1)) + substring(@TableName, 2,50) +'.razor"') EXEC xp_cmdshell @TableCreatorString
set @TableCreatorString = (select 'echo } >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\ComponentScript\SaveAndUpdate\SaveAndUpdate'+ upper(substring(@TableName, 1,1)) + substring(@TableName, 2,50) +'.razor"') EXEC xp_cmdshell @TableCreatorString
set @TableCreatorString = (select 'echo else >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\ComponentScript\SaveAndUpdate\SaveAndUpdate'+ upper(substring(@TableName, 1,1)) + substring(@TableName, 2,50) +'.razor"') EXEC xp_cmdshell @TableCreatorString
set @TableCreatorString = (select 'echo { >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\ComponentScript\SaveAndUpdate\SaveAndUpdate'+ upper(substring(@TableName, 1,1)) + substring(@TableName, 2,50) +'.razor"') EXEC xp_cmdshell @TableCreatorString
set @TableCreatorString = (select 'echo ' + @TableName +'Entity = new ' + @TableName +'Entity(); >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\ComponentScript\SaveAndUpdate\SaveAndUpdate'+ upper(substring(@TableName, 1,1)) + substring(@TableName, 2,50) +'.razor"') EXEC xp_cmdshell @TableCreatorString
set @TableCreatorString = (select 'echo ' + @TableName +'Entity.CreatedBy = 1; // set your user id >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\ComponentScript\SaveAndUpdate\SaveAndUpdate'+ upper(substring(@TableName, 1,1)) + substring(@TableName, 2,50) +'.razor"') EXEC xp_cmdshell @TableCreatorString
set @TableCreatorString = (select 'echo } >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\ComponentScript\SaveAndUpdate\SaveAndUpdate'+ upper(substring(@TableName, 1,1)) + substring(@TableName, 2,50) +'.razor"') EXEC xp_cmdshell @TableCreatorString
set @TableCreatorString = (select 'echo } >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\ComponentScript\SaveAndUpdate\SaveAndUpdate'+ upper(substring(@TableName, 1,1)) + substring(@TableName, 2,50) +'.razor"') EXEC xp_cmdshell @TableCreatorString
set @TableCreatorString = (select 'echo private async Task HandleSubmit() >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\ComponentScript\SaveAndUpdate\SaveAndUpdate'+ upper(substring(@TableName, 1,1)) + substring(@TableName, 2,50) +'.razor"') EXEC xp_cmdshell @TableCreatorString
set @TableCreatorString = (select 'echo { >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\ComponentScript\SaveAndUpdate\SaveAndUpdate'+ upper(substring(@TableName, 1,1)) + substring(@TableName, 2,50) +'.razor"') EXEC xp_cmdshell @TableCreatorString
set @TableCreatorString = (select 'echo if (IsEditMode) >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\ComponentScript\SaveAndUpdate\SaveAndUpdate'+ upper(substring(@TableName, 1,1)) + substring(@TableName, 2,50) +'.razor"') EXEC xp_cmdshell @TableCreatorString
set @TableCreatorString = (select 'echo { >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\ComponentScript\SaveAndUpdate\SaveAndUpdate'+ upper(substring(@TableName, 1,1)) + substring(@TableName, 2,50) +'.razor"') EXEC xp_cmdshell @TableCreatorString
set @TableCreatorString = (select 'echo ' + @TableName +'Entity.UpdatedBy = 1; // set current user ID >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\ComponentScript\SaveAndUpdate\SaveAndUpdate'+ upper(substring(@TableName, 1,1)) + substring(@TableName, 2,50) +'.razor"') EXEC xp_cmdshell @TableCreatorString
set @TableCreatorString = (select 'echo ' + @TableName +'Entity.'+ (select ColumnName from TableCreator  where particulars in ('PrimaryID'))  +' = Id.Value; >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\ComponentScript\SaveAndUpdate\SaveAndUpdate'+ upper(substring(@TableName, 1,1)) + substring(@TableName, 2,50) +'.razor"') EXEC xp_cmdshell @TableCreatorString
set @TableCreatorString = (select 'echo await '+ lower(@TableName) +'.Update' + @TableName +'(' + @TableName +'Entity); >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\ComponentScript\SaveAndUpdate\SaveAndUpdate'+ upper(substring(@TableName, 1,1)) + substring(@TableName, 2,50) +'.razor"') EXEC xp_cmdshell @TableCreatorString
set @TableCreatorString = (select 'echo Nav.NavigateTo($"/Settings/LocationMaster/' + @TableName +'/ComponentScript/GridviewAndDelete/' + @TableName +'"); >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\ComponentScript\SaveAndUpdate\SaveAndUpdate'+ upper(substring(@TableName, 1,1)) + substring(@TableName, 2,50) +'.razor"') EXEC xp_cmdshell @TableCreatorString
set @TableCreatorString = (select 'echo  } >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\ComponentScript\SaveAndUpdate\SaveAndUpdate'+ upper(substring(@TableName, 1,1)) + substring(@TableName, 2,50) +'.razor"') EXEC xp_cmdshell @TableCreatorString
set @TableCreatorString = (select 'echo else >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\ComponentScript\SaveAndUpdate\SaveAndUpdate'+ upper(substring(@TableName, 1,1)) + substring(@TableName, 2,50) +'.razor"') EXEC xp_cmdshell @TableCreatorString
set @TableCreatorString = (select 'echo  { >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\ComponentScript\SaveAndUpdate\SaveAndUpdate'+ upper(substring(@TableName, 1,1)) + substring(@TableName, 2,50) +'.razor"') EXEC xp_cmdshell @TableCreatorString
set @TableCreatorString = (select 'echo ' + @TableName +'Entity.CreatedBy = 1; >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\ComponentScript\SaveAndUpdate\SaveAndUpdate'+ upper(substring(@TableName, 1,1)) + substring(@TableName, 2,50) +'.razor"') EXEC xp_cmdshell @TableCreatorString
set @TableCreatorString = (select 'echo await '+ lower(@TableName) +'.Create' + @TableName +'(' + @TableName +'Entity); >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\ComponentScript\SaveAndUpdate\SaveAndUpdate'+ upper(substring(@TableName, 1,1)) + substring(@TableName, 2,50) +'.razor"') EXEC xp_cmdshell @TableCreatorString
set @TableCreatorString = (select 'echo Nav.NavigateTo($"/Settings/LocationMaster/' + @TableName +'/ComponentScript/GridviewAndDelete/' + @TableName +'"); >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\ComponentScript\SaveAndUpdate\SaveAndUpdate'+ upper(substring(@TableName, 1,1)) + substring(@TableName, 2,50) +'.razor"') EXEC xp_cmdshell @TableCreatorString
set @TableCreatorString = (select 'echo } >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\ComponentScript\SaveAndUpdate\SaveAndUpdate'+ upper(substring(@TableName, 1,1)) + substring(@TableName, 2,50) +'.razor"') EXEC xp_cmdshell @TableCreatorString
set @TableCreatorString = (select 'echo } >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\ComponentScript\SaveAndUpdate\SaveAndUpdate'+ upper(substring(@TableName, 1,1)) + substring(@TableName, 2,50) +'.razor"') EXEC xp_cmdshell @TableCreatorString
set @TableCreatorString = (select 'echo } >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\ComponentScript\SaveAndUpdate\SaveAndUpdate'+ upper(substring(@TableName, 1,1)) + substring(@TableName, 2,50) +'.razor"') EXEC xp_cmdshell @TableCreatorString