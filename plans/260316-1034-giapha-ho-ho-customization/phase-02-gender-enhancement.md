---
phase: 2
title: Gender Enhancement - Hiển Thị Nữ Giới Nổi Bật
status: completed
priority: P1
effort: medium
---

# Phase 2: Gender Enhancement

## Context
- [Analysis Report](../reports/pm-260316-1016-giapha-os-analysis.md)
- [types/index.ts](../../types/index.ts) — Gender type
- [components/FamilyTree.tsx](../../components/FamilyTree.tsx) — Tree visualization
- [utils/kinshipHelpers.ts](../../utils/kinshipHelpers.ts) — Kinship logic

## Overview
Hệ thống gốc đã hỗ trợ cả nam và nữ, nhưng cần enhance để:
1. Visual distinction rõ ràng hơn cho nữ giới
2. Default KHÔNG ẩn nữ (verify & enforce)
3. Thêm matrilineal view (xem theo dòng mẹ)
4. Thống kê giới tính trên dashboard

## Key Insights
- Gender enum đã có: "male" | "female" | "other"
- Filter ẩn/hiện giới tính là TÙY CHỌN, default OFF → OK
- kinshipHelpers.ts phân biệt nội/ngoại đúng chuẩn
- Cần visual indicators mạnh hơn cho nữ trên tree

## Requirements
### Functional
- Color coding: Nam = xanh dương, Nữ = hồng/tím, Khác = xám
- Avatar placeholder khác nhau theo giới tính
- Filter mặc định: hiển thị TẤT CẢ (verify không hide nữ)
- Thêm toggle "Xem theo dòng mẹ" (matrilineal view)
- Stats dashboard: pie chart tỷ lệ nam/nữ theo đời

### Non-functional
- Không thay đổi data model (đã đủ)
- Backward compatible với dữ liệu hiện có

## Related Code Files
### Modify
- `components/FamilyTree.tsx` — Color coding nodes
- `components/MindmapTree.tsx` — Same color coding
- `components/TreeToolbar.tsx` — Verify default filters
- `components/FamilyStats.tsx` — Add gender stats
- `components/MemberCard.tsx` — Gender visual indicator
- `components/DashboardViews.tsx` — Matrilineal view option

### Create
- None (modify existing only)

## Implementation Steps
1. Verify TreeToolbar default: all filters OFF (không ẩn nữ)
2. Add gender-based color coding to FamilyTree node rendering
3. Apply same colors to MindmapTree
4. Add gender-specific avatar placeholders
5. Add pie chart giới tính vào FamilyStats
6. Add "Matrilineal view" toggle — filter tree from female roots
7. Add generation breakdown by gender in stats

## Todo List
- [x] Verify default filters không ẩn nữ (already OFF by default)
- [x] Color coding nodes theo giới tính (already sky/rose/stone)
- [x] Avatar placeholder theo giới tính (already gender-specific SVG)
- [x] Pie chart tỷ lệ nam/nữ (already has bar chart + percentages)
- [x] Quick-view presets: Tất cả / Dòng cha / Dòng mẹ (BaseToolbar.tsx)
- [x] Stats: gender breakdown by generation with stacked bars (FamilyStats.tsx)

## Success Criteria
- Nữ giới hiển thị rõ ràng với màu khác biệt
- Mặc định hiện TẤT CẢ thành viên
- Có thể chuyển qua lại Tree/Mindmap/Matrilineal
- Stats hiển thị tỷ lệ giới tính chính xác

## Security Considerations
- Không thay đổi RLS policies
- Gender data không phải sensitive

## Next Steps
→ Phase 3: Family Photo & Media
