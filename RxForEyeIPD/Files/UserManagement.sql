USE db_RxForEyeIPD
GO

if object_id('users') is not null
drop table users

create table users
(
id					int identity(1,1) not null ,
user_type_role_id	int not null,
base_id				int not null,
branch_id			int null,
users_name			varchar (50) not null,
email_id			varchar(50) not null,
user_password		varbinary(max) not null,
user_image			varbinary(max) null,
created_at			datetime not null default getdate(),
updated_at			datetime null,
deleted_at			datetime null,
created_by			int not null,
updated_by			int null,
deleted_by			int null,
IsActive			char(3) not null default 'Yes'--,
)


--insert into  users (user_type_role_id, branch_id, users_name, email_id, user_password, user_image, created_by) values('1', 1,'Rasel','rasel@gmail.com', EncryptByPassPhrase('8','123'), (select BulkColumn FROM Openrowset( Bulk 'E:\DotNetCoreProjects\RxForEyeOPD\RxForEyeOPD\wwwroot\images\MiscImage\rasel.jpg', Single_Blob) as logo),'1')
--insert into  users (user_type_role_id, branch_id, users_name, email_id, user_password, user_image, created_by) values('4', 2,'parag','parag@gmail.com', EncryptByPassPhrase('8','123'), (select BulkColumn FROM Openrowset( Bulk 'E:\DotNetCoreProjects\RxForEyeOPD\RxForEyeOPD\wwwroot\images\MiscImage\parag.jpg', Single_Blob) as logo),'1')
--insert into  users (user_type_role_id, branch_id, users_name, email_id, user_password, user_image, created_by) values('4', 3,'sib','sib@gmail.com', EncryptByPassPhrase('8','123'), (select BulkColumn FROM Openrowset( Bulk 'E:\DotNetCoreProjects\RxForEyeOPD\RxForEyeOPD\wwwroot\images\MiscImage\male.png', Single_Blob) as logo),'1')
--insert into  users (user_type_role_id, branch_id, users_name, email_id, user_password, user_image, created_by) values('1', 4,'Atoar','atoar@gmail.com', EncryptByPassPhrase('8','123'), (select BulkColumn FROM Openrowset( Bulk 'E:\DotNetCoreProjects\RxForEyeOPD\RxForEyeOPD\wwwroot\images\MiscImage\female.png', Single_Blob) as logo),'1')

if object_id ('procUsers') is not null
drop proc procUsers
go

create proc procUsers
@user_type_role_id int, @base_id int, @branch_id int = null, @users_name varchar (50), @email_id varchar(50), @user_password varchar(30), @user_image varbinary(max) = null,  @created_by int
as
begin

declare @userID int

if not exists(select email_id, user_password from users where email_id= @email_id and user_password= @user_password)
	begin
		insert into  Users (user_type_role_id, base_id, branch_id, users_name, email_id, user_password, user_image, created_by) 
		values(@user_type_role_id,@base_id,  @branch_id, @users_name, @email_id, cast(EncryptByPassPhrase('8', @user_password) as varbinary(200)), @user_image, @created_by)

		--set @userID = (select id from users where base_id = @base_id and branch_id = @branch_id and users_name = @users_name and email_id = @email_id /*and user_password = cast(EncryptByPassPhrase('8', @user_password) as varbinary(200))*/ and created_by = @created_by )
		--insert into UserPermissionForMenu (userid, WebPageId, ControlId, ControlProgId, IsActive, created_by) select @userID 'UserId', wpc.WebPageId, wpc.ControlId, wpc.ControlProgId, 'No', '1' from WebPages wp, WebPagesControls wpc where wp.WebPageId = wpc.WebPageId
	end
end
go

if object_id ('procUserById') is not null
drop proc procUserById
go

create proc procUserById
@id int
as
begin
	select id, user_type_role_id, branch_id, users_name, email_id, user_password, user_image from users where id = @id
end
go


if object_id ('procUpdateUser') is not null
drop proc procUpdateUser
go

create proc procUpdateUser
@id int, @user_type_role_id int, @branch_id int = null, @users_name varchar (50), @email_id varchar(50), @user_password varchar(30), @user_image varbinary(max) = null,  @updated_by int
as
begin

if not exists(select email_id, user_password from users where email_id= @email_id and user_password= @user_password)
	begin
	update Users set user_type_role_id = @user_type_role_id, branch_id = @branch_id, users_name = @users_name, email_id = @email_id, user_password = cast(EncryptByPassPhrase('8', @user_password) as varbinary(200)), user_image = @user_image, updated_by = @updated_by where id = @id
	end
