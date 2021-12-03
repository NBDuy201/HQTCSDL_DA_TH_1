--==========================================================================================================================
--==========================================================================================================================
-- Nhân viên ===============================================================================================================
USE [QLDatChuyenHangOnl]
GO

-- =============================================
--- Xem hợp đồng đang pending
--- Input:
--- Output: Danh sách tất cả các hợp đồng đang chờ duyệt
-- =============================================
CREATE OR ALTER PROCEDURE View_PendingContract @MaDTac int
AS
BEGIN TRAN
	-- Mã đối tác để trống hoặc không tồn tại
	IF NOT EXISTS (SELECT* FROM DOITAC WHERE MADOITAC = @MaDTac) AND @MaDTac IS NOT NULL
	BEGIN
		RAISERROR (N'Thông tin nhập không hợp lệ hoặc bị để trống.', -1, -1)
		ROLLBACK TRAN
		RETURN
	END

	-- In ra tất cả các hợp đồng đang chờ duyệt của tất cả các đối tác
	IF (@MaDTac IS NULL)
	BEGIN
		SELECT *
		FROM HOPDONG h
		WHERE h.TINHTRANGPHIKICHHOAT != 1
	END
	-- Xem hợp đồng của đối tác
	ELSE
	BEGIN
		SELECT *
		FROM HOPDONG h
		WHERE 
			h.TINHTRANGPHIKICHHOAT != 1 AND
			h.MADOITAC = @MaDTac
	END
COMMIT TRAN
GO

--- =============================================
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

		Declare @T Table 
		(
			MAHOPDONG INT,
			MADOITAC INT,
			MASOTHUE NVARCHAR(10),
			NGUOIDAIDIEN NVARCHAR(255),
			SOCHINHANHDANGKI NUMERIC(18, 0),
			PHANTRAMHOAHONG FLOAT,
			THOIGIANHIEULUC INT,
			TINHTRANGPHIKICHHOAT bit
		)
		Insert @T Exec View_PendingContract NULL 
		-- Hợp đồng chưa được duyệt
		IF NOT EXISTS (Select * from @T WHERE MAHOPDONG = @MaHDong)
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

		Declare @T Table 
		(
			MAHOPDONG INT,
			MADOITAC INT,
			MASOTHUE NVARCHAR(10),
			NGUOIDAIDIEN NVARCHAR(255),
			SOCHINHANHDANGKI NUMERIC(18, 0),
			PHANTRAMHOAHONG FLOAT,
			THOIGIANHIEULUC INT,
			TINHTRANGPHIKICHHOAT bit
		)
		Insert @T Exec View_PendingContract NULL 
		-- Hợp đồng chưa được duyệt
		IF EXISTS (Select * from @T WHERE MAHOPDONG = @MaHDong)
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
--- Output: Cập nhật tình trạng đóng phí của chu kì		
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
--========================================================================================================================
--========================================================================================================================
-- Đối tác ===============================================================================================================
USE [QLDatChuyenHangOnl]
GO

-- =============================================
--- Xem hợp đồng của mình
--- Input:
--- Output: Các hợp đồng của mình
-- =============================================
CREATE OR ALTER PROCEDURE View_Contract(@MaDTac int)
AS
BEGIN TRAN
	-- Mã đối tác để trống hoặc không tồn tại
	IF (@MaDTac IS NULL OR NOT EXISTS (SELECT* FROM DOITAC WHERE MADOITAC = @MaDTac))
	BEGIN
		RAISERROR (N'Thông tin nhập không hợp lệ hoặc bị để trống.', -1, -1)
		ROLLBACK TRAN
		RETURN
	END

	-- Xem hợp đồng của đối tác
	SELECT *
	FROM HOPDONG h
	WHERE h.MADOITAC = @MaDTac
