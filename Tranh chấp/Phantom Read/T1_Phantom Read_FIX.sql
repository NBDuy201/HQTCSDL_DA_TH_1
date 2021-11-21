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
VALUES (13, @MaTXE, N'111, đường testing', N'Đã nhận', 24000)
SELECT @MaDonHang = SCOPE_IDENTITY()

-- =============================================
-- T2_FIX
-- T2: đã được tăng mức cô lập Serializable
-- =============================================
BEGIN TRAN SET TRAN ISOLATION LEVEL SERIALIZABLE	
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

