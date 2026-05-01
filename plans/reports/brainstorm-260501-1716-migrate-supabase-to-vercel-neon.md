---
type: brainstorm-summary
date: 2026-05-01
slug: migrate-supabase-to-vercel-neon
status: approved
---

# Brainstorm Summary: Migrate Supabase → Vercel + Neon + Auth.js

## Problem Statement

Current giapha-os (Họ Hồ) chạy trên Vercel + Supabase. User pain points:
1. Supabase free tier auto-pause project sau 7 ngày không activity
2. Mệt mỏi quản lý 2 dashboard (Vercel + Supabase)
3. Lo ngại quota / RLS phức tạp khó debug

**Constraints:**
- Budget: 0đ/tháng (free tier only)
- Quy mô: ~100-500 thành viên họ Hồ mở rộng
- Có data prod thật của gia đình → phải migrate cẩn thận
- Không treo máy local — phải 100% cloud
- OK rewrite toàn bộ backend

## Approaches Evaluated

| # | Phương án | Effort | Verdict |
|---|---|---|---|
| A | Giữ Supabase + Vercel Cron ping | 10 phút | Recommended (KISS/YAGNI) nhưng user chọn migrate |
| B | **Vercel + Neon + Auth.js + Vercel Blob** | 1.5-2 tuần | ✅ **CHOSEN** |
| C | Cloudflare full stack (Pages+D1+R2+Better-Auth) | 2-3 tuần | Rejected — D1 SQLite phải convert schema |
| D | Convex BaaS | 2-4 tuần | Rejected — NoSQL phải rewrite data layer |

## Final Solution: Vercel + Neon + Auth.js + Vercel Blob

### Stack

| Layer | Technology |
|---|---|
| Hosting | Vercel (giữ nguyên) |
| Database | Vercel Postgres (Neon-backed) — 1 dashboard |
| ORM | Drizzle ORM + Drizzle Kit migrations |
| Auth | Auth.js v5 (NextAuth) + Credentials provider + Drizzle adapter |
| Authorization | App-level middleware + permission helpers (replace RLS) |
| Storage | Vercel Blob (avatars) |
| Password | bcryptjs (compatible với Supabase bcrypt hash) |

### User decisions

- **Data state**: Có data prod thật → migration script bắt buộc
- **DB host**: Vercel Postgres (Neon-backed) — gom 1 dashboard
- **First admin**: Invite-only → seed admin qua script, KHÔNG auto-admin user đầu
- **Approval**: Approved, tạo plan chi tiết

### Migration phases

1. **Setup new stack** — install deps, provision Vercel Postgres + Blob
2. **Schema & migrations** — convert SQL → Drizzle schema, generate + push migrations
3. **Auth replacement** — Auth.js v5 setup, replace `utils/supabase/{server,client,middleware}.ts`
4. **Data layer rewrite** — replace 31 files dùng Supabase SDK với Drizzle queries
5. **Storage + data migration** — pg_dump/restore data, migrate avatars Supabase Storage → Vercel Blob
6. **Authorization audit** — replace 15+ RLS policies với app-level checks, audit từng server action

### Success criteria

- Zero `@supabase/*` dependencies
- Đăng nhập + role-based access (admin/editor/member) hoạt động
- CRUD members + relationships + custom_events
- Avatar upload/display
- Import/export GEDCOM/JSON/CSV vẫn hoạt động
- Data prod migrate đầy đủ, không mất record nào
- Permission audit pass (mọi mutation có check role)

### Key risks

| Risk | Severity | Mitigation |
|---|---|---|
| Mất data khi migrate | CAO | `pg_dump` backup + test trên staging |
| Password hash incompatible | TB | Verify bcrypt format; fallback force reset |
| Quên permission check ở app layer | CAO (security) | Centralize helpers + audit checklist |
| First-admin logic mất | TB | Seed script chạy 1 lần khi deploy |
| Vercel Postgres free quota | THẤP | 256MB đủ cho 500 người |

### Files affected (31 files)

- `utils/supabase/{server,client,middleware,queries}.ts` → replace
- `app/actions/{member,user,data}.ts` → rewrite Supabase calls
- `app/dashboard/**/page.tsx` (8 pages) → Drizzle queries
- `components/{RelationshipManager,MemberForm,LineageManager,MemberDetailModal,DataImportExport,CustomEventModal,UserProvider,LogoutButton}.tsx`
- `app/login/page.tsx`, `app/setup/page.tsx`, `app/missing-db-config/page.tsx`
- `proxy.ts`
- New: `lib/db/schema/*.ts`, `lib/auth/*.ts`, `lib/permissions.ts`, `drizzle.config.ts`

### Out of scope

- Self-hosted Supabase (user rejected)
- Supabase Realtime features (codebase không dùng)
- Migrate sang Cloudflare/Convex/Firebase
- UI/UX redesign

## Next Steps

1. Run `/ck:plan` để tạo phase files chi tiết trong `plans/260501-1716-migrate-supabase-to-vercel-neon/`
2. Plan execution theo từng phase, mỗi phase test xong mới sang phase kế
3. Phase 5 (data migration) phải có backup + staging test trước khi chạy production

## Open Questions (resolved)

Tất cả questions đã giải đáp trong brainstorm session.

## Unresolved Questions

- Auth.js v5 (beta) hay v4 (stable)? → Recommend v5 vì Next.js 16 + App Router compat tốt hơn. Confirm trong plan phase.
- Vercel Postgres free tier 256MB compute, 0.25GB storage — đủ cho ~500 người không? Cần verify quota chính xác lúc setup.
- Có cần seed admin script tự động lúc Vercel deploy không, hay manual SQL insert?