end
go

if object_id ('procDeleteUser') is not null
drop proc procDeleteUser
go

create proc procDeleteUser
@id int, @deleted_by int
as
begin
	update Users set IsActive='No', deleted_by = @deleted_by where id = @id
end
go

if object_id ('procReactiveUser') is not null
drop proc procReactiveUser
go

create proc procReactiveUser
@id int, @updated_by int
as
begin
	update Users set IsActive='Yes', updated_by = @updated_by where id = @id
end
go

if object_id ('user_account_policy') is not null
drop table user_account_policy
go

CREATE TABLE user_account_policy
(
id int IDENTITY(1,1) NOT NULL,
user_account_id int NOT NULL,
user_policy nvarchar(50) NULL,
is_enabled bit NOT NULL
)
GO

insert into user_account_policy (user_account_id, user_policy, is_enabled) values (1, 'VIEW_PRODUCT', 1)
insert into user_account_policy (user_account_id, user_policy, is_enabled) values (1, 'ADD_PRODUCT', 0)
insert into user_account_policy (user_account_id, user_policy, is_enabled) values (1, 'EDIT_PRODUCT', 1)
insert into user_account_policy (user_account_id, user_policy, is_enabled) values (1, 'DELETE_PRODUCT', 0)
insert into user_account_policy (user_account_id, user_policy, is_enabled) values (2, 'VIEW_PRODUCT', 0)
insert into user_account_policy (user_account_id, user_policy, is_enabled) values (2, 'ADD_PRODUCT', 0)
insert into user_account_policy (user_account_id, user_policy, is_enabled) values (2, 'EDIT_PRODUCT', 1)
insert into user_account_policy (user_account_id, user_policy, is_enabled) values (2, 'DELETE_PRODUCT', 1)
go

if object_id ('user_accounts') is not null
drop table user_accounts
go

CREATE TABLE user_accounts
(
Id int IDENTITY(1,1) NOT NULL,
user_name nvarchar(100) NULL,
password nvarchar(100) NULL,
role nvarchar(20) NULL
)
GO

insert into user_accounts(user_name, password, role) values('Rasel', '123', 'Admin')
insert into user_accounts(user_name, password, role) values('Rubel', '123', 'User')
go

if object_id('user_types') is not null
drop table user_types

create table user_types
(
id				int identity(1,1) not null ,
user_type_name	varchar(30) not null,
created_at		datetime not null default getdate(),
updated_at		datetime null,
deleted_at		datetime null,
created_by		int not null,
updated_by		int null,
deleted_by		int null--,
)

insert into user_types (user_type_name, created_by) values ('Super Admin', '1')
insert into user_types (user_type_name, created_by) values ('Admin', '1')
insert into user_types (user_type_name, created_by) values ('Default', '1')
insert into user_types (user_type_name, created_by) values ('Guest', '1')
insert into user_types (user_type_name, created_by) values ('PEC Incharge', '1')
insert into user_types (user_type_name, created_by) values ('Volunteer', '1')
insert into user_types (user_type_name, created_by) values ('Incharge', '1')

go


if object_id('Branch') is not null
drop table Branch
go

create table Branch
(
branch_id			int identity(1,1) not null,
Base_id				int not null,
branch_name			nvarchar(100) not null,
branch_contact_name	nvarchar(100) null,
branch_contact_no	varchar(20) null,
branch_email_id		varchar(50) null,
branch_address		nvarchar(100) not null,
branch_dialogue		varchar(100) null,
branch_logo			varbinary(max) null,
branch_message		varchar(50) null,
created_at			datetime not null default getdate(),
updated_at			datetime null,
deleted_at			datetime null,
created_by			int not null,
updated_by			int null,
deleted_by			int null,
IsActive			char(3) not null default 'Yes'
)
go


if object_id('procBranch') is not null
drop proc procBranch
go

create proc procBranch
@Base_id int, @branch_name nvarchar(100), @branch_contact_name nvarchar(100), @branch_contact_no varchar(20), @branch_email_id varchar(50), @branch_address nvarchar(100), @branch_dialogue varchar(100) = null, @branch_logo varbinary(max) = null, @branch_message varchar(50) = null, @created_by int 
as  
begin
	if not exists(select branch_name from Branch where  branch_name = @branch_name and branch_email_id = @branch_email_id)
	begin
		insert into Branch	(	Base_id,	branch_name,	branch_contact_name,	branch_contact_no,		branch_email_id,	branch_address,		branch_dialogue,				branch_logo,				branch_message,					created_by)
					values  (	@Base_id,	@branch_name,	@branch_contact_name,	@branch_contact_no,		@branch_email_id,	@branch_address,	isnull(@branch_dialogue, NULL),	isnull(@branch_logo, NULL),	isnull(@branch_message, NULL),	@created_by)
	end
