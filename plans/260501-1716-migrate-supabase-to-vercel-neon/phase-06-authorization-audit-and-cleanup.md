---
phase: 6
title: Authorization Audit + Cleanup Supabase
status: pending
priority: P1
effort: ~3h
---

# Phase 6: Authorization Audit + Cleanup

## Context Links

- [Plan overview](plan.md)
- Phase 1-5 hoàn thành: app chạy trên Vercel + Neon, data migrated

## Overview

Phase cuối:
1. **Audit toàn bộ permission checks** (mất RLS = mất safety net DB-level)
2. **Cleanup** Supabase deps + dead code
3. **Update docs** (README.md, schema.sql obsolete)
4. **Decommission** Supabase project (sau khi confirmed OK 1 tuần)

## Key Insights

- Mất RLS là risk lớn nhất: trước đây kể cả app code lỗi, RLS DB-level vẫn bảo vệ data
- Giờ app code = single source of truth cho authorization → audit BẮT BUỘC
- 15 RLS policies cần map sang app-level checks

## RLS → App-level mapping

| RLS Policy (cũ) | App-level check (mới) | Locations |
|---|---|---|
| `Users can view own profile` | `requireAuth()` + filter `id = user.id` | Profile pages |
| `Admins can view all profiles` | `requireAdmin()` | `getAdminUsers` |
| `Enable read access for authenticated users` (persons) | `requireAuth()` | All persons read paths |
| `Admins can insert/update/delete persons` | `requireEditor()` | `app/actions/member.ts` |
| `Admins can view/manage private details` | `requireAdmin()` | All `personDetailsPrivate` queries |
| `Enable read access` (relationships) | `requireAuth()` | RelationshipManager reads |
| `Admins can insert/update/delete relationships` | `requireEditor()` | RelationshipManager mutations |
| `Enable read access` (custom_events) | `requireAuth()` | Events page reads |
| `Authenticated users can insert custom events` | `requireAuth()` + set `created_by = user.id` | Event create action |
| `Users can update/delete own custom events` | `requireAuth()` + check `created_by === user.id OR isAdmin` | Event update/delete |
| Storage: avatar publicly accessible | Vercel Blob `access: "public"` | Phase 5 đã set |
| Storage: authenticated upload | Server action with `requireAuth()` | Avatar upload action |

## Requirements

**Functional:**
- Mọi server action có permission check
- Mọi page render có session check (qua middleware hoặc inline)
- Test 3 vai trò: admin, editor, member — verify mỗi vai trò chỉ làm được những gì được phép

**Non-functional:**
- 0 imports `@supabase/*` còn lại
- README cập nhật hướng dẫn deploy mới
- `docs/schema.sql` archived (chuyển sang reference chỉ, source of truth = Drizzle schema)

## Architecture

```
Audit checklist:
├── Server Actions (3 files: member.ts, user.ts, data.ts)
│   └── ✓ requireAuth/requireEditor/requireAdmin trước Drizzle query?
├── Server Components (10 pages)
│   └── ✓ requireAuth() + role check (nếu /users page = requireAdmin)
├── API routes (chỉ /api/auth/[...nextauth])
│   └── Auth.js handle
└── Client components dùng server actions
    └── ✓ Server action có check (không trust client)
```

## Related Code Files

**Audit (read carefully):**
- `app/actions/*.ts` (3 files)
- `app/dashboard/**/page.tsx` (11 pages)
- `lib/auth/admin-actions.ts`
- `middleware.ts`

**Modify:**
- `package.json` — remove `@supabase/ssr`, `@supabase/supabase-js`
- `README.md` — update deploy guide
- `.env.example` — remove Supabase vars
- `docs/schema.sql` — add "DEPRECATED" header, point to Drizzle schema

