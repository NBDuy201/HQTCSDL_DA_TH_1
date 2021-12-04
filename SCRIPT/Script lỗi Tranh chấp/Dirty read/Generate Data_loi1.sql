USE [QLDatChuyenHangOnl]
GO

-- == Xóa tất cả dữ liệu trong bảng ==
-- disable all constraints
EXEC sp_MSForEachTable 'ALTER TABLE ? NOCHECK CONSTRAINT all'

-- delete data in all tables
EXEC sp_MSforeachtable 'DELETE FROM ?'

-- enable all constraints
exec sp_MSForEachTable 'ALTER TABLE ? WITH CHECK CHECK CONSTRAINT all'
GO

SET IDENTITY_INSERT [dbo].[DOITAC] ON 

INSERT [dbo].[DOITAC] ([MADOITAC], [TENDOITAC], [NGUOIDAIDIEN], [SOCHINHANH], [DIACHIKINHDOANH], [THANHPHO], [QUAN], [SOLUONGDONHANGMOINGAY], [LOAIHANGVANCHUYEN], [SODIENTHOAI], [EMAIL]) VALUES (1, N'Future Space Explore Co.', N'96821', CAST(12 AS Numeric(18, 0)), N'Torrance', N'Hưng Yên', N'4', CAST(981 AS Numeric(18, 0)), N'Acazonor', N'08089277696', N'Ligon@example.com')
INSERT [dbo].[DOITAC] ([MADOITAC], [TENDOITAC], [NGUOIDAIDIEN], [SOCHINHANH], [DIACHIKINHDOANH], [THANHPHO], [QUAN], [SOLUONGDONHANGMOINGAY], [LOAIHANGVANCHUYEN], [SODIENTHOAI], [EMAIL]) VALUES (2, N'Global Mobile Group', N'12831', CAST(15 AS Numeric(18, 0)), N'Caerphilly', N'Hà Giang', N'THU DUC', CAST(575 AS Numeric(18, 0)), N'Levogolam', N'08005108865', N'Burrows865@example.com')
INSERT [dbo].[DOITAC] ([MADOITAC], [TENDOITAC], [NGUOIDAIDIEN], [SOCHINHANH], [DIACHIKINHDOANH], [THANHPHO], [QUAN], [SOLUONGDONHANGMOINGAY], [LOAIHANGVANCHUYEN], [SODIENTHOAI], [EMAIL]) VALUES (3, N'North Protection Corp.', N'91981', CAST(5 AS Numeric(18, 0)), N'Yarmouth', N'Cao Lãnh', N'CAN GIO', CAST(528 AS Numeric(18, 0)), N'Influsitec', N'08001204087', N'GeorgannSamples457@example.com')
INSERT [dbo].[DOITAC] ([MADOITAC], [TENDOITAC], [NGUOIDAIDIEN], [SOCHINHANH], [DIACHIKINHDOANH], [THANHPHO], [QUAN], [SOLUONGDONHANGMOINGAY], [LOAIHANGVANCHUYEN], [SODIENTHOAI], [EMAIL]) VALUES (4, N'Future High-Technologies Inc.', N'27381', CAST(23 AS Numeric(18, 0)), N'Barton-on-Humber', N'Long Xuyên', N'HOC MON', CAST(756 AS Numeric(18, 0)), N'Metochloridevant', N'08081151280', N'Cedric.CSotelo@example.com')
INSERT [dbo].[DOITAC] ([MADOITAC], [TENDOITAC], [NGUOIDAIDIEN], [SOCHINHANH], [DIACHIKINHDOANH], [THANHPHO], [QUAN], [SOLUONGDONHANGMOINGAY], [LOAIHANGVANCHUYEN], [SODIENTHOAI], [EMAIL]) VALUES (5, N'Future Mobile Corporation', N'15938', CAST(24 AS Numeric(18, 0)), N'Chinnor', N'Hạ Long', N'2', CAST(618 AS Numeric(18, 0)), N'Ecoperivant', N'08002916356', N'Loftis@example.com')
INSERT [dbo].[DOITAC] ([MADOITAC], [TENDOITAC], [NGUOIDAIDIEN], [SOCHINHANH], [DIACHIKINHDOANH], [THANHPHO], [QUAN], [SOLUONGDONHANGMOINGAY], [LOAIHANGVANCHUYEN], [SODIENTHOAI], [EMAIL]) VALUES (6, N'West Systems Group', N'11427', CAST(28 AS Numeric(18, 0)), N'Peterhead', N'Vĩnh Yên', N'BINH THANH', CAST(891 AS Numeric(18, 0)), N'Radichloridecept', N'08088307092', N'Francene.E.Acker869@example.com')
INSERT [dbo].[DOITAC] ([MADOITAC], [TENDOITAC], [NGUOIDAIDIEN], [SOCHINHANH], [DIACHIKINHDOANH], [THANHPHO], [QUAN], [SOLUONGDONHANGMOINGAY], [LOAIHANGVANCHUYEN], [SODIENTHOAI], [EMAIL]) VALUES (7, N'Australian Space Explore Group', N'27438', CAST(5 AS Numeric(18, 0)), N'Torrington', N'Vị Thanh', N'CAN THO', CAST(166 AS Numeric(18, 0)), N'Doxysidex', N'08006483899', N'ssmxzviy.qout@example.com')
INSERT [dbo].[DOITAC] ([MADOITAC], [TENDOITAC], [NGUOIDAIDIEN], [SOCHINHANH], [DIACHIKINHDOANH], [THANHPHO], [QUAN], [SOLUONGDONHANGMOINGAY], [LOAIHANGVANCHUYEN], [SODIENTHOAI], [EMAIL]) VALUES (8, N'South High-Technologies Group', N'98918', CAST(7 AS Numeric(18, 0)), N'East Boldon', N'Vũng Tàu', N'12', CAST(503 AS Numeric(18, 0)), NULL, N'08003939541', N'Abreu222@example.com')
INSERT [dbo].[DOITAC] ([MADOITAC], [TENDOITAC], [NGUOIDAIDIEN], [SOCHINHANH], [DIACHIKINHDOANH], [THANHPHO], [QUAN], [SOLUONGDONHANGMOINGAY], [LOAIHANGVANCHUYEN], [SODIENTHOAI], [EMAIL]) VALUES (9, N'Beyond Telecommunications Group', N'67589', CAST(6 AS Numeric(18, 0)), N'Londonderry [2]', N'Buôn Ma Thuột', N'5', CAST(135 AS Numeric(18, 0)), N'Innotamte', N'08080585303', N'SeeWild56@example.com')
INSERT [dbo].[DOITAC] ([MADOITAC], [TENDOITAC], [NGUOIDAIDIEN], [SOCHINHANH], [DIACHIKINHDOANH], [THANHPHO], [QUAN], [SOLUONGDONHANGMOINGAY], [LOAIHANGVANCHUYEN], [SODIENTHOAI], [EMAIL]) VALUES (10, N'Beyond High-Technologies Inc.', N'60676', CAST(6 AS Numeric(18, 0)), N'Chippenham', N'Cẩm Phả', N'3', CAST(538 AS Numeric(18, 0)), N'Mucopurivex', NULL, N'Severson757@example.com')
SET IDENTITY_INSERT [dbo].[DOITAC] OFF
GO
SET IDENTITY_INSERT [dbo].[HOPDONG] ON 

