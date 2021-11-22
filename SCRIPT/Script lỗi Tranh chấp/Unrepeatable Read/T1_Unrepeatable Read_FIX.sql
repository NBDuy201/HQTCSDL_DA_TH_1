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
-- T1_FIX
-- T1: đã được tăng mức cô lập Repeatable read
-- =============================================
BEGIN TRAN SET TRAN ISOLATION LEVEL REPEATABLE READ	
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

