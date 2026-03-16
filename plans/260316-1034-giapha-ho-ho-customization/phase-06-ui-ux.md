---
phase: 6
title: UI/UX Improvements
status: pending
priority: P2
effort: medium
---

# Phase 6: UI/UX Improvements

## Context
- Giao diện gốc đã responsive, modern
- Cần customize cho trải nghiệm Họ Hồ

## Overview
Improve UI/UX: theme Họ Hồ, better mobile experience, print-ready tree, search enhancements.

## Requirements
### Functional
- Custom theme colors cho Họ Hồ
- Print-ready family tree (A3/A2 poster)
- Advanced search: tìm theo đời, giới tính, năm sinh, trạng thái
- Mobile-optimized tree navigation
- Dark mode toggle
- Vietnamese locale improvements

### Non-functional
- Performance: tree render <2s cho 200 nodes
- Accessibility: WCAG 2.1 AA
- Print CSS

## Related Code Files
### Modify
- `app/layout.tsx` — Theme setup
- `components/FamilyTree.tsx` — Print mode, performance
- `components/DashboardMemberList.tsx` — Advanced search
- Tailwind config — Custom theme

## Implementation Steps
1. Design custom color palette cho Họ Hồ
2. Implement theme switcher (light/dark)
3. Add print stylesheet cho family tree
4. Advanced search filters
5. Mobile tree navigation improvements
6. Performance optimization cho large trees

## Todo List
- [ ] Custom color palette
- [ ] Dark mode toggle
- [ ] Print-ready family tree
- [ ] Advanced search filters
- [ ] Mobile navigation improvements
- [ ] Performance optimization

## Success Criteria
- Theme nhất quán, đẹp mắt
- In được sơ đồ gia phả chất lượng
- Mobile UX smooth

## Next Steps
→ Phase 7: Testing & Deploy