COMMIT TRAN
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
		-- Mã đối tác để trống hoặc không tồn tại
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

		-- Số chi nhánh đã đăng kí > số chi nhánh đối tác sỡ hữu
		DECLARE 
			@TongChiNhanh INT = (SELECT d.SOCHINHANH
								FROM doitac d
								WHERE d.MADOITAC = @MaDTac),
			@TongCNhanhDaDK INT = (SELECT SUM(SOCHINHANHDANGKI)
									FROM HOPDONG
									WHERE MADOITAC = @MaDTac)
		IF @TongChiNhanh < @TongCNhanhDaDK + @SoCNhanh
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
--- Tìm đơn hàng thuộc hợp đồng nào
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

-- =============================================
--- Xóa sản phẩm khỏi chi nhánh
--- Input: Mã đối tác, Mã chi nhánh, Mã sản phẩm
--- Output: Sản phẩm được xóa khỏi chi nhánh do đối tác quản lý
-- =============================================
CREATE OR ALTER PROCEDURE deleteSanPham_ChiNhanh
	@MaDTac  int,
	@MaCNhanh int,
	@MaSPham  int
AS
BEGIN
	BEGIN TRAN
		-- Thông tin nhập rỗng hoặc không tồn tại
		IF (@MaDTac IS NULL OR NOT EXISTS (SELECT* FROM DOITAC WHERE MADOITAC = @MaDTac)) OR
			(@MaCNhanh IS NULL OR NOT EXISTS (SELECT* FROM CHINHANH WHERE MACHINHANH = @MaCNhanh)) OR
			(@MaSPham IS NULL OR NOT EXISTS (SELECT* FROM SANPHAM WHERE MASANPHAM = @MaSPham))
		BEGIN
			RAISERROR (N'Thông tin nhập không hợp lệ hoặc bị để trống.', -1, -1)
			ROLLBACK TRAN
			RETURN
		END

		-- Chi nhánh không thuộc quyền quản lý của đối tác
		IF @MaDTac != (SELECT MADOITAC FROM CHINHANH WHERE MACHINHANH = @MaCNhanh)
		BEGIN
			RAISERROR (N'Chi nhánh không thuộc quyền quản lý của bạn.', -1, -1)
			ROLLBACK TRAN
			RETURN
		END

		-- Sản phẩm không có tại chi nhánh
		IF NOT EXISTS (SELECT* FROM CHINHANH_SANPHAM WHERE MASANPHAM = @MaSPham AND MACHINHANH = @MaCNhanh)
		BEGIN
			RAISERROR (N'Chi nhánh không có sản phẩm này.', -1, -1)
			ROLLBACK TRAN
			RETURN
		END

		-- Xóa sản phẩm
		DELETE FROM CHINHANH_SANPHAM 
		WHERE 
			MACHINHANH = @MaCNhanh AND
			MASANPHAM = @MaSPham
	COMMIT
END
GO

--========================================================================================================================
--========================================================================================================================
-- Khách hàng ============================================================================================================
--- Xem và cập nhật thông tin chính mình (password của LOGIN)
--- Xem danh sách các đối tác
--- Xem sản phẩm của 1 đối tác
--- Thêm 1 đơn hàng
--- Xem thông tin 1 đơn hàng
-- ================================================
USE [QLDatChuyenHangOnl]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
--- Xem danh sách các đối tác
--- Input:
--- Output: Danh sách mã và tên đối tác
-- =============================================
CREATE OR ALTER PROCEDURE View_DoiTac

AS
BEGIN
	BEGIN TRAN
		SELECT MADOITAC, TENDOITAC
		FROM DOITAC
	COMMIT TRAN
END

GO

-- =============================================
--- Xem sản phẩm của 1 đối tác
--- Input: Mã đối tác
--- Output: Danh sách mã, tên, giá sản phẩm của các chi nhánh của đối tác
-- =============================================
CREATE OR ALTER PROCEDURE View_DoiTac_SanPham (@MaDoiTac int)

