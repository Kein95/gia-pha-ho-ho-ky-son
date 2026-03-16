---
phase: 1
title: Setup & Branding
status: pending
priority: P1
effort: small
---

# Phase 1: Setup & Branding

## Context
- [README.md](../../README.md) — Hướng dẫn cài đặt
- [.env.example](../../.env.example) — Biến môi trường
- [app/layout.tsx](../../app/layout.tsx) — Root layout, metadata

## Overview
Setup môi trường dev local, tạo Supabase project, customize branding cho Họ Hồ.

## Key Insights
- Cần Supabase project riêng cho Họ Hồ
- SITE_NAME env var controls app title
- Tailwind config cho custom colors

## Requirements
### Functional
- App title: "Gia Phả Họ Hồ"
- Custom color scheme phù hợp
- Supabase database initialized with schema.sql

### Non-functional
- Dev server chạy local thành công
- TypeScript compile không lỗi

## Related Code Files
### Modify
- `.env.example` → `.env.local`
- `app/layout.tsx` — metadata title/description
- `public/` — favicon/logo nếu có

### Create
- `.env.local` — env vars

## Implementation Steps
1. Tạo Supabase project mới tại supabase.com
2. Chạy `docs/schema.sql` trong Supabase SQL Editor
3. Copy `.env.example` → `.env.local`, điền Supabase credentials
4. Cập nhật `SITE_NAME="Gia Phả Họ Hồ"`
5. `bun install` để cài dependencies
6. `bun run dev` để verify local server
7. Đăng ký tài khoản đầu tiên (auto admin)
8. Customize metadata trong `app/layout.tsx`

## Todo List
- [ ] Tạo Supabase project
- [ ] Chạy schema.sql
- [ ] Tạo .env.local
- [ ] bun install + bun run dev
- [ ] Đăng ký tài khoản admin
- [ ] Customize branding (title, colors)

## Success Criteria
- Local dev server chạy tại localhost:3000
- Đăng nhập được với tài khoản admin
- Title hiển thị "Gia Phả Họ Hồ"

## Risk Assessment
- Supabase free tier giới hạn 500MB → đủ cho 200 người
- Bun chưa cài → fallback npm

## Next Steps
→ Phase 2: Gender Enhancement
