-- Nhân viên
USE [QLDatChuyenHangOnl]
GO

CREATE OR ALTER FUNCTION SelectPendingContract()
RETURNS TABLE
AS
RETURN
(
   SELECT *
	FROM HOPDONG h
	WHERE h.TINHTRANGPHIKICHHOAT != 1
);
GO

CREATE OR ALTER PROCEDURE Approve_Contract @MaHDong varchar(10)
AS
BEGIN
	BEGIN TRAN
		-- Mã hợp đồng để trống hoặc không tồn tại
		IF @MaHDong IS NULL OR NOT EXISTS (SELECT h.MAHOPDONG FROM HOPDONG h WHERE h.MAHOPDONG = @MaHDong)
		BEGIN
			RAISERROR (N'Mã hợp động không hợp lệ.', -1, -1)
			ROLLBACK TRAN
			RETURN
		END

		-- Hợp đồng đã được duyệt
		IF NOT EXISTS (SELECT * FROM SelectPendingContract() WHERE MAHOPDONG = @MaHDong)
		BEGIN
			RAISERROR (N'Hợp đồng đã được duyệt từ trước.', -1, -1)
			ROLLBACK TRAN
			RETURN
		END

		-- Duyệt hợp đồng
		UPDATE HOPDONG
		SET TINHTRANGPHIKICHHOAT = 1
		WHERE MAHOPDONG = @MaHDong

		-- Thêm thông tin vào bảng theo dõi hợp đồng
		DECLARE	@batdau DATE = GETDATE(),
				@ketthuc DATE = DATEADD(MONTH, (SELECT h.THOIGIANHIEULUC FROM HOPDONG h WHERE h.MAHOPDONG = @MaHDong), GETDATE())
		WHILE (@batdau < @ketthuc)
		BEGIN
			INSERT INTO THEODOIHOPDONG (MAHOPDONG, THOIGIANBATDAUCHUKI, THOIGIANKETTHUCCHUKI, TINHTRANGNOPPHI)
			VALUES (@MaHDong, @batdau, DATEADD(MONTH, 1, @batdau), 0)

			SET @batdau = DATEADD(MONTH, 1, @batdau) -- Ngày bắt đầu + 1 tháng
		END
	COMMIT
END
GO

CREATE OR ALTER PROCEDURE Extend_Contract 
	@MaHDong varchar(10),
	@PHANTRAMHOAHONG FLOAT,
	@TgHieuLuc int
AS
BEGIN
	BEGIN TRAN
		-- Mã hợp đồng để trống hoặc không tồn tại
		IF (@MaHDong IS NULL OR NOT EXISTS (SELECT* FROM HOPDONG h WHERE h.MAHOPDONG = @MaHDong)) OR
			(@PHANTRAMHOAHONG IS NULL) OR
			(@TgHieuLuc IS NULL) OR (@PHANTRAMHOAHONG < 0) OR (@TgHieuLuc < 0)
		BEGIN
			RAISERROR (N'Thông tin nhập không hợp lệ.', -1, -1)
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
	COMMIT
END
GO

CREATE OR ALTER PROCEDURE Approve_MonthlyFee 
	@MaHDong varchar(10),
	@NgayBatDau date
AS
BEGIN
	BEGIN TRAN
		-- Mã hợp đồng để trống hoặc không tồn tại
		IF (@MaHDong IS NULL) OR (@NgayBatDau IS NULL)
		BEGIN
			RAISERROR (N'Mã hợp động hoặc Ngày bắt đầu không hợp lệ.', -1, -1)
			ROLLBACK TRAN
			RETURN
		END

		-- Hợp đồng không có chu kì này
		IF NOT EXISTS (SELECT *
						FROM THEODOIHOPDONG t 
						WHERE t.MAHOPDONG = @MaHDong AND
								t.THOIGIANBATDAUCHUKI = @NgayBatDau)
		BEGIN
			RAISERROR (N'Mã hợp đồng hoặc Ngày bắt đầu tồn tại.', -1, -1)
			ROLLBACK TRAN
			RETURN
		END

		-- Cập nhật phí tháng
		UPDATE THEODOIHOPDONG
		SET TINHTRANGNOPPHI = 1
		WHERE MAHOPDONG = @MaHDong AND THOIGIANBATDAUCHUKI = @NgayBatDau
	COMMIT
END
GO