/*==============================================================*/
/* DBMS name:      Sybase SQL Anywhere 12                       */
/* Created on:     11/1/2021 9:24:47 PM                         */
/*==============================================================*/
USE [master]
GO

alter DATABASE [QLDatChuyenHangOnl] set single_user with rollback IMMEDIATE
GO

DROP DATABASE IF EXISTS [QLDatChuyenHangOnl]
GO

CREATE DATABASE [QLDatChuyenHangOnl]
GO

Use [QLDatChuyenHangOnl]
GO

if exists(select 1 from sys.foreign_keys where name='FK_CHINHANH_DOITAC_CH_DOITAC')
Begin
    alter table CHINHANH 
	DROP CONSTRAINT FK_CHINHANH_DOITAC_CH_DOITAC
End

if exists(select 1 from sys.foreign_keys where name='FK_CHINHANH_HOPDONG_C_HOPDONG')
Begin
    alter table CHINHANH
	DROP CONSTRAINT FK_CHINHANH_HOPDONG_C_HOPDONG
End

if exists(select 1 from sys.foreign_keys where name='FK_CHINHANH_CHINHANH__CHINHANH')
Begin
    alter table CHINHANH_SANPHAM
	DROP CONSTRAINT FK_CHINHANH_CHINHANH__CHINHANH
end

if exists(select 1 from sys.foreign_keys where name='FK_CHINHANH_CHINHANH__SANPHAM')
Begin
    alter table CHINHANH_SANPHAM
	DROP CONSTRAINT FK_CHINHANH_CHINHANH__SANPHAM
end

if exists(select 1 from sys.foreign_keys where name='FK_CHITIETD_CHITIETDO_SANPHAM')
Begin
    alter table CHITIETDONHANG_SANPHAM
    DROP CONSTRAINT FK_CHITIETD_CHITIETDO_SANPHAM
end

if exists(select 1 from sys.foreign_keys where name='FK_CHITIETD_CHITIETDO_DONHANG')
Begin
    alter table CHITIETDONHANG_SANPHAM
	DROP CONSTRAINT FK_CHITIETD_CHITIETDO_DONHANG
end

if exists(select 1 from sys.foreign_keys where name='FK_DONHANG_KHACHHANG_KHACHHAN')
Begin
    alter table DONHANG
	DROP CONSTRAINT FK_DONHANG_KHACHHANG_KHACHHAN
end

if exists(select 1 from sys.foreign_keys where name='FK_DONHANG_TAIXE_DON_TAIXE')
Begin
    alter table DONHANG
	DROP CONSTRAINT FK_DONHANG_TAIXE_DON_TAIXE
end

if exists(select 1 from sys.foreign_keys where name='FK_HOPDONG_DOITAC_HO_DOITAC')
Begin
    alter table HOPDONG
	DROP CONSTRAINT FK_HOPDONG_DOITAC_HO_DOITAC
end

if exists(select 1 from sys.foreign_keys where name='FK_TAIXE_KHACHHANG_KHACHHAN')
Begin
    alter table TAIXE
	DROP CONSTRAINT FK_TAIXE_KHACHHANG_KHACHHAN
end

if exists(select 1 from sys.foreign_keys where name='FK_THEODOIH_HOPDONG_T_HOPDONG')
Begin
    alter table THEODOIHOPDONG
	DROP CONSTRAINT FK_THEODOIH_HOPDONG_T_HOPDONG
end

drop table if exists CHINHANH;

drop table if exists CHINHANH_SANPHAM;

drop table if exists CHITIETDONHANG_SANPHAM;

drop table if exists DOITAC;

drop table if exists DONHANG;

drop table if exists HOPDONG;

drop table if exists KHACHHANG;

drop table if exists SANPHAM;

drop table if exists TAIXE;

drop table if exists THEODOIHOPDONG;

/*==============================================================*/
/* Table: CHINHANH                                              */
/*==============================================================*/
create table CHINHANH 
(
   MACHINHANH           int IDENTITY(1,1)			   not null,
   MADOITAC             int                            null,
   MAHOPDONG            int                            null,
   DIACHICHINHANH       varchar(255)                   not null,
   constraint PK_CHINHANH primary key (MACHINHANH)
);

/*==============================================================*/
/* Table: CHINHANH_SANPHAM                                      */
/*==============================================================*/
create table CHINHANH_SANPHAM 
(
   MACHINHANH           int                           not null,
   MASANPHAM            int                           not null,
   SOLUONGTON           numeric                        null,
   constraint PK_CHINHANH_SANPHAM primary key clustered (MACHINHANH, MASANPHAM)
);

/*==============================================================*/
/* Table: CHITIETDONHANG_SANPHAM                                */
/*==============================================================*/
create table CHITIETDONHANG_SANPHAM 
(
   MASANPHAM            int                            not null,
   MADONHANG            bigint                        not null,
   SOLUONGTUONGUNG      numeric                        not null,
   PHISANPHAM           numeric(8,2)                   not null,
   constraint PK_CHITIETDONHANG_SANPHAM primary key (MASANPHAM, MADONHANG)
);

/*==============================================================*/
/* Table: DOITAC                                                */
/*==============================================================*/
create table DOITAC 
(
   MADOITAC             int IDENTITY(1,1)			   not null,
   TENDOITAC            varchar(255)                   null,
   NGUOIDAIDIEN         varchar(255)                   null,
   SOCHINHANH           numeric                        null,
   DIACHIKINHDOANH      varchar(255)                   null,
   THANHPHO             varchar(255)                   null,
   QUAN                 varchar(255)                   null,
   SOLUONGDONHANGMOINGAY numeric                        null,
   LOAIHANGVANCHUYEN    varchar(255)                   null,
   SODIENTHOAI          varchar(20)                    null,
   EMAIL                varchar(255)                   null,
   constraint PK_DOITAC primary key (MADOITAC)
);

