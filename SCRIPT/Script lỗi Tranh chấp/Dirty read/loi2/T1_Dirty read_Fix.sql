USE [QLDatChuyenHangOnl]
GO

-- T1: tương đương với proc update_GiaSanPham
-- Đối tác 1 cập nhật lại giá của sản phẩm 1 từ 30.00 -> 5.00 nhưng transaction fail
DECLARE	
	@MaDTac  INT = 1,
	@MaSPham  INT = 1,
	@Gia NUMERIC(8, 2) = 5
BEGIN TRAN
	-- Mã đối tác không hợp lệ
	IF @MaDTac IS NULL OR NOT EXISTS (SELECT* FROM DOITAC WHERE MADOITAC = @MaDTac)
	BEGIN
		RAISERROR (N'Mã đối tác không hợp lệ.', -1, -1)
		ROLLBACK TRAN
		RETURN
	END

	-- Mã sản phẩm không hợp lệ
	IF @MaSPham IS NULL OR NOT EXISTS (SELECT* FROM SANPHAM WHERE MASANPHAM = @MaSPham)
	BEGIN
		RAISERROR (N'Mã sản phẩm không hợp lệ.', -1, -1)
		ROLLBACK TRAN
		RETURN
	END

	-- Mã sản phẩm không hợp lệ
	IF @Gia < 0
	BEGIN
		RAISERROR (N'Giá không được âm.', -1, -1)
		ROLLBACK TRAN
		RETURN
	END

	-- Update sản phẩm không thuộc về đối tác
	IF NOT EXISTS (SELECT *
					FROM CHINHANH_SANPHAM c_s JOIN CHINHANH c 
					ON c_s.MACHINHANH = c.MACHINHANH
					WHERE c.MADOITAC = @MaDTac AND
							c_s.MASANPHAM = @MaSPham)
	BEGIN
		RAISERROR (N'Không được cập nhật sản phẩm không phải của bạn.', -1, -1)
		ROLLBACK TRAN
		RETURN
	END

	-- Update số lượng sản phẩm
	UPDATE SANPHAM
	SET GIASANPHAM = @Gia
	WHERE MASANPHAM = @MaSPham

	WAITFOR DELAY '00:00:05'

	-- Xảy ra lỗi
	BEGIN
		RAISERROR (N'Xảy ra lỗi (không được update).', -1, -1)
		ROLLBACK TRAN
		RETURN
	END
COMMIT TRAN
GO