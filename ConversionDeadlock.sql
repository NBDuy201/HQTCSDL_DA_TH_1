﻿GO
USE [QLDatChuyenHangOnl]
GO

-- =============================================
-- Extend_Contract_LOI là PROCEDURE giống với Extend_Contract
-- nhưng có mức cô lập là SERIALIZABLE
-- =============================================
CREATE OR ALTER PROCEDURE Extend_Contract_LOI
	@MaHDong int,
	@PHANTRAMHOAHONG FLOAT,
	@TgHieuLuc int
AS
BEGIN
	BEGIN TRAN SET TRAN ISOLATION LEVEL SERIALIZABLE
		-- Mã hợp đồng để trống hoặc không tồn tại
		IF (@MaHDong IS NULL OR NOT EXISTS (SELECT* FROM HOPDONG h WHERE h.MAHOPDONG = @MaHDong)) OR
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

		WAITFOR DELAY '00:00:10'

		-- Cập nhật % hoa hồng, thời gian hiệu lực
		UPDATE HOPDONG
		SET PHANTRAMHOAHONG = @PHANTRAMHOAHONG, 
			THOIGIANHIEULUC = @TgHieuLuc,
			TINHTRANGPHIKICHHOAT = 0 -- Phi kích hoạt sẽ chưa được đóng
		WHERE MAHOPDONG = @MaHDong
	COMMIT TRAN
END
GO

EXEC Extend_Contract @MaHDong = 3, @PhanTramHoaHong = 0.1, @TgHieuLuc = 5

select * from hopdong