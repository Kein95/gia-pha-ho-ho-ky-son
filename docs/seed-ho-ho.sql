-- ============================================================
-- SEED DATA: GIA PHẢ HỌ HỒ
-- Địa phương: Sơn Thọ, Kỳ Thọ, Kỳ Anh, Hà Tĩnh
-- 8 Đời, ~130+ thành viên
-- Nguồn: Bảng gia phả treo tường + giấy viết tay
-- ============================================================

TRUNCATE TABLE relationships CASCADE;
TRUNCATE TABLE person_details_private CASCADE;
TRUNCATE TABLE persons CASCADE;

-- ============================================================
-- ĐỜI 1 — THỦY TỔ
-- ============================================================
INSERT INTO persons (id, full_name, gender, is_deceased, generation, birth_order, note) VALUES
('01000000-0000-0000-0000-000000000001', 'Hồ Khang', 'male', TRUE, 1, NULL, 'Thủy tổ dòng họ Hồ. Ngày giỗ 19/5.');

-- ============================================================
-- ĐỜI 2 — CON CỦA ÔNG TỔ
-- ============================================================
INSERT INTO persons (id, full_name, gender, is_deceased, generation, birth_order, note) VALUES
('02000000-0000-0000-0000-000000000001', 'Hồ Tạo', 'male', TRUE, 2, 1, 'Ngày giỗ 20/6.'),
('02000000-0000-0000-0000-000000000002', 'Hồ Thị Thịnh', 'female', TRUE, 2, NULL, 'Vợ ông Hồ Tạo. Ngày giỗ 12/9.'),
('02000000-0000-0000-0000-000000000003', 'Nguyễn Thị Loan', 'female', TRUE, 2, NULL, 'Vợ thứ ông Hồ Tạo. Ngày giỗ 26/11.');

-- ============================================================
-- ĐỜI 3 — CHÁU NỘI (Con của Hồ Tạo)
-- ============================================================
INSERT INTO persons (id, full_name, gender, is_deceased, generation, birth_order, note) VALUES
-- Con trai
('03000000-0000-0000-0000-000000000001', 'Hồ Vợi', 'male', TRUE, 3, 1, 'Con trưởng. Ngày giỗ 8/3.'),
('03000000-0000-0000-0000-000000000002', 'Hồ Tuần', 'male', TRUE, 3, 2, 'Con thứ (1). Ngày giỗ 02/3.'),
('03000000-0000-0000-0000-000000000003', 'Hồ Tức', 'male', TRUE, 3, 3, 'Con thứ (2). Ngày giỗ 2/1. Vợ: Thị Bảng.'),
('03000000-0000-0000-0000-000000000004', 'Hồ Tường', 'male', TRUE, 3, 4, 'Con thứ (2). Ngày giỗ 2/1.'),
('03000000-0000-0000-0000-000000000005', 'Hồ Suyên', 'male', TRUE, 3, 5, 'Con thứ (2).'),
('03000000-0000-0000-0000-000000000006', 'Hồ Bầu', 'male', TRUE, 3, 6, 'Con thứ (2). Ngày giỗ 18/8.'),
('03000000-0000-0000-0000-000000000007', 'Hồ Thuyết', 'male', TRUE, 3, 7, 'Con thứ (2). Ngày giỗ 15/5. Vợ: Thị Thiệp.'),
-- Vợ dâu đời 3
('03000000-0000-0000-0000-000000000010', 'Thị Bảng', 'female', TRUE, 3, NULL, 'Vợ ông Hồ Tức.'),
('03000000-0000-0000-0000-000000000011', 'Thị Thiệp', 'female', TRUE, 3, NULL, 'Vợ ông Hồ Thuyết.');

-- ============================================================
-- ĐỜI 4 — CHẮT (Con đời 3)
-- ============================================================
INSERT INTO persons (id, full_name, gender, is_deceased, generation, birth_order, note) VALUES
-- Con của Hồ Vợi
('04000000-0000-0000-0000-000000000001', 'Hồ Ái', 'female', TRUE, 4, 1, 'Con ông Hồ Vợi. Ngày giỗ 1/7. Tên khác: Thị Nhiệm. Ngày giỗ 03/11.'),
('04000000-0000-0000-0000-000000000002', 'Hồ Xình', 'male', TRUE, 4, 2, 'Con ông Hồ Vợi. Ngày giỗ 28/10.'),

-- Con của Hồ Tuần
('04000000-0000-0000-0000-000000000003', 'Hồ Huyên', 'male', TRUE, 4, 1, 'Con ông Hồ Tuần. Ngày giỗ 2/2.'),
('04000000-0000-0000-0000-000000000004', 'Hồ Kiệm', 'male', TRUE, 4, 2, 'Con ông Hồ Tuần. Ngày giỗ 20/12.'),

-- Con của Hồ Tức
('04000000-0000-0000-0000-000000000005', 'Hồ Chuyên', 'male', TRUE, 4, 1, 'Con ông Hồ Tức. Ngày giỗ 12/7.'),
('04000000-0000-0000-0000-000000000006', 'Hồ Nhuyên', 'male', TRUE, 4, 2, 'Con ông Hồ Tức. Ngày giỗ 20/10.'),
('04000000-0000-0000-0000-000000000007', 'Hồ Tiệm', 'male', TRUE, 4, 3, 'Con ông Hồ Tức.'),

-- Con của Hồ Tường
('04000000-0000-0000-0000-000000000008', 'Hồ Biểm', 'male', TRUE, 4, 1, 'Con ông Hồ Tường. Thị Thao.'),
('04000000-0000-0000-0000-000000000009', 'Hồ Niệm', 'male', TRUE, 4, 2, 'Con ông Hồ Tường. Ngày giỗ 26/6. Vợ: Thị Nhuyên.'),

-- Con của Hồ Bầu
('04000000-0000-0000-0000-000000000010', 'Hồ Trần', 'male', TRUE, 4, 1, 'Con ông Hồ Bầu.'),

-- Con của Hồ Thuyết
('04000000-0000-0000-0000-000000000011', 'Hồ Hải', 'male', TRUE, 4, 1, 'Con ông Hồ Thuyết.'),
('04000000-0000-0000-0000-000000000012', 'Hồ Luyện', 'female', TRUE, 4, 2, 'Con ông Hồ Thuyết. Tên khác: Thị Chung.'),
('04000000-0000-0000-0000-000000000013', 'Hồ Huyền', 'male', TRUE, 4, 3, 'Con ông Hồ Thuyết.'),

-- Vợ dâu đời 4
('04000000-0000-0000-0000-000000000020', 'Thị Nhiệm', 'female', TRUE, 4, NULL, 'Tên khác của bà Hồ Ái.'),
('04000000-0000-0000-0000-000000000021', 'Thị Thao', 'female', TRUE, 4, NULL, 'Vợ ông Hồ Biểm.'),
('04000000-0000-0000-0000-000000000022', 'Thị Nhuyên', 'female', TRUE, 4, NULL, 'Vợ ông Hồ Niệm.');

-- ============================================================
-- ĐỜI 5 — (Con đời 4)
-- ============================================================
INSERT INTO persons (id, full_name, gender, is_deceased, generation, birth_order, note) VALUES
-- Con của Hồ Xình → Hồ Nhường
('05000000-0000-0000-0000-000000000001', 'Hồ Nhường', 'male', TRUE, 5, 1, 'Con ông Hồ Xình. Ngày giỗ 6/1. Vợ: Thị Kiên.'),
('05000000-0000-0000-0000-000000000002', 'Thị Kiên', 'female', TRUE, 5, NULL, 'Vợ ông Hồ Nhường.'),

-- Con của Hồ Ái → Hồ Cúc
('05000000-0000-0000-0000-000000000003', 'Hồ Cúc', 'female', TRUE, 5, 1, 'Con bà Hồ Ái. Tên khác: Thị Tư.'),

-- Con của Hồ Huyên (con ông Tuần)
-- (sẽ bổ sung nếu có thêm data)

