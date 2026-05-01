---
title: Migrate Supabase → Vercel + Neon + Auth.js + Vercel Blob
status: pending
priority: P1
effort: large
branch: main
tags: [migration, vercel, neon, drizzle, authjs, infrastructure]
created: 2026-05-01
relatedPlans: [260316-1034-giapha-ho-ho-customization]
---

# Migration Plan: Supabase → Vercel + Neon + Auth.js + Vercel Blob

## Context

**Brainstorm:** [reports/brainstorm-260501-1716-migrate-supabase-to-vercel-neon.md](../reports/brainstorm-260501-1716-migrate-supabase-to-vercel-neon.md)

**Mục tiêu:** Loại bỏ Supabase, gom toàn bộ infra về Vercel ecosystem để giải quyết:
- Auto-pause project sau 7 ngày trên Supabase free tier
- Mệt quản lý 2 dashboard (Vercel + Supabase)

**Constraints:**
- Budget 0đ/tháng, free tier
- Có data prod thật của họ Hồ → migrate cẩn thận, có backup
- 100% cloud, không treo máy local

## Stack Decisions (locked)

| Layer | Technology |
|---|---|
| Hosting | Vercel (giữ) |
| Database | Vercel Postgres (Neon-backed) |
| ORM | Drizzle ORM + Drizzle Kit |
| Auth | Auth.js v5 + Credentials provider |
| Authorization | App-level helpers (replace RLS) |
| Storage | Vercel Blob |
| Password | bcryptjs |
| Admin model | Invite-only (KHÔNG auto-admin user đầu) |

## Phases

| # | Phase | Status | Effort |
|---|-------|--------|--------|
| 1 | [Setup new stack](phase-01-setup-new-stack.md) | ✅ completed | ~3h |
| 2 | [Schema & Drizzle migrations](phase-02-schema-and-drizzle-migrations.md) | ✅ completed | ~3h |
| 3 | [Auth.js v5 + permission helpers](phase-03-authjs-and-permissions.md) | ✅ completed | ~5h |
| 4 | [Data layer rewrite (31 files)](phase-04-data-layer-rewrite.md) | ✅ completed | ~7h |
| 5 | [Storage + data migration](phase-05-storage-and-data-migration.md) | ⏭️ SKIPPED (no prod data) | — |
| 6 | [Authorization audit + cleanup](phase-06-authorization-audit-and-cleanup.md) | ✅ completed | ~3h |

**Tổng effort:** ~25h (1.5-2 tuần part-time)

## Critical Path

```
Phase 1 (setup) → Phase 2 (schema) → Phase 3 (auth)
                                          ↓
                                   Phase 4 (data layer rewrite)
                                          ↓
                          Phase 5 (data migration) → Phase 6 (audit + cleanup)
```

## Key Risks

- **Mất data prod**: Phase 5 có backup + staging test
- **Quên permission check ở app layer**: Phase 6 audit toàn bộ
- **Password hash incompatible**: Verify Phase 3, fallback force reset

## Cross-Plan Note

Plan `260316-1034-giapha-ho-ho-customization` đang in-progress trên Supabase stack. Sau khi migration hoàn tất, Phase 7 (Testing & Deploy) của plan đó cần update:
- Architecture section: Supabase → Vercel + Neon
- Deploy guide: redirect URL config bỏ
