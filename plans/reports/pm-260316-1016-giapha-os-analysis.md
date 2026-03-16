# Phân Tích Dự Án Gia Phả HỒ - giapha-os

**Date:** 2026-03-16 | **Source:** https://github.com/homielab/giapha-os.git

---

## 1. Tổng Quan

**Mô tả:** Ứng dụng quản lý gia phả dòng họ mã nguồn mở, giao diện trực quan để xem sơ đồ phả hệ, quản lý thành viên, tìm kiếm và lọc.

**Tech Stack:**
| Component | Technology |
|-----------|-----------|
| Frontend | Next.js 16.1.6 + React 19.2.4 + TypeScript |
| Styling | Tailwind CSS 4.2.1 |
| Database | Supabase (PostgreSQL + Auth + RLS + Storage) |
| Animation | Framer Motion |
| Calendar | Lunar-JavaScript (âm lịch) |
| Import/Export | PapaParse (CSV), GEDCOM, JSON backup |
| Package Mgr | Bun |

---

## 2. Cấu Trúc Dự Án

```
giapha-os/
├── app/                          # Next.js App Router
│   ├── actions/                  # Server actions (member, data, user)
│   ├── dashboard/                # Protected pages
│   │   ├── members/              # Quản lý thành viên
│   │   ├── lineage/              # Thế thứ đời
│   │   ├── kinship/              # Tìm quan hệ
│   │   ├── stats/                # Thống kê
│   │   ├── data/                 # Import/Export dữ liệu
│   │   ├── events/               # Sự kiện lịch
│   │   └── users/                # Quản lý người dùng
│   ├── login/ | setup/ | about/
│   └── layout.tsx
├── components/                   # ~50 React components
│   ├── FamilyTree.tsx            # Sơ đồ cây (330 lines)
│   ├── MindmapTree.tsx           # Sơ đồ mindmap
│   ├── KinshipFinder.tsx         # Tìm xưng hô
│   ├── LineageManager.tsx        # Tính đời/thứ tự (465 lines)
│   ├── RelationshipManager.tsx   # CRUD quan hệ (1057 lines)
│   ├── MemberForm.tsx            # Form thành viên (941 lines)
│   └── FamilyStats.tsx           # Thống kê
├── utils/
│   ├── kinshipHelpers.ts         # Tính xưng hô (671 lines) ⚠️ CORE LOGIC
│   ├── treeHelpers.ts            # Build tree & filtering
│   ├── dateHelpers.ts            # Chuyển đổi ngày âm/dương
│   ├── gedcom.ts                 # Import/Export GEDCOM
│   ├── csv.ts                    # Import/Export CSV
│   └── supabase/                 # DB client & queries
├── types/index.ts                # Core TypeScript types
├── docs/
│   ├── schema.sql                # Database schema + RLS (~400 lines)
│   └── seed.sql                  # Sample data
└── .env.example
```

---

## 3. Data Models

### Gender Enum
```typescript
type Gender = "male" | "female" | "other"
```

### Person Entity (persons table)
| Field | Type | Note |
|-------|------|------|
| id | UUID | PK |
| full_name | TEXT | Required |
| gender | gender_enum | male/female/other |
| birth_year/month/day | INT | Partial dates OK |
| death_year/month/day | INT | |
| death_lunar_year/month/day | INT | Ngày giỗ âm lịch |
| is_deceased | BOOLEAN | |
| is_in_law | BOOLEAN | Dâu/Rể |
| birth_order | INT | Thứ tự trong gia đình |
| generation | INT | Đời (1=gốc, 2=con, 3=cháu...) |
| other_names | TEXT | Tên khác |
| avatar_url | TEXT | |
| note | TEXT | |

### Relationship Types
```
"marriage" | "biological_child" | "adopted_child"
```
- `biological_child`/`adopted_child`: person_a = cha/mẹ, person_b = con
- `marriage`: bidirectional pair

### Private Details (person_details_private)
- phone_number, occupation, current_residence
- Admin-only access via RLS

---

## 4. Phân Tích Giới Tính - KẾT QUẢ QUAN TRỌNG

### ✅ HỆ THỐNG ĐÃ BAO GỒM CẢ NAM VÀ NỮ

**giapha-os KHÔNG phải hệ thống chỉ theo dòng cha (patrilineal-only):**

