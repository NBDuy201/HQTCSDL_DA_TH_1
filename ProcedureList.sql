-- Nhân viên ===================================================
USE [QLDatChuyenHangOnl]
GO

-- =============================================
--- Xem hợp đồng đang pending
--- Input:
--- Output: Danh sách tất cả các hợp đồng đang chờ duyệt
-- =============================================
CREATE OR ALTER FUNCTION SelectPendingContract()
RETURNS TABLE
AS
RETURN
(
   SELECT *
	FROM HOPDONG h
	WHERE h.TINHTRANGPHIKICHHOAT != 1
);
GO

-- =============================================
--- Duyệt hợp đồng
--- Input: Mã hợp đồng
--- Output: 
--		+ Duyệt hợp đồng
--		+ Thêm các chi nhánh của hợp đồng vào bảng CHINHANH với địa chỉ NULL
--		+ Thêm các chu kì phải đóng phí vào bảng THEODOIHOPDONG
-- =============================================
CREATE OR ALTER PROCEDURE Approve_Contract @MaHDong int
AS
BEGIN
	BEGIN TRAN
		-- Mã hợp đồng để trống hoặc không tồn tại
		IF @MaHDong IS NULL OR NOT EXISTS (SELECT h.MAHOPDONG FROM HOPDONG h WHERE h.MAHOPDONG = @MaHDong)
		BEGIN
			RAISERROR (N'Mã hợp động không hợp lệ.', -1, -1)
			ROLLBACK TRAN
			RETURN
		END

		-- Hợp đồng đã được duyệt
		IF NOT EXISTS (SELECT * FROM SelectPendingContract() WHERE MAHOPDONG = @MaHDong)
		BEGIN
			RAISERROR (N'Hợp đồng đã được duyệt từ trước.', -1, -1)
			ROLLBACK TRAN
			RETURN
		END

		-- Duyệt hợp đồng
		UPDATE HOPDONG
		SET TINHTRANGPHIKICHHOAT = 1
		WHERE MAHOPDONG = @MaHDong

		-- Thêm các chi nhánh thuộc hợp đồng
		DECLARE	@count int = 0,
				@SoCNhanh int = (SELECT h.SOCHINHANHDANGKI FROM HOPDONG h WHERE h.MAHOPDONG = @MaHDong),
				@MaDTac INT = (SELECT h.MADOITAC FROM HOPDONG h WHERE h.MAHOPDONG = @MaHDong)
		WHILE (@count < @SoCNhanh)
		BEGIN
			INSERT INTO CHINHANH (MADOITAC, MAHOPDONG, DIACHICHINHANH)
			VALUES (@MaDTac, @MaHDong, NULL)

			SET @count = @count + 1 -- Tăng số lần lặp
		END

		-- Thêm chu kì theo đóng phí vào bảng THEODOIHOPDONG
		DECLARE	@batdau DATE = GETDATE(),
				@ketthuc DATE = DATEADD(MONTH, (SELECT h.THOIGIANHIEULUC FROM HOPDONG h WHERE h.MAHOPDONG = @MaHDong), GETDATE())
		WHILE (@batdau < @ketthuc)
		BEGIN
			INSERT INTO THEODOIHOPDONG (MAHOPDONG, THOIGIANBATDAUCHUKI, THOIGIANKETTHUCCHUKI, TINHTRANGNOPPHI)
			VALUES (@MaHDong, @batdau, DATEADD(MONTH, 1, @batdau), 0)

			SET @batdau = DATEADD(MONTH, 1, @batdau) -- Ngày bắt đầu + 1 tháng
		END
	COMMIT
END
GO

-- =============================================
--- Gia hạn hợp đồng
--- Input: Mã hợp đồng, phần trăm hoa hồng, thời gian hiệu lực của hợp đồng
--- Output: Cập nhật thời gian hiệu lực và phần trăm hoa hồng của hợp đồng
-- =============================================
CREATE OR ALTER PROCEDURE Extend_Contract 
	@MaHDong int,
	@PHANTRAMHOAHONG FLOAT,
	@TgHieuLuc int
