if object_id ('User') is not null  
drop table User 
Create Table User 
( 
        UserId Int   Identity (1,1) Not Null , 
        BranchId Int   Not Null , 
        UserName nvarchar (20) Not Null , 
        UserEmail varchar (20) Not Null , 
        CreatedBy Int   Not Null , 
        UpdatedBy Int   Null , 
        DeletedBy Int   Null , 
        CreatedAt Datetime   Not Null Default Getdate(), 
        UpdatedAt Datetime   Null , 
        DeletedAt Datetime   Null , 
        IsActive char (3) Not Null Default 'Yes' 
) 
go 
if object_id ('ProcInsertUser') is not null  
drop Proc ProcInsertUser 
Go 
Create Proc ProcInsertUser 
        @BranchId Int  , 
        @UserName nvarchar (20), 
        @UserEmail varchar (20), 
        @UserImage varbinary (max), 
        @CreatedBy Int 
As 
Begin 
if not exists (select * from User where BranchId = @BranchId and UserName = @UserName and UserEmail = @UserEmail and  CreatedBy = @CreatedBy) /* if not exists section. set here your required not null columns*/ 
    Begin -- if not exists Begin 
        insert into User ( 
               BranchId, 
               UserName, 
               UserEmail, 
               UserImage, 
                CreatedBy) 
        Values ( 
                @BranchId, 
                @UserName, 
                @UserEmail, 
                @UserImage, 
                @CreatedBy) 
    End -- if not exists end 
End 
Go 
if object_id ('ProcUpdateUser') is not null  
drop Proc ProcUpdateUser 
Go 
Create Proc ProcUpdateUser 
        @UserId Int  , 
        @BranchId Int  , 
        @UserName nvarchar (20), 
        @UserEmail varchar (20), 
        @UserImage varbinary (max), 
        @UpdatedBy Int 
As 
Begin 
        Update User set  
        BranchId = @BranchId, UserName = @UserName, UserEmail = @UserEmail, UserImage = @UserImage,  UpdatedBy = @UpdatedBy where UserId = @UserId 
End 
Go 
if object_id ('ProcDeleteUser') is not null  
drop Proc ProcDeleteUser 
Go 
Create Proc ProcDeleteUser 
        @UserId Int  , 
        @DeletedBy Int 
As 
Begin 
        Update User set IsActive = 'No', 
        DeletedBy = @DeletedBy where UserId = @UserId 
End 
Go 
if object_id ('ProcSelectAllUser') is not null  
drop Proc ProcSelectAllUser 
Go 
Create Proc ProcSelectAllUser 
As 
Begin 
        Select 
  UserId,  BranchId,  UserName,  UserEmail,  UserImage,  CreatedBy,  UpdatedBy,  DeletedBy,  CreatedAt,  UpdatedAt,  DeletedAt,  IsActive from User Where IsActive = 'Yes' 
End 
Go 
if object_id ('ProcSelectOneUser') is not null  
drop Proc ProcSelectOneUser 
Go 
Create Proc ProcSelectOneUser 
        @UserId Int   
As 
Begin 
        Select 
         UserId,  BranchId,  UserName,  UserEmail,  UserImage,  CreatedBy,  UpdatedBy,  DeletedBy,  CreatedAt,  UpdatedAt,  DeletedAt,  IsActive from User  where IsActive = 'Yes' and UserId = @UserId 
End 
Go 
if object_id ('ProcSelectUserByBranchId') is not null  
drop Proc ProcSelectUsersByBranchId 
Go 
Create Proc ProcSelectUsersByBranchId 
        @BranchId Int   
As 
Begin 
        Select 
        BranchId from User  where IsActive = 'Yes' and BranchId = @BranchId 
End 
Go 