INSERT [dbo].[HOPDONG] ([MAHOPDONG], [MADOITAC], [MASOTHUE], [NGUOIDAIDIEN], [SOCHINHANHDANGKI], [PHANTRAMHOAHONG], [THOIGIANHIEULUC], [TINHTRANGPHIKICHHOAT]) VALUES (1, 8, N'FI59217615', N'Antoine', CAST(15 AS Numeric(18, 0)), 15.62, 60, 1)
INSERT [dbo].[HOPDONG] ([MAHOPDONG], [MADOITAC], [MASOTHUE], [NGUOIDAIDIEN], [SOCHINHANHDANGKI], [PHANTRAMHOAHONG], [THOIGIANHIEULUC], [TINHTRANGPHIKICHHOAT]) VALUES (2, 2, N'HU43857230', N'Edythe', CAST(16 AS Numeric(18, 0)), 16.93, 32, 1)
INSERT [dbo].[HOPDONG] ([MAHOPDONG], [MADOITAC], [MASOTHUE], [NGUOIDAIDIEN], [SOCHINHANHDANGKI], [PHANTRAMHOAHONG], [THOIGIANHIEULUC], [TINHTRANGPHIKICHHOAT]) VALUES (3, 7, N'ESV9490024', N'Albert', CAST(18 AS Numeric(18, 0)), 18.89, 18, 1)
INSERT [dbo].[HOPDONG] ([MAHOPDONG], [MADOITAC], [MASOTHUE], [NGUOIDAIDIEN], [SOCHINHANHDANGKI], [PHANTRAMHOAHONG], [THOIGIANHIEULUC], [TINHTRANGPHIKICHHOAT]) VALUES (4, 1, N'EL49639858', N'Lanette', CAST(13 AS Numeric(18, 0)), 13.77, 45, 1)
INSERT [dbo].[HOPDONG] ([MAHOPDONG], [MADOITAC], [MASOTHUE], [NGUOIDAIDIEN], [SOCHINHANHDANGKI], [PHANTRAMHOAHONG], [THOIGIANHIEULUC], [TINHTRANGPHIKICHHOAT]) VALUES (5, 3, N'CZ21940835', N'Lean', CAST(15 AS Numeric(18, 0)), 15.06, 18, 1)
INSERT [dbo].[HOPDONG] ([MAHOPDONG], [MADOITAC], [MASOTHUE], [NGUOIDAIDIEN], [SOCHINHANHDANGKI], [PHANTRAMHOAHONG], [THOIGIANHIEULUC], [TINHTRANGPHIKICHHOAT]) VALUES (6, 7, N'SE88541024', N'Darla', CAST(18 AS Numeric(18, 0)), 18.43, 27, 1)
INSERT [dbo].[HOPDONG] ([MAHOPDONG], [MADOITAC], [MASOTHUE], [NGUOIDAIDIEN], [SOCHINHANHDANGKI], [PHANTRAMHOAHONG], [THOIGIANHIEULUC], [TINHTRANGPHIKICHHOAT]) VALUES (7, 3, N'NL98505948', N'Alfreda', CAST(12 AS Numeric(18, 0)), 12.22, 14, 1)
INSERT [dbo].[HOPDONG] ([MAHOPDONG], [MADOITAC], [MASOTHUE], [NGUOIDAIDIEN], [SOCHINHANHDANGKI], [PHANTRAMHOAHONG], [THOIGIANHIEULUC], [TINHTRANGPHIKICHHOAT]) VALUES (8, 7, N'SE28594620', N'Adrienne', CAST(17 AS Numeric(18, 0)), 17.61, 7, 1)
INSERT [dbo].[HOPDONG] ([MAHOPDONG], [MADOITAC], [MASOTHUE], [NGUOIDAIDIEN], [SOCHINHANHDANGKI], [PHANTRAMHOAHONG], [THOIGIANHIEULUC], [TINHTRANGPHIKICHHOAT]) VALUES (9, 1, N'CZ34429949', N'Karma', CAST(13 AS Numeric(18, 0)), 13.88, 8, 1)
INSERT [dbo].[HOPDONG] ([MAHOPDONG], [MADOITAC], [MASOTHUE], [NGUOIDAIDIEN], [SOCHINHANHDANGKI], [PHANTRAMHOAHONG], [THOIGIANHIEULUC], [TINHTRANGPHIKICHHOAT]) VALUES (10, 2, N'BG16544391', NULL, CAST(16 AS Numeric(18, 0)), 16.84, 9, 1)
SET IDENTITY_INSERT [dbo].[HOPDONG] OFF
GO
SET IDENTITY_INSERT [dbo].[CHINHANH] ON 

