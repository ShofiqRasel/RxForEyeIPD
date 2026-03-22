use db_RxForEyeIPD
go

if object_id ('BaseHospital') is not null  
drop table BaseHospital 
Create Table BaseHospital 
( 
        BaseHospitalId Int Identity (1,1) Not Null , 
        BaseHospitalName nvarchar (100) Not Null , 
        BaseHospitalContact varchar (20) Null , 
        BaseHospitalEmail varchar (40) Null , 
        BaseHospitalAddress varchar (100) Not Null , 
        BaseHospitalDialogue varchar (100) Null , 
        BaseHospitalLogo varbinary (max),
        BaseHospitalMessage varchar (100) Null , 
        CreatedBy Int Not Null , 
        UpdatedBy Int Null , 
        DeletedBy Int Null , 
        CreatedAt Datetime Not Null Default Getdate(), 
        UpdatedAt Datetime Null , 
        DeletedAt Datetime Null , 
        IsActive char (3) Not Null Default 'Yes'  
) 
go 
if object_id ('ProcInsertBaseHospital') is not null  
drop Proc ProcInsertBaseHospital 
Go 
Create Proc ProcInsertBaseHospital 
        @BaseHospitalName nvarchar (100), 
        @BaseHospitalContact varchar (20), 
        @BaseHospitalEmail varchar (40), 
        @BaseHospitalAddress varchar (100), 
        @BaseHospitalDialogue varchar (100), 
        @BaseHospitalLogo varbinary (max) = null, 
        @BaseHospitalMessage varchar (100), 
        @CreatedBy Int 
As 
Begin 
	if not exists(select * from BaseHospital where BaseHospitalName = @BaseHospitalName)
    Begin -- if not exists Begin 
        insert into BaseHospital ( 
               BaseHospitalName, 
               BaseHospitalContact, 
               BaseHospitalEmail, 
               BaseHospitalAddress, 
               BaseHospitalDialogue, 
               BaseHospitalLogo, 
               BaseHospitalMessage, 
                CreatedBy) 
        Values ( 
                @BaseHospitalName, 
                @BaseHospitalContact, 
                @BaseHospitalEmail, 
                @BaseHospitalAddress, 
                @BaseHospitalDialogue, 
                @BaseHospitalLogo, 
                @BaseHospitalMessage, 
                @CreatedBy) 
    End -- if not exists end 
End 
Go 


if object_id ('ProcUpdateBaseHospital') is not null  
drop Proc ProcUpdateBaseHospital 
Go 
Create Proc ProcUpdateBaseHospital 
        @BaseHospitalId Int  , 
        @BaseHospitalName nvarchar (100), 
        @BaseHospitalContact varchar (20), 
        @BaseHospitalEmail varchar (40), 
        @BaseHospitalAddress varchar (100), 
        @BaseHospitalDialogue varchar (100), 
        @BaseHospitalLogo varbinary (max), 
        @BaseHospitalMessage varchar (100), 
        @UpdatedBy Int 
As 
Begin 
        Update BaseHospital set  
        BaseHospitalName = @BaseHospitalName, BaseHospitalContact = @BaseHospitalContact, BaseHospitalEmail = @BaseHospitalEmail, BaseHospitalAddress = @BaseHospitalAddress, BaseHospitalDialogue = @BaseHospitalDialogue, BaseHospitalLogo = @BaseHospitalLogo, BaseHospitalMessage = @BaseHospitalMessage,  UpdatedBy = @UpdatedBy where BaseHospitalId = @BaseHospitalId 
End 
Go 

if object_id ('ProcDeleteBaseHospital') is not null  
drop Proc ProcDeleteBaseHospital 
Go 
Create Proc ProcDeleteBaseHospital 
        @BaseHospitalId Int  , 
        @DeletedBy Int 
As 
Begin 
        Update BaseHospital set IsActive = 'No', DeletedBy = @DeletedBy where BaseHospitalId = @BaseHospitalId 
End 
Go 


if object_id ('ProcSelectAllBaseHospital') is not null  
drop Proc ProcSelectAllBaseHospital 
Go 
Create Proc ProcSelectAllBaseHospital 
As 
Begin 
        Select BaseHospitalId,  BaseHospitalName,  BaseHospitalContact,  BaseHospitalEmail,  BaseHospitalAddress,  BaseHospitalDialogue,  BaseHospitalLogo,  BaseHospitalMessage,  CreatedBy,  UpdatedBy,  DeletedBy,  CreatedAt,  UpdatedAt,  DeletedAt,  IsActive from BaseHospital Where IsActive = 'Yes' 
End 
Go 


if object_id ('ProcSelectOneBaseHospital') is not null  
drop Proc ProcSelectOneBaseHospital 
Go 
Create Proc ProcSelectOneBaseHospital 
        @BaseHospitalId Int   
As 
Begin 
        Select BaseHospitalId,  BaseHospitalName,  BaseHospitalContact,  BaseHospitalEmail,  BaseHospitalAddress,  BaseHospitalDialogue,  BaseHospitalLogo,  BaseHospitalMessage,  CreatedBy,  UpdatedBy,  DeletedBy,  CreatedAt,  UpdatedAt,  DeletedAt,  IsActive from BaseHospital  where IsActive = 'Yes' and BaseHospitalId = @BaseHospitalId 
End 
Go 
