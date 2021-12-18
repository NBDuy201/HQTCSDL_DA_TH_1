USE [QLDatChuyenHangOnl]
GO

-- T1_FIX: tương đương với proc ChonDonHang nhưng có thêm updlock để tránh đọc dữ liệu khi 1 trans chuẩn bị ghi
-- Tài xế 1 chọn đơn hàng có @MaDonHang = 1
DECLARE 
@MaTaiXe int = 1,
@MaDonHang INT = 1
BEGIN TRAN
	IF @MaTaiXe IS NULL OR NOT EXISTS ( SELECT MATAIXE FROM TAIXE )
	BEGIN
		RAISERROR (N'Mã tài xế không hợp lệ.', -1, -1)
		ROLLBACK TRAN
		RETURN 
	END

	IF @MaDonHang IS NULL OR NOT EXISTS ( SELECT MADONHANG FROM DONHANG WITH (UPDLOCK) WHERE MADONHANG = @MaDonHang and TINHTRANGDONHANG = N'Đồng ý' )
	BEGIN
		RAISERROR (N'Mã đơn hàng không hợp lệ hoặc đã có người giao.', -1, -1)
		ROLLBACK TRAN
		RETURN 
	END

	WAITFOR DELAY '00:00:05'

	BEGIN TRY
		UPDATE DONHANG
		SET MATAIXE=@MaTaiXe, TINHTRANGDONHANG=N'Đang giao'
		WHERE MADONHANG=@MaDonHang
	END TRY
	BEGIN CATCH
		ROLLBACK TRAN
		RETURN
	END CATCH
COMMIT TRAN
GO