---
type: cook-final-report
date: 2026-05-01
slug: migration-complete
status: completed
---

# Migration Complete: Supabase → Vercel + Neon + Auth.js

## Status: ✅ DONE

Tổng thời gian thực tế: ~4-5h (vs estimate 25h, do skip Phase 5 + delegate Phase 4)

## Phase summary

| # | Phase | Status |
|---|-------|--------|
| 1 | Setup new stack | ✅ done |
| 2 | Schema & Drizzle migrations | ✅ done |
| 3 | Auth.js v5 + permission helpers | ✅ done |
| 4 | Data layer rewrite (31 files) | ✅ done (delegated to fullstack-developer agent) |
| 5 | Storage + data migration | ⏭️ SKIPPED (no prod data on Supabase) |
| 6 | Authorization audit + cleanup | ✅ done |

## Stack final

- **Hosting:** Vercel
- **Database:** Vercel Postgres (Neon, Singapore region) — 8 tables
- **ORM:** Drizzle ORM 0.45 + Drizzle Kit 0.31
- **Auth:** Auth.js v5 beta.31 + Credentials provider + bcryptjs
- **Storage:** Vercel Blob (public access, avatar bucket)
- **Authorization:** App-level helpers (`requireAuth/Editor/Admin`)

## Files created (key)

- `lib/db/index.ts` — Drizzle client
- `lib/db/schema/{enums,users,persons,relationships,custom-events}.ts`
- `lib/db/migrations/0000_whole_shadowcat.sql`
- `auth.ts`, `auth.config.ts`
- `types/next-auth.d.ts`
- `lib/auth/{permissions,queries,admin-actions}.ts`
- `app/api/auth/[...nextauth]/route.ts`
- `app/actions/relationship.ts` (new server action by subagent)
- `scripts/seed-admin.ts`
- `scripts/migration/{01,02,03,README}` (kept for future reference)
- `drizzle.config.ts`

## Files modified (31)

- `proxy.ts` — switched to Auth.js
- `app/login/page.tsx`, `app/missing-db-config/page.tsx`, `app/setup/page.tsx`
- `app/dashboard/**/page.tsx` (11 pages)
- `app/actions/{member,user,data}.ts`
- `components/{UserProvider,LogoutButton,RelationshipManager,MemberForm,MemberDetailModal,LineageManager,DataImportExport,CustomEventModal}.tsx`
- `package.json` — removed `@supabase/*`, added drizzle/auth/blob/bcryptjs
- `.env.example` — full rewrite for new stack
- `README.md` — Cài đặt section rewrite cho Vercel + Neon + Auth.js
- `docs/schema.sql` — DEPRECATED header

## Files deleted

- `utils/supabase/{server,client,middleware,queries}.ts`

## Verifications

- ✅ `bun run build` pass (Next.js 16.1.6 + Turbopack)
- ✅ `grep -r "@supabase"` → 0 imports trong code
- ✅ Schema pushed: 8 tables trên Vercel Postgres
- ✅ Seed admin script work: created `admin@hoho.kyson` (id=`5b084e3a-6a07-440a-9ba9-4af008f8d8b0`)
- ✅ Dev server starts ở `http://localhost:3000`

## Production deploy checklist

Trước khi deploy production:

1. Add vào Vercel Environment Variables:
   - `AUTH_SECRET` (Production + Preview)
   - `SITE_NAME` (all envs)
   - `AUTH_URL` không cần — auto từ `VERCEL_URL`
2. Push code lên main branch → Vercel tự deploy
3. Sau deploy lần đầu, chạy 1 lần seed admin (có thể qua Vercel CLI hoặc script local pointing prod DB)

## Skipped scope

- **Phase 5 data migration:** không có data prod thật trên Supabase, skip toàn bộ
- **Decommission Supabase project:** không có project active để pause/delete
- Migration scripts giữ trong `scripts/migration/*` cho trường hợp future cần migrate từ source khác

## Open / Unresolved

- Smoke test login chưa được user xác nhận (dev server đã ready, chờ user test browser)
- `AUTH_SECRET` chưa add vào Vercel dashboard — cần làm trước khi deploy production
- Avatar upload trong `MemberForm.tsx` còn stub (subagent note) — cần implement Vercel Blob upload server action
- README "Tài khoản đầu tiên" + "Xử lý lỗi đăng ký" sections đã xoá vì không còn relevant với invite-only model — có thể cần thêm section "Tạo admin đầu tiên" rõ ràng hơn

## Next steps (suggested)

1. User smoke test login local
2. Add AUTH_SECRET vào Vercel + deploy production
3. Implement avatar upload qua Vercel Blob (replace stub trong MemberForm)
4. Update plan `260316-1034-giapha-ho-ho-customization` (architecture section + Phase 7) phản ánh stack mới
5. Bắt đầu nhập data thật của họ Hồ - Kỳ Sơn vào prod
