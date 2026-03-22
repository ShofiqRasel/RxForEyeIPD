use master 
go

if exists (select name from sys.databases where name = 'db_RxForEyeIPD')
begin
	alter database db_RxForEyeIPD
	set single_user with rollback immediate
	drop database db_RxForEyeIPD
end

set dateformat dmy
-- ALTER SCHEMA dbo TRANSFER easyexam.webpagescontrols
----exec xp_cmdshell 'getmac /s 192.168.1.155'

----First U need to configure by following way


---- for excel openrowset query
EXEC sp_configure 'Show Advanced Options', 1
RECONFIGURE
GO
 
EXEC sp_configure 'Ad Hoc Distributed Queries', 1
RECONFIGURE
GO

 
--EXEC master.dbo.sp_MSset_oledb_prop N'Microsoft.ACE.OLEDB.12.0', N'AllowInProcess', 1 
--GO 
--EXEC master.dbo.sp_MSset_oledb_prop N'Microsoft.ACE.OLEDB.12.0', N'DynamicParameters', 1 
--GO 


/*
--in run window run this line
regsvr32 C:\Windows\SysWOW64\msexcl40.dll
*/

-- download 64 bit version and install
--https://www.microsoft.com/en-us/download/details.aspx?id=13255

-- To enable the feature.
EXEC sp_configure 'xp_cmdshell', 1
GO
-- To update the currently configured value for this feature.
RECONFIGURE
GO

--This Command Make a Data Folder in your D drive
exec xp_cmdshell 'md E:\db_RxForEyeIPD'
go

exec xp_cmdshell 'md E:\db_RxForEyeIPD\EmployeePhotoGraph'
go

exec xp_cmdshell 'md E:\db_RxForEyeIPD\BackupBD'
go

exec xp_cmdshell 'md E:\db_RxForEyeIPD\BackupBDOld'
go

create database db_RxForEyeIPD
on
	(
		name = 'db_RxForEyeIPD_DATA',
		filename = 'E:\db_RxForEyeIPD\db_RxForEyeIPD.mdf'
	)

log on
	(
		name = 'db_RxForEyeIPD_LOG',
		filename = 'E:\db_RxForEyeIPD\db_RxForEyeIPD.ldf'
	)

go

use db_RxForEyeIPD
go