INSERT [dbo].[CHINHANH] ([MACHINHANH], [MADOITAC], [MAHOPDONG], [DIACHICHINHANH]) VALUES (1, 9, 2, N'Palmers Green')
INSERT [dbo].[CHINHANH] ([MACHINHANH], [MADOITAC], [MAHOPDONG], [DIACHICHINHANH]) VALUES (2, 4, 3, N'Billingham')
INSERT [dbo].[CHINHANH] ([MACHINHANH], [MADOITAC], [MAHOPDONG], [DIACHICHINHANH]) VALUES (3, 6, 1, N'Chatham')
INSERT [dbo].[CHINHANH] ([MACHINHANH], [MADOITAC], [MAHOPDONG], [DIACHICHINHANH]) VALUES (4, 2, 1, N'Billingshurst')
INSERT [dbo].[CHINHANH] ([MACHINHANH], [MADOITAC], [MAHOPDONG], [DIACHICHINHANH]) VALUES (5, 3, 2, N'Skipton')
INSERT [dbo].[CHINHANH] ([MACHINHANH], [MADOITAC], [MAHOPDONG], [DIACHICHINHANH]) VALUES (6, 9, 9, N'Littlehampton')
INSERT [dbo].[CHINHANH] ([MACHINHANH], [MADOITAC], [MAHOPDONG], [DIACHICHINHANH]) VALUES (7, 1, 8, N'Ystrad Meurig')
INSERT [dbo].[CHINHANH] ([MACHINHANH], [MADOITAC], [MAHOPDONG], [DIACHICHINHANH]) VALUES (8, 10, 10, N'Chathill')
INSERT [dbo].[CHINHANH] ([MACHINHANH], [MADOITAC], [MAHOPDONG], [DIACHICHINHANH]) VALUES (9, 6, 3, N'Tranent')
INSERT [dbo].[CHINHANH] ([MACHINHANH], [MADOITAC], [MAHOPDONG], [DIACHICHINHANH]) VALUES (10, 6, 2, N'Shepperton')
INSERT [dbo].[CHINHANH] ([MACHINHANH], [MADOITAC], [MAHOPDONG], [DIACHICHINHANH]) VALUES (11, 3, 8, N'Sleaford')
INSERT [dbo].[CHINHANH] ([MACHINHANH], [MADOITAC], [MAHOPDONG], [DIACHICHINHANH]) VALUES (12, 10, 1, N'Bilston')
INSERT [dbo].[CHINHANH] ([MACHINHANH], [MADOITAC], [MAHOPDONG], [DIACHICHINHANH]) VALUES (13, 9, 4, N'Par')
INSERT [dbo].[CHINHANH] ([MACHINHANH], [MADOITAC], [MAHOPDONG], [DIACHICHINHANH]) VALUES (14, 4, 6, N'Chatteris')
INSERT [dbo].[CHINHANH] ([MACHINHANH], [MADOITAC], [MAHOPDONG], [DIACHICHINHANH]) VALUES (15, 4, 1, N'Bingley')
INSERT [dbo].[CHINHANH] ([MACHINHANH], [MADOITAC], [MAHOPDONG], [DIACHICHINHANH]) VALUES (16, 5, 7, N'Houston')
INSERT [dbo].[CHINHANH] ([MACHINHANH], [MADOITAC], [MAHOPDONG], [DIACHICHINHANH]) VALUES (17, 10, 10, N'Liverpool')
INSERT [dbo].[CHINHANH] ([MACHINHANH], [MADOITAC], [MAHOPDONG], [DIACHICHINHANH]) VALUES (18, 6, 2, N'Tredegar')
INSERT [dbo].[CHINHANH] ([MACHINHANH], [MADOITAC], [MAHOPDONG], [DIACHICHINHANH]) VALUES (19, 6, 8, N'Clerkenwell')
INSERT [dbo].[CHINHANH] ([MACHINHANH], [MADOITAC], [MAHOPDONG], [DIACHICHINHANH]) VALUES (20, 6, 1, N'Enfield')
INSERT [dbo].[CHINHANH] ([MACHINHANH], [MADOITAC], [MAHOPDONG], [DIACHICHINHANH]) VALUES (21, 4, 4, N'Hove')
INSERT [dbo].[CHINHANH] ([MACHINHANH], [MADOITAC], [MAHOPDONG], [DIACHICHINHANH]) VALUES (22, 9, 4, N'Clevedon')
INSERT [dbo].[CHINHANH] ([MACHINHANH], [MADOITAC], [MAHOPDONG], [DIACHICHINHANH]) VALUES (23, 3, 6, N'Liverpool Street')
INSERT [dbo].[CHINHANH] ([MACHINHANH], [MADOITAC], [MAHOPDONG], [DIACHICHINHANH]) VALUES (24, 10, 8, N'Slough')
INSERT [dbo].[CHINHANH] ([MACHINHANH], [MADOITAC], [MAHOPDONG], [DIACHICHINHANH]) VALUES (25, 10, 6, N'Cheadle')
INSERT [dbo].[CHINHANH] ([MACHINHANH], [MADOITAC], [MAHOPDONG], [DIACHICHINHANH]) VALUES (26, 8, 8, N'Enniskillen')
INSERT [dbo].[CHINHANH] ([MACHINHANH], [MADOITAC], [MAHOPDONG], [DIACHICHINHANH]) VALUES (27, 4, 1, N'Clitheroe')
INSERT [dbo].[CHINHANH] ([MACHINHANH], [MADOITAC], [MAHOPDONG], [DIACHICHINHANH]) VALUES (28, 9, 2, N'Howwood')
INSERT [dbo].[CHINHANH] ([MACHINHANH], [MADOITAC], [MAHOPDONG], [DIACHICHINHANH]) VALUES (29, 3, 10, N'Shepton Mallet')
INSERT [dbo].[CHINHANH] ([MACHINHANH], [MADOITAC], [MAHOPDONG], [DIACHICHINHANH]) VALUES (30, 7, 8, N'Liversedge')
SET IDENTITY_INSERT [dbo].[CHINHANH] OFF
GO
SET IDENTITY_INSERT [dbo].[SANPHAM] ON 