AS
BEGIN
	BEGIN TRAN
		-- Mã hợp đồng để trống hoặc không tồn tại
		IF (@MaHDong IS NULL OR NOT EXISTS (SELECT* FROM HOPDONG h WHERE h.MAHOPDONG = @MaHDong)) OR
			(@PHANTRAMHOAHONG IS NULL) OR
			(@TgHieuLuc IS NULL) OR (@PHANTRAMHOAHONG < 0) OR (@TgHieuLuc < 0)
		BEGIN
			RAISERROR (N'Thông tin nhập không hợp lệ hoặc bị để trống.', -1, -1)
			ROLLBACK TRAN
			RETURN
		END

		-- Hợp đồng chưa được duyệt
		IF EXISTS (SELECT * FROM SelectPendingContract() WHERE MAHOPDONG = @MaHDong)
		BEGIN
			RAISERROR (N'Mã hợp động chưa được duyệt.', -1, -1)
			ROLLBACK TRAN
			RETURN
		END

		-- Hợp đồng vẫn còn hiệu lực
		ELSE IF (GETDATE() < (SELECT MAX(t.THOIGIANKETTHUCCHUKI) FROM THEODOIHOPDONG t WHERE t.MAHOPDONG = @MaHDong))
		BEGIN  
			RAISERROR (N'Hợp đồng vẫn còn hiệu lực.', -1, -1)
			ROLLBACK TRAN
			RETURN
        END

		-- Cập nhật % hoa hồng, thời gian hiệu lực
		UPDATE HOPDONG
		SET PHANTRAMHOAHONG = @PHANTRAMHOAHONG, 
			THOIGIANHIEULUC = @TgHieuLuc,
			TINHTRANGPHIKICHHOAT = 0 -- Phi kích hoạt sẽ chưa được đóng
		WHERE MAHOPDONG = @MaHDong
	COMMIT
END
GO

-- =============================================
--- Cập nhật phí thanh toán theo tháng
--- Input: Mã hợp đồng, ngày bắt của chu kì
--- Output: Cập nhật thời gian tình trạng đóng phí
-- =============================================
CREATE OR ALTER PROCEDURE Approve_MonthlyFee 
	@MaHDong int,
	@NgayBatDau date
AS
BEGIN
	BEGIN TRAN
		-- Mã hợp đồng để trống hoặc không tồn tại
		IF (@MaHDong IS NULL OR NOT EXISTS (SELECT* FROM HOPDONG h WHERE h.MAHOPDONG = @MaHDong)) OR 
			(@NgayBatDau IS NULL)
		BEGIN
			RAISERROR (N'Thông tin nhập không hợp lệ hoặc bị để trống.', -1, -1)
			ROLLBACK TRAN
			RETURN
		END

		-- Hợp đồng không có chu kì này
		IF NOT EXISTS (SELECT *
						FROM THEODOIHOPDONG t 
						WHERE t.MAHOPDONG = @MaHDong AND
								t.THOIGIANBATDAUCHUKI = @NgayBatDau)
		BEGIN
			RAISERROR (N'Mã hợp đồng hoặc Ngày bắt đầu tồn tại.', -1, -1)
			ROLLBACK TRAN
			RETURN
		END

		-- Cập nhật phí tháng
		UPDATE THEODOIHOPDONG
		SET TINHTRANGNOPPHI = 1
		WHERE MAHOPDONG = @MaHDong AND THOIGIANBATDAUCHUKI = @NgayBatDau
	COMMIT
END
GO

-- Đối tác ===================================================
USE [QLDatChuyenHangOnl]
GO

-- =============================================
--- Xem hợp đồng của mình
--- Input:
--- Output: Các hợp đồng của mình
-- =============================================
CREATE OR ALTER FUNCTION SelectContract(@MaDTac int)
RETURNS TABLE
AS
RETURN
(
   SELECT *
	FROM HOPDONG h
	WHERE h.MADOITAC = @MaDTac
);
GO

