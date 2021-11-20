USE [QLDatChuyenHangOnl]
GO

-- =============================================
--- Đồng ý đơn hàng:
--- Input: Mã Đơn hàng ở trạng thái chưa đồng ý
--- Output: Cập nhật tình trạng đơn hàng = đồng ý
-- =============================================
DECLARE @MaDonHang int = 5
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

	-- Gặp sự cố
	WAITFOR DELAY '00:00:05';
	ROLLBACK TRAN
	RETURN
	
COMMIT TRAN
GO

-- Mã đơn hàng 5 có tình trạng đơn hàng = 'Chưa đồng ý'
SELECT DH.MADONHANG, dh.MATAIXE, dh.TINHTRANGDONHANG
FROM DONHANG DH
WHERE DH.MADONHANG = 5
GO