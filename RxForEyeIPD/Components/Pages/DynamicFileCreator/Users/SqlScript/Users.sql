if object_id ('Users') is not null  
drop table Users 
Create Table Users 
( 
        UserId Int   Identity (1,1) Not Null , 
        UserRoleId Int   Not Null , 
        UserName varchar (20) Not Null , 
        UserEmail varchar (100) Not Null , 
        UserImage varbinary (max) Null , 
        UserPassword varchar (max) Not Null , 
        DeviceName varchar (30) Null , 
        ScreenSize varchar (20) Null , 
        Manufacturer varchar (30) Null , 
        IpAddress varchar (20) Null , 
        LockHours int Null,
        RememberMe bit Null,
        CreatedBy Int   Not Null , 
        UpdatedBy Int   Null , 
        DeletedBy Int   Null , 
        CreatedAt DateTime   Not Null Default Getdate(), 
        UpdatedAt DateTime   Null , 
        DeletedAt DateTime   Null , 
        IsActive char (3) Not Null Default 'Yes' 
) 
go 
if object_id ('ProcInsertUsers') is not null  
drop Proc ProcInsertUsers 
Go 
Create Proc ProcInsertUsers 
        @UserRoleId Int  , 
        @UserName nvarchar (20), 
        @UserEmail varchar (100), 
        @UserImage varbinary (max), 
        @UserPassword varchar (max), 
        @DeviceName varchar (30), 
        @ScreenSize varchar (20), 
        @Manufacturer varchar (30), 
        @IpAddress varchar (20), 
        @LockHours int,
        @RememberMe bit,
        @CreatedBy Int 
As 
Begin 
	if not exists(select * from Users where UserEmail = @UserEmail)
    Begin -- if not exists Begin 
        insert into Users ( 
               UserRoleId, 
               UserName, 
               UserEmail, 
               UserImage, 
               UserPassword, 
               DeviceName, 
               ScreenSize, 
               Manufacturer, 
               IpAddress, 
               LockHours,
			   RememberMe,
                CreatedBy) 
        Values ( 
                @UserRoleId, 
                @UserName, 
                @UserEmail, 
                @UserImage, 
                @UserPassword, 
                @DeviceName, 
                @ScreenSize, 
                @Manufacturer, 
                @IpAddress, 
                @LockHours,
			    @RememberMe,
                @CreatedBy) 
    End -- if not exists end 
End 
Go 


if object_id ('ProcUpdateUsers') is not null  
drop Proc ProcUpdateUsers 
Go 
Create Proc ProcUpdateUsers 
        @UserId Int  , 
        @UserRoleId Int  , 
        @UserName NVarChar (20), 
        @UserEmail VarChar (100), 
        @UserImage VarBinary (max), 
        @UserPassword VarChar (max), 
        @DeviceName VarChar (30), 
        @ScreenSize VarChar (20), 
        @Manufacturer VarChar (30), 
        @IpAddress VarChar (20), 
        @LockHours int,
	    @RememberMe bit,
        @UpdatedBy Int 
As 
Begin 
        Update Users set  UserRoleId = @UserRoleId, UserName = @UserName, UserEmail = @UserEmail, UserImage = @UserImage, UserPassword = @UserPassword, DeviceName = @DeviceName, ScreenSize = @ScreenSize, Manufacturer = @Manufacturer, IpAddress = @IpAddress, LockHours = @LockHours, RememberMe = @RememberMe, UpdatedBy = @UpdatedBy where UserId = @UserId 
End 
Go 
if object_id ('ProcDeleteUsers') is not null  
drop Proc ProcDeleteUsers 
Go 
Create Proc ProcDeleteUsers 
        @UserId Int  , 
        @DeletedBy Int 
As 
Begin 
        Update Users set IsActive = 'No', DeletedBy = @DeletedBy where UserId = @UserId 