INSERT [dbo].[SANPHAM] ([MASANPHAM], [TENSANPHAM], [GIASANPHAM]) VALUES (1, N'Cabjectentor', CAST(124.82 AS Numeric(8, 2)))
INSERT [dbo].[SANPHAM] ([MASANPHAM], [TENSANPHAM], [GIASANPHAM]) VALUES (2, N'Anlictscope', CAST(691.54 AS Numeric(8, 2)))
INSERT [dbo].[SANPHAM] ([MASANPHAM], [TENSANPHAM], [GIASANPHAM]) VALUES (3, N'Armleator', CAST(898.97 AS Numeric(8, 2)))
INSERT [dbo].[SANPHAM] ([MASANPHAM], [TENSANPHAM], [GIASANPHAM]) VALUES (4, N'Charculimator', CAST(182.68 AS Numeric(8, 2)))
INSERT [dbo].[SANPHAM] ([MASANPHAM], [TENSANPHAM], [GIASANPHAM]) VALUES (5, N'Cartculphone', CAST(1110.03 AS Numeric(8, 2)))
INSERT [dbo].[SANPHAM] ([MASANPHAM], [TENSANPHAM], [GIASANPHAM]) VALUES (6, N'Antaar', CAST(550.73 AS Numeric(8, 2)))
INSERT [dbo].[SANPHAM] ([MASANPHAM], [TENSANPHAM], [GIASANPHAM]) VALUES (7, N'Miccesson', CAST(1147.14 AS Numeric(8, 2)))
INSERT [dbo].[SANPHAM] ([MASANPHAM], [TENSANPHAM], [GIASANPHAM]) VALUES (8, N'Transcyclommridge', CAST(1004.16 AS Numeric(8, 2)))
INSERT [dbo].[SANPHAM] ([MASANPHAM], [TENSANPHAM], [GIASANPHAM]) VALUES (9, N'Monbandleter', CAST(1496.16 AS Numeric(8, 2)))
INSERT [dbo].[SANPHAM] ([MASANPHAM], [TENSANPHAM], [GIASANPHAM]) VALUES (10, N'Playpickentor', CAST(1393.72 AS Numeric(8, 2)))
INSERT [dbo].[SANPHAM] ([MASANPHAM], [TENSANPHAM], [GIASANPHAM]) VALUES (11, N'Chartoplet', CAST(1854.46 AS Numeric(8, 2)))
INSERT [dbo].[SANPHAM] ([MASANPHAM], [TENSANPHAM], [GIASANPHAM]) VALUES (12, N'Biputlet', CAST(1282.27 AS Numeric(8, 2)))
INSERT [dbo].[SANPHAM] ([MASANPHAM], [TENSANPHAM], [GIASANPHAM]) VALUES (13, N'Cartcordaquer', CAST(1920.27 AS Numeric(8, 2)))
INSERT [dbo].[SANPHAM] ([MASANPHAM], [TENSANPHAM], [GIASANPHAM]) VALUES (14, N'Comtingaer', CAST(572.35 AS Numeric(8, 2)))
INSERT [dbo].[SANPHAM] ([MASANPHAM], [TENSANPHAM], [GIASANPHAM]) VALUES (15, N'Tweetcordar', CAST(143.01 AS Numeric(8, 2)))
INSERT [dbo].[SANPHAM] ([MASANPHAM], [TENSANPHAM], [GIASANPHAM]) VALUES (16, NULL, NULL)
INSERT [dbo].[SANPHAM] ([MASANPHAM], [TENSANPHAM], [GIASANPHAM]) VALUES (17, N'Readpickon', CAST(1722.18 AS Numeric(8, 2)))
INSERT [dbo].[SANPHAM] ([MASANPHAM], [TENSANPHAM], [GIASANPHAM]) VALUES (18, N'Submutupor', CAST(691.63 AS Numeric(8, 2)))
INSERT [dbo].[SANPHAM] ([MASANPHAM], [TENSANPHAM], [GIASANPHAM]) VALUES (19, N'Subniefer', CAST(485.76 AS Numeric(8, 2)))
INSERT [dbo].[SANPHAM] ([MASANPHAM], [TENSANPHAM], [GIASANPHAM]) VALUES (20, NULL, NULL)
SET IDENTITY_INSERT [dbo].[SANPHAM] OFF
GO
INSERT [dbo].[CHINHANH_SANPHAM] ([MACHINHANH], [MASANPHAM], [SOLUONGTON]) VALUES (1, 1, CAST(1656 AS Numeric(18, 0)))
INSERT [dbo].[CHINHANH_SANPHAM] ([MACHINHANH], [MASANPHAM], [SOLUONGTON]) VALUES (2, 1, CAST(677 AS Numeric(18, 0)))
INSERT [dbo].[CHINHANH_SANPHAM] ([MACHINHANH], [MASANPHAM], [SOLUONGTON]) VALUES (2, 2, CAST(218 AS Numeric(18, 0)))
INSERT [dbo].[CHINHANH_SANPHAM] ([MACHINHANH], [MASANPHAM], [SOLUONGTON]) VALUES (3, 2, CAST(949 AS Numeric(18, 0)))
INSERT [dbo].[CHINHANH_SANPHAM] ([MACHINHANH], [MASANPHAM], [SOLUONGTON]) VALUES (3, 3, CAST(1558 AS Numeric(18, 0)))
INSERT [dbo].[CHINHANH_SANPHAM] ([MACHINHANH], [MASANPHAM], [SOLUONGTON]) VALUES (4, 3, CAST(1116 AS Numeric(18, 0)))
INSERT [dbo].[CHINHANH_SANPHAM] ([MACHINHANH], [MASANPHAM], [SOLUONGTON]) VALUES (4, 4, CAST(768 AS Numeric(18, 0)))
INSERT [dbo].[CHINHANH_SANPHAM] ([MACHINHANH], [MASANPHAM], [SOLUONGTON]) VALUES (5, 4, CAST(742 AS Numeric(18, 0)))
INSERT [dbo].[CHINHANH_SANPHAM] ([MACHINHANH], [MASANPHAM], [SOLUONGTON]) VALUES (5, 5, CAST(364 AS Numeric(18, 0)))
INSERT [dbo].[CHINHANH_SANPHAM] ([MACHINHANH], [MASANPHAM], [SOLUONGTON]) VALUES (6, 5, CAST(1572 AS Numeric(18, 0)))
INSERT [dbo].[CHINHANH_SANPHAM] ([MACHINHANH], [MASANPHAM], [SOLUONGTON]) VALUES (6, 6, CAST(422 AS Numeric(18, 0)))
INSERT [dbo].[CHINHANH_SANPHAM] ([MACHINHANH], [MASANPHAM], [SOLUONGTON]) VALUES (7, 6, CAST(1315 AS Numeric(18, 0)))
INSERT [dbo].[CHINHANH_SANPHAM] ([MACHINHANH], [MASANPHAM], [SOLUONGTON]) VALUES (7, 7, CAST(1828 AS Numeric(18, 0)))
INSERT [dbo].[CHINHANH_SANPHAM] ([MACHINHANH], [MASANPHAM], [SOLUONGTON]) VALUES (8, 7, CAST(263 AS Numeric(18, 0)))
INSERT [dbo].[CHINHANH_SANPHAM] ([MACHINHANH], [MASANPHAM], [SOLUONGTON]) VALUES (8, 8, CAST(1581 AS Numeric(18, 0)))
INSERT [dbo].[CHINHANH_SANPHAM] ([MACHINHANH], [MASANPHAM], [SOLUONGTON]) VALUES (9, 8, CAST(1402 AS Numeric(18, 0)))
INSERT [dbo].[CHINHANH_SANPHAM] ([MACHINHANH], [MASANPHAM], [SOLUONGTON]) VALUES (9, 9, CAST(222 AS Numeric(18, 0)))
INSERT [dbo].[CHINHANH_SANPHAM] ([MACHINHANH], [MASANPHAM], [SOLUONGTON]) VALUES (10, 9, CAST(1638 AS Numeric(18, 0)))
INSERT [dbo].[CHINHANH_SANPHAM] ([MACHINHANH], [MASANPHAM], [SOLUONGTON]) VALUES (10, 10, CAST(1030 AS Numeric(18, 0)))
INSERT [dbo].[CHINHANH_SANPHAM] ([MACHINHANH], [MASANPHAM], [SOLUONGTON]) VALUES (11, 10, CAST(461 AS Numeric(18, 0)))
INSERT [dbo].[CHINHANH_SANPHAM] ([MACHINHANH], [MASANPHAM], [SOLUONGTON]) VALUES (11, 11, CAST(1560 AS Numeric(18, 0)))
INSERT [dbo].[CHINHANH_SANPHAM] ([MACHINHANH], [MASANPHAM], [SOLUONGTON]) VALUES (12, 12, CAST(1204 AS Numeric(18, 0)))
INSERT [dbo].[CHINHANH_SANPHAM] ([MACHINHANH], [MASANPHAM], [SOLUONGTON]) VALUES (13, 13, CAST(1949 AS Numeric(18, 0)))
INSERT [dbo].[CHINHANH_SANPHAM] ([MACHINHANH], [MASANPHAM], [SOLUONGTON]) VALUES (14, 14, CAST(835 AS Numeric(18, 0)))
INSERT [dbo].[CHINHANH_SANPHAM] ([MACHINHANH], [MASANPHAM], [SOLUONGTON]) VALUES (15, 15, CAST(92 AS Numeric(18, 0)))
INSERT [dbo].[CHINHANH_SANPHAM] ([MACHINHANH], [MASANPHAM], [SOLUONGTON]) VALUES (16, 16, CAST(219 AS Numeric(18, 0)))
INSERT [dbo].[CHINHANH_SANPHAM] ([MACHINHANH], [MASANPHAM], [SOLUONGTON]) VALUES (17, 17, CAST(316 AS Numeric(18, 0)))
INSERT [dbo].[CHINHANH_SANPHAM] ([MACHINHANH], [MASANPHAM], [SOLUONGTON]) VALUES (18, 18, CAST(1993 AS Numeric(18, 0)))
INSERT [dbo].[CHINHANH_SANPHAM] ([MACHINHANH], [MASANPHAM], [SOLUONGTON]) VALUES (19, 19, CAST(642 AS Numeric(18, 0)))
INSERT [dbo].[CHINHANH_SANPHAM] ([MACHINHANH], [MASANPHAM], [SOLUONGTON]) VALUES (20, 20, CAST(1779 AS Numeric(18, 0)))
GO
SET IDENTITY_INSERT [dbo].[KHACHHANG] ON 

