USE [QLDatChuyenHangOnl]
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
	IF NOT EXISTS ( SELECT TINHTRANGDONHANG FROM DONHANG DH WHERE DH.MADONHANG = @MaDonHang AND DH.TINHTRANGDONHANG <> N'Chưa đồng ý')
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
GO

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