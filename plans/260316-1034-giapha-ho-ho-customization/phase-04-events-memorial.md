---
phase: 4
title: Events & Memorial Enhancement
status: pending
priority: P2
effort: medium
---

# Phase 4: Events & Memorial

## Context
- [app/dashboard/events/](../../app/dashboard/events/) — Existing events page
- [utils/eventHelpers.ts](../../utils/eventHelpers.ts) — Event computation
- [utils/dateHelpers.ts](../../utils/dateHelpers.ts) — Lunar calendar conversion
- Hệ thống đã có tính năng sự kiện cơ bản

## Overview
Enhance sự kiện & ngày giỗ. Đảm bảo ngày giỗ CẢ NAM VÀ NỮ đều được track. Thêm reminder, timeline view.

## Requirements
### Functional
- Ngày giỗ cả nam và nữ hiển thị bình đẳng
- Timeline view: lịch sử gia đình theo thời gian
- Reminder system: thông báo ngày giỗ sắp tới
- Event categories: giỗ, cưới, sinh, mất, họp họ
- Recurring events: giỗ hàng năm (âm lịch)

### Non-functional
- Lunar-JavaScript đã có sẵn
- Calendar view responsive

## Related Code Files
### Modify
- `app/dashboard/events/page.tsx` — Enhance events page
- `utils/eventHelpers.ts` — Add event categories, reminders
- `components/EventCalendar.tsx` — If exists, enhance

### Create
- `components/FamilyTimeline.tsx` — Timeline visualization
- Migration SQL cho event categories

## Implementation Steps
1. Audit existing events: verify cả nam & nữ included
2. Add event categories enum (giỗ, cưới, sinh, mất, họp_họ)
3. Build timeline view component
4. Add upcoming events widget on dashboard
5. Lunar calendar integration cho ngày giỗ
6. Reminder notification (browser notification API)

## Todo List
- [ ] Audit existing events — verify nữ included
- [ ] Add event categories
- [ ] Timeline view component
- [ ] Upcoming events widget
- [ ] Lunar ngày giỗ enhancement
- [ ] Browser notification reminders

## Success Criteria
- Ngày giỗ cả ông bà (nam & nữ) hiển thị đầy đủ
- Timeline xem được lịch sử gia đình
- Upcoming events chính xác theo âm lịch

## Next Steps
→ Phase 5: Data Entry & Import