-- Con của Hồ Chuyên
('05000000-0000-0000-0000-000000000004', 'Hồ Ngùy', 'female', TRUE, 5, 1, 'Con ông Hồ Chuyên. Tên khác: Thị Biển.'),
('05000000-0000-0000-0000-000000000005', 'Hồ Vi', 'female', TRUE, 5, 2, 'Con ông Hồ Chuyên. Tên khác: Thị Bình.'),

-- Con của Hồ Nhuyên
('05000000-0000-0000-0000-000000000006', 'Hồ Đàm', 'male', TRUE, 5, 1, 'Con ông Hồ Nhuyên.'),
('05000000-0000-0000-0000-000000000007', 'Hồ Minh', 'male', TRUE, 5, 2, 'Con ông Hồ Nhuyên.'),

-- Con của Hồ Biểm (từ giấy viết tay ảnh 3)
('05000000-0000-0000-0000-000000000008', 'Hồ Niệm (5)', 'male', TRUE, 5, 1, 'Con ông Hồ Biểm.'),

-- Con của Hồ Niệm (đời 4)
('05000000-0000-0000-0000-000000000009', 'Hồ Xiên', 'female', TRUE, 5, 1, 'Con ông Hồ Niệm. Tên khác: Thị Chức.'),
('05000000-0000-0000-0000-000000000010', 'Hồ Kiên', 'male', TRUE, 5, 2, 'Con ông Hồ Niệm.'),
('05000000-0000-0000-0000-000000000011', 'Hồ Xiết', 'female', TRUE, 5, 3, 'Con ông Hồ Niệm. Tên khác: Thị Doanh.'),
('05000000-0000-0000-0000-000000000012', 'Hồ Niên', 'male', TRUE, 5, 4, 'Con ông Hồ Niệm.'),
('05000000-0000-0000-0000-000000000013', 'Hồ Phiệt', 'female', TRUE, 5, 5, 'Con ông Hồ Niệm. Tên khác: Thị Đính.'),
('05000000-0000-0000-0000-000000000014', 'Hồ Yên', 'female', TRUE, 5, 6, 'Con ông Hồ Niệm.'),

-- Con của Hồ Trần (từ giấy viết tay ảnh 4)
('05000000-0000-0000-0000-000000000015', 'Hồ Mẫn', 'female', TRUE, 5, 1, 'Con ông Hồ Trần. Tên khác: Thị Nhụy.'),

-- Con của Hồ Hải
('05000000-0000-0000-0000-000000000016', 'Hồ Phiệt (Th)', 'female', TRUE, 5, 1, 'Con ông Hồ Hải. Tên khác: Thị Đính.'),
('05000000-0000-0000-0000-000000000017', 'Hồ Theo', 'male', TRUE, 5, 2, 'Con ông Hồ Hải.'),
('05000000-0000-0000-0000-000000000018', 'Hồ Kỳ', 'male', TRUE, 5, 3, 'Con ông Hồ Hải.'),
('05000000-0000-0000-0000-000000000019', 'Hồ Lý', 'male', TRUE, 5, 4, 'Con ông Hồ Hải.'),
('05000000-0000-0000-0000-000000000020', 'Hồ Mần', 'male', TRUE, 5, 5, 'Con ông Hồ Hải.'),

-- Con của Hồ Luyện (Thị Chung)
-- (sẽ bổ sung)

-- Con của Hồ Huyền
('05000000-0000-0000-0000-000000000021', 'Hồ Bàn', 'male', TRUE, 5, 1, 'Con ông Hồ Huyền. Tên khác: Thị Hiện.');

-- Con của Hồ Cúc (đời 5) - nằm ở nhánh khác
INSERT INTO persons (id, full_name, gender, is_deceased, generation, birth_order, note) VALUES
('05000000-0000-0000-0000-000000000030', 'Hồ Nhi', 'male', TRUE, 5, 2, 'Con bà Hồ Cúc.'),
('05000000-0000-0000-0000-000000000031', 'Hồ Thị Các', 'female', TRUE, 5, 3, 'Con bà Hồ Cúc.');

-- ============================================================
-- ĐỜI 6 — (Con đời 5)
-- ============================================================
INSERT INTO persons (id, full_name, gender, is_deceased, generation, birth_order, note) VALUES
-- Con của Hồ Nhường (Thị Kiên)
('06000000-0000-0000-0000-000000000001', 'Hồ Rạn', 'female', TRUE, 6, 1, 'Con ông Hồ Nhường. Tên khác: Thị Thanh.'),
('06000000-0000-0000-0000-000000000002', 'Hồ Lan', 'male', TRUE, 6, 2, 'Con ông Hồ Nhường.'),
('06000000-0000-0000-0000-000000000003', 'Hồ Vĩnh', 'male', TRUE, 6, 3, 'Con ông Hồ Nhường.'),
('06000000-0000-0000-0000-000000000004', 'Hồ Minh (6)', 'male', TRUE, 6, 4, 'Con ông Hồ Nhường.'),
('06000000-0000-0000-0000-000000000005', 'Hồ Mần (6)', 'male', TRUE, 6, 5, 'Con ông Hồ Nhường.'),
('06000000-0000-0000-0000-000000000006', 'Hồ Ninh', 'female', TRUE, 6, 6, 'Con ông Hồ Nhường. Tên khác: Thị Chương.'),

-- Con của Hồ Cúc → Thị Tư
('06000000-0000-0000-0000-000000000007', 'Hồ Lộc', 'female', TRUE, 6, 1, 'Con bà Hồ Cúc. Tên khác: Thị Phận.'),
('06000000-0000-0000-0000-000000000008', 'Hồ Đoàn', 'female', TRUE, 6, 2, 'Con bà Hồ Cúc. Tên khác: Thị Tàm(?).'),

-- Con của Hồ Huyên → đời 4
('06000000-0000-0000-0000-000000000009', 'Hồ Thị Đỗ', 'female', TRUE, 6, 1, 'Nhánh ông Hồ Huyên.'),
('06000000-0000-0000-0000-000000000010', 'Hồ Thị Các (6)', 'female', TRUE, 6, 2, 'Nhánh ông Hồ Huyên.'),
('06000000-0000-0000-0000-000000000011', 'Hồ Thị Đô', 'female', TRUE, 6, 3, 'Nhánh ông Hồ Huyên.'),

-- Con của Hồ Kiệm
('06000000-0000-0000-0000-000000000012', 'Hồ Thảo', 'female', TRUE, 6, 1, 'Con ông Hồ Kiệm. Tên khác: Thị Phế.'),

-- Con của Hồ Chuyên qua đời 5
('06000000-0000-0000-0000-000000000013', 'Hồ Ngùy (6)', 'female', TRUE, 6, 1, 'Nhánh Hồ Chuyên. Tên khác: Thị Biển.'),

-- Con của Hồ Đàm
('06000000-0000-0000-0000-000000000014', 'Hồ Hạnh', 'female', FALSE, 6, 1, 'Con ông Hồ Đàm. Tên khác: Thị Nhương.'),
('06000000-0000-0000-0000-000000000015', 'Hồ Hạnh (nam)', 'male', FALSE, 6, 2, 'Con ông Hồ Đàm. Tên khác: Thị Lản.'),

-- Con của Hồ Mẫn (Thị Nhụy)
('06000000-0000-0000-0000-000000000016', 'Hồ Dự', 'female', FALSE, 6, 1, 'Con bà Hồ Mẫn. Tên khác: Thị Loạn.'),
('06000000-0000-0000-0000-000000000017', 'Hồ Hiếu', 'male', FALSE, 6, 2, 'Con bà Hồ Mẫn.'),

-- Nhánh Hồ Niệm → Xiên, Kiên, Xiết, Niên, Phiệt, Yên
-- Con của Hồ Xiên (Thị Chức)
('06000000-0000-0000-0000-000000000020', 'Hồ Hoành', 'female', FALSE, 6, 1, 'Con bà Hồ Xiên. Tên khác: Thị Điệu.'),
('06000000-0000-0000-0000-000000000021', 'Hồ Diệp', 'female', FALSE, 6, 2, 'Con bà Hồ Xiên.'),
('06000000-0000-0000-0000-000000000022', 'Hồ Huế', 'male', FALSE, 6, 3, 'Con bà Hồ Xiên.'),
('06000000-0000-0000-0000-000000000023', 'Hồ Huy', 'male', FALSE, 6, 4, 'Con bà Hồ Xiên.'),

