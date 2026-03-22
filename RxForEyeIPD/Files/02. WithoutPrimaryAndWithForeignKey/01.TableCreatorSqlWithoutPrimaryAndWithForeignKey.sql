use db_RxForEyeIPD
set nocount on

declare @TableNameString as varchar(50) = ''


if object_id ('TableCreatorFirst') is not null
drop table TableCreatorFirst
go

select * into TableCreatorFirst from OPENROWSET('Microsoft.ACE.OLEDB.12.0',  'Excel 8.0;HDR=YES;Database=E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Files\02. WithoutPrimaryAndWithForeignKey\TableCreateWithoutPrimaryAndWithForeignKey.xlsx', 'select * from [TblUser$]') 

if object_id ('TableCreator') is not null
drop table TableCreator
go 

select ROW_NUMBER() OVER (ORDER BY Slno asc) as SlNo, Particulars, ColumnName, ValueType, Amount, Nullable, DefaultValue, ChildRow, Method, Tbl, Val, Txt, ValidationMessage into TableCreator from TableCreatorFirst order by SlNo asc


declare @TableCreatorString varchar(4000) = '',  @TableName varchar (100), @EntityCreatorRow varchar(200), @Counter int = 2

declare @TempSelectOne varchar(400) = ''

declare @TempSelectAll varchar(400) = ''


set @TableName = (select ColumnName from TableCreator where particulars = 'TableName')

