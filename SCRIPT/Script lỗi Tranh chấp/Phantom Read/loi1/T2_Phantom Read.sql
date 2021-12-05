USE [QLDatChuyenHangOnl]
GO

-- =============================================
-- T2: PROCEDURE tài xế truy vấn số tiền vận chuyển trung bình
-- nhưng có mức cô lập là Read Uncommitted
-- =============================================
DECLARE @MaTXE int = 3

BEGIN TRAN SET TRAN ISOLATION LEVEL READ UNCOMMITTED
	-- Mã đơn hàng để trống hoặc không tồn tại
	IF @MaTXE IS NULL OR NOT EXISTS ( SELECT MATAIXE FROM TAIXE WHERE MATAIXE = @MaTXE )
	BEGIN
		ROLLBACK TRAN
		RETURN
	END
	-- Số đơn hàng đã giao
	DECLARE @SoDonHang int = ( SELECT COUNT(*) FROM DONHANG WHERE MATAIXE=@MaTXE AND TINHTRANGDONHANG=N'Đã nhận')

	WAITFOR DELAY '00:00:10'

	-- Tổng tiền
	DECLARE @TongPhiGiao numeric(8,2) = ( SELECT SUM(PHIVANCHUYEN) FROM DONHANG WHERE MATAIXE=@MaTXE AND TINHTRANGDONHANG=N'Đã nhận')
	
	DECLARE @Result numeric(8,2) = @TongPhiGiao / @SoDonHang
	PRINT(@Result)
COMMIT TRAN
GO