-- =============================================
--- Thêm hợp đồng
--- Input: Mã đối tác, mã số thuế, người đại diện, số chi nhánh, phần trăm hoa hồng, thời gian hiệu lực của hợp đồng
--- Output: Hợp đồng mới được tạo ra và chờ duyệt
-- =============================================
CREATE OR ALTER PROCEDURE insertContract
	@MaDTac  int,
	@MaSThue varchar(10),
	@NDDien  nvarchar(255),
	@SoCNhanh int,
	@PTHoaHong float,
	@TGHieuLuc int
AS
BEGIN
	BEGIN TRAN
		-- Mã hợp đồng để trống hoặc không tồn tại
		IF (@MaDTac IS NULL OR NOT EXISTS (SELECT* FROM DOITAC WHERE MADOITAC = @MaDTac)) OR
			(@MaSThue IS NULL) OR
			(@NDDien IS NULL) OR 
			(@SoCNhanh IS NULL) OR (@SoCNhanh < 0) OR 
			(@TgHieuLuc IS NULL) OR (@TgHieuLuc < 0) OR
			(@PTHoaHong IS NULL) OR (@PTHoaHong < 0)
		BEGIN
			RAISERROR (N'Thông tin nhập không hợp lệ hoặc bị để trống.', -1, -1)
			ROLLBACK TRAN
			RETURN
		END

		-- Số chi nhánh đăng kí < số chi nhánh của đối tác
		DECLARE 
			@TongChiNhanh INT = (SELECT d.SOCHINHANH
								FROM chinhanh c JOIN doitac d
								ON c.MADOITAC  = d.MADOITAC
								WHERE d.MADOITAC = @MaDTac),
			@TongCNhanhDaDK INT = (SELECT SUM(SOCHINHANHDANGKI)
									FROM HOPDONG
									WHERE MADOITAC = @MaDTac)
		IF @TongChiNhanh > @TongCNhanhDaDK + @SoCNhanh
		BEGIN
        	RAISERROR (N'Số chi nhánh đăng kí vượt quá tổng số chi nhánh của bạn.', -1, -1)
			ROLLBACK TRAN
			RETURN
        END

		-- Insert Hợp đồng mới
		INSERT INTO HOPDONG (MADOITAC, MASOTHUE, NGUOIDAIDIEN, SOCHINHANHDANGKI, PHANTRAMHOAHONG, THOIGIANHIEULUC, TINHTRANGPHIKICHHOAT)
		VALUES (@MaDTac, @MaSThue, @NDDien, @SoCNhanh, @PTHoaHong, @TgHieuLuc, 0)
	COMMIT
END
GO

-- =============================================
--- Update tình trạng đơn hàng của chi nhánh mà đối tác sỡ hữu
--- Input: Mã đơn hàng
--- Output: Mã hợp đồng
-- =============================================
CREATE OR ALTER FUNCTION DHang_FindContract(@MaDHang int)
RETURNS TABLE
AS
RETURN
(
   SELECT c.MAHOPDONG
	FROM DONHANG d join CHINHANH c
	ON d.MACHINHANH = c.MACHINHANH
	WHERE d.MADONHANG = @MaDHang
);
GO

-- =============================================
--- Update tình trạng đơn hàng của chi nhánh mà đối tác sỡ hữu
--- Input: Mã đối tác, mã đơn hàng, tình trạng đơn hàng
--- Output: Tình trạng đơn hàng được cập nhật
-- =============================================
CREATE OR ALTER PROCEDURE updateTinhTrangDonHang
	@MaDTac  int,
	@MaDonHang bigint,
	@TinhTrangDHang  nvarchar(255)