/*==============================================================*/
/* Table: DONHANG                                               */
/*==============================================================*/
create table DONHANG 
(
   MADONHANG            bigint IDENTITY(1,1)		   not null,
   MAKHACHHANG          int                            not null,
   MATAIXE              int                            null,
   DIACHIGIAODEN        varchar(255)                   null,
   HINHTHUCTHANHTOAN    varchar(255)                   null,
   TINHTRANGDONHANG     varchar(255)                   null,
   PHIVANCHUYEN         numeric(8,2)                   null,
   TONGPHISANPHAM       numeric(8,2)                   null,
   constraint PK_DONHANG primary key (MADONHANG)
);

/*==============================================================*/
/* Table: HOPDONG                                               */
/*==============================================================*/
create table HOPDONG 
(
   MAHOPDONG            int IDENTITY(1,1)			   not null,
   MADOITAC             int                           not null,
   MASOTHUE             varchar(10)                       null,
   NGUOIDAIDIEN         varchar(255)                   null,
   SOCHINHANHDANGKI     numeric                        null,
   PHANTRAMHOAHONG      float                          null,
   THOIGIANHIEULUC      int                            null,
   TINHTRANGPHIKICHHOAT bit                            null
   constraint PK_HOPDONG primary key (MAHOPDONG)
);

/*==============================================================*/
/* Table: KHACHHANG                                             */
/*==============================================================*/
create table KHACHHANG 
(
   MAKHACHHANG          int IDENTITY(1,1)			   not null,
   HOTEN                varchar(255)                   null,
   SODIENTHOAI          varchar(20)                    null,
   DIACHI               varchar(255)                   null,
   EMAIL                varchar(255)                   null,
   constraint PK_KHACHHANG primary key (MAKHACHHANG)
);

/*==============================================================*/
/* Table: SANPHAM                                               */
/*==============================================================*/
create table SANPHAM 
(
   MASANPHAM            int IDENTITY(1,1)			   not null,
   TENSANPHAM           varchar(255)                   null,
   GIASANPHAM           numeric(8,2)                   null,
   constraint PK_SANPHAM primary key (MASANPHAM)
);

/*==============================================================*/
/* Table: TAIXE                                                 */
/*==============================================================*/
create table TAIXE 
(
   MATAIXE	            int IDENTITY(1,1)			   not null,
   HOTEN                varchar(255)                   null,
   SODIENTHOAI          varchar(20)                    null,
   DIACHI               varchar(255)                   null,
   EMAIL                varchar(255)                   null,
   CMND                 varchar(10)                    null,
   BIENSOXE             varchar(10)                    null,
   KHUVUCHOATDONG       varchar(255)                   null,
   SOTAIKHOANNGANHANG   varchar(20)                    null,
   CHINHANHNGANHANG     varchar(255)                   null,
   PHITHUECHAN          numeric(8,2)                   null,
   TINHTRANGDONGPHITHUECHAN varchar(255)               null,
   THUNHAP              numeric(8,2)                   null,
   constraint PK_TAIXE primary key clustered (MATAIXE)
);

/*==============================================================*/
/* Table: THEODOIHOPDONG                                        */
/*==============================================================*/
create table THEODOIHOPDONG 
(
   MAHOPDONG            int                            not null,
   THOIGIANBATDAUCHUKI  date                           null,
   THOIGIANKETTHUCCHUKI date                           null,
   DOANHSOCUATHANG      numeric(8,2)                   null,
   PHIHOAHONGCUATHANG   numeric(8,2)                   null,
   TINHTRANGNOPPHI      BIT                            NULL,
);

alter table CHINHANH
   add constraint FK_CHINHANH_DOITAC_CH_DOITAC foreign key (MADOITAC)
      references DOITAC (MADOITAC)
      on update cascade

alter table CHINHANH
   add constraint FK_CHINHANH_HOPDONG_C_HOPDONG foreign key (MAHOPDONG)
      references HOPDONG (MAHOPDONG)
      on update cascade

alter table CHINHANH_SANPHAM
   add constraint FK_CHINHANH_CHINHANH__CHINHANH foreign key (MACHINHANH)
      references CHINHANH (MACHINHANH)
      on update cascade

alter table CHINHANH_SANPHAM
   add constraint FK_CHINHANH_CHINHANH__SANPHAM foreign key (MASANPHAM)
      references SANPHAM (MASANPHAM)
      on update cascade

alter table CHITIETDONHANG_SANPHAM
   add constraint FK_CHITIETD_CHITIETDO_SANPHAM foreign key (MASANPHAM)
      references SANPHAM (MASANPHAM)
      on update cascade

alter table CHITIETDONHANG_SANPHAM
   add constraint FK_CHITIETD_CHITIETDO_DONHANG foreign key (MADONHANG)
      references DONHANG (MADONHANG)
      on update cascade

alter table DONHANG
   add constraint FK_DONHANG_KHACHHANG_KHACHHAN foreign key (MAKHACHHANG)
      references KHACHHANG (MAKHACHHANG)
      on update cascade

alter table DONHANG
   add constraint FK_DONHANG_TAIXE_DON_TAIXE foreign key (MATAIXE)
      references TAIXE (MATAIXE)
      on update cascade

alter table HOPDONG
   add constraint FK_HOPDONG_DOITAC_HO_DOITAC foreign key (MADOITAC)
      references DOITAC (MADOITAC)

alter table THEODOIHOPDONG
   add constraint FK_THEODOIH_HOPDONG_T_HOPDONG foreign key (MAHOPDONG)
      references HOPDONG (MAHOPDONG)
      on update cascade