AS
BEGIN
	BEGIN TRAN
		SELECT SP.MASANPHAM, SP.TENSANPHAM, SP.GIASANPHAM, CN.MACHINHANH
		FROM CHINHANH CN, CHINHANH_SANPHAM CN_SP, SANPHAM SP
		WHERE 
			CN.MADOITAC = @MaDoiTac and
			CN_SP.MACHINHANH = CN.MACHINHANH AND
			CN_SP.MASANPHAM = SP.MASANPHAM
	COMMIT TRAN
END

GO

-- =============================================
--- Xem thông tin 1 đơn hàng:
--- Input: Mã đơn hàng
--- Output: Thông tin của đơn và danh sách sản phẩm của đơn hàng
-- =============================================
CREATE OR ALTER PROCEDURE View_DonHang 
	@MaDonHang bigint
AS
BEGIN
	BEGIN TRAN
		-- Mã đơn hàng để trống hoặc không tồn tại
		IF @MaDonHang IS NULL OR NOT EXISTS ( SELECT MADONHANG FROM DONHANG )
		BEGIN
			RAISERROR (N'Mã đơn hàng không hợp lệ.', -1, -1)
			ROLLBACK TRAN
			RETURN
		END

		SELECT *
		FROM DONHANG DH, CHITIETDONHANG_SANPHAM DH_SP, SANPHAM SP
		WHERE DH.MADONHANG = @MaDonHang AND
			  DH.MADONHANG = DH_SP.MADONHANG AND
			  DH_SP.MASANPHAM = SP.MASANPHAM		  
			  
	COMMIT TRAN
END

GO

-- =============================================
--- Thêm 1 đơn hàng mới:
--- Input: Mã khách hàng, địa chỉ giao đến, hình thứ thanh toán
--- Output: Mã đơn hàng vừa thêm
-- =============================================
CREATE OR ALTER PROCEDURE Insert_DonHang
	@MaKhachHang int,
	@DiaChiGiaoDen varchar(255), 
	@HinhThucThanhToan nvarchar(255)

AS
BEGIN
	BEGIN TRAN
		-- Mã khách hàng để trống hoặc không tồn tại
		IF @MaKhachHang IS NULL OR NOT EXISTS ( SELECT MAKHACHHANG FROM KHACHHANG )
		BEGIN
			RAISERROR (N'Mã khách hàng không hợp lệ.', -1, -1)
			ROLLBACK TRAN
			RETURN 
		END

		-- Tạo mã đơn hàng mới (auto increase)
		DECLARE @MaDonHang int

		-- Thêm thông tin vào bảng 
		INSERT INTO DONHANG ( MAKHACHHANG, DIACHIGIAODEN, HINHTHUCTHANHTOAN, TINHTRANGDONHANG, TONGPHISANPHAM )
		VALUES (@MaKhachHang, @DiaChiGiaoDen, @HinhThucThanhToan, N'Chưa đồng ý', 0 )

		SELECT @MaDonHang = SCOPE_IDENTITY()
		-- Trả về mã đơn hàng
		-- RETURN @MaDonHang 
	COMMIT TRAN
END

GO

-- =============================================
--- Thêm 1 sản phẩm vào đơn hàng:
--- Input: Mã Đơn hàng, Mã sản phẩm, Số lượng 
--- Output: 
-- =============================================
CREATE OR ALTER PROCEDURE Insert_ChiTietDonHang
	@MaDonHang bigint, 
	@MaSanPham int, 
	@MaChiNhanh int,
	@SoLuong numeric

