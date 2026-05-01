---
phase: 5
title: Storage + Data Migration (Production)
status: pending
priority: P1
effort: ~4h
---

# Phase 5: Storage + Data Migration

## Context Links

- [Plan overview](plan.md)
- Phase 1-4 hoàn thành: Vercel Postgres + Blob ready, app code không còn Supabase calls

## Overview

Migrate data prod thật của họ Hồ:
1. Backup Supabase trước
2. Export data từ Supabase Postgres
3. Transform + import vào Vercel Postgres
4. Migrate avatars Supabase Storage → Vercel Blob
5. Update `avatar_url` trong DB
6. Seed admin invite-only user(s)

⚠️ **CRITICAL:** Data prod thật → backup trước, test trên staging.

## Key Insights

- **`auth.users` (Supabase managed)** → `public.users` (Auth.js Drizzle):
  - `id` (UUID) giữ nguyên
  - `email` lấy từ `auth.users.email`
  - `encrypted_password` (bcrypt) → `password_hash` (compatible bcrypt)
  - `email_confirmed_at` → `emailVerified`
  - Profile data từ `public.profiles`: `role`, `is_active`
- **Bcrypt format**: Supabase dùng `$2a$XX$...`, bcryptjs verify `$2a` + `$2b` đều OK → migrate hash trực tiếp
- **Avatar URLs**: `https://<project>.supabase.co/storage/v1/object/public/avatars/<filename>` → cần download + reupload sang Vercel Blob
- **Foreign keys**: import order: `users` → `persons` → `person_details_private` → `relationships` → `custom_events`
- **First-user-admin trigger** đã bỏ Phase 2 → seed 1 admin manual qua script

## Requirements

**Functional:**
- Backup Supabase prod (full dump)
- Export 5 bảng từ Supabase: profiles, persons, person_details_private, relationships, custom_events
- Export auth.users (cho password hash)
- Import vào Vercel Postgres với schema mới
- Migrate avatars sang Vercel Blob, rewrite URLs
- Seed admin script (idempotent)

**Non-functional:**
- Migration script chạy được nhiều lần idempotent (re-runnable)
- Log chi tiết từng record migrated
- Rollback plan: nếu fail, drop tables Vercel Postgres + chạy lại

## Architecture

```
Migration scripts (in scripts/migration/)
├── 01-backup-supabase.sh           # pg_dump backup
├── 02-export-data.ts               # Connect Supabase, export to JSON
├── 03-transform-import.ts          # Read JSON, transform, insert via Drizzle
├── 04-migrate-avatars.ts           # Download Supabase avatars, upload Vercel Blob
└── 05-seed-admin.ts                # Create initial admin user (invite-only model)
```

## Related Code Files

**Create:**
- `scripts/migration/01-backup-supabase.sh`
- `scripts/migration/02-export-data.ts`
- `scripts/migration/03-transform-import.ts`
- `scripts/migration/04-migrate-avatars.ts`
- `scripts/migration/05-seed-admin.ts`
- `scripts/migration/README.md`

**Read for context:**
- `lib/db/schema/*` (target schema)
- Supabase project credentials (POSTGRES_URL của Supabase, anon/service keys)

## Implementation Steps

### 1. Create scripts/migration/01-backup-supabase.sh

```bash
#!/bin/bash
set -e
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="./backups"
mkdir -p "$BACKUP_DIR"

# Lấy connection string từ Supabase Project Settings → Database
SUPABASE_DB_URL="${SUPABASE_DB_URL:?Missing SUPABASE_DB_URL}"

pg_dump "$SUPABASE_DB_URL" \
  --schema=public \
  --schema=auth \
  --no-owner --no-privileges \
  -f "$BACKUP_DIR/supabase-backup-$TIMESTAMP.sql"

echo "Backup saved: $BACKUP_DIR/supabase-backup-$TIMESTAMP.sql"
```