-- Con của Hồ Xiết (Thị Doanh)
('06000000-0000-0000-0000-000000000024', 'Hồ Đồng', 'male', FALSE, 6, 1, 'Con bà Hồ Xiết.'),
('06000000-0000-0000-0000-000000000025', 'Hồ Cường', 'male', FALSE, 6, 2, 'Con bà Hồ Xiết.'),

-- Con của Hồ Phiệt (Thị Đính) - nhánh Hồ Niệm
('06000000-0000-0000-0000-000000000026', 'Hồ Thủy', 'male', FALSE, 6, 1, 'Con bà Hồ Phiệt.'),
('06000000-0000-0000-0000-000000000027', 'Hồ Chung Phượng', 'female', FALSE, 6, 2, 'Con bà Hồ Phiệt.'),
('06000000-0000-0000-0000-000000000028', 'Hồ Minh (Ph)', 'male', FALSE, 6, 3, 'Con bà Hồ Phiệt.'),
('06000000-0000-0000-0000-000000000029', 'Hồ Mơ', 'male', FALSE, 6, 4, 'Con bà Hồ Phiệt.'),

-- Con của Hồ Bàn (Thị Hiện) - nhánh Hồ Huyền
('06000000-0000-0000-0000-000000000030', 'Hồ Hồng', 'male', FALSE, 6, 1, 'Con ông Hồ Bàn.'),
('06000000-0000-0000-0000-000000000031', 'Hồ Hà', 'male', FALSE, 6, 2, 'Con ông Hồ Bàn.'),
('06000000-0000-0000-0000-000000000032', 'Hồ Mần (B)', 'male', FALSE, 6, 3, 'Con ông Hồ Bàn.'),

-- Nhánh Hồ Thuyết → Hồ Hải → con
('06000000-0000-0000-0000-000000000040', 'Hồ Niên (H)', 'male', FALSE, 6, 1, 'Con ông Hồ Hải, nhánh Hồ Thuyết.'),
('06000000-0000-0000-0000-000000000041', 'Hồ Chung', 'male', FALSE, 6, 2, 'Nhánh Hồ Thuyết.'),
('06000000-0000-0000-0000-000000000042', 'Hồ Minh (HH)', 'male', FALSE, 6, 3, 'Nhánh Hồ Thuyết.'),
('06000000-0000-0000-0000-000000000043', 'Hồ Mỡ', 'male', FALSE, 6, 4, 'Nhánh Hồ Thuyết.');

-- ============================================================
-- ĐỜI 7 — (Con đời 6)
-- ============================================================
INSERT INTO persons (id, full_name, gender, is_deceased, generation, birth_order, note) VALUES
-- Con của Hồ Nhường (qua đời 6) → Hồ Rạn, Lan, Vĩnh, Minh, Mần, Ninh
-- Con của Hồ Rạn (Thị Thanh) → Hồ Toàn
('07000000-0000-0000-0000-000000000001', 'Hồ Thoản', 'female', FALSE, 7, 1, 'Con bà Hồ Rạn. Tên khác: Thị Lan.'),

-- Con của Hồ Ninh (Thị Chương) - nhiều con
('07000000-0000-0000-0000-000000000002', 'Hồ Sơn', 'male', FALSE, 7, 1, 'Con bà Hồ Ninh.'),
('07000000-0000-0000-0000-000000000003', 'Hồ Hồng (7)', 'male', FALSE, 7, 2, 'Con bà Hồ Ninh.'),
('07000000-0000-0000-0000-000000000004', 'Hồ An', 'male', FALSE, 7, 3, 'Con bà Hồ Ninh.'),
('07000000-0000-0000-0000-000000000005', 'Hồ Dũng', 'male', FALSE, 7, 4, 'Con bà Hồ Ninh.'),
('07000000-0000-0000-0000-000000000006', 'Hồ Đính', 'male', FALSE, 7, 5, 'Con bà Hồ Ninh.'),
('07000000-0000-0000-0000-000000000007', 'Hồ Chính', 'male', FALSE, 7, 6, 'Con bà Hồ Ninh.'),
('07000000-0000-0000-0000-000000000008', 'Hồ Chiến', 'male', FALSE, 7, 7, 'Con bà Hồ Ninh.'),
('07000000-0000-0000-0000-000000000009', 'Hồ Xuân', 'male', FALSE, 7, 8, 'Con bà Hồ Ninh.'),
('07000000-0000-0000-0000-000000000010', 'Hồ Điệu', 'female', FALSE, 7, 9, 'Con bà Hồ Ninh.'),
('07000000-0000-0000-0000-000000000011', 'Hồ Anh', 'male', FALSE, 7, 10, 'Con bà Hồ Ninh.'),
('07000000-0000-0000-0000-000000000012', 'Hồ Đức', 'male', FALSE, 7, 11, 'Con bà Hồ Ninh.'),

-- Con của Hồ Lộc (Thị Phận)
('07000000-0000-0000-0000-000000000013', 'Hồ Bắc', 'female', FALSE, 7, 1, 'Con bà Hồ Lộc. Tên khác: Thị Vinh.'),
('07000000-0000-0000-0000-000000000014', 'Hồ Thái', 'male', FALSE, 7, 2, 'Con bà Hồ Lộc.'),
('07000000-0000-0000-0000-000000000015', 'Hồ Lam', 'male', FALSE, 7, 3, 'Con bà Hồ Lộc.'),
('07000000-0000-0000-0000-000000000016', 'Hồ Dung', 'male', FALSE, 7, 4, 'Con bà Hồ Lộc.'),

-- Con ông Hồ Đoàn
('07000000-0000-0000-0000-000000000017', 'Hồ Nam', 'female', FALSE, 7, 1, 'Con ông Hồ Đoàn. Tên khác: Thị Ngần.'),
('07000000-0000-0000-0000-000000000018', 'Hồ Kiều', 'female', FALSE, 7, 2, 'Con ông Hồ Đoàn.'),

-- Con của Hồ Thảo (Thị Phế)
('07000000-0000-0000-0000-000000000019', 'Hồ Duyên', 'female', FALSE, 7, 1, 'Con bà Hồ Thảo. Tên khác: Thị Hiền.'),

-- Con bà Hồ Dự (Thị Loạn)
('07000000-0000-0000-0000-000000000020', 'Hồ Hậu', 'female', FALSE, 7, 1, 'Con bà Hồ Dự. Tên khác: Thị Dung/Phương.'),
('07000000-0000-0000-0000-000000000021', 'Hồ Hòa', 'male', FALSE, 7, 2, 'Con bà Hồ Dự.'),
('07000000-0000-0000-0000-000000000022', 'Hồ Phương', 'male', FALSE, 7, 3, 'Con bà Hồ Dự.'),
('07000000-0000-0000-0000-000000000023', 'Hồ Tâm', 'male', FALSE, 7, 4, 'Con bà Hồ Dự.'),
('07000000-0000-0000-0000-000000000024', 'Hồ Linh', 'male', FALSE, 7, 5, 'Con bà Hồ Dự.'),
('07000000-0000-0000-0000-000000000025', 'Hồ Minh (D)', 'male', FALSE, 7, 6, 'Con bà Hồ Dự.'),

-- Con của Hồ Hiếu
('07000000-0000-0000-0000-000000000026', 'Hồ Tuần (7)', 'male', FALSE, 7, 1, 'Con ông Hồ Hiếu.'),

