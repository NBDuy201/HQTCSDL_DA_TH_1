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
		BEGIN TRY
			INSERT DOITAC (TENDOITAC, NGUOIDAIDIEN, SOCHINHANH, DIACHIKINHDOANH, THANHPHO, QUAN, SOLUONGDONHANGMOINGAY, LOAIHANGVANCHUYEN, SODIENTHOAI, EMAIL )
			VALUES (@TenDT, @NguoiDaiDien, @SoChiNhanh, @DiaChi, @ThanhPho, @Quan, @SoDH_moingay, @LoaiHang, @Sdt, @Email)
			SELECT @MaDT = SCOPE_IDENTITY()
		END TRY
		BEGIN CATCH
			ROLLBACK TRAN
			RETURN
		END CATCH

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
	COMMIT TRAN
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
		BEGIN TRY
			INSERT KHACHHANG (HOTEN, SODIENTHOAI, DIACHI, EMAIL)
			VALUES (@TenKH, @Sdt, @DiaChi, @Email)
			SELECT @MaKH = SCOPE_IDENTITY()
		END TRY
		BEGIN CATCH
			ROLLBACK TRAN
			RETURN
		END CATCH

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
	COMMIT TRAN
END
GO


-- =============================================
--- Thêm tài xế  mới
--- Input: Thông tin tài xế
--- Output: 
--- SQL: LOGIN + USER + ROLE
-- =============================================
CREATE OR ALTER PROC [dbo].[newlogin_TaiXe]
@TenTX varchar(255),
@Sdt varchar(20),
@DiaChi varchar(255),
@Email varchar(255),
@CMND varchar(10),
@BiensoXe varchar(10),
@KhuVucHoatDong varchar(255),
@SoTKNH varchar(20),
@ChiNhanhTKNN varchar(255)
AS
BEGIN
	BEGIN TRAN
		-- Sđt đã được sử dụng
		IF EXISTS (SELECT SODIENTHOAI FROM TAIXE WHERE SODIENTHOAI=@Sdt)
		BEGIN
			RAISERROR (N'Số điện thoại này đã được đăng ký.', -1, -1)
			ROLLBACK TRAN
			RETURN
		END

		DECLARE @MaTX int

		-- INSERT thông tin Đối tác
		BEGIN TRY
			INSERT TAIXE(HOTEN, SODIENTHOAI, DIACHI, EMAIL, CMND, BIENSOXE, KHUVUCHOATDONG, SOTAIKHOANNGANHANG, CHINHANHNGANHANG, TINHTRANGDONGPHITHUECHAN)
			VALUES (@TenTX, @Sdt, @DiaChi, @Email, @CMND, @BiensoXe, @KhuVucHoatDong, @SoTKNH, @ChiNhanhTKNN, N'Chưa đóng')
			SELECT @MaTX = SCOPE_IDENTITY()
		END TRY
		BEGIN CATCH
			ROLLBACK TRAN
			RETURN
		END CATCH


		-- Tạo login (username = KHG + Sdt)
		DECLARE @safe_username varchar(40)
		DECLARE @safe_password varchar(40)
		DECLARE @safe_db varchar(40)
		SET @safe_username = REPLACE('TXE'+@Sdt,'''','''''')
		SET @safe_password = REPLACE(@Sdt,'''','''''')
		SET @safe_db = REPLACE('QLDatChuyenHangOnl','''','''''')

		DECLARE @sql nvarchar(max)
		SET @sql = 'USE ' + @safe_db + ';' +
				   'CREATE LOGIN ' + @safe_username + ' WITH PASSWORD=''' + @safe_password + '''; ' +
				   'CREATE USER ' + @safe_username + ' FOR LOGIN ' + @safe_username + '; ' +
				   'ALTER ROLE [DriverROLE] ADD MEMBER ' + @safe_username + ';'
		EXEC (@sql)
	COMMIT TRAN
END
GO


--[Phân hệ tài xế]---------------------------------------------------

CREATE OR ALTER PROC [dbo].[XemDonHang](@MaTaiXe int)
AS
BEGIN
	BEGIN TRAN
		IF @MaTaiXe IS NULL OR NOT EXISTS ( SELECT MATAIXE FROM TAIXE )
		BEGIN
			RAISERROR (N'Mã tài xế không hợp lệ.', -1, -1)
			ROLLBACK TRAN
			RETURN 
		END

		DECLARE @KhuVuc varchar(255)
		SET @KhuVuc = ( SELECT KHUVUCHOATDONG FROM TAIXE WHERE MATAIXE=@MaTaiXe )
		IF @KhuVuc IS NULL
		BEGIN
			RAISERROR (N'Tài xế chưa cập nhật khu vực hoạt động.', -1, -1)
			ROLLBACK TRAN
			RETURN 
		END

		SELECT kh.HOTEN, dh.DIACHIGIAODEN, dh.HINHTHUCTHANHTOAN, dh.PHIVANCHUYEN, dh.TONGPHISANPHAM
		FROM DONHANG dh JOIN KHACHHANG kh ON dh.MAKHACHHANG = kh.MAKHACHHANG
		WHERE dh.TINHTRANGDONHANG = N'Chưa đồng ý' AND dh.DIACHIGIAODEN LIKE '%' + @KhuVuc
	COMMIT TRAN
END
GO




CREATE OR ALTER PROC [dbo].[ChonDonHang]( @MaTaiXe int, @MaDonHang bigint )
AS
BEGIN
	BEGIN TRAN
		IF @MaTaiXe IS NULL OR NOT EXISTS ( SELECT MATAIXE FROM TAIXE )
		BEGIN
			RAISERROR (N'Mã tài xế không hợp lệ.', -1, -1)
			ROLLBACK TRAN
			RETURN 
		END

		IF @MaDonHang IS NULL OR NOT EXISTS ( SELECT MADONHANG FROM DONHANG ) OR
		   N'Chưa đồng ý' <> ( SELECT MADONHANG FROM DONHANG WHERE MADONHANG=@MaDonHang )
		BEGIN
			RAISERROR (N'Mã đơn hàng không hợp lệ.', -1, -1)
			ROLLBACK TRAN
			RETURN 
		END

		BEGIN TRY
			UPDATE DONHANG
			SET MATAIXE=@MaTaiXe, TINHTRANGDONHANG=N'Đang giao'
			WHERE MADONHANG=@MaDonHang
		END TRY
		BEGIN CATCH
			ROLLBACK TRAN
			RETURN
		END CATCH
	COMMIT TRAN
END
GO




CREATE OR ALTER PROC [dbo].[TraCuuDonHangDaGiao] @MaTaiXe int
AS
BEGIN
	BEGIN TRAN
		IF @MaTaiXe IS NULL OR NOT EXISTS ( SELECT MATAIXE FROM TAIXE )
		BEGIN
			RAISERROR (N'Mã tài xế không hợp lệ.', -1, -1)
			ROLLBACK TRAN
			RETURN 
		END

		SELECT MADONHANG, PHIVANCHUYEN
		FROM DONHANG
		WHERE MATAIXE=@MaTaiXe

	COMMIT TRAN
END