-- Create Table
set @TableCreatorString = (select 'IF EXIST "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\SqlScript\' + @TableName +'" RMDIR /S /Q "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\SqlScript\' + @TableName +'"')
EXEC xp_cmdshell @TableCreatorString

set @TableCreatorString = (select 'mkdir "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\SqlScript\' + @TableName +'"')
EXEC xp_cmdshell @TableCreatorString
-- Create Table


--Section : Create Table

set @TableCreatorString = (select 'echo if object_id ('''+ @TableName + ''') is not null  >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\SqlScript\'+ @TableName +'.sql"')
EXEC xp_cmdshell @TableCreatorString

set @TableCreatorString = (select 'echo drop table '+ @TableName + ' >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\SqlScript\'+ @TableName +'.sql"')
EXEC xp_cmdshell @TableCreatorString

set @TableCreatorString = (select 'echo Create Table '+ @TableName + ' >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\SqlScript\'+ @TableName +'.sql"')
EXEC xp_cmdshell @TableCreatorString

set @TableCreatorString = ('echo ( >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\SqlScript\'+ @TableName +'.sql"')
EXEC xp_cmdshell @TableCreatorString


while (@Counter<= (select (count(*)) Total from TableCreator))
begin
	
	set @TableCreatorString = (select 'echo '+ (select '        ' + ColumnName + ' ' + ValueType + ' ' + Amount + ' ' + Nullable + ' ' + DefaultValue from TableCreator where SlNo = @Counter) +' >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\SqlScript\'+ @TableName +'.sql"')
	EXEC xp_cmdshell @TableCreatorString
	set @Counter += 1

end

set @TableCreatorString = ('echo ) >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\SqlScript\'+ @TableName +'.sql"')
EXEC xp_cmdshell @TableCreatorString

set @TableCreatorString = ('echo go >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\SqlScript\'+ @TableName +'.sql"')
EXEC xp_cmdshell @TableCreatorString
--Section : Create Table


--Section : Proc Insert


set @TableCreatorString = (select 'echo if object_id (''ProcInsert'+ @TableName + ''') is not null  >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\SqlScript\'+ @TableName +'.sql"')
EXEC xp_cmdshell @TableCreatorString

set @TableCreatorString = (select 'echo drop Proc ProcInsert'+ @TableName + ' >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\SqlScript\'+ @TableName +'.sql"')
EXEC xp_cmdshell @TableCreatorString

set @TableCreatorString = (select 'echo Go >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\SqlScript\'+ @TableName +'.sql"')
EXEC xp_cmdshell @TableCreatorString

set @TableCreatorString = (select 'echo Create Proc ProcInsert'+ @TableName + ' >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\SqlScript\'+ @TableName +'.sql"')
EXEC xp_cmdshell @TableCreatorString

set @Counter = 3

while ((select (count(*) + 3) Total from TableCreator  where particulars in ('Column')) > @Counter)
begin
	
	set @TableCreatorString = (select 'echo '+ (select '        @' + ColumnName + ' ' + ValueType + ' ' + Amount + ',' from TableCreator where particulars in ('Column') and SlNo = @Counter) +' >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\SqlScript\'+ @TableName +'.sql"')
	EXEC xp_cmdshell @TableCreatorString
	set @Counter += 1

end

set @TableCreatorString = (select 'echo         @CreatedBy Int >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\SqlScript\'+ @TableName +'.sql"')
EXEC xp_cmdshell @TableCreatorString

set @TableCreatorString = (select 'echo As >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\SqlScript\'+ @TableName +'.sql"')
EXEC xp_cmdshell @TableCreatorString

set @TableCreatorString = (select 'echo Begin >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\SqlScript\'+ @TableName +'.sql"')
EXEC xp_cmdshell @TableCreatorString

-- if not exists end

set @Counter = 3
declare @TempIfExists varchar(200) = ''

while ((select (count(*) + 3) Total from TableCreator  where particulars in ('Column') and Nullable = 'Not Null' ) > @Counter)
begin
	set @TempIfExists += (select ColumnName + ' = @'  + ColumnName + ' and ' from TableCreator where particulars in ('Column') and Nullable = 'Not Null' and SlNo = @Counter)
	set @Counter +=1

end

set @TableCreatorString = (select 'echo if not exists (select * from '+ @TableName +' where '+ @TempIfExists +' CreatedBy = @CreatedBy) /* if not exists section. set here your required not null columns*/ >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\SqlScript\'+ @TableName +'.sql"')
EXEC xp_cmdshell @TableCreatorString

set @TableCreatorString = (select 'echo     Begin -- if not exists Begin >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\SqlScript\'+ @TableName +'.sql"')
EXEC xp_cmdshell @TableCreatorString

set @TableCreatorString = (select 'echo         insert into ' + @TableName +' ( >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\SqlScript\'+ @TableName +'.sql"')
	EXEC xp_cmdshell @TableCreatorString
set @Counter = 3

while ((select (count(*) + 3) Total from TableCreator  where particulars in ('Column')) > @Counter)
begin
	
	set @TableCreatorString = (select 'echo '+ (select '               ' + ColumnName +',' from TableCreator where particulars in ('Column') and SlNo = @Counter) +' >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\SqlScript\'+ @TableName +'.sql"')
	EXEC xp_cmdshell @TableCreatorString
	set @Counter += 1

end 
set @TableCreatorString = (select 'echo                 CreatedBy) >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\SqlScript\'+ @TableName +'.sql"')
	EXEC xp_cmdshell @TableCreatorString
	
set @TableCreatorString = (select 'echo         Values ( >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\SqlScript\'+ @TableName +'.sql"')
	EXEC xp_cmdshell @TableCreatorString

set @Counter = 3

while ((select (count(*) + 3) Total from TableCreator  where particulars in ('Column')) > @Counter)
begin
	
	set @TableCreatorString = (select 'echo '+ (select '                @' + ColumnName +',' from TableCreator where particulars in ('Column') and SlNo = @Counter) +' >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\SqlScript\'+ @TableName +'.sql"')
	EXEC xp_cmdshell @TableCreatorString
	set @Counter += 1

end 
set @TableCreatorString = (select 'echo                 @CreatedBy) >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\SqlScript\'+ @TableName +'.sql"')
	EXEC xp_cmdshell @TableCreatorString

set @TableCreatorString = (select 'echo     End -- if not exists end >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\SqlScript\'+ @TableName +'.sql"')
EXEC xp_cmdshell @TableCreatorString

set @TableCreatorString = (select 'echo End >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\SqlScript\'+ @TableName +'.sql"')
EXEC xp_cmdshell @TableCreatorString

set @TableCreatorString = (select 'echo Go >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\SqlScript\'+ @TableName +'.sql"')
EXEC xp_cmdshell @TableCreatorString


--Section : Proc Insert


--Section : Proc Update


set @TableCreatorString = (select 'echo if object_id (''ProcUpdate'+ @TableName + ''') is not null  >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\SqlScript\'+ @TableName +'.sql"')
EXEC xp_cmdshell @TableCreatorString

set @TableCreatorString = (select 'echo drop Proc ProcUpdate'+ @TableName + ' >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\SqlScript\'+ @TableName +'.sql"')
EXEC xp_cmdshell @TableCreatorString

set @TableCreatorString = (select 'echo Go >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\SqlScript\'+ @TableName +'.sql"')
EXEC xp_cmdshell @TableCreatorString

set @TableCreatorString = (select 'echo Create Proc ProcUpdate'+ @TableName + ' >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\SqlScript\'+ @TableName +'.sql"')
EXEC xp_cmdshell @TableCreatorString

set @Counter = 2

while ((select (count(*) + 2) Total from TableCreator  where particulars in ('PrimaryID', 'Column')) > @Counter)
begin
	
	set @TableCreatorString = (select 'echo '+ (select '        @' + ColumnName + ' ' + ValueType + ' ' + Amount + ',' from TableCreator where particulars in ('PrimaryID', 'Column') and SlNo = @Counter) +' >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\SqlScript\'+ @TableName +'.sql"')
	EXEC xp_cmdshell @TableCreatorString
	set @Counter += 1

end

set @TableCreatorString = (select 'echo         @UpdatedBy Int >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\SqlScript\'+ @TableName +'.sql"')
EXEC xp_cmdshell @TableCreatorString

set @TableCreatorString = (select 'echo As >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\SqlScript\'+ @TableName +'.sql"')
EXEC xp_cmdshell @TableCreatorString

set @TableCreatorString = (select 'echo Begin >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\SqlScript\'+ @TableName +'.sql"')
EXEC xp_cmdshell @TableCreatorString

-- Update Start

set @TableCreatorString = (select 'echo         Update '+ @TableName +' set  >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\SqlScript\'+ @TableName +'.sql"')
	EXEC xp_cmdshell @TableCreatorString

set @Counter = 3
declare @TempStr varchar(400) = ''
while ((select (count(*) + 3) Total from TableCreator  where particulars in ('Column')) > @Counter)
begin
	set @TempStr += (select ColumnName + ' = @'  + ColumnName + ', ' from TableCreator where particulars in ('Column') and SlNo = @Counter)
	set @Counter += 1

end 

set @TableCreatorString = (select 'echo         '+ @TempStr +' UpdatedBy = @UpdatedBy where '+ (select ColumnName + ' = @'  + ColumnName  from TableCreator where particulars in ('PrimaryId')) + ' >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\SqlScript\'+ @TableName +'.sql"')
	EXEC xp_cmdshell @TableCreatorString
--Update Section

set @TableCreatorString = (select 'echo End >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\SqlScript\'+ @TableName +'.sql"')
EXEC xp_cmdshell @TableCreatorString

set @TableCreatorString = (select 'echo Go >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\SqlScript\'+ @TableName +'.sql"')
EXEC xp_cmdshell @TableCreatorString


--Section : Proc Update



--Section : Proc Delete


set @TableCreatorString = (select 'echo if object_id (''ProcDelete'+ @TableName + ''') is not null  >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\SqlScript\'+ @TableName +'.sql"')
EXEC xp_cmdshell @TableCreatorString

set @TableCreatorString = (select 'echo drop Proc ProcDelete'+ @TableName + ' >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\SqlScript\'+ @TableName +'.sql"')
EXEC xp_cmdshell @TableCreatorString

set @TableCreatorString = (select 'echo Go >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\SqlScript\'+ @TableName +'.sql"')
EXEC xp_cmdshell @TableCreatorString

set @TableCreatorString = (select 'echo Create Proc ProcDelete'+ @TableName + ' >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\SqlScript\'+ @TableName +'.sql"')
EXEC xp_cmdshell @TableCreatorString

set @Counter = 2

while ((select (count(*) + 2) Total from TableCreator  where particulars in ('PrimaryID')) > @Counter)
begin
	
	set @TableCreatorString = (select 'echo '+ (select '        @' + ColumnName + ' ' + ValueType + ' ' + Amount + ',' from TableCreator where particulars in ('PrimaryID', 'Column') and SlNo = @Counter) +' >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\SqlScript\'+ @TableName +'.sql"')
	EXEC xp_cmdshell @TableCreatorString
	set @Counter += 1

end

set @TableCreatorString = (select 'echo         @DeletedBy Int >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\SqlScript\'+ @TableName +'.sql"')
EXEC xp_cmdshell @TableCreatorString

set @TableCreatorString = (select 'echo As >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\SqlScript\'+ @TableName +'.sql"')
EXEC xp_cmdshell @TableCreatorString

set @TableCreatorString = (select 'echo Begin >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\SqlScript\'+ @TableName +'.sql"')
EXEC xp_cmdshell @TableCreatorString

-- Update Start

set @TableCreatorString = (select 'echo         Update '+ @TableName +' set IsActive = ''No'', >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\SqlScript\'+ @TableName +'.sql"')
	EXEC xp_cmdshell @TableCreatorString

set @TableCreatorString = (select 'echo         DeletedBy = @DeletedBy where '+ (select ColumnName + ' = @'  + ColumnName  from TableCreator where particulars in ('PrimaryId')) + ' >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\SqlScript\'+ @TableName +'.sql"')
	EXEC xp_cmdshell @TableCreatorString
--Update Section

set @TableCreatorString = (select 'echo End >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\SqlScript\'+ @TableName +'.sql"')
EXEC xp_cmdshell @TableCreatorString

set @TableCreatorString = (select 'echo Go >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\SqlScript\'+ @TableName +'.sql"')
EXEC xp_cmdshell @TableCreatorString

--Section : Proc Delete


--Section : Proc Select All

set @TableCreatorString = (select 'echo if object_id (''ProcSelectAll'+ @TableName + ''') is not null  >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\SqlScript\'+ @TableName +'.sql"')
EXEC xp_cmdshell @TableCreatorString

set @TableCreatorString = (select 'echo drop Proc ProcSelectAll'+ @TableName + ' >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\SqlScript\'+ @TableName +'.sql"')
EXEC xp_cmdshell @TableCreatorString

set @TableCreatorString = (select 'echo Go >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\SqlScript\'+ @TableName +'.sql"')
EXEC xp_cmdshell @TableCreatorString

set @TableCreatorString = (select 'echo Create Proc ProcSelectAll'+ @TableName + ' >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\SqlScript\'+ @TableName +'.sql"')
EXEC xp_cmdshell @TableCreatorString

set @TableCreatorString = (select 'echo As >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\SqlScript\'+ @TableName +'.sql"')
EXEC xp_cmdshell @TableCreatorString

set @TableCreatorString = (select 'echo Begin >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\SqlScript\'+ @TableName +'.sql"')
EXEC xp_cmdshell @TableCreatorString

set @TableCreatorString = (select 'echo         Select >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\SqlScript\'+ @TableName +'.sql"')
EXEC xp_cmdshell @TableCreatorString
-- Select Start


set @Counter = 2


while ((select (count(*) + 2) Total from TableCreator  where particulars not in ('TableName')) > @Counter)
begin
	
	set @TempSelectAll += (select ' ' + ColumnName + ', ' from TableCreator where SlNo = @Counter)
	set @Counter += 1

end
set @TempSelectAll = reverse(substring(reverse(@TempSelectAll), 3, len(@TempSelectAll)))

set @TableCreatorString = (select 'echo  '+ @TempSelectAll + ' from '+ @TableName +' Where IsActive = ''Yes'' >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\SqlScript\'+ @TableName +'.sql"')
	EXEC xp_cmdshell @TableCreatorString
-- Select Start

set @TableCreatorString = (select 'echo End >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\SqlScript\'+ @TableName +'.sql"')
EXEC xp_cmdshell @TableCreatorString

set @TableCreatorString = (select 'echo Go >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\SqlScript\'+ @TableName +'.sql"')
EXEC xp_cmdshell @TableCreatorString

--Section : Proc Select All

declare @PrimaryForeign as table(slno int identity (1,1) not null, ColumnName varchar(50) not null)
insert into @PrimaryForeign (ColumnName)
select ColumnName from TableCreator where Method = 'Yes' order by SlNo

--select * from @PrimaryForeign

--Section : Proc Select One By Primary Key

set @TableCreatorString = (select 'echo if object_id (''ProcSelectOne'+ @TableName + ''') is not null  >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\SqlScript\'+ @TableName +'.sql"')
EXEC xp_cmdshell @TableCreatorString

set @TableCreatorString = (select 'echo drop Proc ProcSelectOne'+ @TableName + ' >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\SqlScript\'+ @TableName +'.sql"')
EXEC xp_cmdshell @TableCreatorString

set @TableCreatorString = (select 'echo Go >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\SqlScript\'+ @TableName +'.sql"')
EXEC xp_cmdshell @TableCreatorString

set @TableCreatorString = (select 'echo Create Proc ProcSelectOne'+ @TableName + ' >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\SqlScript\'+ @TableName +'.sql"')
EXEC xp_cmdshell @TableCreatorString

set @TableCreatorString = (select 'echo         @' + ColumnName + ' ' + ValueType + ' ' + Amount from TableCreator where particulars in ('PrimaryID')) + ' >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\SqlScript\'+ @TableName +'.sql"'
EXEC xp_cmdshell @TableCreatorString

set @TableCreatorString = (select 'echo As >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\SqlScript\'+ @TableName +'.sql"')
EXEC xp_cmdshell @TableCreatorString

set @TableCreatorString = (select 'echo Begin >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\SqlScript\'+ @TableName +'.sql"')
EXEC xp_cmdshell @TableCreatorString

set @TableCreatorString = (select 'echo         Select >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\SqlScript\'+ @TableName +'.sql"')
EXEC xp_cmdshell @TableCreatorString
-- Select Start

set @Counter = 3


while ((select (count(*) + 3) Total from TableCreator  where particulars in ('Column')) > @Counter)
begin
	
	set @TempSelectOne += (select '        ' + ColumnName + ', ' from TableCreator where particulars in ('Column') and SlNo = @Counter)
	set @Counter += 1

end
set @TempSelectOne = reverse(substring(reverse(@TempSelectAll), 1, len(@TempSelectAll)))

set @TableCreatorString = (select 'echo         '+ @TempSelectOne + ' from '+ @TableName +'  where IsActive = ''Yes'' and '+ (select ColumnName + ' = @'  + ColumnName  from TableCreator where particulars in ('PrimaryId')) + ' >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\SqlScript\'+ @TableName +'.sql"')
	EXEC xp_cmdshell @TableCreatorString
-- Select Start

set @TableCreatorString = (select 'echo End >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\SqlScript\'+ @TableName +'.sql"')
EXEC xp_cmdshell @TableCreatorString

set @TableCreatorString = (select 'echo Go >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\SqlScript\'+ @TableName +'.sql"')
EXEC xp_cmdshell @TableCreatorString


--Section : Proc Select One By Primary Key


--Section : Proc Select One By Foreign Key

set @TableCreatorString = (select 'echo if object_id (''ProcSelect'+ @TableName + 'By'+(select ColumnName from TableCreator where Method = 'Yes' )+''') is not null  >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\SqlScript\'+ @TableName +'.sql"')
EXEC xp_cmdshell @TableCreatorString

set @TableCreatorString = (select 'echo drop Proc ProcSelect'+ @TableName + 'sBy'+(select ColumnName from TableCreator where Method = 'Yes' )+' >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\SqlScript\'+ @TableName +'.sql"')
EXEC xp_cmdshell @TableCreatorString

set @TableCreatorString = (select 'echo Go >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\SqlScript\'+ @TableName +'.sql"')
EXEC xp_cmdshell @TableCreatorString

set @TableCreatorString = (select 'echo Create Proc ProcSelect'+ @TableName + 'sBy'+(select ColumnName from TableCreator where Method = 'Yes' )+' >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\SqlScript\'+ @TableName +'.sql"')
EXEC xp_cmdshell @TableCreatorString

set @TableCreatorString = (select 'echo         @'+(select ColumnName from TableCreator where Method = 'Yes' )+' ' + ValueType + ' ' + Amount from TableCreator where particulars in ('PrimaryID')) + ' >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\SqlScript\'+ @TableName +'.sql"'
EXEC xp_cmdshell @TableCreatorString

set @TableCreatorString = (select 'echo As >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\SqlScript\'+ @TableName +'.sql"')
EXEC xp_cmdshell @TableCreatorString

set @TableCreatorString = (select 'echo Begin >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\SqlScript\'+ @TableName +'.sql"')
EXEC xp_cmdshell @TableCreatorString

set @TableCreatorString = (select 'echo         Select >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\SqlScript\'+ @TableName +'.sql"')
EXEC xp_cmdshell @TableCreatorString
-- Select Start

--------------- here check the @TempSelectOne it resulting selecting column wrong

set @TempSelectOne = (select ColumnName from TableCreator where SlNo = (select ChildRow from TableCreator where ChildRow != '.'))

set @TableCreatorString = (select 'echo         '+ @TempSelectOne + ' from '+ @TableName +'  where IsActive = ''Yes'' and '+(select ColumnName from TableCreator where Method = 'Yes' )+' = '+(select '@'+ ColumnName from TableCreator where Method = 'Yes' )+' >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\SqlScript\'+ @TableName +'.sql"')
	EXEC xp_cmdshell @TableCreatorString
-- Select Start

set @TableCreatorString = (select 'echo End >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\SqlScript\'+ @TableName +'.sql"')
EXEC xp_cmdshell @TableCreatorString

set @TableCreatorString = (select 'echo Go >> "E:\DotNetCoreProjects\RxForEyeIPD\RxForEyeIPD\Components\Pages\DynamicFileCreator\' + @TableName +'\SqlScript\'+ @TableName +'.sql"')
EXEC xp_cmdshell @TableCreatorString


--Section : Proc Select One By Foreign Key