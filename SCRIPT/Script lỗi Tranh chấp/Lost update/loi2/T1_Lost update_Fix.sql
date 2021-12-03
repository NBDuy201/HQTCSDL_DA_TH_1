USE [QLDatChuyenHangOnl]
GO

-- T1: tương đương với proc DongY_DonHang
-- Khách hàng 1 đồng ý đơn hàng 1 có chứa sản phẩm 1
-- Tuy nhiên chỉ còn 1 sản phẩm
-- Sửa lỗi: Thêm khóa updlock để T2 phải chờ khi vào sau
DECLARE 
@MaDonHang BIGINT = 1
BEGIN TRAN
	-- Đơn hàng không ở tình trạng chưa đồng ý
	IF EXISTS ( SELECT TINHTRANGDONHANG FROM DONHANG DH WHERE DH.MADONHANG = @MaDonHang AND DH.TINHTRANGDONHANG <> N'Chưa đồng ý')
		BEGIN
			RAISERROR (N'Đơn này đã được đồng ý rồi.', -1, -1)
			ROLLBACK TRAN
			RETURN
		END

	-- Đơn hàng chưa có sản phẩm nào
	IF NOT EXISTS ( SELECT CT.MADONHANG
					FROM DONHANG DH, CHITIETDONHANG_SANPHAM CT 
					WHERE CT.MADONHANG = DH.MADONHANG )
		BEGIN
			RAISERROR (N'Đơn hàng chưa có sản phẩm nào.', -1, -1)
			ROLLBACK TRAN
			RETURN
		END

	WAITFOR DELAY '00:00:07'

	-- Cập nhật tình trạng đơn hàng
	UPDATE DONHANG WITH (UPDLOCK)
	SET TINHTRANGDONHANG = N'Đồng ý'
	WHERE MADONHANG = @MaDonHang

	-- Cập nhật lại số lượng tồn các sản phẩm của chi nhánh
	UPDATE CHINHANH_SANPHAM
	SET SOLUONGTON = SOLUONGTON - DH_SP.SOLUONGTUONGUNG

	FROM CHINHANH_SANPHAM CN_SP
	INNER JOIN CHITIETDONHANG_SANPHAM DH_SP
	ON CN_SP.MASANPHAM = DH_SP.MASANPHAM AND
		DH_SP.MADONHANG = @MaDonHang

	IF EXISTS ( SELECT SOLUONGTON
				FROM CHINHANH_SANPHAM
				WHERE SOLUONGTON < 0 )

	BEGIN
		RAISERROR (N'Số lượng đang đặt vượt quá số lượng tồn của chi nhánh.', -1, -1)
		ROLLBACK TRAN
		RETURN
	END
COMMIT TRAN
GO