-- Nhánh phải (Hồ Bầu → Hồ Trần)
-- Con ông Hồ Trần (từ giấy viết tay ảnh 4)
-- qua đời 5 Hồ Mẫn → đời 6 → đời 7
('07000000-0000-0000-0000-000000000030', 'Hồ Toàn', 'female', FALSE, 7, 1, 'Tên khác: Thị Hằng.'),
('07000000-0000-0000-0000-000000000031', 'Hồ Linh (T)', 'male', FALSE, 7, 2, 'Nhánh Hồ Trần.'),
('07000000-0000-0000-0000-000000000032', 'Hồ Kiên (7)', 'male', FALSE, 7, 3, 'Nhánh Hồ Trần.'),
('07000000-0000-0000-0000-000000000033', 'Hồ Cường (7)', 'male', FALSE, 7, 4, 'Nhánh Hồ Trần.'),

-- Con Hồ Hoành (Thị Điệu) - nhánh Niệm
('07000000-0000-0000-0000-000000000040', 'Hồ Diễn', 'male', FALSE, 7, 1, 'Con bà Hồ Hoành.'),

-- Con Hồ Phiệt → Hồ Chung Phượng...
('07000000-0000-0000-0000-000000000041', 'Hồ Điền', 'male', FALSE, 7, 1, 'Con bà Hồ Phiệt.'),
('07000000-0000-0000-0000-000000000042', 'Hồ Hoàng', 'male', FALSE, 7, 2, 'Con bà Hồ Phiệt.'),

-- Nhánh Hồ Bàn (đời 5) → đời 6 → đời 7
('07000000-0000-0000-0000-000000000050', 'Hồ Hồng (Bàn)', 'male', FALSE, 7, 1, 'Nhánh Hồ Bàn.'),
('07000000-0000-0000-0000-000000000051', 'Hồ Hà (Bàn)', 'male', FALSE, 7, 2, 'Nhánh Hồ Bàn.'),
('07000000-0000-0000-0000-000000000052', 'Hồ Mần (Bàn)', 'male', FALSE, 7, 3, 'Nhánh Hồ Bàn.'),

-- Nhánh Hồ Tường → Suyên → ...
('07000000-0000-0000-0000-000000000060', 'Hồ Phong', 'female', FALSE, 7, 1, 'Tên khác: Thị Nga.'),
('07000000-0000-0000-0000-000000000061', 'Hồ Lĩnh', 'female', FALSE, 7, 2, 'Tên khác: Thị Vân.'),
('07000000-0000-0000-0000-000000000062', 'Hồ Anh (7)', 'male', FALSE, 7, 3, 'Nhánh Hồ Tường.'),

-- Thêm từ giấy viết tay
('07000000-0000-0000-0000-000000000070', 'Hồ Trung', 'female', FALSE, 7, 1, 'Tên khác: Thị Tuyến.'),
('07000000-0000-0000-0000-000000000071', 'Hồ Sáu', 'male', FALSE, 7, 2, ''),
('07000000-0000-0000-0000-000000000072', 'Hồ Hậu (7)', 'female', FALSE, 7, 3, 'Tên khác: Thị Phương.'),
('07000000-0000-0000-0000-000000000073', 'Hồ Mỹ', 'male', FALSE, 7, 4, ''),
('07000000-0000-0000-0000-000000000074', 'Hồ Phương (7)', 'male', FALSE, 7, 5, ''),
('07000000-0000-0000-0000-000000000075', 'Hồ Manh', 'male', FALSE, 7, 6, ''),
('07000000-0000-0000-0000-000000000076', 'Hồ Đẳng', 'male', FALSE, 7, 7, '');

-- ============================================================
-- ĐỜI 8 — Thế hệ trẻ nhất (Con đời 7)
-- ============================================================
INSERT INTO persons (id, full_name, gender, is_deceased, generation, birth_order, note) VALUES
-- Con của Hồ Bắc (Thị Vinh)
('08000000-0000-0000-0000-000000000001', 'Hồ Khánh', 'male', FALSE, 8, 1, 'Con bà Hồ Bắc.'),
('08000000-0000-0000-0000-000000000002', 'Hồ Ngọc', 'male', FALSE, 8, 2, 'Con bà Hồ Bắc.'),

-- Con của Hồ Duyên (Thị Hiền)
('08000000-0000-0000-0000-000000000003', 'Hồ Dương', 'male', FALSE, 8, 1, 'Con bà Hồ Duyên.'),

-- Từ giấy viết tay - con Hồ Tuần
('08000000-0000-0000-0000-000000000010', 'Hồ Tường (8)', 'male', FALSE, 8, 1, ''),
('08000000-0000-0000-0000-000000000011', 'Thanh Ngần', 'female', FALSE, 8, 2, ''),
('08000000-0000-0000-0000-000000000012', 'Hồ Bằng', 'male', FALSE, 8, 3, ''),
('08000000-0000-0000-0000-000000000013', 'Quỳnh Như', 'female', FALSE, 8, 4, ''),

-- Thêm từ video frames cuối
('08000000-0000-0000-0000-000000000020', 'Hồ Trâm', 'male', FALSE, 8, 1, ''),
('08000000-0000-0000-0000-000000000021', 'Hồ Khuê', 'male', FALSE, 8, 2, ''),
('08000000-0000-0000-0000-000000000022', 'Hồ Thành', 'male', FALSE, 8, 3, ''),
('08000000-0000-0000-0000-000000000023', 'Hồ Cảnh', 'male', FALSE, 8, 4, ''),
('08000000-0000-0000-0000-000000000024', 'Hồ Manh (8)', 'male', FALSE, 8, 5, ''),
('08000000-0000-0000-0000-000000000025', 'Hồ Đẳng (8)', 'male', FALSE, 8, 6, ''),
('08000000-0000-0000-0000-000000000026', 'Hồ Nhật', 'male', FALSE, 8, 7, ''),
('08000000-0000-0000-0000-000000000027', 'Hồ Phương (8)', 'male', FALSE, 8, 8, ''),
('08000000-0000-0000-0000-000000000028', 'Hồ Phát', 'male', FALSE, 8, 9, '');

-- Từ giấy viết tay (ảnh 3 - nhánh Hồ Biểm)
INSERT INTO persons (id, full_name, gender, is_deceased, generation, birth_order, note) VALUES
-- Giấy viết tay ảnh 3: Ông Hồ Biểm + Bà Cao Thị Thao
-- Con: Hồ Thị Đậm, Hồ Thị Hình, Hồ Công Toàn, Nguyễn Thị Nhụy
('09000000-0000-0000-0000-000000000001', 'Cao Thị Thao', 'female', TRUE, 4, NULL, 'Bà vợ ông Hồ Biểm (giấy viết tay).'),
('09000000-0000-0000-0000-000000000002', 'Hồ Thị Đậm', 'female', FALSE, 5, 1, 'Con gái ông Hồ Biểm & bà Cao Thị Thao.'),
('09000000-0000-0000-0000-000000000003', 'Hồ Thị Hình', 'female', FALSE, 5, 2, 'Con gái ông Hồ Biểm & bà Cao Thị Thao.'),
('09000000-0000-0000-0000-000000000004', 'Hồ Công Toàn', 'male', FALSE, 5, 3, 'Con trai ông Hồ Biểm & bà Cao Thị Thao.'),
('09000000-0000-0000-0000-000000000005', 'Nguyễn Thị Nhụy', 'female', FALSE, 5, 4, 'Con gái ông Hồ Biểm & bà Cao Thị Thao.'),

-- Cháu: Hồ Thái Phong (vợ: Trương Thị Nga)
('09000000-0000-0000-0000-000000000006', 'Hồ Thái Phong', 'male', FALSE, 6, 1, 'Cháu ông Hồ Biểm.'),
('09000000-0000-0000-0000-000000000007', 'Trương Thị Nga', 'female', FALSE, 6, NULL, 'Vợ Hồ Thái Phong.'),
-- Chắt: Hồ Thái Cảnh, Hồ Thái Mạnh
('09000000-0000-0000-0000-000000000008', 'Hồ Thái Cảnh', 'male', FALSE, 7, 1, 'Chắt ông Hồ Biểm, con Hồ Thái Phong.'),
('09000000-0000-0000-0000-000000000009', 'Hồ Thái Mạnh', 'male', FALSE, 7, 2, 'Chắt ông Hồ Biểm, con Hồ Thái Phong.'),

