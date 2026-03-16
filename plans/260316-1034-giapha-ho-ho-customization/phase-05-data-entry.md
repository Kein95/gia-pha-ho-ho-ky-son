---
phase: 5
title: Data Entry & Seed Data
status: pending
priority: P1
effort: large
---

# Phase 5: Data Entry & Import

## Context
- Chưa có dữ liệu, nhập tay từ đầu
- 6-10 đời, ~50-200 người
- CẦN nhập cả nam VÀ nữ (bà, mẹ, con gái, cháu gái)

## Overview
Xây dựng quy trình nhập liệu hiệu quả. Tạo seed data mẫu. Hướng dẫn nhập liệu cho Họ Hồ.

## Requirements
### Functional
- Batch import: nhập nhiều người cùng lúc (Excel → CSV → import)
- Template Excel cho gia đình tự điền
- Quick-add mode: form đơn giản cho thành viên cơ bản
- Relationship auto-suggest khi nhập con/vợ/chồng
- Validation: warn nếu thiếu thông tin nữ giới

### Non-functional
- CSV import đã có sẵn (PapaParse)
- GEDCOM import/export đã có

## Related Code Files
### Modify
- `app/dashboard/data/page.tsx` — Enhance import UI
- `utils/csv.ts` — Improve CSV mapping
- `components/MemberForm.tsx` — Quick-add mode

### Create
- Template CSV/Excel file
- Seed data mẫu cho Họ Hồ (fictional demo)
- `components/BatchImport.tsx` — Batch import wizard

## Implementation Steps
1. Tạo template CSV với columns đầy đủ (bao gồm gender)
2. Build batch import wizard (step-by-step)
3. Add quick-add mode cho MemberForm
4. Add relationship auto-suggest
5. Tạo seed data mẫu (fictional Họ Hồ, 5 đời, cả nam & nữ)
6. Add validation: cảnh báo nếu đời nào chỉ có nam mà thiếu nữ
7. Viết hướng dẫn nhập liệu

## Todo List
- [ ] Template CSV cho gia đình tự điền
- [ ] Batch import wizard
- [ ] Quick-add mode form
- [ ] Relationship auto-suggest
- [ ] Seed data mẫu Họ Hồ (5 đời, cả nam & nữ)
- [ ] Validation cảnh báo thiếu nữ giới
- [ ] Hướng dẫn nhập liệu

## Success Criteria
- Import 50+ người từ CSV thành công
- Seed data hiển thị đúng trên tree
- Cả nam và nữ đều có trong mỗi đời

## Risk Assessment
- Dữ liệu thật cần thu thập từ gia đình → ngoài scope kỹ thuật
- Tên trùng → cần matching/dedup logic

## Next Steps
→ Phase 6: UI/UX Improvements
