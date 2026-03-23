use db_RxForEyeIPD
go

set dateformat dmy

if object_id ('UserRole') is not null  
drop table UserRole 
Create Table UserRole 
( 
        UserRoleId Int   Identity (1,1) Not Null , 
        UserRoleName VarChar (20) Not Null , 
        CreatedBy Int   Not Null , 
        UpdatedBy Int   Null , 
        DeletedBy Int   Null , 
        CreatedAt Datetime   Not Null Default Getdate(), 
        UpdatedAt Datetime   Null , 
        DeletedAt Datetime   Null , 
        IsActive char (3) Not Null Default 'Yes'  
) 
go 
if object_id ('ProcInsertUserRole') is not null  
drop Proc ProcInsertUserRole 
Go 
Create Proc ProcInsertUserRole 
        @UserRoleName VarChar (20), 
        @CreatedBy Int 
As 
Begin 
if not exists (select * from UserRole where UserRoleName = @UserRoleName and  CreatedBy = @CreatedBy) /* if not exists section. set here your required not null columns*/ 
    Begin -- if not exists Begin 
		if not exists(select * from UserRole where UserRoleName = @UserRoleName)
        insert into UserRole ( 
               UserRoleName, 
                CreatedBy) 
        Values ( 
                @UserRoleName, 
                @CreatedBy) 
    End -- if not exists end 
End 
Go 
if object_id ('ProcUpdateUserRole') is not null  
drop Proc ProcUpdateUserRole 
Go 
Create Proc ProcUpdateUserRole 
        @UserRoleId Int  , 
        @UserRoleName VarChar (20), 
        @UpdatedBy Int 
As 
Begin 
        Update UserRole set UserRoleName = @UserRoleName,  UpdatedBy = @UpdatedBy where UserRoleId = @UserRoleId 
End 
Go 
if object_id ('ProcDeleteUserRole') is not null  
drop Proc ProcDeleteUserRole 
Go 
Create Proc ProcDeleteUserRole 
        @UserRoleId Int  , 
        @DeletedBy Int 
As 
Begin 
        Update UserRole set IsActive = 'No', DeletedBy = @DeletedBy where UserRoleId = @UserRoleId 
End 
Go 
if object_id ('ProcSelectAllUserRole') is not null  
drop Proc ProcSelectAllUserRole 
Go 
Create Proc ProcSelectAllUserRole 
As 
Begin 
        Select UserRoleId,  UserRoleName,  CreatedBy,  UpdatedBy,  DeletedBy,  CreatedAt,  UpdatedAt,  DeletedAt,  IsActive from UserRole Where IsActive = 'Yes' 
End 
Go 
if object_id ('ProcSelectOneUserRole') is not null  
drop Proc ProcSelectOneUserRole 
Go 
Create Proc ProcSelectOneUserRole 
        @UserRoleId Int   
As 
Begin 
        Select UserRoleId,  UserRoleName,  CreatedBy,  UpdatedBy,  DeletedBy,  CreatedAt,  UpdatedAt,  DeletedAt,  IsActive from UserRole  where IsActive = 'Yes' and UserRoleId = @UserRoleId 
End 
Go 