-- Cháu: Hồ Xuân Linh (vợ: Dương Thị Vân)
('09000000-0000-0000-0000-000000000010', 'Hồ Xuân Linh', 'male', FALSE, 6, 2, 'Cháu ông Hồ Biểm.'),
('09000000-0000-0000-0000-000000000011', 'Dương Thị Vân', 'female', FALSE, 6, NULL, 'Vợ Hồ Xuân Linh.'),
-- Chắt: Hồ Hải Đăng, Hồ Xuân Đạt, Hồ Thùy Linh
('09000000-0000-0000-0000-000000000012', 'Hồ Hải Đăng', 'male', FALSE, 7, 1, 'Con Hồ Xuân Linh.'),
('09000000-0000-0000-0000-000000000013', 'Hồ Xuân Đạt', 'male', FALSE, 7, 2, 'Con Hồ Xuân Linh.'),
('09000000-0000-0000-0000-000000000014', 'Hồ Thùy Linh', 'female', FALSE, 7, 3, 'Con Hồ Xuân Linh.'),

-- Cháu: Hồ Hiền Anh (vợ: Vũ Hoàng Yến)
('09000000-0000-0000-0000-000000000015', 'Hồ Hiền Anh', 'male', FALSE, 6, 3, 'Cháu ông Hồ Biểm.'),
('09000000-0000-0000-0000-000000000016', 'Vũ Hoàng Yến', 'female', FALSE, 6, NULL, 'Vợ Hồ Hiền Anh.'),
-- Cháu: Hồ Ngọc Ánh
('09000000-0000-0000-0000-000000000017', 'Hồ Ngọc Ánh', 'female', FALSE, 7, 1, 'Con Hồ Hiền Anh.'),
-- Chắt: Hồ Vũ Mai Phương, Hồ Vũ Pháp Hiếu
('09000000-0000-0000-0000-000000000018', 'Hồ Vũ Mai Phương', 'female', FALSE, 8, 1, 'Chắt ông Hồ Biểm.'),
('09000000-0000-0000-0000-000000000019', 'Hồ Vũ Pháp Hiếu', 'male', FALSE, 8, 2, 'Chắt ông Hồ Biểm.');

-- Từ giấy viết tay (ảnh 4 - nhánh Hồ Trần)
INSERT INTO persons (id, full_name, gender, is_deceased, generation, birth_order, note) VALUES
('09100000-0000-0000-0000-000000000001', 'Hồ Thị Nhuyên', 'female', TRUE, 4, NULL, 'Bà vợ ông Hồ Trần (giấy viết tay).'),
-- Con ông Hồ Trần: 4 người
('09100000-0000-0000-0000-000000000002', 'Hồ Thị Xên', 'female', FALSE, 5, 1, 'Con gái ông Hồ Trần. Chồng: Hồ Văn Lam.'),
('09100000-0000-0000-0000-000000000003', 'Hồ Công Xiên', 'male', FALSE, 5, 2, 'Con trai ông Hồ Trần. Vợ: Hồ Thị Chiéc.'),
('09100000-0000-0000-0000-000000000004', 'Hồ Thị Hiền', 'female', FALSE, 5, 3, 'Con gái ông Hồ Trần. Chồng: Lê Văn Minh.'),
('09100000-0000-0000-0000-000000000005', 'Hồ Công Xiết', 'male', FALSE, 5, 4, 'Con trai ông Hồ Trần. Vợ: Pham Thị Doan.'),
-- Cháu ông Xiên: Hồ Minh Đức (vợ: Lê Thị Tính)
('09100000-0000-0000-0000-000000000006', 'Hồ Minh Đức', 'male', FALSE, 6, 1, 'Cháu Hồ Công Xiên. Vợ: Lê Thị Tính.'),
('09100000-0000-0000-0000-000000000007', 'Lê Thị Tính', 'female', FALSE, 6, NULL, 'Vợ Hồ Minh Đức.'),
-- Con cua Đức: Hồ Lam Trình, Hồ Việt Nhất
('09100000-0000-0000-0000-000000000008', 'Hồ Lam Trình', 'male', FALSE, 7, 1, 'Con Hồ Minh Đức.'),
('09100000-0000-0000-0000-000000000009', 'Hồ Việt Nhất', 'male', FALSE, 7, 2, 'Con Hồ Minh Đức.'),
-- (2) Hồ Cự Điền (vợ: Nguyễn Thị Ninh)
('09100000-0000-0000-0000-000000000010', 'Hồ Cự Điền', 'male', FALSE, 6, 2, 'Con Hồ Công Xiên. Vợ: Nguyễn Thị Ninh.'),
('09100000-0000-0000-0000-000000000011', 'Nguyễn Thị Ninh', 'female', FALSE, 6, NULL, 'Vợ Hồ Cự Điền.'),
-- Con: Hồ Thị Phương, Hồ Cửng Phát, Hồ Công Tài
('09100000-0000-0000-0000-000000000012', 'Hồ Thị Phương', 'female', FALSE, 7, 1, 'Con Hồ Cự Điền.'),
('09100000-0000-0000-0000-000000000013', 'Hồ Công Phát', 'male', FALSE, 7, 2, 'Con Hồ Cự Điền.'),
('09100000-0000-0000-0000-000000000014', 'Hồ Công Tài', 'male', FALSE, 7, 3, 'Con Hồ Cự Điền.'),
-- (3) Hồ Thị Diệp - Chồng: Nguyễn Văn Hùng
('09100000-0000-0000-0000-000000000015', 'Hồ Thị Diệp', 'female', FALSE, 6, 3, 'Con Hồ Công Xiên. Chồng: Nguyễn Văn Hùng.'),
-- (4) Hồ Hoành - Vợ: Hồ Thị Hoa
('09100000-0000-0000-0000-000000000016', 'Hồ Hoành', 'male', FALSE, 6, 4, 'Con Hồ Công Xiên. Vợ: Hồ Thị Hoa.'),
('09100000-0000-0000-0000-000000000017', 'Hồ Thị Hoa', 'female', FALSE, 6, NULL, 'Vợ Hồ Hoành.'),
-- Con: Hồ Thiện Nhân (Nhiên)
('09100000-0000-0000-0000-000000000018', 'Hồ Thiện Nhân', 'male', FALSE, 7, 1, 'Con Hồ Hoành. Tên khác: Nhiên.'),
-- (5) Hồ Thị Thuế - Chồng: Hà Văn Tiến
('09100000-0000-0000-0000-000000000019', 'Hồ Thị Thuế', 'female', FALSE, 6, 5, 'Con Hồ Công Xiên. Chồng: Hà Văn Tiến.'),
-- (6) Hồ Cự Thụy - Vợ: Phạm Thị Linh
('09100000-0000-0000-0000-000000000020', 'Hồ Cự Thụy', 'male', FALSE, 6, 6, 'Con Hồ Công Xiên. Vợ: Phạm Thị Linh.'),
('09100000-0000-0000-0000-000000000021', 'Phạm Thị Linh', 'female', FALSE, 6, NULL, 'Vợ Hồ Cự Thụy.'),
-- Con: Hồ Gia Long
('09100000-0000-0000-0000-000000000022', 'Hồ Gia Long', 'male', FALSE, 7, 1, 'Con Hồ Cự Thụy.');

