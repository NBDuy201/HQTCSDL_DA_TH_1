
GO
USE [QLDatChuyenHangOnl]
GO

-- =============================================
-- T2: giống hệt DongY_DonHang 
-- nhưng thay đổi thứ tự cập nhật của bảng HOADON và CHINHANH_SANPHAM
-- Cụ thể: 1.CHINHANH_SANPHAM --> 2.DONHANG
-- =============================================
DECLARE
	@MaDonHang bigint = 1

BEGIN TRAN SET TRAN ISOLATION LEVEL SERIALIZABLE
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

	-- Cập nhật tình trạng đơn hàng
	UPDATE DONHANG 
	SET TINHTRANGDONHANG = N'Đồng ý'
	WHERE MADONHANG = @MaDonHang

COMMIT TRAN
RETURN

GO