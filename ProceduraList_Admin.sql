USE [QLDatChuyenHangOnl]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--[Phân hệ quản trị]---------------------------------------------------

-- =============================================
--- Thêm đối tác mới
--- Input: Thông tin đối tác
--- Output: 
--- SQL: LOGIN + USER + ROLE
-- =============================================
CREATE OR ALTER PROC [dbo].[newlogin_DoiTac]
@TenDT varchar(255),
@NguoiDaiDien varchar(255),
@DiaChi varchar(255),
@ThanhPho varchar(255),
@Quan varchar(255),
@SoChiNhanh numeric,
@SoDH_moingay numeric,
@LoaiHang varchar(255),
@Sdt varchar(20),
@Email varchar(255)
AS
BEGIN
	BEGIN TRAN
		-- Sđt đã được sử dụng
		IF EXISTS (SELECT SODIENTHOAI FROM DOITAC WHERE SODIENTHOAI=@Sdt)
		BEGIN
			RAISERROR (N'Số điện thoại này đã được đăng ký.', -1, -1)
			ROLLBACK TRAN
			RETURN
		END

		DECLARE @MaDT int

		-- INSERT thông tin Đối tác
		INSERT DOITAC
		VALUES (@TenDT, @NguoiDaiDien, @SoChiNhanh, @DiaChi, @ThanhPho, @Quan, @SoDH_moingay, @LoaiHang, @Sdt, @Email)
		SELECT @MaDT = SCOPE_IDENTITY()

		-- Tạo login (username = DTA + Sdt)
		DECLARE @safe_username varchar(40)
		DECLARE @safe_password varchar(40)
		DECLARE @safe_db varchar(40)
		SET @safe_username = REPLACE('DTA'+@Sdt,'''','''''')
		SET @safe_password = REPLACE(@Sdt,'''','''''')
		SET @safe_db = REPLACE('QLDatChuyenHangOnl','''','''''')

		DECLARE @sql nvarchar(max)
		SET @sql = 'USE ' + @safe_db + ';' +
				   'CREATE LOGIN ' + @safe_username + ' WITH PASSWORD=''' + @safe_password + '''; ' +
				   'CREATE USER ' + @safe_username + ' FOR LOGIN ' + @safe_username + '; ' +
				   'ALTER ROLE [ParnerROLE] ADD MEMBER ' + @safe_username + ';'
		EXEC (@sql)
	COMMIT
END
GO

-- =============================================
--- Thêm khác hàng  mới
--- Input: Thông tin khách hàng
--- Output: 
--- SQL: LOGIN + USER + ROLE
-- =============================================
CREATE OR ALTER PROC [dbo].[newlogin_KhachHang]
@TenKH varchar(255),
@Sdt varchar(20),
@DiaChi varchar(255),
@Email varchar(255)
AS
BEGIN
	BEGIN TRAN
		-- Sđt đã được sử dụng
		IF EXISTS (SELECT SODIENTHOAI FROM KHACHHANG WHERE SODIENTHOAI=@Sdt)
		BEGIN
			RAISERROR (N'Số điện thoại này đã được đăng ký.', -1, -1)
			ROLLBACK TRAN
			RETURN
		END

		DECLARE @MaKH int

		-- INSERT thông tin Đối tác
		INSERT KHACHHANG
		VALUES (@TenKH, @Sdt, @DiaChi, @Email)
		SELECT @MaKH = SCOPE_IDENTITY()

		-- Tạo login (username = KHG + Sdt)
		DECLARE @safe_username varchar(40)
		DECLARE @safe_password varchar(40)
		DECLARE @safe_db varchar(40)
		SET @safe_username = REPLACE('KHG'+@Sdt,'''','''''')
		SET @safe_password = REPLACE(@Sdt,'''','''''')
		SET @safe_db = REPLACE('QLDatChuyenHangOnl','''','''''')

		DECLARE @sql nvarchar(max)
		SET @sql = 'USE ' + @safe_db + ';' +
				   'CREATE LOGIN ' + @safe_username + ' WITH PASSWORD=''' + @safe_password + '''; ' +
				   'CREATE USER ' + @safe_username + ' FOR LOGIN ' + @safe_username + '; ' +
				   'ALTER ROLE [CustomerROLE] ADD MEMBER ' + @safe_username + ';'
		EXEC (@sql)
	COMMIT
END
GO