End 
Go 
if object_id ('ProcSelectAllUsers') is not null  
drop Proc ProcSelectAllUsers 
Go 
Create Proc ProcSelectAllUsers 
As 
Begin 
        Select UserId,  UserRoleId,  UserName,  UserEmail,  UserImage,  UserPassword,  DeviceName,  ScreenSize,  Manufacturer,  IpAddress,  LockHours, RememberMe, CreatedBy,  UpdatedBy,  DeletedBy,  CreatedAt,  UpdatedAt,  DeletedAt,  IsActive from Users Where IsActive = 'Yes' 
End 
Go 
if object_id ('ProcSelectOneUsers') is not null  
drop Proc ProcSelectOneUsers 
Go 
Create Proc ProcSelectOneUsers 
        @UserId Int   
As 
Begin 
        Select UserId,  UserRoleId,  UserName,  UserEmail,  UserImage,  UserPassword,  DeviceName,  ScreenSize,  Manufacturer,  IpAddress, LockHours, RememberMe, CreatedBy,  UpdatedBy,  DeletedBy,  CreatedAt,  UpdatedAt,  DeletedAt,  IsActive from Users  where IsActive = 'Yes' and UserId = @UserId 
End 
Go 
if object_id ('ProcSelectUserssByUserRoleId') is not null  
drop Proc ProcSelectUserssByUserRoleId 
Go 
Create Proc ProcSelectUserssByUserRoleId 
        @UserRoleId Int   
As 
Begin 
        Select UserRoleId from Users  where IsActive = 'Yes' and UserRoleId = @UserRoleId 
End 
Go 


if object_id ('UserPolicy') is not null
drop table UserPolicy
go

create table UserPolicy
(
PolicyId	int identity(1,1) Not Null,
PolicyName  varchar(50),
CreatedBy	Int   Not Null , 
UpdatedBy	Int   Null , 
DeletedBy	Int   Null , 
CreatedAt	DateTime   Not Null Default Getdate(), 
UpdatedAt	DateTime   Null , 
DeletedAt	DateTime   Null , 
IsActive	char (3) Not Null Default 'Yes'
)

insert into UserPolicy (PolicyName, CreatedBy) values ('VIEW_PRODUCT', 1)
insert into UserPolicy (PolicyName, CreatedBy) values ('EDIT_PRODUCT', 1)
insert into UserPolicy (PolicyName, CreatedBy) values ('ADD_PRODUCT', 1)
insert into UserPolicy (PolicyName, CreatedBy) values ('DELETE_PRODUCT', 1)
go


if object_id ('UserAccountPolicy') is not null
drop table UserAccountPolicy
go

CREATE TABLE UserAccountPolicy
(
PolicyId int IDENTITY(1,1) NOT NULL,
UserId int NOT NULL,
AssingnUserPolicy nvarchar(50) NULL,
IsEnabled bit NOT NULL
)
GO

insert into UserAccountPolicy (UserId, AssingnUserPolicy, IsEnabled) values (1, 'VIEW_PRODUCT', 1)
insert into UserAccountPolicy (UserId, AssingnUserPolicy, IsEnabled) values (1, 'ADD_PRODUCT', 1)
insert into UserAccountPolicy (UserId, AssingnUserPolicy, IsEnabled) values (1, 'EDIT_PRODUCT', 1)
insert into UserAccountPolicy (UserId, AssingnUserPolicy, IsEnabled) values (1, 'DELETE_PRODUCT', 1)
insert into UserAccountPolicy (UserId, AssingnUserPolicy, IsEnabled) values (2, 'VIEW_PRODUCT', 0)
insert into UserAccountPolicy (UserId, AssingnUserPolicy, IsEnabled) values (2, 'ADD_PRODUCT', 0)
insert into UserAccountPolicy (UserId, AssingnUserPolicy, IsEnabled) values (2, 'EDIT_PRODUCT', 0)
insert into UserAccountPolicy (UserId, AssingnUserPolicy, IsEnabled) values (2, 'DELETE_PRODUCT', 0)
go



/*

select PolicyId, UserId, AssingnUserPolicy, IsEnabled from UserAccountPolicy where UserId = 1 and IsEnabled = 1
select * from users
select UserId, UserName, UserPassword, UserRoleId from Users where user_name = 'rasel@gmail.com'
select PolicyName FROM UserPolicy where IsActive='Yes'
*/