User chạy:
```bash
export SUPABASE_DB_URL="postgres://postgres:<pw>@db.<ref>.supabase.co:5432/postgres"
bash scripts/migration/01-backup-supabase.sh
```

### 2. Create scripts/migration/02-export-data.ts

Dùng `pg` driver connect trực tiếp Supabase:

```ts
import { Client } from "pg";
import { writeFileSync, mkdirSync } from "fs";

const supabaseUrl = process.env.SUPABASE_DB_URL!;
const outDir = "./backups/exported";
mkdirSync(outDir, { recursive: true });

async function main() {
  const client = new Client({ connectionString: supabaseUrl });
  await client.connect();

  // Export từng bảng
  const tables = [
    { sql: "SELECT id, email, encrypted_password, email_confirmed_at, created_at FROM auth.users", file: "auth-users.json" },
    { sql: "SELECT * FROM public.profiles", file: "profiles.json" },
    { sql: "SELECT * FROM public.persons", file: "persons.json" },
    { sql: "SELECT * FROM public.person_details_private", file: "person-details-private.json" },
    { sql: "SELECT * FROM public.relationships", file: "relationships.json" },
    { sql: "SELECT * FROM public.custom_events", file: "custom-events.json" },
  ];

  for (const t of tables) {
    const { rows } = await client.query(t.sql);
    writeFileSync(`${outDir}/${t.file}`, JSON.stringify(rows, null, 2));
    console.log(`Exported ${rows.length} rows → ${t.file}`);
  }

  await client.end();
}
main().catch(console.error);
```

Chạy: `bun run scripts/migration/02-export-data.ts`

### 3. Create scripts/migration/03-transform-import.ts

```ts
import { readFileSync } from "fs";
import { db } from "../../lib/db";
import { users, persons, personDetailsPrivate, relationships, customEvents } from "../../lib/db/schema";

async function main() {
  const dir = "./backups/exported";
  const authUsers = JSON.parse(readFileSync(`${dir}/auth-users.json`, "utf-8"));
  const profiles = JSON.parse(readFileSync(`${dir}/profiles.json`, "utf-8"));
  const personsData = JSON.parse(readFileSync(`${dir}/persons.json`, "utf-8"));
  const detailsPrivate = JSON.parse(readFileSync(`${dir}/person-details-private.json`, "utf-8"));
  const relsData = JSON.parse(readFileSync(`${dir}/relationships.json`, "utf-8"));
  const eventsData = JSON.parse(readFileSync(`${dir}/custom-events.json`, "utf-8"));

  // 1. Merge auth.users + profiles → users
  const profileById = new Map(profiles.map((p: any) => [p.id, p]));
  const usersToInsert = authUsers.map((u: any) => {
    const profile = profileById.get(u.id);
    return {
      id: u.id,
      email: u.email,
      passwordHash: u.encrypted_password,  // bcrypt $2a$ format compatible
      emailVerified: u.email_confirmed_at,
      role: profile?.role ?? "member",
      isActive: profile?.is_active ?? false,
      createdAt: u.created_at,
    };
  });

  await db.insert(users).values(usersToInsert).onConflictDoNothing();
  console.log(`Imported ${usersToInsert.length} users`);

  // 2. Persons (snake_case → camelCase)
  const personsToInsert = personsData.map((p: any) => ({
    id: p.id,
    fullName: p.full_name,
    gender: p.gender,
    birthYear: p.birth_year,
    birthMonth: p.birth_month,
    birthDay: p.birth_day,
    deathYear: p.death_year,
    deathMonth: p.death_month,
    deathDay: p.death_day,
    deathLunarYear: p.death_lunar_year,
    deathLunarMonth: p.death_lunar_month,
    deathLunarDay: p.death_lunar_day,
    isDeceased: p.is_deceased,
    isInLaw: p.is_in_law,
    birthOrder: p.birth_order,
    generation: p.generation,
    otherNames: p.other_names,
    avatarUrl: p.avatar_url,  // Tạm giữ Supabase URL, Phase tiếp rewrite
    note: p.note,
    createdAt: p.created_at,
    updatedAt: p.updated_at,
  }));
  await db.insert(persons).values(personsToInsert).onConflictDoNothing();
  console.log(`Imported ${personsToInsert.length} persons`);

  // 3. person_details_private
  await db.insert(personDetailsPrivate).values(
    detailsPrivate.map((d: any) => ({
      personId: d.person_id,
      phoneNumber: d.phone_number,
      occupation: d.occupation,
      currentResidence: d.current_residence,
      createdAt: d.created_at,
      updatedAt: d.updated_at,
    }))
  ).onConflictDoNothing();
  console.log(`Imported ${detailsPrivate.length} private details`);

  // 4. Relationships
  await db.insert(relationships).values(
    relsData.map((r: any) => ({
      id: r.id,
      type: r.type,
      personA: r.person_a,
      personB: r.person_b,
      note: r.note,
      createdAt: r.created_at,
      updatedAt: r.updated_at,
    }))
  ).onConflictDoNothing();
  console.log(`Imported ${relsData.length} relationships`);

  // 5. Custom events
  await db.insert(customEvents).values(
    eventsData.map((e: any) => ({
      id: e.id,
      name: e.name,
      content: e.content,
      eventDate: e.event_date,
      location: e.location,
      createdBy: e.created_by,
      createdAt: e.created_at,
      updatedAt: e.updated_at,
    }))
  ).onConflictDoNothing();
  console.log(`Imported ${eventsData.length} custom events`);

  console.log("Migration complete.");
}

main().catch((e) => { console.error(e); process.exit(1); });
```