-- Từ giấy viết tay (ảnh 5 - nhánh Hồ Cúc)
INSERT INTO persons (id, full_name, gender, is_deceased, generation, birth_order, note) VALUES
('09200000-0000-0000-0000-000000000001', 'Phạm Thị Cư', 'female', TRUE, 5, NULL, 'Bà vợ ông Hồ Cúc (giấy viết tay).'),
-- I. Hồ Sỹ Lộc (vợ: Phương Thị Phần) → sinh 5 con, 3 trai 2 gái
('09200000-0000-0000-0000-000000000002', 'Hồ Sỹ Lộc', 'male', FALSE, 6, 1, 'Con ông Hồ Cúc. Vợ: Phương Thị Phần.'),
('09200000-0000-0000-0000-000000000003', 'Phương Thị Phần', 'female', FALSE, 6, NULL, 'Vợ Hồ Sỹ Lộc.'),
-- Con Hồ Sỹ Lộc:
('09200000-0000-0000-0000-000000000004', 'Hồ Văn Hà', 'male', FALSE, 7, 1, 'Con Hồ Sỹ Lộc. Nam.'),
('09200000-0000-0000-0000-000000000005', 'Hồ Văn Bắc', 'male', FALSE, 7, 2, 'Con Hồ Sỹ Lộc. Vợ: Dũng Thị Vinh.'),
('09200000-0000-0000-0000-000000000006', 'Dũng Thị Vinh', 'female', FALSE, 7, NULL, 'Vợ Hồ Văn Bắc.'),
-- Con Hồ Văn Bắc: 3 người (1 trai, 2 gái)
('09200000-0000-0000-0000-000000000007', 'Hồ Quang Khải', 'male', FALSE, 8, 1, 'Con Hồ Văn Bắc. Nam.'),
('09200000-0000-0000-0000-000000000008', 'Hồ Ngân Khánh', 'female', FALSE, 8, 2, 'Con Hồ Văn Bắc. Nữ.'),
('09200000-0000-0000-0000-000000000009', 'Hồ Bảo Ngọc', 'female', FALSE, 8, 3, 'Con Hồ Văn Bắc. Nữ.'),

-- II. Hồ Minh Đoàn (vợ: Trần Thị Cẩm)
('09200000-0000-0000-0000-000000000010', 'Hồ Minh Đoàn', 'male', FALSE, 6, 2, 'Con ông Hồ Cúc. Vợ: Trần Thị Cẩm. Sinh 2 con, 1 trai 1 gái.'),
('09200000-0000-0000-0000-000000000011', 'Trần Thị Cẩm', 'female', FALSE, 6, NULL, 'Vợ Hồ Minh Đoàn.'),
('09200000-0000-0000-0000-000000000012', 'Hồ Thị Dung', 'female', FALSE, 7, 1, 'Con Hồ Minh Đoàn. Nữ.'),
('09200000-0000-0000-0000-000000000013', 'Hồ Việt Anh', 'male', FALSE, 7, 2, 'Con Hồ Minh Đoàn. Vợ: Trần Thị Hòa.'),
('09200000-0000-0000-0000-000000000014', 'Trần Thị Hòa', 'female', FALSE, 7, NULL, 'Vợ Hồ Việt Anh.'),
-- Con Hồ Việt Anh: sinh 2 con trai
('09200000-0000-0000-0000-000000000015', 'Hồ Cung Đường', 'male', FALSE, 8, 1, 'Con Hồ Việt Anh.'),
('09200000-0000-0000-0000-000000000016', 'Hồ Nam Phong', 'male', FALSE, 8, 2, 'Con Hồ Việt Anh.'),

-- III. Hồ Văn Nam (vợ: Đinh Thị Ngần)
('09200000-0000-0000-0000-000000000017', 'Hồ Văn Nam', 'male', FALSE, 6, 3, 'Con ông Hồ Cúc. Vợ: Đinh Thị Ngần. Sinh 2 con gái.'),
('09200000-0000-0000-0000-000000000018', 'Đinh Thị Ngần', 'female', FALSE, 6, NULL, 'Vợ Hồ Văn Nam.'),
('09200000-0000-0000-0000-000000000019', 'Hồ Mai Hương', 'female', FALSE, 7, 1, 'Con Hồ Văn Nam. Gái.'),
('09200000-0000-0000-0000-000000000020', 'Hồ Thảo My', 'female', FALSE, 7, 2, 'Con Hồ Văn Nam. Gái.'),

-- IV. Hồ Thị Doa
('09200000-0000-0000-0000-000000000021', 'Hồ Thị Doa', 'female', FALSE, 6, 4, 'Con ông Hồ Cúc.'),

-- V. Hồ Thị Kiều
('09200000-0000-0000-0000-000000000022', 'Hồ Thị Kiều', 'female', FALSE, 6, 5, 'Con ông Hồ Cúc.');


-- ============================================================
-- QUAN HỆ GIA ĐÌNH
-- biological_child: person_a = Bố/Mẹ, person_b = Con
-- marriage: person_a & person_b = Vợ chồng
-- ============================================================

-- Đời 1 → Đời 2
INSERT INTO relationships (type, person_a, person_b) VALUES
('biological_child', '01000000-0000-0000-0000-000000000001', '02000000-0000-0000-0000-000000000001');

-- Hôn nhân đời 2
INSERT INTO relationships (type, person_a, person_b) VALUES
('marriage', '02000000-0000-0000-0000-000000000001', '02000000-0000-0000-0000-000000000002'),
('marriage', '02000000-0000-0000-0000-000000000001', '02000000-0000-0000-0000-000000000003');

-- Đời 2 → Đời 3
INSERT INTO relationships (type, person_a, person_b) VALUES
('biological_child', '02000000-0000-0000-0000-000000000001', '03000000-0000-0000-0000-000000000001'),
('biological_child', '02000000-0000-0000-0000-000000000001', '03000000-0000-0000-0000-000000000002'),
('biological_child', '02000000-0000-0000-0000-000000000001', '03000000-0000-0000-0000-000000000003'),
('biological_child', '02000000-0000-0000-0000-000000000001', '03000000-0000-0000-0000-000000000004'),
('biological_child', '02000000-0000-0000-0000-000000000001', '03000000-0000-0000-0000-000000000005'),
('biological_child', '02000000-0000-0000-0000-000000000001', '03000000-0000-0000-0000-000000000006'),
('biological_child', '02000000-0000-0000-0000-000000000001', '03000000-0000-0000-0000-000000000007');

-- Hôn nhân đời 3
INSERT INTO relationships (type, person_a, person_b) VALUES
('marriage', '03000000-0000-0000-0000-000000000003', '03000000-0000-0000-0000-000000000010'),
('marriage', '03000000-0000-0000-0000-000000000007', '03000000-0000-0000-0000-000000000011');

-- Đời 3 → Đời 4 (Hồ Vợi)
INSERT INTO relationships (type, person_a, person_b) VALUES
('biological_child', '03000000-0000-0000-0000-000000000001', '04000000-0000-0000-0000-000000000001'),
('biological_child', '03000000-0000-0000-0000-000000000001', '04000000-0000-0000-0000-000000000002');

-- Đời 3 → Đời 4 (Hồ Tuần)
INSERT INTO relationships (type, person_a, person_b) VALUES
('biological_child', '03000000-0000-0000-0000-000000000002', '04000000-0000-0000-0000-000000000003'),
('biological_child', '03000000-0000-0000-0000-000000000002', '04000000-0000-0000-0000-000000000004');

-- Đời 3 → Đời 4 (Hồ Tức)
INSERT INTO relationships (type, person_a, person_b) VALUES
('biological_child', '03000000-0000-0000-0000-000000000003', '04000000-0000-0000-0000-000000000005'),
('biological_child', '03000000-0000-0000-0000-000000000003', '04000000-0000-0000-0000-000000000006'),
('biological_child', '03000000-0000-0000-0000-000000000003', '04000000-0000-0000-0000-000000000007');

-- Đời 3 → Đời 4 (Hồ Tường)
INSERT INTO relationships (type, person_a, person_b) VALUES
('biological_child', '03000000-0000-0000-0000-000000000004', '04000000-0000-0000-0000-000000000008'),
('biological_child', '03000000-0000-0000-0000-000000000004', '04000000-0000-0000-0000-000000000009');

-- Đời 3 → Đời 4 (Hồ Bầu)
INSERT INTO relationships (type, person_a, person_b) VALUES
('biological_child', '03000000-0000-0000-0000-000000000006', '04000000-0000-0000-0000-000000000010');

-- Đời 3 → Đời 4 (Hồ Thuyết)
INSERT INTO relationships (type, person_a, person_b) VALUES
('biological_child', '03000000-0000-0000-0000-000000000007', '04000000-0000-0000-0000-000000000011'),
('biological_child', '03000000-0000-0000-0000-000000000007', '04000000-0000-0000-0000-000000000012'),
('biological_child', '03000000-0000-0000-0000-000000000007', '04000000-0000-0000-0000-000000000013');

