USE [QLDatChuyenHangOnl]
GO


DECLARE
	@MaTXE int = 3,
	@MaDonHang INT = 3
-- =============================================
-- T1_FIX
-- T1: không đổi
-- =============================================
BEGIN TRAN SET TRAN ISOLATION LEVEL READ UNCOMMITTED	
	-- Mã đơn hàng để trống hoặc không tồn tại
	IF @MaDonHang IS NULL OR NOT EXISTS ( SELECT MADONHANG FROM DONHANG WHERE MADONHANG = @MaDonHang )
	BEGIN
		ROLLBACK TRAN
		RETURN
	END
	WAITFOR DELAY '00:00:05'

	-- Xóa đơn hàng
	DELETE DONHANG
	WHERE MADONHANG = @MaDonHang
COMMIT TRAN
GO

