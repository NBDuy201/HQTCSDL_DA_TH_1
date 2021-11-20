﻿GO
USE [QLDatChuyenHangOnl]
GO

-- =============================================
-- T2_FIX: 
-- T2 đã được giảm mức cô lập xuống thành READ COMMITTED
-- và thêm khóa đọc-ghi Update khi thực hiện đọc trên bảng HOPDONG
-- =============================================
DECLARE
	@MaHDong int = 3,
	@PHANTRAMHOAHONG float = 0.2,
	@TgHieuLuc int = 10

-- SỬA 1: GIẢM MỨC CÔ LẬP
BEGIN TRAN SET TRAN ISOLATION LEVEL READ COMMITTED
	-- Mã hợp đồng để trống hoặc không tồn tại
	-- SỬA 2: ĐẶT KHÓA UPDATE
	IF (@MaHDong IS NULL OR NOT EXISTS (SELECT* FROM HOPDONG h WITH (UPDLOCK)
										WHERE h.MAHOPDONG = @MaHDong)) OR
		(@PHANTRAMHOAHONG IS NULL) OR
		(@TgHieuLuc IS NULL) OR (@PHANTRAMHOAHONG < 0) OR (@TgHieuLuc < 0)
	BEGIN
		RAISERROR (N'Thông tin nhập không hợp lệ hoặc bị để trống.', -1, -1)
		ROLLBACK TRAN
		RETURN
	END

	-- Hợp đồng chưa được duyệt
	IF EXISTS (SELECT * FROM SelectPendingContract() WHERE MAHOPDONG = @MaHDong)
	BEGIN
		RAISERROR (N'Mã hợp động chưa được duyệt.', -1, -1)
		ROLLBACK TRAN
		RETURN
	END

	-- Hợp đồng vẫn còn hiệu lực
	ELSE IF (GETDATE() < (SELECT MAX(t.THOIGIANKETTHUCCHUKI) FROM THEODOIHOPDONG t WHERE t.MAHOPDONG = @MaHDong))
	BEGIN  
		RAISERROR (N'Hợp đồng vẫn còn hiệu lực.', -1, -1)
		ROLLBACK TRAN
		RETURN
    END

	-- Cập nhật % hoa hồng, thời gian hiệu lực
	UPDATE HOPDONG
	SET PHANTRAMHOAHONG = @PHANTRAMHOAHONG, 
		THOIGIANHIEULUC = @TgHieuLuc,
		TINHTRANGPHIKICHHOAT = 0 -- Phi kích hoạt sẽ chưa được đóng
	WHERE MAHOPDONG = @MaHDong
COMMIT TRAN
RETURN