-- Hôn nhân đời 4
INSERT INTO relationships (type, person_a, person_b) VALUES
('marriage', '04000000-0000-0000-0000-000000000008', '09000000-0000-0000-0000-000000000001'),
('marriage', '04000000-0000-0000-0000-000000000009', '04000000-0000-0000-0000-000000000022'),
('marriage', '04000000-0000-0000-0000-000000000010', '09100000-0000-0000-0000-000000000001');

-- Đời 4 → Đời 5 (Hồ Xình → Hồ Nhường)
INSERT INTO relationships (type, person_a, person_b) VALUES
('biological_child', '04000000-0000-0000-0000-000000000002', '05000000-0000-0000-0000-000000000001');

-- Đời 4 → Đời 5 (Hồ Ái → Hồ Cúc)
INSERT INTO relationships (type, person_a, person_b) VALUES
('biological_child', '04000000-0000-0000-0000-000000000001', '05000000-0000-0000-0000-000000000003'),
('biological_child', '04000000-0000-0000-0000-000000000001', '05000000-0000-0000-0000-000000000030'),
('biological_child', '04000000-0000-0000-0000-000000000001', '05000000-0000-0000-0000-000000000031');

-- Đời 4 → Đời 5 (Hồ Chuyên)
INSERT INTO relationships (type, person_a, person_b) VALUES
('biological_child', '04000000-0000-0000-0000-000000000005', '05000000-0000-0000-0000-000000000004'),
('biological_child', '04000000-0000-0000-0000-000000000005', '05000000-0000-0000-0000-000000000005');

-- Đời 4 → Đời 5 (Hồ Nhuyên)
INSERT INTO relationships (type, person_a, person_b) VALUES
('biological_child', '04000000-0000-0000-0000-000000000006', '05000000-0000-0000-0000-000000000006'),
('biological_child', '04000000-0000-0000-0000-000000000006', '05000000-0000-0000-0000-000000000007');

-- Đời 4 → Đời 5 (Hồ Biểm)
INSERT INTO relationships (type, person_a, person_b) VALUES
('biological_child', '04000000-0000-0000-0000-000000000008', '09000000-0000-0000-0000-000000000002'),
('biological_child', '04000000-0000-0000-0000-000000000008', '09000000-0000-0000-0000-000000000003'),
('biological_child', '04000000-0000-0000-0000-000000000008', '09000000-0000-0000-0000-000000000004'),
('biological_child', '04000000-0000-0000-0000-000000000008', '09000000-0000-0000-0000-000000000005');

-- Đời 4 → Đời 5 (Hồ Niệm)
INSERT INTO relationships (type, person_a, person_b) VALUES
('biological_child', '04000000-0000-0000-0000-000000000009', '05000000-0000-0000-0000-000000000009'),
('biological_child', '04000000-0000-0000-0000-000000000009', '05000000-0000-0000-0000-000000000010'),
('biological_child', '04000000-0000-0000-0000-000000000009', '05000000-0000-0000-0000-000000000011'),
('biological_child', '04000000-0000-0000-0000-000000000009', '05000000-0000-0000-0000-000000000012'),
('biological_child', '04000000-0000-0000-0000-000000000009', '05000000-0000-0000-0000-000000000013'),
('biological_child', '04000000-0000-0000-0000-000000000009', '05000000-0000-0000-0000-000000000014');

-- Đời 4 → Đời 5 (Hồ Trần → con)
INSERT INTO relationships (type, person_a, person_b) VALUES
('biological_child', '04000000-0000-0000-0000-000000000010', '09100000-0000-0000-0000-000000000002'),
('biological_child', '04000000-0000-0000-0000-000000000010', '09100000-0000-0000-0000-000000000003'),
('biological_child', '04000000-0000-0000-0000-000000000010', '09100000-0000-0000-0000-000000000004'),
('biological_child', '04000000-0000-0000-0000-000000000010', '09100000-0000-0000-0000-000000000005');

-- Đời 4 → Đời 5 (Hồ Hải)
INSERT INTO relationships (type, person_a, person_b) VALUES
('biological_child', '04000000-0000-0000-0000-000000000011', '05000000-0000-0000-0000-000000000016'),
('biological_child', '04000000-0000-0000-0000-000000000011', '05000000-0000-0000-0000-000000000017'),
('biological_child', '04000000-0000-0000-0000-000000000011', '05000000-0000-0000-0000-000000000018'),
('biological_child', '04000000-0000-0000-0000-000000000011', '05000000-0000-0000-0000-000000000019'),
('biological_child', '04000000-0000-0000-0000-000000000011', '05000000-0000-0000-0000-000000000020');

-- Đời 4 → Đời 5 (Hồ Huyền → Hồ Bàn)
INSERT INTO relationships (type, person_a, person_b) VALUES
('biological_child', '04000000-0000-0000-0000-000000000013', '05000000-0000-0000-0000-000000000021');

-- Hôn nhân đời 5
INSERT INTO relationships (type, person_a, person_b) VALUES
('marriage', '05000000-0000-0000-0000-000000000001', '05000000-0000-0000-0000-000000000002');

-- Đời 5 → Đời 6 (Hồ Nhường)
INSERT INTO relationships (type, person_a, person_b) VALUES
('biological_child', '05000000-0000-0000-0000-000000000001', '06000000-0000-0000-0000-000000000001'),
('biological_child', '05000000-0000-0000-0000-000000000001', '06000000-0000-0000-0000-000000000002'),
('biological_child', '05000000-0000-0000-0000-000000000001', '06000000-0000-0000-0000-000000000003'),
('biological_child', '05000000-0000-0000-0000-000000000001', '06000000-0000-0000-0000-000000000004'),
('biological_child', '05000000-0000-0000-0000-000000000001', '06000000-0000-0000-0000-000000000005'),
('biological_child', '05000000-0000-0000-0000-000000000001', '06000000-0000-0000-0000-000000000006');

-- Đời 5 → Đời 6 (Hồ Cúc → Lộc, Đoàn...)
INSERT INTO relationships (type, person_a, person_b) VALUES
('biological_child', '05000000-0000-0000-0000-000000000003', '06000000-0000-0000-0000-000000000007'),
('biological_child', '05000000-0000-0000-0000-000000000003', '06000000-0000-0000-0000-000000000008');

-- Đời 5 → Đời 6 (Hồ Bàn)
INSERT INTO relationships (type, person_a, person_b) VALUES
('biological_child', '05000000-0000-0000-0000-000000000021', '06000000-0000-0000-0000-000000000030'),
('biological_child', '05000000-0000-0000-0000-000000000021', '06000000-0000-0000-0000-000000000031'),
('biological_child', '05000000-0000-0000-0000-000000000021', '06000000-0000-0000-0000-000000000032');

-- Đời 6 → Đời 7 (Hồ Ninh → Thị Chương)
INSERT INTO relationships (type, person_a, person_b) VALUES
('biological_child', '06000000-0000-0000-0000-000000000006', '07000000-0000-0000-0000-000000000002'),
('biological_child', '06000000-0000-0000-0000-000000000006', '07000000-0000-0000-0000-000000000003'),
('biological_child', '06000000-0000-0000-0000-000000000006', '07000000-0000-0000-0000-000000000004'),
('biological_child', '06000000-0000-0000-0000-000000000006', '07000000-0000-0000-0000-000000000005'),
('biological_child', '06000000-0000-0000-0000-000000000006', '07000000-0000-0000-0000-000000000006'),
('biological_child', '06000000-0000-0000-0000-000000000006', '07000000-0000-0000-0000-000000000007'),
('biological_child', '06000000-0000-0000-0000-000000000006', '07000000-0000-0000-0000-000000000008'),
('biological_child', '06000000-0000-0000-0000-000000000006', '07000000-0000-0000-0000-000000000009'),
('biological_child', '06000000-0000-0000-0000-000000000006', '07000000-0000-0000-0000-000000000010'),
('biological_child', '06000000-0000-0000-0000-000000000006', '07000000-0000-0000-0000-000000000011'),
('biological_child', '06000000-0000-0000-0000-000000000006', '07000000-0000-0000-0000-000000000012');

