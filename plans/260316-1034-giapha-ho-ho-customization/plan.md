---
title: Gia Phả Họ Hồ - Customization & Enhancement
status: in-progress
priority: P1
effort: large
branch: main
tags: [genealogy, customization, vietnamese, family-tree]
created: 2026-03-16
---

# Gia Phả Họ Hồ - Implementation Plan

**Source:** https://github.com/homielab/giapha-os.git (đã clone)
**Mục tiêu:** Customize giapha-os cho dòng Họ Hồ, đảm bảo liệt kê CẢ NAM VÀ NỮ, thêm nhiều tính năng mới.

## Context
- Dữ liệu: Chưa có, nhập tay từ đầu
- Quy mô: 6-10 đời (~50-200 người)
- Deploy: Quyết định sau, focus local trước
- Customize: Sâu — thêm nhiều tính năng mới

## Phases

| # | Phase | Status | Progress |
|---|-------|--------|----------|
| 1 | [Setup & Branding](phase-01-setup-branding.md) | in-progress | 30% |
| 2 | [Gender Enhancement](phase-02-gender-enhancement.md) | completed | 100% |
| 3 | [Family Photo & Media](phase-03-family-media.md) | pending | 0% |
| 4 | [Events & Memorial](phase-04-events-memorial.md) | pending | 0% |
| 5 | [Data Entry & Import](phase-05-data-entry.md) | pending | 0% |
| 6 | [UI/UX Improvements](phase-06-ui-ux.md) | completed | 100% |
| 7 | [Testing & Deploy](phase-07-testing-deploy.md) | pending | 0% |

## Key Dependencies
- Supabase project (Phase 1)
- Bun runtime installed (Phase 1)
- Data collection from family (Phase 5)

## Architecture
- Next.js 16 + React 19 + TypeScript
- Supabase (PostgreSQL + Auth + RLS + Storage)
- Tailwind CSS 4.2.1
