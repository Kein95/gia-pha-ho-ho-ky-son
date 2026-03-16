---
phase: 7
title: Testing & Deployment
status: pending
priority: P1
effort: medium
---

# Phase 7: Testing & Deploy

## Context
- Repo gốc không có test suite
- Deploy target: TBD (Vercel hoặc self-host)

## Overview
Add testing, ensure quality, prepare deployment.

## Requirements
### Functional
- Unit tests cho core logic (kinship, tree, date helpers)
- Integration tests cho server actions
- E2E tests cho critical flows
- CI/CD pipeline

### Non-functional
- >80% coverage cho utils/
- Build thành công, no TypeScript errors
- Security audit (RLS policies)

## Related Code Files
### Create
- `__tests__/` — Test directory
- `.github/workflows/ci.yml` — CI pipeline
- `vitest.config.ts` — Test config

## Implementation Steps
1. Setup Vitest + testing-library
2. Write unit tests cho kinshipHelpers, treeHelpers, dateHelpers
3. Write component tests cho MemberForm, FamilyTree
4. Security audit RLS policies
5. Setup CI/CD (GitHub Actions)
6. Choose deploy target & deploy
7. DNS/domain setup nếu cần

## Todo List
- [ ] Setup Vitest
- [ ] Unit tests cho utils
- [ ] Component tests
- [ ] Security audit
- [ ] CI/CD pipeline
- [ ] Deploy

## Success Criteria
- All tests pass
- Build thành công
- App accessible online
- RLS policies verified

## Risk Assessment
- No existing tests → build from scratch
- Deploy cost: Vercel free tier đủ cho small app