end
go

if object_id('procBranchSearchByCriteria') is not null
drop proc procBranchSearchByCriteria
go
create proc procBranchSearchByCriteria
@Criteria varchar(100), @Criteriavalue varchar(100), @OrderBy varchar(100)
as 
begin
declare @SearchMainString varchar(max)
set @SearchMainString = (select 'select branch_id, Base_id, branch_name, branch_contact_name, branch_contact_no, branch_email_id, branch_address, branch_dialogue, isnull(branch_logo, convert(VARBINARY(max), (select user_image from temp_user where id = 1))) branch_logo, branch_message from Branch where '+ @Criteria + ' like ''%'+ @Criteriavalue +'%''' + ' Order By ' + @OrderBy)
exec (@SearchMainString)
--select @SearchMainString
end
go

insert into Branch (Base_id,branch_name,branch_contact_name,branch_contact_no,branch_email_id,branch_address,branch_logo,branch_dialogue,branch_message,created_by) values (1,'Base Hospital','Mamun','123','mamun@gmail.com','bnsbmym',(select BulkColumn FROM Openrowset( Bulk 'F:\DotNetProjects\unicare\unicare\Images\Logo\bnsbmym.png', Single_Blob) as logo),'The Right Choice','Ramadan Mubarak',1)
insert into Branch (Base_id,branch_name,branch_contact_name,branch_contact_no,branch_email_id,branch_address,branch_logo,branch_dialogue,branch_message,created_by) values (1,'PEC, Nakla','Rasel','123','rasel@gmail.com','Mymensingh',(select BulkColumn FROM Openrowset( Bulk 'F:\DotNetProjects\unicare\unicare\Images\Logo\bnsbmym.png', Single_Blob) as logo),'The Right Choice','Ramadan Mubarak',1)
insert into Branch (Base_id,branch_name,branch_contact_name,branch_contact_no,branch_email_id,branch_address,branch_logo,branch_dialogue,branch_message,created_by) values (1,'PEC Sreebardi','Zafar','123','zafar@gmail.com','Chandpur',(select BulkColumn FROM Openrowset( Bulk 'F:\DotNetProjects\unicare\unicare\Images\Logo\chandpur.jpg', Single_Blob) as logo),'The Right Choice','Ramadan Mubarak',1)
insert into Branch (Base_id,branch_name,branch_contact_name,branch_contact_no,branch_email_id,branch_address,branch_logo,branch_dialogue,branch_message,created_by) values (1,'PEC Sherpur','shahidul','123','shahidul@gmail.com','Dhaka',(select BulkColumn FROM Openrowset( Bulk 'F:\DotNetProjects\unicare\unicare\Images\Logo\pbeh.jpg', Single_Blob) as logo),'The Right Choice','Ramadan Mubarak',1)
insert into Branch (Base_id,branch_name,branch_contact_name,branch_contact_no,branch_email_id,branch_address,branch_logo,branch_dialogue,branch_message,created_by) values (1,'Mati, Hujurikanda','Lalin','123','mati@gmail.com','Dhaka',(select BulkColumn FROM Openrowset( Bulk 'F:\DotNetProjects\unicare\unicare\Images\Logo\Mati.png', Single_Blob) as logo),'The Right Choice','Ramadan Mubarak',1)
insert into Branch (Base_id,branch_name,branch_contact_name,branch_contact_no,branch_email_id,branch_address,branch_logo,branch_dialogue,branch_message,created_by) values (1,'Orbis International','CD','123','orbis@gmail.org','Dhaka',(select BulkColumn FROM Openrowset( Bulk 'F:\DotNetProjects\unicare\unicare\Images\Logo\OrbisLogo.png', Single_Blob) as logo),'The Right Choice','Ramadan Mubarak',1)

if object_id('procBranchListByID') is not null
drop proc procBranchListByID
go
create proc procBranchListByID
@BrnId int
as 
begin
	select branch_id, Base_id, branch_name, branch_contact_name, branch_contact_no, branch_email_id, branch_address, branch_dialogue, branch_message, ISNULL(branch_logo, convert(VARBINARY(max), (select user_image from temp_user where id = 1))) branch_logo from Branch where branch_id = @BrnId 
end
go