AS
BEGIN
	BEGIN TRAN
	-- Mã đơn hàng để trống hoặc không tồn tại
	IF @MaDonHang IS NULL OR NOT EXISTS ( SELECT MADONHANG FROM DONHANG DH WHERE DH.MADONHANG = @MaDonHang)
		BEGIN
			RAISERROR (N'Mã đơn hàng không hợp lệ.', -1, -1)
			ROLLBACK TRAN
			RETURN
		END

	-- Mã sản phẩm để trống hoặc không tồn tại
	IF @MaSanPham IS NULL OR NOT EXISTS ( SELECT MASANPHAM FROM SANPHAM SP WHERE SP.MASANPHAM = @MaSanPham )
		BEGIN
			RAISERROR (N'Mã sản phẩm không hợp lệ.', -1, -1)
			ROLLBACK TRAN
			RETURN
		END

	-- Mã chi nhánh để trống hoặc không tồn tại
	IF @MaChiNhanh IS NULL OR NOT EXISTS ( SELECT MACHINHANH FROM CHINHANH CN WHERE CN.MACHINHANH = @MaChiNhanh)
		BEGIN
			RAISERROR (N'Mã chi nhánh không hợp lệ.', -1, -1)
			ROLLBACK TRAN
			RETURN
		END

	-- Đơn hàng đã được khách hàng đồng ý trước đó
	IF EXISTS ( SELECT TINHTRANGDONHANG FROM DONHANG DH WHERE DH.MADONHANG = @MaDonHang AND DH.TINHTRANGDONHANG <> N'Chưa đồng ý')
		BEGIN
			RAISERROR (N'Không thể thêm sản phẩm vào đơn hàng đã đi giao.', -1, -1)
			ROLLBACK TRAN
			RETURN
		END

	-- Số lượng thêm ít hơn số lượng tồn của chi nhánh đang chọn
	IF @SoLuong > ( SELECT SUM(CN_SP.SOLUONGTON)
					FROM SANPHAM SP, CHINHANH_SANPHAM CN_SP 
					WHERE CN_SP.MACHINHANH = @MaChiNhanh AND
						  CN_SP.MASANPHAM = SP.MASANPHAM )
		BEGIN
			RAISERROR (N'Số lượng đang đặt vượt quá số lượng tồn của chi nhánh.', -1, -1)
			ROLLBACK TRAN
			RETURN
		END

	-- Tính phí sản phẩm tương ứng
	DECLARE @PhiSanPham numeric(8, 2)
	SET @PhiSanPham = @SoLuong * ( SELECT GIASANPHAM
								   FROM SANPHAM
								   WHERE MASANPHAM = @MaSanPham )

	IF @PhiSanPham is null
	BEGIN
		RAISERROR (N'Phí sản phẩm không hợp lệ', -1, -1)
		ROLLBACK TRAN
		RETURN
	END

	-- Nếu sản phẩm đã có trong chi tiết đơn hàng thì chỉ cập nhật lại số lượng tương ứng
	IF EXISTS ( SELECT * 
				FROM CHITIETDONHANG_SANPHAM
				WHERE MASANPHAM = @MaSanPham AND
					  MADONHANG = @MaDonHang )
	BEGIN
		UPDATE CHITIETDONHANG_SANPHAM
		SET SOLUONGTUONGUNG = @SoLuong
		WHERE MASANPHAM = @MaSanPham AND
				MADONHANG = @MaDonHang
		COMMIT TRAN
	END
	ELSE
	BEGIN
		--  Thêm thông tin vào bảng
		BEGIN TRY
			INSERT INTO CHITIETDONHANG_SANPHAM ( MADONHANG, MASANPHAM, SOLUONGTUONGUNG, PHISANPHAM )
			VALUES ( @MaDonHang, @MaSanPham, @SoLuong, @PhiSanPham )
		END TRY
		BEGIN CATCH
			RAISERROR (N'Đã xảy ra lỗi khi thêm sản phẩm vào đơn hàng', -1, -1)
			ROLLBACK TRAN
			RETURN
		END CATCH
		COMMIT TRAN
	END
END

GO

-- =============================================
--- Đồng ý đơn hàng:
--- Input: Mã Đơn hàng ở trạng thái chưa đồng ý
--- Output: Cập nhật tình trạng đơn hàng = đồng ý
-- =============================================
CREATE OR ALTER PROCEDURE DongY_DonHang
	@MaDonHang bigint 

