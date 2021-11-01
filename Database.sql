/*==============================================================*/
/* DBMS name:      Sybase SQL Anywhere 12                       */
/* Created on:     11/1/2021 9:24:47 PM                         */
/*==============================================================*/


if exists(select 1 from sys.sysforeignkey where role='FK_CHINHANH_DOITAC_CH_DOITAC') then
    alter table CHINHANH
       delete foreign key FK_CHINHANH_DOITAC_CH_DOITAC
end if;

if exists(select 1 from sys.sysforeignkey where role='FK_CHINHANH_HOPDONG_C_HOPDONG') then
    alter table CHINHANH
       delete foreign key FK_CHINHANH_HOPDONG_C_HOPDONG
end if;

if exists(select 1 from sys.sysforeignkey where role='FK_CHINHANH_CHINHANH__CHINHANH') then
    alter table CHINHANH_SANPHAM
       delete foreign key FK_CHINHANH_CHINHANH__CHINHANH
end if;

if exists(select 1 from sys.sysforeignkey where role='FK_CHINHANH_CHINHANH__SANPHAM') then
    alter table CHINHANH_SANPHAM
       delete foreign key FK_CHINHANH_CHINHANH__SANPHAM
end if;

if exists(select 1 from sys.sysforeignkey where role='FK_CHITIETD_CHITIETDO_SANPHAM') then
    alter table CHITIETDONHANG_SANPHAM
       delete foreign key FK_CHITIETD_CHITIETDO_SANPHAM
end if;

if exists(select 1 from sys.sysforeignkey where role='FK_CHITIETD_CHITIETDO_DONHANG') then
    alter table CHITIETDONHANG_SANPHAM
       delete foreign key FK_CHITIETD_CHITIETDO_DONHANG
end if;

if exists(select 1 from sys.sysforeignkey where role='FK_DONHANG_KHACHHANG_KHACHHAN') then
    alter table DONHANG
       delete foreign key FK_DONHANG_KHACHHANG_KHACHHAN
end if;

if exists(select 1 from sys.sysforeignkey where role='FK_DONHANG_TAIXE_DON_TAIXE') then
    alter table DONHANG
       delete foreign key FK_DONHANG_TAIXE_DON_TAIXE
end if;

if exists(select 1 from sys.sysforeignkey where role='FK_HOPDONG_DOITAC_HO_DOITAC') then
    alter table HOPDONG
       delete foreign key FK_HOPDONG_DOITAC_HO_DOITAC
end if;

if exists(select 1 from sys.sysforeignkey where role='FK_TAIXE_KHACHHANG_KHACHHAN') then
    alter table TAIXE
       delete foreign key FK_TAIXE_KHACHHANG_KHACHHAN
end if;

if exists(select 1 from sys.sysforeignkey where role='FK_THEODOIH_HOPDONG_T_HOPDONG') then
    alter table THEODOIHOPDONG
       delete foreign key FK_THEODOIH_HOPDONG_T_HOPDONG
end if;

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
   MACHINHANH           char(10)                       not null,
   MADOITAC             char(10)                       not null,
   MAHOPDONG            char(10)                       not null,
   DIACHICHINHANH       varchar(255)                   not null,
   constraint PK_CHINHANH primary key (MACHINHANH)
);

/*==============================================================*/
/* Table: CHINHANH_SANPHAM                                      */
/*==============================================================*/
create table CHINHANH_SANPHAM 
(
   MACHINHANH           char(10)                       not null,
   MASANPHAM            char(10)                       not null,
   SOLUONGTON           numeric                        null,
   constraint PK_CHINHANH_SANPHAM primary key clustered (MACHINHANH, MASANPHAM)
);

/*==============================================================*/
/* Table: CHITIETDONHANG_SANPHAM                                */
/*==============================================================*/
create table CHITIETDONHANG_SANPHAM 
(
   MASANPHAM            char(10)                       not null,
   MADONHANG            char(10)                       not null,
   SOLUONGTUONGUNG      numeric                        not null,
   PHI_SANPHAM          char(10)                       not null,
   constraint PK_CHITIETDONHANG_SANPHAM primary key (MASANPHAM, MADONHANG)
);

/*==============================================================*/
/* Table: DOITAC                                                */
/*==============================================================*/
create table DOITAC 
(
   MADOITAC             char(10)                       not null,
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
   MADONHANG            char(10)                       not null,
   MAKHACHHANG          char(10)                       not null,
   TAI_MAKHACHHANG      char(10)                       not null,
   DIACHIGIAODEN        varchar(255)                   null,
   HINHTHUCTHANHTOAN    varchar(255)                   null,
   TINHTRANGDONHANG     varchar(255)                   null,
   ATTRIBUTE_35         numeric(8,2)                   null,
   TONGPHISANPHAM       numeric(8,2)                   null,
   constraint PK_DONHANG primary key (MADONHANG)
);