**Delete:**
- `utils/supabase/server.ts`
- `utils/supabase/client.ts`
- `utils/supabase/middleware.ts`
- `utils/supabase/queries.ts`
- `utils/supabase/` (empty dir)
- `proxy.ts` (logic in middleware.ts)
- `app/setup/page.tsx` (nếu không cần)
- `app/setup/CopyButton.tsx`
- `docs/migrations/*.sql` (Supabase-specific, archive)

## Implementation Steps

### 1. Audit checklist matrix

Tạo file `plans/260501-1716-migrate-supabase-to-vercel-neon/audit-checklist.md`:

| File | Function/Route | Required check | Has check? | Notes |
|---|---|---|---|---|
| `app/actions/member.ts` | `deleteMemberProfile` | requireEditor | ☐ | |
| `app/actions/member.ts` | `createMember` | requireEditor | ☐ | |
| `app/actions/member.ts` | `updateMember` | requireEditor | ☐ | |
| `app/actions/user.ts` | `setUserRoleAction` | requireAdmin | ☐ | |
| `app/actions/user.ts` | `deleteUserAction` | requireAdmin + self-check | ☐ | |
| `app/actions/data.ts` | `importData` | requireEditor | ☐ | |
| `app/actions/data.ts` | `exportData` | requireAuth | ☐ | |
| `app/dashboard/users/page.tsx` | render | requireAdmin | ☐ | |
| `app/dashboard/members/[id]/edit/page.tsx` | render | requireEditor | ☐ | |
| ... | | | | |

Walk qua từng file, tick checkbox. File nào miss → fix.

### 2. Add ESLint custom rule (optional, nice-to-have)

Detect server actions thiếu permission check:

`.eslintrc.cjs` thêm rule custom hoặc dùng `eslint-plugin-security`:
- Warn khi file có `"use server"` mà KHÔNG có call tới `require*` helpers

(Skip nếu effort > value — manual audit đủ)

### 3. Test với 3 user roles

Tạo 3 test users qua `05-seed-admin.ts` (sửa script support tạo non-admin):

```bash
bun run scripts/migration/05-seed-user.ts admin@test.com pwd123 admin
bun run scripts/migration/05-seed-user.ts editor@test.com pwd123 editor
bun run scripts/migration/05-seed-user.ts member@test.com pwd123 member
```

Manual test matrix:

| Action | admin | editor | member |
|---|---|---|---|
| View dashboard | ✓ | ✓ | ✓ |
| View members list | ✓ | ✓ | ✓ |
| View member details (public) | ✓ | ✓ | ✓ |
| View private details (phone, etc) | ✓ | ✗ | ✗ |
| Create member | ✓ | ✓ | ✗ |
| Edit member | ✓ | ✓ | ✗ |
| Delete member | ✓ | ✓ | ✗ |
| Manage relationships | ✓ | ✓ | ✗ |
| View `/dashboard/users` | ✓ | ✗ | ✗ |
| Create user | ✓ | ✗ | ✗ |
| Set role | ✓ | ✗ | ✗ |
| Delete user | ✓ | ✗ | ✗ |
| Create event | ✓ | ✓ | ✓ |
| Edit own event | ✓ | ✓ | ✓ |
| Edit others' event | ✓ | ✗ | ✗ |
| Import data | ✓ | ✓ | ✗ |
| Export data | ✓ | ✓ | ✓ |

Tích từng row, fix nếu bug.

### 4. Cleanup Supabase deps

```bash
bun remove @supabase/ssr @supabase/supabase-js
```

Verify `package.json` không còn `@supabase/*`.

### 5. Delete dead files

```bash
rm -rf utils/supabase/
rm proxy.ts
rm -rf app/setup/  # nếu không cần
```

### 6. Update .env.example

Remove Supabase vars block. Final state:
```
# === Vercel Postgres ===
POSTGRES_URL=
POSTGRES_PRISMA_URL=
POSTGRES_URL_NON_POOLING=
POSTGRES_USER=
POSTGRES_HOST=
POSTGRES_PASSWORD=
POSTGRES_DATABASE=

# === Vercel Blob ===
BLOB_READ_WRITE_TOKEN=

# === Auth.js ===
AUTH_SECRET=
AUTH_URL=http://localhost:3000

# === App ===
SITE_NAME=Gia Phả Họ Hồ
```

