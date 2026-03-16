---
phase: 3
title: Family Photo & Media Gallery
status: pending
priority: P2
effort: medium
---

# Phase 3: Family Photo & Media

## Context
- Supabase Storage đã có bucket `avatars`
- Cần thêm gallery cho ảnh gia đình, sự kiện

## Overview
Thêm tính năng upload/xem ảnh gia đình, ảnh nhóm, ảnh sự kiện. Mỗi thành viên có thể có nhiều ảnh (không chỉ avatar).

## Requirements
### Functional
- Photo gallery cho mỗi thành viên (nhiều ảnh)
- Family album: ảnh chung gia đình, sự kiện
- Upload/delete ảnh (editor+ permission)
- Lightbox viewer cho ảnh
- Caption/mô tả cho mỗi ảnh

### Non-functional
- Image optimization (resize, compress)
- Lazy loading
- Supabase Storage bucket mới `family-photos`

## Related Code Files
### Modify
- `docs/schema.sql` — Add photos table
- `components/MemberForm.tsx` — Add photo gallery section
- `app/dashboard/` — Add photos page

### Create
- `components/PhotoGallery.tsx` — Gallery component
- `components/PhotoUpload.tsx` — Upload component
- `app/dashboard/photos/page.tsx` — Photos page

## Implementation Steps
1. Design photos table schema (person_id, url, caption, event_id, created_at)
2. Create Supabase Storage bucket `family-photos`
3. Add RLS policies for photos
4. Build PhotoUpload component
5. Build PhotoGallery component with lightbox
6. Integrate into MemberForm (per-person gallery)
7. Create family album page

## Todo List
- [ ] Design & create photos table
- [ ] Setup Storage bucket + RLS
- [ ] PhotoUpload component
- [ ] PhotoGallery component
- [ ] Integrate into member profile
- [ ] Family album page

## Success Criteria
- Upload/view/delete photos cho mỗi thành viên
- Family album hiển thị tất cả ảnh
- Responsive trên mobile

## Next Steps
→ Phase 4: Events & Memorial