/*==============================================================*/
/* Table: HOPDONG                                               */
/*==============================================================*/
create table HOPDONG 
(
   MAHOPDONG            char(10)                       not null,
   MADOITAC             char(10)                       not null,
   MASOTHUE             char(10)                       null,
   NGUOIDAIDIEN         varchar(255)                   null,
   SOCHINHANHDANGKI     numeric                        null,
   PHANTRAMHOAHONG      float                          null,
   THOIGIANHIEULUC      date                           null,
   TINHTRANGPHIKICHHOAT smallint                       null,
   constraint PK_HOPDONG primary key (MAHOPDONG)
);

/*==============================================================*/
/* Table: KHACHHANG                                             */
/*==============================================================*/
create table KHACHHANG 
(
   MAKHACHHANG          char(10)                       not null,
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
   MASANPHAM            char(10)                       not null,
   TENSANPHAM           varchar(255)                   null,
   GIASANPHAM           numeric(8,2)                   null,
   constraint PK_SANPHAM primary key (MASANPHAM)
);

/*==============================================================*/
/* Table: TAIXE                                                 */
/*==============================================================*/
create table TAIXE 
(
   MAKHACHHANG          char(10)                       not null,
   HOTEN                varchar(255)                   null,
   SODIENTHOAI          varchar(20)                    null,
   DIACHI               varchar(255)                   null,
   EMAIL                varchar(255)                   null,
   CMND                 char(10)                       null,
   BIENSOXE             char(10)                       null,
   KHUVUCHOATDONG       varchar(255)                   null,
   SOTAIKHOANNGANHANG   varchar(20)                    null,
   CHINHANHNGANHANG     varchar(255)                   null,
   PHITHUECHAN          numeric(8,2)                   null,
   TINHTRANGDONGPHITHUECHAN varchar(255)                   null,
   THUNHAP              numeric(8,2)                   null,
   constraint PK_TAIXE primary key clustered (MAKHACHHANG)
);

/*==============================================================*/
/* Table: THEODOIHOPDONG                                        */
/*==============================================================*/
create table THEODOIHOPDONG 
(
   MAHOPDONG            char(10)                       not null,
   THOIGIANBATDAUCHUKI  date                           null,
   THOIGIANKETTHUCCHUKI date                           null,
   DOANHSOCUATHANG      numeric(8,2)                   null,
   PHIHOAHONGCUATHANG   numeric(8,2)                   null,
   TINHTRANGNOPPHI      smallint                       null
);

alter table CHINHANH
   add constraint FK_CHINHANH_DOITAC_CH_DOITAC foreign key (MADOITAC)
      references DOITAC (MADOITAC)
      on update restrict
      on delete restrict;

alter table CHINHANH
   add constraint FK_CHINHANH_HOPDONG_C_HOPDONG foreign key (MAHOPDONG)
      references HOPDONG (MAHOPDONG)
      on update restrict
      on delete restrict;

alter table CHINHANH_SANPHAM
   add constraint FK_CHINHANH_CHINHANH__CHINHANH foreign key (MACHINHANH)
      references CHINHANH (MACHINHANH)
      on update restrict
      on delete restrict;

alter table CHINHANH_SANPHAM
   add constraint FK_CHINHANH_CHINHANH__SANPHAM foreign key (MASANPHAM)
      references SANPHAM (MASANPHAM)
      on update restrict
      on delete restrict;

alter table CHITIETDONHANG_SANPHAM
   add constraint FK_CHITIETD_CHITIETDO_SANPHAM foreign key (MASANPHAM)
      references SANPHAM (MASANPHAM)
      on update restrict
      on delete restrict;

alter table CHITIETDONHANG_SANPHAM
   add constraint FK_CHITIETD_CHITIETDO_DONHANG foreign key (MADONHANG)
      references DONHANG (MADONHANG)
      on update restrict
      on delete restrict;

alter table DONHANG
   add constraint FK_DONHANG_KHACHHANG_KHACHHAN foreign key (MAKHACHHANG)
      references KHACHHANG (MAKHACHHANG)
      on update restrict
      on delete restrict;

alter table DONHANG
   add constraint FK_DONHANG_TAIXE_DON_TAIXE foreign key (TAI_MAKHACHHANG)
      references TAIXE (MAKHACHHANG)
      on update restrict
      on delete restrict;

alter table HOPDONG
   add constraint FK_HOPDONG_DOITAC_HO_DOITAC foreign key (MADOITAC)
      references DOITAC (MADOITAC)
      on update restrict
      on delete restrict;

alter table TAIXE
   add constraint FK_TAIXE_KHACHHANG_KHACHHAN foreign key (MAKHACHHANG)
      references KHACHHANG (MAKHACHHANG)
      on update restrict
      on delete restrict;

alter table THEODOIHOPDONG
   add constraint FK_THEODOIH_HOPDONG_T_HOPDONG foreign key (MAHOPDONG)
      references HOPDONG (MAHOPDONG)
      on update restrict
      on delete restrict;