### 7. Update README.md

Replace "Cài đặt và Chạy dự án" section:
- Bỏ phần Supabase setup
- Thêm Vercel Postgres + Blob provision steps
- Bỏ phần "Xử lý lỗi khi đăng ký" (không còn redirect URL config)
- Cập nhật "Tài khoản đầu tiên": admin invite-only — chạy seed script

### 8. Update docs/schema.sql

Thêm header:
```sql
-- ==========================================
-- DEPRECATED — REFERENCE ONLY
-- ==========================================
-- Source of truth: lib/db/schema/*.ts (Drizzle)
-- This file kept for historical reference của Supabase setup.
-- Last valid: 2026-05-01
-- ==========================================
```

### 9. Final build + deploy check

```bash
bun run build
```

Deploy to Vercel:
```bash
vercel --prod
```

Smoke test trên production URL với 3 roles.

### 10. Decommission Supabase (sau 1 tuần production OK)

⚠️ Chỉ làm sau khi:
- Production stable 7 ngày
- Backup `.sql` file safe
- Không có bug report nào

Steps:
1. Vào Supabase dashboard → Project Settings
2. Pause project (giữ 30 ngày grace period nếu cần restore)
3. Sau 30 ngày → Delete project
4. Remove Supabase env vars khỏi Vercel project

## Todo List

- [ ] Tạo `audit-checklist.md` matrix
- [ ] Audit từng server action có permission check
- [ ] Audit từng dashboard page có session check
- [ ] Test 3 roles manual matrix (~17 test cases)
- [ ] Fix mọi bug audit phát hiện
- [ ] `bun remove @supabase/ssr @supabase/supabase-js`
- [ ] Delete `utils/supabase/`, `proxy.ts`
- [ ] Update `.env.example`
- [ ] Update `README.md`
- [ ] Update `docs/schema.sql` (DEPRECATED header)
- [ ] `bun run build` pass
- [ ] Deploy production: `vercel --prod`
- [ ] Smoke test prod với 3 roles
- [ ] Wait 7 days production stable
- [ ] Pause Supabase project
- [ ] Remove Supabase env vars Vercel
- [ ] (Sau 30 days) Delete Supabase project

## Success Criteria

- 0 imports `@supabase/*` trong codebase: `grep -r "@supabase" --exclude-dir=node_modules` → empty
- `package.json` không có `@supabase/*` deps
- Audit matrix 100% checked
- Manual test matrix 17/17 pass
- Production stable 7 ngày, no regressions
- README + .env.example updated

## Risk Assessment

| Risk | Severity | Mitigation |
|---|---|---|
| Quên 1 server action không check permission | CRITICAL | Audit matrix mandatory; consider ESLint rule |
| Member role được view private details vì miss check | CRITICAL | Test matrix specifically test role boundaries |
| Decommission Supabase quá sớm → không restore được | CAO | Grace period 1 tuần stable + 30 ngày paused |
| README outdated → user mới setup fail | TB | Test README guide với 1 fresh project |

## Security Considerations

- **Single point of failure**: Mất RLS = app code là gate duy nhất. Audit là CRITICAL
- **Defense in depth**: Cân nhắc thêm Drizzle middleware/intercepts để verify session trước query (advanced, optional)
- **Audit logging**: Add log mọi admin action (`getAdminUsers`, `deleteUser`, etc.) — nice-to-have
- **Rate limiting**: Vercel có rate limiting basic free tier — đủ cho gia đình

## Next Steps

🎉 Migration complete. Plan đóng status: `completed`.

Follow-up cho plan `260316-1034-giapha-ho-ho-customization`:
- Update Phase 7 (Testing & Deploy): replace Supabase steps với Vercel Postgres
- Update plan.md Architecture section: Supabase → Vercel + Neon
