GO
USE [QLDatChuyenHangOnl]
GO


DECLARE
	@MaTXE int = 3,
	@MaDonHang int
-- =============================================
-- tạo dữ liệu ảo
-- =============================================
INSERT INTO DONHANG ( MAKHACHHANG, MATAIXE, TINHTRANGDONHANG, PHIVANCHUYEN)
VALUES (1, @MaTXE, N'Đã nhận', 24000)
SELECT @MaDonHang = SCOPE_IDENTITY()

-- =============================================
-- T1: PROCEDURE quản trị viên cập nhật phí vận chuyển của 1 đơn hàng
-- nhưng có mức cô lập là Read Uncommitted
-- =============================================
BEGIN TRAN SET TRAN ISOLATION LEVEL READ UNCOMMITTED	
	-- Mã đơn hàng để trống hoặc không tồn tại
	IF @MaDonHang IS NULL OR NOT EXISTS ( SELECT MADONHANG FROM DONHANG WHERE MADONHANG = @MaDonHang )
	BEGIN
		ROLLBACK TRAN
		RETURN
	END
	WAITFOR DELAY '00:00:05'

	-- Cập nhật lại phí vận chuyển
	UPDATE DONHANG
	SET PHIVANCHUYEN = 25000
	WHERE MADONHANG = @MaDonHang
COMMIT TRAN
GO