INSERT [dbo].[KHACHHANG] ([MAKHACHHANG], [HOTEN], [SODIENTHOAI], [DIACHI], [EMAIL]) VALUES (1, N'Cindie', N'08007129558', N'Sevenoaks', N'KoryBurton@nowhere.com')
INSERT [dbo].[KHACHHANG] ([MAKHACHHANG], [HOTEN], [SODIENTHOAI], [DIACHI], [EMAIL]) VALUES (2, N'Romeo', N'08088573782', N'Willesden', N'Anna.E.Ogle91@example.com')
INSERT [dbo].[KHACHHANG] ([MAKHACHHANG], [HOTEN], [SODIENTHOAI], [DIACHI], [EMAIL]) VALUES (3, N'Addie', N'08089928570', N'Oxford', N'Grubbs395@example.com')
INSERT [dbo].[KHACHHANG] ([MAKHACHHANG], [HOTEN], [SODIENTHOAI], [DIACHI], [EMAIL]) VALUES (4, N'Jarvis', N'08006449181', N'Abbey Wood', N'JakeNegron@example.com')
INSERT [dbo].[KHACHHANG] ([MAKHACHHANG], [HOTEN], [SODIENTHOAI], [DIACHI], [EMAIL]) VALUES (5, N'Valeri', N'08080450965', N'Shaftesbury', N'KelvinPeyton281@nowhere.com')
SET IDENTITY_INSERT [dbo].[KHACHHANG] OFF
GO
SET IDENTITY_INSERT [dbo].[TAIXE] ON 

