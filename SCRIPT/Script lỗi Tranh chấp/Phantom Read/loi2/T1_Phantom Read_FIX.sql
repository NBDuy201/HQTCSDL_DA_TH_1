USE [QLDatChuyenHangOnl]
GO

-- =============================================
-- T1: khách hàng xem phí trung bình cho 1 đơn hàng
-- Sửa lỗi: Tăng mức cô lập lên SERIALIZABLE
-- =============================================
DECLARE
	@MaKHang int = 1
BEGIN TRAN SET TRAN ISOLATION LEVEL SERIALIZABLE
	-- Mã khách hàng để trống hoặc không tồn tại
	IF @MaKHang IS NULL OR NOT EXISTS (SELECT* FROM khachhang WHERE MAKHACHHANG = @MaKHang)
	BEGIN
		RAISERROR (N'Thông tin nhập không hợp lệ hoặc bị để trống.', -1, -1)
		ROLLBACK TRAN
		RETURN
	END

	-- Tính tổng phí trên các hóa đơn của khách hàng
	DECLARE @tongphi int = (SELECT sum(TONGPHISANPHAM)
							FROM donhang
							WHERE 
								MAKHACHHANG = @MaKHang AND
								TINHTRANGDONHANG = N'Đã nhận')
	WAITFOR DELAY '00:00:05' 

	-- Tính số các đơn hàng
	DECLARE @SoDHang int = (SELECT COUNT(*)
							FROM donhang
							WHERE 
								MAKHACHHANG = @MaKHang AND
								TINHTRANGDONHANG = N'Đã nhận')
	DECLARE @TongTienTB NUMERIC(8, 2) = @tongphi / @SoDHang
	PRINT(@TongTienTB)
COMMIT TRAN
GO