AS
BEGIN
	BEGIN TRAN
	-- Đơn hàng không ở tình trạng chưa đồng ý
	IF EXISTS ( SELECT TINHTRANGDONHANG FROM DONHANG DH WHERE DH.MADONHANG = @MaDonHang AND DH.TINHTRANGDONHANG <> N'Chưa đồng ý')
		BEGIN
			RAISERROR (N'Đơn này đã được đồng ý rồi.', -1, -1)
			ROLLBACK TRAN
			RETURN
		END

	-- Đơn hàng chưa có sản phẩm nào
	IF NOT EXISTS ( SELECT CT.MADONHANG
					FROM DONHANG DH, CHITIETDONHANG_SANPHAM CT 
					WHERE CT.MADONHANG = DH.MADONHANG )
		BEGIN
			RAISERROR (N'Đơn hàng chưa có sản phẩm nào.', -1, -1)
			ROLLBACK TRAN
			RETURN
		END

	-- Cập nhật tình trạng đơn hàng
	UPDATE DONHANG 
	SET TINHTRANGDONHANG = N'Đồng ý'
	WHERE MADONHANG = @MaDonHang
	-- Cập nhật lại số lượng tồn các sản phẩm của chi nhánh

	UPDATE CHINHANH_SANPHAM
	SET SOLUONGTON = SOLUONGTON - DH_SP.SOLUONGTUONGUNG

	FROM CHINHANH_SANPHAM CN_SP
	INNER JOIN CHITIETDONHANG_SANPHAM DH_SP
	ON CN_SP.MASANPHAM = DH_SP.MASANPHAM AND
		DH_SP.MADONHANG = @MaDonHang

	IF EXISTS ( SELECT SOLUONGTON
				FROM CHINHANH_SANPHAM
				WHERE SOLUONGTON < 0 )

	BEGIN
		RAISERROR (N'Số lượng đang đặt vượt quá số lượng tồn của chi nhánh.', -1, -1)
		ROLLBACK TRAN
		RETURN
	END
	
	COMMIT TRAN
END
GO
--========================================================================================================================
--========================================================================================================================
-- Tài xế ================================================================================================================
USE [QLDatChuyenHangOnl]
GO

-- =============================================
--- Xem danh sách đơn hàng có thể giao:
--- Input: Mã tài xế
--- Output: Thông tin của đơn hàng trong khu vực hoạt động và có tình trạng = 'Đồng ý'
-- =============================================
CREATE OR ALTER PROC [dbo].[XemDonHang](@MaTaiXe int)
AS
BEGIN
	BEGIN TRAN
		IF @MaTaiXe IS NULL OR NOT EXISTS ( SELECT MATAIXE FROM TAIXE WHERE MATAIXE = @MaTaiXe )
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
		WHERE dh.TINHTRANGDONHANG = N'Đồng ý' AND dh.DIACHIGIAODEN LIKE '%' + @KhuVuc
	COMMIT TRAN
END
GO

-- =============================================
--- Xác nhận giao 1 đơn hàng
--- Input: Mã tài xế, Mã đơn hàng
--- Output: Cập nhật tình trạng đơn hàng = 'Đang giao'
-- =============================================
CREATE OR ALTER PROC [dbo].[ChonDonHang]( @MaTaiXe int, @MaDonHang bigint )
AS
BEGIN
	BEGIN TRAN
		IF @MaTaiXe IS NULL OR NOT EXISTS ( SELECT MATAIXE FROM TAIXE WHERE MATAIXE = @MaTaiXe )
		BEGIN
			RAISERROR (N'Mã tài xế không hợp lệ.', -1, -1)
			ROLLBACK TRAN
			RETURN 
		END

		IF @MaDonHang IS NULL OR NOT EXISTS ( SELECT MADONHANG FROM DONHANG WHERE MADONHANG = @MaDonHang AND TINHTRANGDONHANG = N'Đồng ý' )
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

