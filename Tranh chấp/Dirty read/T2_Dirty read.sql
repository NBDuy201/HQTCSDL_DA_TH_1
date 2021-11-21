﻿USE [QLDatChuyenHangOnl]
GO

-- T2: tương đương với proc XemDonHang
-- Lỗi ở đây: Tài xế xem đơn hàng chưa commit
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
GO

DECLARE @MaTaiXe INT = 1
BEGIN TRAN
	IF @MaTaiXe IS NULL OR NOT EXISTS ( SELECT MATAIXE FROM TAIXE )
	BEGIN
		RAISERROR (N'Mã tài xế không hợp lệ.', -1, -1)
		ROLLBACK TRAN
		RETURN 
	END

	DECLARE @KhuVuc varchar(255)
	SET @KhuVuc = ( SELECT KHUVUCHOATDONG FROM TAIXE WHERE MATAIXE=@MaTaiXe )
	IF @KhuVuc IS NULL
	BEGIN
		RAISERROR (N'Tài xế chưa cập nhật khu vực hoạt động.', -1, -1)
		ROLLBACK TRAN
		RETURN 
	END

	SELECT kh.HOTEN, dh.DIACHIGIAODEN, dh.HINHTHUCTHANHTOAN, dh.PHIVANCHUYEN, dh.TONGPHISANPHAM
	FROM DONHANG dh JOIN KHACHHANG kh ON dh.MAKHACHHANG = kh.MAKHACHHANG
	WHERE dh.TINHTRANGDONHANG = N'Đồng ý' AND dh.DIACHIGIAODEN LIKE '%' + @KhuVuc
COMMIT TRAN
GO
-- Tài xế vẫn thấy Mã đơn hàng 5 dù tình trạng đơn hàng = 'Chưa đồng ý'