-- Đời 6 → Đời 7 (Hồ Lộc → Bắc, Thái, Lam, Dung)
INSERT INTO relationships (type, person_a, person_b) VALUES
('biological_child', '06000000-0000-0000-0000-000000000007', '07000000-0000-0000-0000-000000000013'),
('biological_child', '06000000-0000-0000-0000-000000000007', '07000000-0000-0000-0000-000000000014'),
('biological_child', '06000000-0000-0000-0000-000000000007', '07000000-0000-0000-0000-000000000015'),
('biological_child', '06000000-0000-0000-0000-000000000007', '07000000-0000-0000-0000-000000000016');

-- Đời 7 → Đời 8 (Hồ Bắc → Khánh, Ngọc)
INSERT INTO relationships (type, person_a, person_b) VALUES
('biological_child', '07000000-0000-0000-0000-000000000013', '08000000-0000-0000-0000-000000000001'),
('biological_child', '07000000-0000-0000-0000-000000000013', '08000000-0000-0000-0000-000000000002');

-- Nhánh Hồ Biểm (giấy viết tay)
INSERT INTO relationships (type, person_a, person_b) VALUES
-- Hồ Thái Phong
('biological_child', '09000000-0000-0000-0000-000000000004', '09000000-0000-0000-0000-000000000006'),
('marriage', '09000000-0000-0000-0000-000000000006', '09000000-0000-0000-0000-000000000007'),
('biological_child', '09000000-0000-0000-0000-000000000006', '09000000-0000-0000-0000-000000000008'),
('biological_child', '09000000-0000-0000-0000-000000000006', '09000000-0000-0000-0000-000000000009'),
-- Hồ Xuân Linh
('biological_child', '09000000-0000-0000-0000-000000000004', '09000000-0000-0000-0000-000000000010'),
('marriage', '09000000-0000-0000-0000-000000000010', '09000000-0000-0000-0000-000000000011'),
('biological_child', '09000000-0000-0000-0000-000000000010', '09000000-0000-0000-0000-000000000012'),
('biological_child', '09000000-0000-0000-0000-000000000010', '09000000-0000-0000-0000-000000000013'),
('biological_child', '09000000-0000-0000-0000-000000000010', '09000000-0000-0000-0000-000000000014'),
-- Hồ Hiền Anh
('biological_child', '09000000-0000-0000-0000-000000000004', '09000000-0000-0000-0000-000000000015'),
('marriage', '09000000-0000-0000-0000-000000000015', '09000000-0000-0000-0000-000000000016'),
('biological_child', '09000000-0000-0000-0000-000000000015', '09000000-0000-0000-0000-000000000017'),
('biological_child', '09000000-0000-0000-0000-000000000017', '09000000-0000-0000-0000-000000000018'),
('biological_child', '09000000-0000-0000-0000-000000000017', '09000000-0000-0000-0000-000000000019');

-- Nhánh Hồ Trần (giấy viết tay)
INSERT INTO relationships (type, person_a, person_b) VALUES
-- Hồ Công Xiên → con
('biological_child', '09100000-0000-0000-0000-000000000003', '09100000-0000-0000-0000-000000000006'),
('biological_child', '09100000-0000-0000-0000-000000000003', '09100000-0000-0000-0000-000000000010'),
('biological_child', '09100000-0000-0000-0000-000000000003', '09100000-0000-0000-0000-000000000015'),
('biological_child', '09100000-0000-0000-0000-000000000003', '09100000-0000-0000-0000-000000000016'),
('biological_child', '09100000-0000-0000-0000-000000000003', '09100000-0000-0000-0000-000000000019'),
('biological_child', '09100000-0000-0000-0000-000000000003', '09100000-0000-0000-0000-000000000020'),
-- Marriages
('marriage', '09100000-0000-0000-0000-000000000006', '09100000-0000-0000-0000-000000000007'),
('marriage', '09100000-0000-0000-0000-000000000010', '09100000-0000-0000-0000-000000000011'),
('marriage', '09100000-0000-0000-0000-000000000016', '09100000-0000-0000-0000-000000000017'),
('marriage', '09100000-0000-0000-0000-000000000020', '09100000-0000-0000-0000-000000000021'),
-- Con cháu
('biological_child', '09100000-0000-0000-0000-000000000006', '09100000-0000-0000-0000-000000000008'),
('biological_child', '09100000-0000-0000-0000-000000000006', '09100000-0000-0000-0000-000000000009'),
('biological_child', '09100000-0000-0000-0000-000000000010', '09100000-0000-0000-0000-000000000012'),
('biological_child', '09100000-0000-0000-0000-000000000010', '09100000-0000-0000-0000-000000000013'),
('biological_child', '09100000-0000-0000-0000-000000000010', '09100000-0000-0000-0000-000000000014'),
('biological_child', '09100000-0000-0000-0000-000000000016', '09100000-0000-0000-0000-000000000018'),
('biological_child', '09100000-0000-0000-0000-000000000020', '09100000-0000-0000-0000-000000000022');

-- Nhánh Hồ Cúc (giấy viết tay ảnh 5)
INSERT INTO relationships (type, person_a, person_b) VALUES
('biological_child', '05000000-0000-0000-0000-000000000003', '09200000-0000-0000-0000-000000000002'),
('biological_child', '05000000-0000-0000-0000-000000000003', '09200000-0000-0000-0000-000000000010'),
('biological_child', '05000000-0000-0000-0000-000000000003', '09200000-0000-0000-0000-000000000017'),
('biological_child', '05000000-0000-0000-0000-000000000003', '09200000-0000-0000-0000-000000000021'),
('biological_child', '05000000-0000-0000-0000-000000000003', '09200000-0000-0000-0000-000000000022'),
-- Marriages
('marriage', '09200000-0000-0000-0000-000000000002', '09200000-0000-0000-0000-000000000003'),
('marriage', '09200000-0000-0000-0000-000000000010', '09200000-0000-0000-0000-000000000011'),
('marriage', '09200000-0000-0000-0000-000000000017', '09200000-0000-0000-0000-000000000018'),
-- Con cháu
('biological_child', '09200000-0000-0000-0000-000000000002', '09200000-0000-0000-0000-000000000004'),
('biological_child', '09200000-0000-0000-0000-000000000002', '09200000-0000-0000-0000-000000000005'),
('marriage', '09200000-0000-0000-0000-000000000005', '09200000-0000-0000-0000-000000000006'),
('biological_child', '09200000-0000-0000-0000-000000000005', '09200000-0000-0000-0000-000000000007'),
('biological_child', '09200000-0000-0000-0000-000000000005', '09200000-0000-0000-0000-000000000008'),
('biological_child', '09200000-0000-0000-0000-000000000005', '09200000-0000-0000-0000-000000000009'),
('biological_child', '09200000-0000-0000-0000-000000000010', '09200000-0000-0000-0000-000000000012'),
('biological_child', '09200000-0000-0000-0000-000000000010', '09200000-0000-0000-0000-000000000013'),
('marriage', '09200000-0000-0000-0000-000000000013', '09200000-0000-0000-0000-000000000014'),
('biological_child', '09200000-0000-0000-0000-000000000013', '09200000-0000-0000-0000-000000000015'),
('biological_child', '09200000-0000-0000-0000-000000000013', '09200000-0000-0000-0000-000000000016'),
('biological_child', '09200000-0000-0000-0000-000000000017', '09200000-0000-0000-0000-000000000019'),
('biological_child', '09200000-0000-0000-0000-000000000017', '09200000-0000-0000-0000-000000000020');

-- ============================================================
-- END OF SEED — GIA PHẢ HỌ HỒ
-- 8 đời, ~160 thành viên
-- Nguồn: Bảng gia phả treo tường + giấy viết tay gia đình
-- Địa phương: Sơn Thọ, Kỳ Thọ, Kỳ Anh, Hà Tĩnh
-- ============================================================
