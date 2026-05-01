---
phase: 1
title: Setup New Stack (deps + Vercel Postgres + Blob)
status: pending
priority: P1
effort: ~3h
---

# Phase 1: Setup New Stack

## Context Links

- [Brainstorm summary](../reports/brainstorm-260501-1716-migrate-supabase-to-vercel-neon.md)
- [Plan overview](plan.md)

## Overview

Cài dependencies mới, provision Vercel Postgres + Vercel Blob, setup env vars. KHÔNG xoá Supabase deps ở phase này — giữ song song để app vẫn chạy.

## Key Insights

- Vercel Postgres = Neon backend, tích hợp qua dashboard Vercel
- Free tier: 256MB compute / 0.25GB storage / 60h/tháng → đủ cho 500 người (DB ~5-10MB)
- Vercel Blob: 1GB storage free, 100k operations/tháng
- Drizzle preferred over Prisma vì lightweight + native Neon serverless driver

## Requirements

**Functional:**
- Cài 6 packages mới: drizzle-orm, drizzle-kit, @vercel/postgres, next-auth@beta, bcryptjs, @vercel/blob
- Provision Vercel Postgres + Vercel Blob
- Env vars setup local + Vercel

**Non-functional:**
- App vẫn build pass với Supabase deps còn nguyên
- Không break dev server hiện tại

## Architecture

```
Vercel Dashboard
├── Project: giapha-ho-ho
│   ├── Storage tab
│   │   ├── Postgres database (giapha-postgres)
│   │   │   └── Connection strings (POSTGRES_URL, POSTGRES_URL_NON_POOLING, ...)
│   │   └── Blob store (giapha-avatars)
│   │       └── BLOB_READ_WRITE_TOKEN
│   └── Environment Variables
│       ├── POSTGRES_* (auto-injected)
│       ├── BLOB_READ_WRITE_TOKEN (auto-injected)
│       ├── AUTH_SECRET (manual)
│       └── AUTH_URL (manual)
```

## Related Code Files

**Modify:**
- `package.json` — add deps
- `.env.example` — add new env vars template
- `.env.local` — add real values (gitignored)

**Create:**
- `drizzle.config.ts` — Drizzle Kit config

## Implementation Steps

### 1. Install dependencies

```bash
bun add drizzle-orm @vercel/postgres next-auth@beta bcryptjs @vercel/blob
bun add -D drizzle-kit @types/bcryptjs
```

### 2. Provision Vercel Postgres

User actions trong Vercel dashboard:
1. Project → Storage tab → Create Database → Postgres
2. Name: `giapha-postgres`, Region: Singapore (gần VN nhất)
3. Connect to project → auto-inject env vars
4. Pull env vars về local: `vercel env pull .env.local`

### 3. Provision Vercel Blob

User actions:
1. Project → Storage tab → Create Database → Blob
2. Name: `giapha-avatars`
3. Connect to project → auto-inject `BLOB_READ_WRITE_TOKEN`
4. Pull env: `vercel env pull .env.local`

### 4. Generate AUTH_SECRET

```bash
openssl rand -base64 32
```

Add vào Vercel env vars (Production + Preview + Development) + `.env.local`:
```
AUTH_SECRET=<generated>
AUTH_URL=http://localhost:3000  # production tự pick từ VERCEL_URL
```

### 5. Create drizzle.config.ts

```ts
import type { Config } from "drizzle-kit";

export default {
  schema: "./lib/db/schema/*",
  out: "./lib/db/migrations",
  dialect: "postgresql",
  dbCredentials: {
    url: process.env.POSTGRES_URL!,
  },
} satisfies Config;
```

### 6. Update .env.example

Thêm các biến mới (giữ Supabase vars để backward compat phase này):
```
# === Vercel Postgres (auto-injected by Vercel) ===
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

# === Supabase (legacy, sẽ xoá ở Phase 6) ===
NEXT_PUBLIC_SUPABASE_URL=
NEXT_PUBLIC_SUPABASE_PUBLISHABLE_DEFAULT_KEY=
```

### 7. Verify

```bash
bun install
bun run build
```

App phải build pass — chưa code mới, chỉ deps.

## Todo List

- [ ] Install 6 packages mới
- [ ] Provision Vercel Postgres trong dashboard
- [ ] Provision Vercel Blob trong dashboard
- [ ] Pull env vars: `vercel env pull .env.local`
- [ ] Generate + add AUTH_SECRET
- [ ] Create `drizzle.config.ts`
- [ ] Update `.env.example`
- [ ] Run `bun install` + `bun run build` pass

## Success Criteria

- `bun install` không error
- `bun run build` pass
- `.env.local` có đủ POSTGRES_*, BLOB_READ_WRITE_TOKEN, AUTH_SECRET
- Vercel dashboard show database + blob đã connect

## Risk Assessment

| Risk | Mitigation |
|---|---|
| Vercel Postgres region không có Singapore | Fallback: Tokyo / Mumbai (acceptable latency) |
| `bun install` conflict deps | Lock bun version, use `--frozen-lockfile` |
| AUTH_SECRET leak | Verify `.env.local` trong `.gitignore` |

## Security Considerations

- `AUTH_SECRET` 32 bytes random, KHÔNG commit
- `BLOB_READ_WRITE_TOKEN` server-only, KHÔNG expose client
- Verify `.gitignore` có `.env*.local`

## Next Steps

Phase 2: Convert SQL schema sang Drizzle TypeScript schema, generate migrations.
