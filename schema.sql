-- ====================================================================
-- HỆ THỐNG QUẢN LÝ ĐIỂM HỌC TẬP - CAO ĐẲNG CÔNG NGHIỆP THÁI NGUYÊN
-- KỊCH BẢN TẠO CƠ SỞ DỮ LIỆU (DATABASE DDL SCRIPT - 7 BƯỚC / 4 TÁC NHÂN)
-- ====================================================================

DROP DATABASE IF EXISTS quan_ly_diem_cdcn;
CREATE DATABASE quan_ly_diem_cdcn CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE quan_ly_diem_cdcn;

-- 1. BẢNG NGƯỜI DÙNG (TÀI KHOẢN CÁN BỘ / NHÀ GIÁO - 4 VAI TRÒ CHUẨN)
CREATE TABLE NGUOI_DUNG (
    ma_nguoi_dung VARCHAR(20) PRIMARY KEY,
    ho_va_ten VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    mat_khau VARCHAR(255) NOT NULL,
    vai_tro ENUM('Nhà giáo giảng dạy', 'Nhà giáo chấm thi', 'Khoa chuyên môn', 'Phòng ĐT&NCKH') NOT NULL,
    so_dien_thoai VARCHAR(15) NULL
);

-- 2. BẢNG MÔN HỌC / MÔ ĐUN
CREATE TABLE MON_HOC_MO_DUN (
    ma_mon VARCHAR(20) PRIMARY KEY,
    ten_mon VARCHAR(150) NOT NULL,
    so_tin_chi INT NOT NULL CHECK (so_tin_chi > 0),
    he_so_tbc FLOAT DEFAULT 0.4,
    he_so_thi FLOAT DEFAULT 0.6
);

-- 3. BẢNG LỚP HỌC
CREATE TABLE LOP_HOC (
    ma_lop VARCHAR(20) PRIMARY KEY,
    ten_lop VARCHAR(100) NOT NULL,
    khoa_hoc VARCHAR(20) NOT NULL,
    hoc_ky VARCHAR(10) NOT NULL,
    nam_hoc VARCHAR(20) NOT NULL
);

-- 4. BẢNG HỌC SINH SINH VIÊN (HỒ SƠ SINH VIÊN)
CREATE TABLE HOC_SINH_SINH_VIEN (
    ma_hssv VARCHAR(20) PRIMARY KEY,
    ho_va_ten VARCHAR(100) NOT NULL,
    ngay_sinh DATE NOT NULL,
    ma_lop VARCHAR(20) NOT NULL,
    FOREIGN KEY (ma_lop) REFERENCES LOP_HOC(ma_lop) ON DELETE CASCADE
);

-- 5. BẢNG PHÂN CÔNG GIẢNG DẠY & CHẤM THI
CREATE TABLE PHAN_CONG_GIANG_DAY (
    ma_phan_cong VARCHAR(30) PRIMARY KEY,
    ma_lop VARCHAR(20) NOT NULL,
    ma_mon VARCHAR(20) NOT NULL,
    ma_gvg VARCHAR(20) NOT NULL,
    ma_gvct VARCHAR(20) NOT NULL,
    FOREIGN KEY (ma_lop) REFERENCES LOP_HOC(ma_lop),
    FOREIGN KEY (ma_mon) REFERENCES MON_HOC_MO_DUN(ma_mon),
    FOREIGN KEY (ma_gvg) REFERENCES NGUOI_DUNG(ma_nguoi_dung),
    FOREIGN KEY (ma_gvct) REFERENCES NGUOI_DUNG(ma_nguoi_dung)
);

-- 6. BẢNG PHIẾU KẾT QUẢ HỌC TẬP (BIỂU MẪU BM/QLĐ/ĐTNCKH/03)
CREATE TABLE PHIEU_KET_QUA_HOC_TAP (
    ma_phieu VARCHAR(30) PRIMARY KEY,
    ma_phan_cong VARCHAR(30) NOT NULL,
    lan_thi INT NOT NULL DEFAULT 1 CHECK (lan_thi IN (1, 2)),
    hinh_thuc_thi VARCHAR(50) NOT NULL,
    trang_thai ENUM('Khoi_tao', 'Da_xet_dieu_kien', 'Da_ghep_diem_thi', 'Khoa_da_duyet', 'Da_gui_Phong_DTNCKH', 'Da_tong_hop') NOT NULL DEFAULT 'Khoi_tao',
    ngay_lap DATE DEFAULT (CURRENT_DATE),
    ngay_khoa_duyet DATE NULL,
    ngay_gui_phong DATE NULL,
    ngay_tong_hop DATE NULL,
    FOREIGN KEY (ma_phan_cong) REFERENCES PHAN_CONG_GIANG_DAY(ma_phan_cong)
);