-- =============================================
--- Xem danh sách đơn hàng đã giao:
--- Input: Mã tài xế
--- Output: Thông tin của đơn hàng đã giao của Mã tài xế
-- =============================================
CREATE OR ALTER PROC [dbo].[TraCuuDonHangDaGiao] @MaTaiXe int
AS
BEGIN
	BEGIN TRAN
		IF @MaTaiXe IS NULL OR NOT EXISTS ( SELECT MATAIXE FROM TAIXE WHERE MATAIXE = @MaTaiXe )
		BEGIN
			RAISERROR (N'Mã tài xế không hợp lệ.', -1, -1)
			ROLLBACK TRAN
			RETURN 
		END

		SELECT MADONHANG, NGAYLAP, PHIVANCHUYEN
		FROM DONHANG
		WHERE MATAIXE=@MaTaiXe AND TINHTRANGDONHANG=N'Đã nhận'

	COMMIT TRAN
END
GO
--========================================================================================================================
--========================================================================================================================
-- Quản trị ==============================================================================================================
USE [QLDatChuyenHangOnl]
GO 

-- =============================================
--- Thêm đối tác mới
--- Input: Thông tin đối tác
--- Output: 
---     + Thêm thông tin đối tác vào bảng DOITAC
---		+ Tạo login, user; add ROLE 
-- =============================================
CREATE OR ALTER PROC [dbo].[newlogin_DoiTac]
@TenDT nvarchar(255),
@NguoiDaiDien nvarchar(255),
@DiaChi nvarchar(255),
@ThanhPho nvarchar(255),
@Quan nvarchar(255),
@SoChiNhanh numeric,
@SoDH_moingay numeric,
@LoaiHang nvarchar(255),
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
--- Thêm khách hàng mới
--- Input: Thông tin khách hàng
--- Output: 
---     + Thêm thông tin đối tác vào bảng KHACHHANG
---		+ Tạo login, user; add ROLE 
-- =============================================
CREATE OR ALTER PROC [dbo].[newlogin_KhachHang]
@TenKH nvarchar(255),
@Sdt varchar(20),
@DiaChi nvarchar(255),
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
--- Thêm tài xế mới
--- Input: Thông tin tài xế
--- Output: 
---     + Thêm thông tin đối tác vào bảng TAIXE
---		+ Tạo login, user; add ROLE 
-- =============================================
CREATE OR ALTER PROC [dbo].[newlogin_TaiXe]
@TenTX nvarchar(255),
@Sdt varchar(20),
@DiaChi nvarchar(255),
@Email varchar(255),
@CMND varchar(10),
@BiensoXe varchar(10),
@KhuVucHoatDong nvarchar(255),
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

-- =============================================
--- Kích hoạt tài khoản đã bị khóa
--- Input: username (tên đăng nhập của tài khoản)
--- Output: GRANT CONNECT cho username
-- =============================================
CREATE OR ALTER PROC [dbo].[grantAccount] @username varchar(max)
AS
BEGIN
BEGIN TRAN
	DECLARE @sql nvarchar(max)
	SET @sql = 'USE [QLDatChuyenHangOnl];' +
			   'GRANT CONNECT TO ' + @username + ';'
	EXEC(@sql)
COMMIT
END
GO

-- =============================================
--- Khóa tài khoản
--- Input: username (tên đăng nhập của tài khoản)
--- Output: DENY CONNECT cho username
-- =============================================
CREATE OR ALTER PROC [dbo].[denyAccount] @username varchar(max)
AS
BEGIN
BEGIN TRAN
	DECLARE @sql nvarchar(max)
	SET @sql = 'USE [QLDatChuyenHangOnl];' +
			   'DENY CONNECT TO ' + @username + ';'
	EXEC(@sql)
COMMIT
END
GO