| Tính năng | Nam | Nữ | Ghi chú |
|-----------|-----|-----|---------|
| Có thể là gốc cây | ✅ | ✅ | Không filter giới tính khi chọn root |
| Có thể là cha/mẹ | ✅ | ✅ | biological_child cho cả hai |
| Hiển thị trên cây | ✅ | ✅ | Default hiển thị tất cả |
| Tính đời (generation) | ✅ | ✅ | BFS không phân biệt |
| Thứ tự sinh (birth_order) | ✅ | ✅ | Tính cho tất cả con |
| Tính xưng hô (kinship) | ✅ | ✅ | LCA-based, phân biệt nội/ngoại |
| Thống kê | ✅ | ✅ | Đếm cả hai |
| Tìm kiếm | ✅ | ✅ | Không hạn chế |

### Filter Giới Tính (TÙY CHỌN, không bắt buộc)
UI có các toggle filter:
- `hideDaughters` / `hideSons` — Ẩn con gái/trai
- `hideMales` / `hideFemales` — Ẩn tất cả nam/nữ
- `hideDaughtersInLaw` / `hideSonsInLaw` — Ẩn dâu/rể

→ Đây là **filter tùy chọn** do người dùng bật/tắt, KHÔNG phải logic mặc định.

### Xưng Hô Việt Nam (kinshipHelpers.ts)
Phân biệt nội/ngoại dựa trên **giới tính tổ tiên chung**, không phải "chỉ theo dòng nam":
- **Bên nội** (bố): Ông nội, Bà nội, Bác, Chú, Cô
- **Bên ngoại** (mẹ): Ông ngoại, Bà ngoại, Cậu, Dì
- **Con/Cháu**: Không phân biệt giới tính

---

## 5. Kiến Trúc Hệ Thống

### Authentication & Authorization
- Supabase Auth (email/password)
- Roles: `admin` | `editor` | `member` (read-only)
- RLS policies enforce access control
- First registered user → auto admin
- Auto-approve first user email

### Key Server Actions
| Action | Purpose |
|--------|---------|
| `deleteMemberProfile()` | Xóa thành viên (check relationships) |
| `exportData()` | Backup JSON (persons + relationships) |
| `importData()` | Bulk import with conflict handling |
| User management | Admin CRUD for users |

### Storage
- Supabase Storage bucket `avatars` — public read, authenticated write

---

## 6. Đề Xuất Cho Dự Án "Gia Phả Họ HỒ"

### A. Clone & Customize
```bash
git clone https://github.com/homielab/giapha-os.git
# Setup Supabase project
# Customize branding (SITE_NAME, colors, logo)
# Import/seed data cho Họ Hồ
```

### B. Đảm Bảo Liệt Kê CẢ NỮ
Hệ thống gốc ĐÃ hỗ trợ — chỉ cần:
1. **Đảm bảo mặc định KHÔNG bật filter ẩn nữ** (đã là default)
2. **Nhập đầy đủ dữ liệu cả nam và nữ** khi seed data
3. **Khuyến khích nhập thông tin bà, mẹ, con gái** — không chỉ dòng nam

### C. Cải Tiến Có Thể
1. **Highlight nữ giới** — Thêm visual indicators (màu sắc khác) cho nữ
2. **Thống kê giới tính** — Dashboard hiển thị tỷ lệ nam/nữ
3. **Dòng mẹ (matrilineal view)** — Tùy chọn xem theo dòng mẹ
4. **Ngày giỗ các cụ bà** — Đảm bảo lunar dates cho cả nữ
5. **Vai trò gia đình mở rộng** — Thêm ghi chú vai trò (trưởng họ, etc.)

### D. Các Vấn Đề Cần Lưu Ý
| Issue | Risk | Mitigation |
|-------|------|------------|
| File lớn (>200 lines) | Maintainability | Modularize RelationshipManager, MemberForm, kinshipHelpers |
| Supabase dependency | Lock-in | Có thể self-host Supabase |
| Bun package manager | Compatibility | Fallback npm/pnpm if needed |
| RLS complexity | Security | Test thoroughly trước deploy |

---

## 7. Bước Tiếp Theo

1. **Setup Supabase project** cho Họ Hồ
2. **Clone giapha-os** vào working directory
3. **Customize branding** — tên, logo, màu sắc
4. **Import seed data** — Bắt đầu từ gốc họ Hồ (cả nam và nữ)
5. **Deploy** — Vercel hoặc self-hosted
6. **Optional enhancements** — theo đề xuất phần C

---

## Unresolved Questions

1. Dữ liệu gia phả Họ Hồ hiện có ở đâu? (Excel, giấy, ảnh?)
2. Bao nhiêu đời/thế hệ cần nhập?
3. Có cần chỉnh sửa xưng hô đặc thù vùng miền không?
4. Deploy trên Vercel (miễn phí) hay self-host?
5. Cần multi-language (Anh/Việt) không?
