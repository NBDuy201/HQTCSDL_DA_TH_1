USE [QLDatChuyenHangOnl]
GO

-- =============================================
-- T2: quản trị viên xóa đi 1 đơn hàng
-- Sửa lỗi: Không đổi
-- =============================================
DECLARE @MaDhang int = 1

BEGIN TRAN SET TRAN ISOLATION LEVEL READ Uncommitted
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