### 4. Create scripts/migration/04-migrate-avatars.ts

```ts
import { db } from "../../lib/db";
import { persons } from "../../lib/db/schema";
import { put } from "@vercel/blob";
import { eq } from "drizzle-orm";

async function main() {
  const allPersons = await db.select().from(persons);
  const supabaseAvatars = allPersons.filter((p) =>
    p.avatarUrl?.includes(".supabase.co/storage/v1/object/public/avatars/")
  );

  console.log(`Found ${supabaseAvatars.length} avatars to migrate`);

  for (const person of supabaseAvatars) {
    try {
      const res = await fetch(person.avatarUrl!);
      if (!res.ok) {
        console.warn(`Failed to download avatar for ${person.id}: ${res.status}`);
        continue;
      }
      const blob = await res.blob();
      const filename = `avatars/${person.id}-${Date.now()}.${blob.type.split("/")[1] || "jpg"}`;
      const uploaded = await put(filename, blob, {
        access: "public",
        contentType: blob.type,
      });

      await db.update(persons).set({ avatarUrl: uploaded.url }).where(eq(persons.id, person.id));
      console.log(`Migrated avatar for ${person.fullName}`);
    } catch (e) {
      console.error(`Error migrating avatar for ${person.id}:`, e);
    }
  }

  console.log("Avatar migration complete.");
}

main().catch((e) => { console.error(e); process.exit(1); });
```

### 5. Create scripts/migration/05-seed-admin.ts (invite-only model)

Trường hợp Supabase đã có admin → đã migrate qua Step 3. Script này dùng khi:
- Lần đầu deploy fresh (không có data Supabase cũ)
- Cần thêm admin mới qua CLI

```ts
import bcrypt from "bcryptjs";
import { db } from "../../lib/db";
import { users } from "../../lib/db/schema";

async function main() {
  const email = process.argv[2];
  const password = process.argv[3];
  if (!email || !password) {
    console.error("Usage: bun run scripts/migration/05-seed-admin.ts <email> <password>");
    process.exit(1);
  }

  const passwordHash = await bcrypt.hash(password, 10);
  const [user] = await db.insert(users).values({
    email,
    passwordHash,
    role: "admin",
    isActive: true,
    emailVerified: new Date(),
  }).returning({ id: users.id });

  console.log(`Admin created: ${email} (id=${user.id})`);
}

main().catch((e) => { console.error(e); process.exit(1); });
```

