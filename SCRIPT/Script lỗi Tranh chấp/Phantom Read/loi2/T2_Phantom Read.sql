USE [QLDatChuyenHangOnl]
GO

-- =============================================
-- T2: quản trị viên xóa đi 1 đơn hàng 
-- nhưng T1 đang tính phí trung bình cho 1 đơn hàng
-- =============================================
DECLARE @MaDhang int = 1

BEGIN TRAN
	-- Mã đơn hàng để trống hoặc không tồn tại
	IF @MaDhang IS NULL OR NOT EXISTS ( SELECT MADONHANG FROM DONHANG WHERE MADONHANG = @MaDhang )
	BEGIN
		ROLLBACK TRAN
		RETURN
	END

	-- Xóa đơn hàng
	DELETE DONHANG
	WHERE MADONHANG = @MaDhang
COMMIT TRAN
GO