INSERT [dbo].[TAIXE] ([MATAIXE], [HOTEN], [SODIENTHOAI], [DIACHI], [EMAIL], [CMND], [BIENSOXE], [KHUVUCHOATDONG], [SOTAIKHOANNGANHANG], [CHINHANHNGANHANG], [PHITHUECHAN], [TINHTRANGDONGPHITHUECHAN], [THUNHAP]) VALUES (1, N'Criszilla', N'08004937256', N'Ystrad Meurig', N'CarlenaHorner324@example.com', N'3124989376', N'BSZ2', N'Virginia Water', N'XOBH AF F4 4W5', N'5 Artillery Row', CAST(1585.86 AS Numeric(8, 2)), 1, NULL)
INSERT [dbo].[TAIXE] ([MATAIXE], [HOTEN], [SODIENTHOAI], [DIACHI], [EMAIL], [CMND], [BIENSOXE], [KHUVUCHOATDONG], [SOTAIKHOANNGANHANG], [CHINHANHNGANHANG], [PHITHUECHAN], [TINHTRANGDONGPHITHUECHAN], [THUNHAP]) VALUES (2, N'Thordes', N'08000468253', N'Holmfirth', N'Erwin@example.com', N'9310283459', N'BS8O10', N'Ystrad Meurig', N'RDIC AF 7V', N'32-48 Redchurch Street', CAST(1489.71 AS Numeric(8, 2)), 1, NULL)
INSERT [dbo].[TAIXE] ([MATAIXE], [HOTEN], [SODIENTHOAI], [DIACHI], [EMAIL], [CMND], [BIENSOXE], [KHUVUCHOATDONG], [SOTAIKHOANNGANHANG], [CHINHANHNGANHANG], [PHITHUECHAN], [TINHTRANGDONGPHITHUECHAN], [THUNHAP]) VALUES (3, N'Darvin', N'08089529803', N'Brough', N'xrlh3903@nowhere.com', N'7864472230', N'BSCH', N'Ystrad Meurig', N'OGTH GT 2A 5JG', N'3 St Mark''s Road', CAST(324.33 AS Numeric(8, 2)), 1, NULL)
INSERT [dbo].[TAIXE] ([MATAIXE], [HOTEN], [SODIENTHOAI], [DIACHI], [EMAIL], [CMND], [BIENSOXE], [KHUVUCHOATDONG], [SOTAIKHOANNGANHANG], [CHINHANHNGANHANG], [PHITHUECHAN], [TINHTRANGDONGPHITHUECHAN], [THUNHAP]) VALUES (4, N'Varina', N'08002434723', N'Stoke-sub-Hamdon', N'MildaMclain423@example.com', N'9310283475', N'BSM', N'Fairbourne', N'NXAV AR 7R 34I', N'1 Jamestown Road', CAST(848.85 AS Numeric(8, 2)), 1, NULL)
INSERT [dbo].[TAIXE] ([MATAIXE], [HOTEN], [SODIENTHOAI], [DIACHI], [EMAIL], [CMND], [BIENSOXE], [KHUVUCHOATDONG], [SOTAIKHOANNGANHANG], [CHINHANHNGANHANG], [PHITHUECHAN], [TINHTRANGDONGPHITHUECHAN], [THUNHAP]) VALUES (5, N'Charlena', N'08003740430', N'Halesowen', N'BradSilvia@example.com', N'4024989413', N'BSEAQ0M', N'Fairbourne', N'THUP CH 80 HI3', N'2-8 Tollington Way', CAST(763.04 AS Numeric(8, 2)), 1, NULL)
SET IDENTITY_INSERT [dbo].[TAIXE] OFF
GO
SET IDENTITY_INSERT [dbo].[DONHANG] ON 

