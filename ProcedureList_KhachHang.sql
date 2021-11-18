﻿
GO
USE [QLDatChuyenHangOnl]
GO

-- ================================================
-- Khách hàng
--- Xem và cập nhật thông tin chính mình (password của LOGIN)
--- Xem danh sách các đối tác
--- Xem sản phẩm của 1 đối tác
--- Thêm 1 đơn hàng
--- Xem thông tin 1 đơn hàng

-- ================================================
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
		SELECT SP.MASANPHAM, SP.TENSANPHAM, SP.GIASANPHAM
		FROM DOITAC DT, CHINHANH CN, CHINHANH_SANPHAM CN_SP, SANPHAM SP
		WHERE DT.MADOITAC = CN.MADOITAC AND
			  CN.MACHINHANH = CN_SP.MASANPHAM AND
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
	@HinhThucThanhToan numeric(8, 2)

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
	IF @SoLuong > ( SELECT CN_SP.SOLUONGTON
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

	-- Cập nhật lại số lượng tồn của chi nhánh
	UPDATE CHINHANH_SANPHAM 
	SET SOLUONGTON = SOLUONGTON - @SoLuong
	WHERE MACHINHANH = @MaChiNhanh AND
		  MASANPHAM = @MaSanPham
	
	COMMIT TRAN

END

GO

-- =============================================
--- Đồng ý đơn hàng:
--- Input: Mã Đơn hàng ở trạng thái chưa đồng ý
--- Output: Cập nhật tình trạng đơn hàng = đồng ý
-- =============================================
CREATE OR ALTER PROCEDURE DongY_DonHang
	@MaDonHang char(10)

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
	
	COMMIT TRAN
END