-- 7. BẢNG SỔ ĐIỂM CHI TIẾT (BM/01, BM/02, BM/03)
CREATE TABLE SO_DIEM_CHI_TIET (
    id INT AUTO_INCREMENT PRIMARY KEY,
    ma_phieu VARCHAR(30) NOT NULL,
    ma_hssv VARCHAR(20) NOT NULL,
    diem_tx FLOAT NULL CHECK (diem_tx BETWEEN 0.0 AND 10.0),
    diem_dk FLOAT NULL CHECK (diem_dk BETWEEN 0.0 AND 10.0),
    diem_tbc_kt FLOAT NULL CHECK (diem_tbc_kt BETWEEN 0.0 AND 10.0),
    dieu_kien_du_thi BOOLEAN DEFAULT FALSE,
    diem_thi_lan_1 FLOAT NULL CHECK (diem_thi_lan_1 BETWEEN 0.0 AND 10.0),
    diem_thi_lan_2 FLOAT NULL CHECK (diem_thi_lan_2 BETWEEN 0.0 AND 10.0),
    diem_tong_ket_10 FLOAT NULL CHECK (diem_tong_ket_10 BETWEEN 0.0 AND 10.0),
    diem_chu VARCHAR(5) NULL,
    diem_thang_4 FLOAT NULL CHECK (diem_thang_4 BETWEEN 0.0 AND 4.0),
    ghi_chu VARCHAR(255) NULL,
    FOREIGN KEY (ma_phieu) REFERENCES PHIEU_KET_QUA_HOC_TAP(ma_phieu) ON DELETE CASCADE,
    FOREIGN KEY (ma_hssv) REFERENCES HOC_SINH_SINH_VIEN(ma_hssv)
);

-- ====================================================================
-- CHÈN DỮ LIỆU MẪU (TEST SEED DATA)
-- ====================================================================

-- 4 Tác nhân mẫu
INSERT INTO NGUOI_DUNG (ma_nguoi_dung, ho_va_ten, email, mat_khau, vai_tro) VALUES
('GV01', 'Nguyễn Văn An', 'an.nguyen@cdcn.edu.vn', '$2b$10$hashed_password_gvg', 'Nhà giáo giảng dạy'),
('GV02', 'Phạm Minh Dũng', 'dung.pham@cdcn.edu.vn', '$2b$10$hashed_password_gvct', 'Nhà giáo chấm thi'),
('K01',  'Trần Văn Khoa',  'khoa.tran@cdcn.edu.vn', '$2b$10$hashed_password_kcm',  'Khoa chuyên môn'),
('DT01', 'Cán bộ Đào tạo', 'daotao@cdcn.edu.vn',   '$2b$10$hashed_password_dtnckh', 'Phòng ĐT&NCKH');

-- Môn học mẫu
INSERT INTO MON_HOC_MO_DUN (ma_mon, ten_mon, so_tin_chi) VALUES
('MH01', 'Lập trình Web', 3);

-- Lớp học mẫu
INSERT INTO LOP_HOC (ma_lop, ten_lop, khoa_hoc, hoc_ky, nam_hoc) VALUES
('C22-CNTT1', 'Công nghệ thông tin 1', 'K2022-2025', 'HK1', '2025-2026');

-- 3 Sinh viên mẫu
INSERT INTO HOC_SINH_SINH_VIEN (ma_hssv, ho_va_ten, ngay_sinh, ma_lop) VALUES
('20210001', 'Nguyễn Văn A', '2004-05-12', 'C22-CNTT1'),
('20210002', 'Trần Thị B',  '2004-08-20', 'C22-CNTT1'),
('20210003', 'Lê Văn C',    '2004-11-03', 'C22-CNTT1');

-- Phân công
INSERT INTO PHAN_CONG_GIANG_DAY (ma_phan_cong, ma_lop, ma_mon, ma_gvg, ma_gvct) VALUES
('PC-WEB-01', 'C22-CNTT1', 'MH01', 'GV01', 'GV02');

-- Phiếu điểm mẫu
INSERT INTO PHIEU_KET_QUA_HOC_TAP (ma_phieu, ma_phan_cong, lan_thi, hinh_thuc_thi, trang_thai) VALUES
('PKQ-WEB-01', 'PC-WEB-01', 1, 'Thực hành', 'Khoi_tao');

-- Chi tiết điểm
INSERT INTO SO_DIEM_CHI_TIET (ma_phieu, ma_hssv, diem_tx, diem_dk, diem_tbc_kt, dieu_kien_du_thi, diem_thi_lan_1, diem_tong_ket_10, diem_chu, diem_thang_4) VALUES
('PKQ-WEB-01', '20210001', 8.0, 7.0, 7.3, TRUE,  8.0, 7.7, 'B', 3.0),
('PKQ-WEB-01', '20210002', 4.0, 3.0, 3.3, FALSE, NULL, NULL, 'F', 0.0),
('PKQ-WEB-01', '20210003', 9.0, 9.0, 9.0, TRUE,  9.5, 9.3, 'A', 4.0);