INSERT [dbo].[DONHANG] ([MADONHANG], [MAKHACHHANG], [MATAIXE], [DIACHIGIAODEN], [HINHTHUCTHANHTOAN], [TINHTRANGDONHANG], [PHIVANCHUYEN], [TONGPHISANPHAM], [NGAYLAP], [MACHINHANH]) VALUES (1, 3, NULL, N'Fairbourne', N'Tiền mặt', N'Đồng ý', CAST(89.44 AS Numeric(8, 2)), NULL, CAST(N'2021-10-01' AS Date), 4)
INSERT [dbo].[DONHANG] ([MADONHANG], [MAKHACHHANG], [MATAIXE], [DIACHIGIAODEN], [HINHTHUCTHANHTOAN], [TINHTRANGDONHANG], [PHIVANCHUYEN], [TONGPHISANPHAM], [NGAYLAP], [MACHINHANH]) VALUES (2, 3, 3, N'Colne', N'Chuyển khoản', N'Đồng ý', CAST(36.94 AS Numeric(8, 2)), NULL, CAST(N'2021-10-14' AS Date), 29)
INSERT [dbo].[DONHANG] ([MADONHANG], [MAKHACHHANG], [MATAIXE], [DIACHIGIAODEN], [HINHTHUCTHANHTOAN], [TINHTRANGDONHANG], [PHIVANCHUYEN], [TONGPHISANPHAM], [NGAYLAP], [MACHINHANH]) VALUES (3, 3, NULL, N'Ystrad Meurig', N'Chuyển khoản', N'Đồng ý', CAST(90.68 AS Numeric(8, 2)), NULL, CAST(N'2021-11-16' AS Date), 14)
INSERT [dbo].[DONHANG] ([MADONHANG], [MAKHACHHANG], [MATAIXE], [DIACHIGIAODEN], [HINHTHUCTHANHTOAN], [TINHTRANGDONHANG], [PHIVANCHUYEN], [TONGPHISANPHAM], [NGAYLAP], [MACHINHANH]) VALUES (4, 4, 5, N'Knaresborough', N'Chuyển khoản', N'Đồng ý', CAST(84.95 AS Numeric(8, 2)), NULL, CAST(N'2021-10-26' AS Date), 18)
INSERT [dbo].[DONHANG] ([MADONHANG], [MAKHACHHANG], [MATAIXE], [DIACHIGIAODEN], [HINHTHUCTHANHTOAN], [TINHTRANGDONHANG], [PHIVANCHUYEN], [TONGPHISANPHAM], [NGAYLAP], [MACHINHANH]) VALUES (5, 3, 3, N'Virginia Water', N'Chuyển khoản', N'Chưa đồng ý', CAST(79.28 AS Numeric(8, 2)), NULL, CAST(N'2021-10-06' AS Date), 13)
SET IDENTITY_INSERT [dbo].[DONHANG] OFF
GO
INSERT [dbo].[CHITIETDONHANG_SANPHAM] ([MASANPHAM], [MADONHANG], [SOLUONGTUONGUNG], [PHISANPHAM]) VALUES (1, 1, CAST(3 AS Numeric(18, 0)), CAST(187.26 AS Numeric(8, 2)))
INSERT [dbo].[CHITIETDONHANG_SANPHAM] ([MASANPHAM], [MADONHANG], [SOLUONGTUONGUNG], [PHISANPHAM]) VALUES (2, 1, CAST(1 AS Numeric(18, 0)), CAST(22.14 AS Numeric(8, 2)))
INSERT [dbo].[CHITIETDONHANG_SANPHAM] ([MASANPHAM], [MADONHANG], [SOLUONGTUONGUNG], [PHISANPHAM]) VALUES (2, 2, CAST(4 AS Numeric(18, 0)), CAST(197.39 AS Numeric(8, 2)))
INSERT [dbo].[CHITIETDONHANG_SANPHAM] ([MASANPHAM], [MADONHANG], [SOLUONGTUONGUNG], [PHISANPHAM]) VALUES (3, 1, CAST(1 AS Numeric(18, 0)), CAST(25.94 AS Numeric(8, 2)))
INSERT [dbo].[CHITIETDONHANG_SANPHAM] ([MASANPHAM], [MADONHANG], [SOLUONGTUONGUNG], [PHISANPHAM]) VALUES (3, 2, CAST(9 AS Numeric(18, 0)), CAST(161.97 AS Numeric(8, 2)))
INSERT [dbo].[CHITIETDONHANG_SANPHAM] ([MASANPHAM], [MADONHANG], [SOLUONGTUONGUNG], [PHISANPHAM]) VALUES (3, 3, CAST(5 AS Numeric(18, 0)), CAST(50.93 AS Numeric(8, 2)))
INSERT [dbo].[CHITIETDONHANG_SANPHAM] ([MASANPHAM], [MADONHANG], [SOLUONGTUONGUNG], [PHISANPHAM]) VALUES (4, 1, CAST(5 AS Numeric(18, 0)), CAST(144.19 AS Numeric(8, 2)))
INSERT [dbo].[CHITIETDONHANG_SANPHAM] ([MASANPHAM], [MADONHANG], [SOLUONGTUONGUNG], [PHISANPHAM]) VALUES (4, 2, CAST(2 AS Numeric(18, 0)), CAST(165.88 AS Numeric(8, 2)))
INSERT [dbo].[CHITIETDONHANG_SANPHAM] ([MASANPHAM], [MADONHANG], [SOLUONGTUONGUNG], [PHISANPHAM]) VALUES (4, 3, CAST(6 AS Numeric(18, 0)), CAST(4.92 AS Numeric(8, 2)))
INSERT [dbo].[CHITIETDONHANG_SANPHAM] ([MASANPHAM], [MADONHANG], [SOLUONGTUONGUNG], [PHISANPHAM]) VALUES (4, 4, CAST(6 AS Numeric(18, 0)), CAST(7.87 AS Numeric(8, 2)))
INSERT [dbo].[CHITIETDONHANG_SANPHAM] ([MASANPHAM], [MADONHANG], [SOLUONGTUONGUNG], [PHISANPHAM]) VALUES (5, 1, CAST(9 AS Numeric(18, 0)), CAST(113.54 AS Numeric(8, 2)))
INSERT [dbo].[CHITIETDONHANG_SANPHAM] ([MASANPHAM], [MADONHANG], [SOLUONGTUONGUNG], [PHISANPHAM]) VALUES (5, 2, CAST(7 AS Numeric(18, 0)), CAST(78.70 AS Numeric(8, 2)))
INSERT [dbo].[CHITIETDONHANG_SANPHAM] ([MASANPHAM], [MADONHANG], [SOLUONGTUONGUNG], [PHISANPHAM]) VALUES (5, 3, CAST(8 AS Numeric(18, 0)), CAST(111.11 AS Numeric(8, 2)))
INSERT [dbo].[CHITIETDONHANG_SANPHAM] ([MASANPHAM], [MADONHANG], [SOLUONGTUONGUNG], [PHISANPHAM]) VALUES (5, 4, CAST(5 AS Numeric(18, 0)), CAST(186.75 AS Numeric(8, 2)))
INSERT [dbo].[CHITIETDONHANG_SANPHAM] ([MASANPHAM], [MADONHANG], [SOLUONGTUONGUNG], [PHISANPHAM]) VALUES (5, 5, CAST(6 AS Numeric(18, 0)), CAST(82.14 AS Numeric(8, 2)))
INSERT [dbo].[CHITIETDONHANG_SANPHAM] ([MASANPHAM], [MADONHANG], [SOLUONGTUONGUNG], [PHISANPHAM]) VALUES (6, 1, CAST(7 AS Numeric(18, 0)), CAST(26.56 AS Numeric(8, 2)))
INSERT [dbo].[CHITIETDONHANG_SANPHAM] ([MASANPHAM], [MADONHANG], [SOLUONGTUONGUNG], [PHISANPHAM]) VALUES (6, 2, CAST(3 AS Numeric(18, 0)), CAST(4.07 AS Numeric(8, 2)))
INSERT [dbo].[CHITIETDONHANG_SANPHAM] ([MASANPHAM], [MADONHANG], [SOLUONGTUONGUNG], [PHISANPHAM]) VALUES (6, 3, CAST(8 AS Numeric(18, 0)), CAST(174.07 AS Numeric(8, 2)))
INSERT [dbo].[CHITIETDONHANG_SANPHAM] ([MASANPHAM], [MADONHANG], [SOLUONGTUONGUNG], [PHISANPHAM]) VALUES (6, 4, CAST(7 AS Numeric(18, 0)), CAST(78.57 AS Numeric(8, 2)))
INSERT [dbo].[CHITIETDONHANG_SANPHAM] ([MASANPHAM], [MADONHANG], [SOLUONGTUONGUNG], [PHISANPHAM]) VALUES (6, 5, CAST(8 AS Numeric(18, 0)), CAST(139.39 AS Numeric(8, 2)))
INSERT [dbo].[CHITIETDONHANG_SANPHAM] ([MASANPHAM], [MADONHANG], [SOLUONGTUONGUNG], [PHISANPHAM]) VALUES (7, 2, CAST(7 AS Numeric(18, 0)), CAST(73.63 AS Numeric(8, 2)))
INSERT [dbo].[CHITIETDONHANG_SANPHAM] ([MASANPHAM], [MADONHANG], [SOLUONGTUONGUNG], [PHISANPHAM]) VALUES (7, 3, CAST(9 AS Numeric(18, 0)), CAST(3.50 AS Numeric(8, 2)))
INSERT [dbo].[CHITIETDONHANG_SANPHAM] ([MASANPHAM], [MADONHANG], [SOLUONGTUONGUNG], [PHISANPHAM]) VALUES (7, 4, CAST(1 AS Numeric(18, 0)), CAST(55.59 AS Numeric(8, 2)))
INSERT [dbo].[CHITIETDONHANG_SANPHAM] ([MASANPHAM], [MADONHANG], [SOLUONGTUONGUNG], [PHISANPHAM]) VALUES (7, 5, CAST(8 AS Numeric(18, 0)), CAST(109.78 AS Numeric(8, 2)))
INSERT [dbo].[CHITIETDONHANG_SANPHAM] ([MASANPHAM], [MADONHANG], [SOLUONGTUONGUNG], [PHISANPHAM]) VALUES (8, 3, CAST(9 AS Numeric(18, 0)), CAST(102.27 AS Numeric(8, 2)))
INSERT [dbo].[CHITIETDONHANG_SANPHAM] ([MASANPHAM], [MADONHANG], [SOLUONGTUONGUNG], [PHISANPHAM]) VALUES (8, 4, CAST(1 AS Numeric(18, 0)), CAST(181.62 AS Numeric(8, 2)))
INSERT [dbo].[CHITIETDONHANG_SANPHAM] ([MASANPHAM], [MADONHANG], [SOLUONGTUONGUNG], [PHISANPHAM]) VALUES (8, 5, CAST(6 AS Numeric(18, 0)), CAST(181.71 AS Numeric(8, 2)))
INSERT [dbo].[CHITIETDONHANG_SANPHAM] ([MASANPHAM], [MADONHANG], [SOLUONGTUONGUNG], [PHISANPHAM]) VALUES (9, 4, CAST(7 AS Numeric(18, 0)), CAST(114.95 AS Numeric(8, 2)))
INSERT [dbo].[CHITIETDONHANG_SANPHAM] ([MASANPHAM], [MADONHANG], [SOLUONGTUONGUNG], [PHISANPHAM]) VALUES (9, 5, CAST(9 AS Numeric(18, 0)), CAST(153.97 AS Numeric(8, 2)))
INSERT [dbo].[CHITIETDONHANG_SANPHAM] ([MASANPHAM], [MADONHANG], [SOLUONGTUONGUNG], [PHISANPHAM]) VALUES (10, 5, CAST(6 AS Numeric(18, 0)), CAST(200.00 AS Numeric(8, 2)))
GO
INSERT [dbo].[THEODOIHOPDONG] ([MAHOPDONG], [THOIGIANBATDAUCHUKI], [THOIGIANKETTHUCCHUKI], [DOANHSOCUATHANG], [PHIHOAHONGCUATHANG], [TINHTRANGNOPPHI]) VALUES (3, CAST(N'2021-11-22' AS Date), CAST(N'2021-12-22' AS Date), NULL, NULL, NULL)
GO