AS
BEGIN
	BEGIN TRAN
		-- Thông tin nhập rỗng hoặc không tồn tại
		IF (@MaDTac IS NULL OR NOT EXISTS (SELECT* FROM DOITAC WHERE MADOITAC = @MaDTac)) OR
			(@MaDonHang IS NULL OR NOT EXISTS (SELECT* FROM DONHANG WHERE MADONHANG = @MaDonHang))
		BEGIN
			RAISERROR (N'Mã đối tác hoặc mã đơn hàng không hợp lệ hoặc bị để trống.', -1, -1)
			ROLLBACK TRAN
			RETURN
		END

		-- Từ khóa của "tình trạng đơn hàng" ko hợp lệ
		PRINT @TinhTrangDHang
		--IF (@TinhTrangDHang IS NULL) OR (@TinhTrangDHang != N'Đang giao') OR (@TinhTrangDHang <> N'Đã nhận')
		IF @TinhTrangDHang IS NULL OR @TinhTrangDHang NOT IN(N'Đã nhận', N'Đang giao')
		BEGIN
			RAISERROR (N'Từ khóa của "tình trạng đơn hàng" ko hợp lệ.', -1, -1)
			ROLLBACK TRAN
			RETURN
		END

		-- Update đơn hàng ko nằm trong chi nhánh mà mình quản lý
		IF @MaDTac != (SELECT c.MADOITAC 
						FROM CHINHANH c JOIN DONHANG d
						ON c.MACHINHANH = d.MACHINHANH
						WHERE d.MADONHANG = @MaDonHang)
		BEGIN
			RAISERROR (N'Đơn hàng không nằm trong chi nhánh bạn quản lý.', -1, -1)
			ROLLBACK TRAN
			RETURN
		END

		-- Cập nhật tình trạng đơn hàng
		UPDATE DONHANG
		SET TINHTRANGDONHANG = @TinhTrangDHang
		WHERE @MaDonHang = MADONHANG

		-- Cập nhật doanh thu tháng
		IF @TinhTrangDHang = N'Đã nhận'
		BEGIN
			Declare 
				@Tong NUMERIC(8,2) = (SELECT TONGPHISANPHAM FROM DONHANG WHERE MADONHANG = @MaDonHang),
				@PhiVChuyen NUMERIC(8,2) = (SELECT PHIVANCHUYEN FROM DONHANG WHERE MADONHANG = @MaDonHang),
				@MaHDong int = (Select * from DHang_FindContract(@MaDonHang)),
				@NgayLap date = (SELECT NGAYLAP FROM DONHANG WHERE MADONHANG = @MaDonHang),
				@DoanhSoThang NUMERIC(8,2)
			SET @DoanhSoThang = @Tong - @PhiVChuyen

            UPDATE THEODOIHOPDONG
			SET DOANHSOCUATHANG = @DoanhSoThang
			WHERE 
				FORMAT(THOIGIANBATDAUCHUKI, 'yyyy-MM' ) = FORMAT(@NgayLap, 'yyyy-MM' ) AND
				MAHOPDONG = @MaHDong
        END
	COMMIT
END
GO

-- =============================================
--- Update địa chỉ các chi nhánh
--- Input: Mã đối tác, Mã chi nhánh
--- Output: update địa chỉ chi nhánh
-- =============================================
CREATE OR ALTER PROCEDURE updateDiaChi
	@MaDTac  int,
	@MaCNhanh int,
	@DiaChi  nvarchar(255)
AS
BEGIN
	BEGIN TRAN
		-- Thông tin nhập rỗng hoặc không tồn tại
		IF (@MaDTac IS NULL OR NOT EXISTS (SELECT* FROM DOITAC WHERE MADOITAC = @MaDTac)) OR
			(@MaCNhanh IS NULL OR NOT EXISTS (SELECT* FROM CHINHANH WHERE MACHINHANH = @MaCNhanh))
		BEGIN
			RAISERROR (N'Mã đối tác hoặc mã chi nhánh không hợp lệ hoặc bị để trống.', -1, -1)
			ROLLBACK TRAN
			RETURN
		END

		-- Update địa chỉ của chi nhánh mà mình không quản lý
		IF @MaDTac != (SELECT MADOITAC FROM CHINHANH WHERE MACHINHANH = @MaCNhanh)
		BEGIN
			RAISERROR (N'Chi nhánh không thuộc quyền quản lý của bạn.', -1, -1)
			ROLLBACK TRAN
			RETURN
		END

		UPDATE CHINHANH
		SET DIACHICHINHANH = @DiaChi
		WHERE MACHINHANH = @MaCNhanh AND
			MADOITAC = @MaDTac
	COMMIT
END
GO