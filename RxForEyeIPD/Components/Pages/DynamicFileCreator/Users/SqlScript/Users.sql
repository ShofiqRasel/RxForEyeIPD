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
        LockHours int Null default 0,
        LockUpTo DateTime null,
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
        @UserRoleId Int , 
        @UserName nvarchar (20), 
        @UserEmail varchar (100), 
        @UserImage varbinary (max) = null, 
        @UserPassword varchar (max), 
        @DeviceName varchar (30) = null, 
        @ScreenSize varchar (20) = null, 
        @Manufacturer varchar (30) = null, 
        @IpAddress varchar (20) = null, 
        --@LockHours int,
        @RememberMe bit = null,
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
               --LockHours,
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
                --@LockHours,
			    @RememberMe,
                @CreatedBy) 
                
            -- Assign User Policy for The User Inserted
            declare @UsrId int = (select UserId from Users where UserEmail = @UserEmail) 
               
			insert into UserAccountPolicy (UserId, AssingnUserPolicy, IsEnabled) values (@UsrId, 'ViewPermission', 0)
			insert into UserAccountPolicy (UserId, AssingnUserPolicy, IsEnabled) values (@UsrId, 'AddPermission', 0)
			insert into UserAccountPolicy (UserId, AssingnUserPolicy, IsEnabled) values (@UsrId, 'EditPermission', 0)
			insert into UserAccountPolicy (UserId, AssingnUserPolicy, IsEnabled) values (@UsrId, 'DeletePermission', 0)
            -- Assign User Policy for The User Inserted
                
    End -- if not exists end 
End 
Go 

-- Creating a super admin user for running the application. Don't forget to delete this user after creating first super user for that organization. Otherwise anyone can hack this db using this default user id and pass
declare @HashPass varchar(200) = (select '$2a$12$kDZghhxi6eeYC97JoZwbX.wKmSSBvFDVQ3PBq6AdbP6y4s8btTObG')
exec ProcInsertUsers 1, N'Super Admin', 'superadmin@gmail.com', null, @HashPass, null, null, null, null, null, 1
go
-- Creating a super admin user for running the application. Don't forget to delete this user after creating first super user for that organization. Otherwise anyone can hack this db using this default user id and pass

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
        --@LockHours int,
	    @RememberMe bit,
        @UpdatedBy Int 
As 
Begin 
        Update Users set  UserRoleId = @UserRoleId, UserName = @UserName, UserEmail = @UserEmail, UserImage = @UserImage, UserPassword = @UserPassword, DeviceName = @DeviceName, ScreenSize = @ScreenSize, Manufacturer = @Manufacturer, IpAddress = @IpAddress, /*LockHours = @LockHours,*/ RememberMe = @RememberMe, UpdatedBy = @UpdatedBy where UserId = @UserId 
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

if object_id ('ProcLockTimeUpto') is not null  
drop Proc ProcLockTimeUpto 
Go 
create proc ProcLockTimeUpto 
    @LockUpTo datetime, 
    @UserId INT
AS 
BEGIN 
    update Users 
    set LockUpTo = @LockUpTo, UpdatedBy = @UserId  
    where UserId = @UserId AND IsActive = 'Yes'
END

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

insert into UserPolicy (PolicyName, CreatedBy) values ('ViewPermission', 1)
insert into UserPolicy (PolicyName, CreatedBy) values ('EditPermission', 1)
insert into UserPolicy (PolicyName, CreatedBy) values ('AddPermission', 1)
insert into UserPolicy (PolicyName, CreatedBy) values ('DeletePermission', 1)
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

insert into UserAccountPolicy (UserId, AssingnUserPolicy, IsEnabled) values (1, 'ViewPermission', 1)
insert into UserAccountPolicy (UserId, AssingnUserPolicy, IsEnabled) values (1, 'AddPermission', 1)
insert into UserAccountPolicy (UserId, AssingnUserPolicy, IsEnabled) values (1, 'EditPermission', 1)
insert into UserAccountPolicy (UserId, AssingnUserPolicy, IsEnabled) values (1, 'DeletePermission', 1)
insert into UserAccountPolicy (UserId, AssingnUserPolicy, IsEnabled) values (2, 'ViewPermission', 0)
insert into UserAccountPolicy (UserId, AssingnUserPolicy, IsEnabled) values (2, 'AddPermission', 0)
insert into UserAccountPolicy (UserId, AssingnUserPolicy, IsEnabled) values (2, 'EditPermission', 0)
insert into UserAccountPolicy (UserId, AssingnUserPolicy, IsEnabled) values (2, 'DeletePermission', 0)
go



/*

select PolicyId, UserId, AssingnUserPolicy, IsEnabled from UserAccountPolicy where UserId = 1 and IsEnabled = 1
select * from users
select UserId, UserName, UserPassword, UserRoleId from Users where user_name = 'rasel@gmail.com'
select PolicyName FROM UserPolicy where IsActive='Yes'
*/