### 6. Create scripts/migration/README.md

Hướng dẫn chạy migration:

```markdown
# Migration Runbook

## Prerequisites
- Vercel Postgres + Blob provisioned (Phase 1)
- Drizzle schema pushed (Phase 2)
- App code refactored (Phase 4)
- `.env.local` có cả `SUPABASE_DB_URL` (legacy) + `POSTGRES_URL` (new) + `BLOB_READ_WRITE_TOKEN`

## Steps

1. **Backup**: `bash scripts/migration/01-backup-supabase.sh`
2. **Export**: `bun run scripts/migration/02-export-data.ts`
3. **Import**: `bun run scripts/migration/03-transform-import.ts`
4. **Migrate avatars**: `bun run scripts/migration/04-migrate-avatars.ts`
5. **Verify**: Connect Drizzle Studio, count rows.

## Rollback
Nếu fail mid-migration:
- DROP all tables Vercel Postgres: `bun run db:push -- --force` sau khi xoá schema
- Chạy lại `db:push` + restart từ step 2
```

### 7. Run on staging first

⚠️ User MUST chạy migration trên staging Vercel project trước:
1. Tạo Vercel project staging clone của prod
2. Provision Vercel Postgres + Blob staging
3. Run full migration
4. Smoke test
5. Nếu OK → run trên prod

### 8. Run on production

```bash
# Backup
bash scripts/migration/01-backup-supabase.sh

# Pull prod env
vercel env pull .env.local --environment=production

# Run migration scripts
bun run scripts/migration/02-export-data.ts
bun run scripts/migration/03-transform-import.ts
bun run scripts/migration/04-migrate-avatars.ts

# Verify
bun run db:studio  # check counts
```

## Todo List

- [ ] Create `scripts/migration/01-backup-supabase.sh`
- [ ] Create `scripts/migration/02-export-data.ts`
- [ ] Create `scripts/migration/03-transform-import.ts`
- [ ] Create `scripts/migration/04-migrate-avatars.ts`
- [ ] Create `scripts/migration/05-seed-admin.ts`
- [ ] Create `scripts/migration/README.md`
- [ ] Test full migration trên staging
- [ ] Verify counts staging match prod
- [ ] Run migration trên prod
- [ ] Verify counts prod
- [ ] Manual smoke test với 1 user thật

## Success Criteria

- Backup file tồn tại + readable
- Vercel Postgres rows count == Supabase rows count cho mỗi bảng
- Tất cả avatars accessible qua Vercel Blob URLs (no 404)
- 1 admin user login được với password cũ
- Manual smoke test pass

## Risk Assessment

| Risk | Severity | Mitigation |
|---|---|---|
| **Mất data prod** | CRITICAL | Backup trước, test staging trước, idempotent script |
| Password bcrypt format reject | TB | Test với 1 user trước migrate full. Fallback: force reset password broadcast |
| Avatar download fail (Supabase down/private) | TB | Log lỗi từng avatar, retry batch sau |
| Vercel Blob upload rate limit | THẤP | Batch 10 avatar/giây, retry với exponential backoff |
| FK violation khi import (relationships trước persons) | THẤP | Import order strict trong script |
| `onConflictDoNothing` skip update khi re-run | THẤP | Document: nếu cần re-run với fresh data, drop tables trước |

## Security Considerations

- `SUPABASE_DB_URL` chứa password DB → KHÔNG commit vào git
- Backup `.sql` file chứa hashed passwords → store offline (encrypted USB/cloud private)
- Migration script chạy với service role tương đương → audit kỹ
- Sau migration thành công, REVOKE Supabase service key

## Next Steps

Phase 6: Authorization audit + cleanup Supabase deps + decommission Supabase project.
