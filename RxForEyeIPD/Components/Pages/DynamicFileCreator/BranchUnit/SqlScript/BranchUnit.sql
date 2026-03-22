use db_RxForEyeIPD
go


if object_id ('BranchUnit') is not null  
drop table BranchUnit 
Create Table BranchUnit 
( 
        BranchUnitId Int   Identity (1,1) Not Null , 
        BaseHospitalId int   Not Null , 
        BranchUnitName nvarchar (100) Not Null , 
        BranchUnitContact varchar (20) Null , 
        BranchUnitEmail varchar (40) Null , 
        BranchUnitAddress varchar (100) Not Null , 
        BranchUnitDialogue varchar (100) Null , 
        BranchUnitMessage varchar (100) Null , 
        CreatedBy Int   Not Null , 
        UpdatedBy Int   Null , 
        DeletedBy Int   Null , 
        CreatedAt Datetime   Not Null Default Getdate(), 
        UpdatedAt Datetime   Null , 
        DeletedAt Datetime   Null , 
        IsActive char (3) Not Null Default 'Yes' 
) 
go 
if object_id ('ProcInsertBranchUnit') is not null  
drop Proc ProcInsertBranchUnit 
Go 
Create Proc ProcInsertBranchUnit 
        @BaseHospitalId int  , 
        @BranchUnitName nvarchar (100), 
        @BranchUnitContact varchar (20), 
        @BranchUnitEmail varchar (40), 
        @BranchUnitAddress varchar (100), 
        @BranchUnitDialogue varchar (100), 
        --@BranchUnitLogo varbinary (max), 
        @BranchUnitMessage varchar (100), 
        @CreatedBy Int 
As 
Begin 
if not exists(select * from BranchUnit where BranchUnitName = @BranchUnitName)
    Begin -- if not exists Begin 
        insert into BranchUnit ( 
               BaseHospitalId, 
               BranchUnitName, 
               BranchUnitContact, 
               BranchUnitEmail, 
               BranchUnitAddress, 
               BranchUnitDialogue, 
               --BranchUnitLogo, 
               BranchUnitMessage, 
                CreatedBy) 
        Values ( 
                @BaseHospitalId, 
                @BranchUnitName, 
                @BranchUnitContact, 
                @BranchUnitEmail, 
                @BranchUnitAddress, 
                @BranchUnitDialogue, 
                --@BranchUnitLogo, 
                @BranchUnitMessage, 
                @CreatedBy) 
    End -- if not exists end 
End 
Go 
if object_id ('ProcUpdateBranchUnit') is not null  
drop Proc ProcUpdateBranchUnit 
Go 
Create Proc ProcUpdateBranchUnit 
        @BranchUnitId Int  , 
        @BaseHospitalId int  , 
        @BranchUnitName nvarchar (100), 
        @BranchUnitContact varchar (20), 
        @BranchUnitEmail varchar (40), 
        @BranchUnitAddress varchar (100), 
        @BranchUnitDialogue varchar (100), 
        --@BranchUnitLogo varbinary (max), 
        @BranchUnitMessage varchar (100), 
        @UpdatedBy Int 
As 
Begin 
        Update BranchUnit set  
        BaseHospitalId = @BaseHospitalId, BranchUnitName = @BranchUnitName, BranchUnitContact = @BranchUnitContact, BranchUnitEmail = @BranchUnitEmail, BranchUnitAddress = @BranchUnitAddress, BranchUnitDialogue = @BranchUnitDialogue, /*BranchUnitLogo = @BranchUnitLogo,*/ BranchUnitMessage = @BranchUnitMessage,  UpdatedBy = @UpdatedBy where BranchUnitId = @BranchUnitId 
End 
Go 
if object_id ('ProcDeleteBranchUnit') is not null  
drop Proc ProcDeleteBranchUnit 
Go 
Create Proc ProcDeleteBranchUnit 
        @BranchUnitId Int  , 
        @DeletedBy Int 
As 
Begin 
        Update BranchUnit set IsActive = 'No', 
        DeletedBy = @DeletedBy where BranchUnitId = @BranchUnitId 
End 
Go 
if object_id ('ProcSelectAllBranchUnit') is not null  
drop Proc ProcSelectAllBranchUnit 
Go 
Create Proc ProcSelectAllBranchUnit 
As 
Begin 
        Select 
  BranchUnitId,  BaseHospitalId,  BranchUnitName,  BranchUnitContact,  BranchUnitEmail,  BranchUnitAddress,  BranchUnitDialogue,  /*BranchUnitLogo,*/  BranchUnitMessage,  CreatedBy,  UpdatedBy,  DeletedBy,  CreatedAt,  UpdatedAt,  DeletedAt,  IsActive from BranchUnit Where IsActive = 'Yes' 
End 
Go 
if object_id ('ProcSelectOneBranchUnit') is not null  
drop Proc ProcSelectOneBranchUnit 
Go 
Create Proc ProcSelectOneBranchUnit 
        @BranchUnitId Int   
As 
Begin 
        Select 
         BranchUnitId,  BaseHospitalId,  BranchUnitName,  BranchUnitContact,  BranchUnitEmail,  BranchUnitAddress,  BranchUnitDialogue,  /*BranchUnitLogo,*/  BranchUnitMessage,  CreatedBy,  UpdatedBy,  DeletedBy,  CreatedAt,  UpdatedAt,  DeletedAt,  IsActive from BranchUnit  where IsActive = 'Yes' and BranchUnitId = @BranchUnitId 
End 
Go 
if object_id ('ProcSelectBranchUnitsByBaseHospitalId') is not null  
drop Proc ProcSelectBranchUnitsByBaseHospitalId 
Go 
Create Proc ProcSelectBranchUnitsByBaseHospitalId 
        @BaseHospitalId Int   
As 
Begin 
        Select 
        BranchUnitName from BranchUnit  where IsActive = 'Yes' and BaseHospitalId = @BaseHospitalId 
End 
Go 
