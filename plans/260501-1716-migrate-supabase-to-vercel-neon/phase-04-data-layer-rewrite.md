---
phase: 4
title: Data Layer Rewrite (31 files Supabase → Drizzle)
status: pending
priority: P1
effort: ~7h
---

# Phase 4: Data Layer Rewrite

## Context Links

- [Plan overview](plan.md)
- Files affected: 31 files dùng `@supabase/*` (xem brainstorm summary)

## Overview

Replace toàn bộ `supabase.from(...)` calls sang Drizzle queries. Replace `supabase.auth.*` sang Auth.js `auth()` + `signIn`/`signOut`. Sau phase này: 0 reference tới `@supabase/*` trong app code (nhưng `node_modules` vẫn còn — cleanup ở Phase 6).

## Key Insights

- **Pattern Supabase → Drizzle:**
  - `supabase.from("persons").select("*")` → `db.select().from(persons)`
  - `supabase.from("persons").select("*").eq("id", x).single()` → `db.select().from(persons).where(eq(persons.id, x)).limit(1)` then `[0]`
  - `supabase.from("persons").insert({...})` → `db.insert(persons).values({...}).returning()`
  - `supabase.from("persons").update({...}).eq("id", x)` → `db.update(persons).set({...}).where(eq(persons.id, x))`
  - `supabase.from("persons").delete().eq("id", x)` → `db.delete(persons).where(eq(persons.id, x))`
  - `supabase.rpc("get_admin_users")` → `await getAdminUsers()` (từ admin-actions.ts)
- **Camel case mapping**: Drizzle schema dùng camelCase (`fullName`, `birthYear`) nhưng DB cột vẫn snake_case (`full_name`, `birth_year`). Mapping tự động qua schema definition.
- **Result types khác**: Supabase trả `{ data, error }`, Drizzle trả data trực tiếp hoặc throw. Cần wrap try/catch.
- **`person_details_private` join**: trước RLS chặn member, giờ `requireAdmin()` rồi mới query.

## Requirements

**Functional:**
- Tất cả 31 files build pass với Drizzle imports
- Tất cả CRUD operations work: members, relationships, custom_events, users
- Login/logout work qua Auth.js
- Avatar upload/display work (Phase 5 thay storage)

**Non-functional:**
- Mỗi server action có permission check trước query
- Error messages giữ tiếng Việt như cũ

## Architecture

```
Refactor groups (priority order):
1. Auth-adjacent (4 files) — block UserProvider, login first
   ├── components/UserProvider.tsx
   ├── components/LogoutButton.tsx
   ├── app/login/page.tsx
   └── app/missing-db-config/page.tsx
2. Server actions (3 files) — core mutations
   ├── app/actions/member.ts
   ├── app/actions/user.ts
   └── app/actions/data.ts
3. Dashboard pages (8 files) — read queries
   ├── app/dashboard/page.tsx
   ├── app/dashboard/layout.tsx
   ├── app/dashboard/members/* (4 files)
   ├── app/dashboard/users/page.tsx
   ├── app/dashboard/stats/page.tsx
   ├── app/dashboard/lineage/page.tsx
   ├── app/dashboard/data/page.tsx
   ├── app/dashboard/events/page.tsx
   └── app/dashboard/kinship/page.tsx
4. Components (6 files) — client-side (use server actions)
   ├── components/RelationshipManager.tsx
   ├── components/MemberForm.tsx
   ├── components/MemberDetailModal.tsx
   ├── components/LineageManager.tsx
   ├── components/DataImportExport.tsx
   └── components/CustomEventModal.tsx
5. Setup page
   └── app/setup/page.tsx (nếu còn cần — có thể bỏ vì migration tự động)
```

## Related Code Files

**Modify (31 files):**

Auth-adjacent:
- `components/UserProvider.tsx`
- `components/LogoutButton.tsx`
- `app/login/page.tsx`
- `app/missing-db-config/page.tsx`

Server actions:
- `app/actions/member.ts`
- `app/actions/user.ts`
- `app/actions/data.ts`

Pages:
- `app/dashboard/page.tsx`
- `app/dashboard/layout.tsx`
- `app/dashboard/members/page.tsx`
- `app/dashboard/members/new/page.tsx`
- `app/dashboard/members/[id]/page.tsx`
- `app/dashboard/members/[id]/edit/page.tsx`
- `app/dashboard/users/page.tsx`
- `app/dashboard/stats/page.tsx`
- `app/dashboard/lineage/page.tsx`
- `app/dashboard/data/page.tsx`
- `app/dashboard/events/page.tsx`
- `app/dashboard/kinship/page.tsx`
- `app/setup/page.tsx`

Components:
- `components/RelationshipManager.tsx`
- `components/MemberForm.tsx`
- `components/MemberDetailModal.tsx`
- `components/LineageManager.tsx`
- `components/DataImportExport.tsx`
- `components/CustomEventModal.tsx`

**Delete after this phase (next phase):**
- `utils/supabase/server.ts`
- `utils/supabase/client.ts`
- `utils/supabase/middleware.ts`
- `utils/supabase/queries.ts`
- `proxy.ts` (logic moved to middleware.ts)

## Implementation Steps

### 1. Replace utils/supabase/queries.ts → lib/auth/queries.ts

```ts
import { cache } from "react";
import { eq } from "drizzle-orm";
import { db } from "@/lib/db";
import { users } from "@/lib/db/schema";
import { auth } from "@/auth";

export const getCurrentUser = cache(async () => {
  const session = await auth();
  return session?.user ?? null;
});

export const getProfile = cache(async (userId?: string) => {
  let id = userId;
  if (!id) {
    const user = await getCurrentUser();
    if (!user) return null;
    id = user.id;
  }
  const [profile] = await db.select().from(users).where(eq(users.id, id)).limit(1);
  return profile ?? null;
});

export const getIsAdmin = cache(async () => {
  const user = await getCurrentUser();
  return user?.role === "admin";
});
```

### 2. Refactor app/login/page.tsx

Replace `supabase.auth.signInWithPassword(...)` với:

```tsx
"use client";
import { signIn } from "next-auth/react";

async function handleLogin(formData: FormData) {
  const result = await signIn("credentials", {
    email: formData.get("email"),
    password: formData.get("password"),
    redirect: false,
  });
  if (result?.error) {
    setError("Email hoặc mật khẩu không đúng");
  } else {
    router.push("/dashboard");
  }
}
```

Bỏ phần signup (vì invite-only). Hiện thông báo "Liên hệ admin để được tạo tài khoản."

### 3. Refactor components/LogoutButton.tsx

```tsx
"use client";
import { signOut } from "next-auth/react";

<button onClick={() => signOut({ callbackUrl: "/login" })}>Đăng xuất</button>
```

### 4. Refactor components/UserProvider.tsx

Replace Supabase auth listener với Auth.js `SessionProvider`:

```tsx
"use client";
import { SessionProvider } from "next-auth/react";

export default function UserProvider({ children }: { children: React.ReactNode }) {
  return <SessionProvider>{children}</SessionProvider>;
}
```

Server-side data needs go through `getCurrentUser()` from `lib/auth/queries.ts`.

### 5. Refactor app/actions/member.ts

```ts
"use server";
import { db } from "@/lib/db";
import { persons, relationships } from "@/lib/db/schema";
import { eq, or } from "drizzle-orm";
import { requireEditor } from "@/lib/auth/permissions";
import { revalidatePath } from "next/cache";
import { redirect } from "next/navigation";

export async function deleteMemberProfile(memberId: string) {
  await requireEditor();

  const existingRels = await db
    .select({ id: relationships.id })
    .from(relationships)
    .where(or(eq(relationships.personA, memberId), eq(relationships.personB, memberId)))
    .limit(1);

  if (existingRels.length > 0) {
    return { error: "Không thể xoá. Vui lòng xoá hết các mối quan hệ gia đình của người này trước." };
  }

  try {
    await db.delete(persons).where(eq(persons.id, memberId));
  } catch (e) {
    console.error("Error deleting person:", e);
    return { error: "Đã xảy ra lỗi khi xoá hồ sơ." };
  }

  revalidatePath("/dashboard/members");
  redirect("/dashboard/members");
}
```

### 6. Refactor app/actions/user.ts

Wraps `lib/auth/admin-actions.ts` với form-friendly signatures:

```ts
"use server";
import {
  getAdminUsers as _list,
  setUserRole as _setRole,
  deleteUser as _delete,
  adminCreateUser as _create,
  setUserActiveStatus as _setActive,
} from "@/lib/auth/admin-actions";
import { revalidatePath } from "next/cache";

export async function listAdminUsers() {
  return _list();
}

export async function setUserRoleAction(formData: FormData) {
  const userId = formData.get("userId") as string;
  const role = formData.get("role") as "admin" | "editor" | "member";
  await _setRole(userId, role);
  revalidatePath("/dashboard/users");
}

// ... similar wrappers for các action khác
```

### 7. Refactor dashboard pages

Pattern chung:
```ts
// Cũ:
const supabase = await getSupabase();
const { data: persons } = await supabase.from("persons").select("*").order("full_name");

// Mới:
import { db } from "@/lib/db";
import { persons } from "@/lib/db/schema";
import { asc } from "drizzle-orm";
const allPersons = await db.select().from(persons).orderBy(asc(persons.fullName));
```

Permission check ở đầu file:
```ts
import { requireAuth } from "@/lib/auth/permissions";
// trong page component:
await requireAuth();
```

### 8. Refactor components dùng `createClient()` browser-side

`components/MemberForm.tsx`, `RelationshipManager.tsx`, etc. — các components này hiện gọi `createClient()` từ `utils/supabase/client.ts`. Convert sang server actions hoặc tRPC-style server functions.

**Recommended pattern:** Move data fetching lên server component cha, pass data xuống client component qua props. Mutations qua server actions.

### 9. Handle setup/missing-db-config pages

- `app/setup/page.tsx`: Có thể bỏ — Drizzle migrations chạy ngoài UI. Hoặc redirect tới `/login`.
- `app/missing-db-config/page.tsx`: Update message — env vars là `POSTGRES_*` thay `NEXT_PUBLIC_SUPABASE_*`.

### 10. Build + smoke test

```bash
bun run build
bun run dev
```

Manual smoke test:
- [ ] `/login` render
- [ ] Sign in với 1 admin user mới (insert thủ công vào DB tạm thời để test)
- [ ] `/dashboard` render
- [ ] List members
- [ ] Create new member
- [ ] Edit member
- [ ] Manage relationships
- [ ] List users (admin only)

## Todo List

- [ ] Create `lib/auth/queries.ts` (replace `utils/supabase/queries.ts`)
- [ ] Refactor `app/login/page.tsx` (signIn Auth.js)
- [ ] Refactor `components/LogoutButton.tsx`
- [ ] Refactor `components/UserProvider.tsx` (SessionProvider)
- [ ] Refactor `app/actions/member.ts`
- [ ] Refactor `app/actions/user.ts`
- [ ] Refactor `app/actions/data.ts`
- [ ] Refactor 11 dashboard pages
- [ ] Refactor 6 components
- [ ] Update `app/missing-db-config/page.tsx`
- [ ] Bỏ hoặc redirect `app/setup/page.tsx`
- [ ] `bun run build` pass
- [ ] Smoke test 7 flows manual

## Success Criteria

- 0 imports `@supabase/*` trong `app/`, `components/`, `lib/`
- `bun run build` pass
- 7 smoke test flows pass
- Type errors = 0

## Risk Assessment

| Risk | Severity | Mitigation |
|---|---|---|
| Subtle query semantics khác (single vs limit 1) | TB | Test từng read path manually |
| `revalidatePath` miss → stale cache | THẤP | Audit mọi mutation có revalidate |
| Camel/snake case mismatch | THẤP | Drizzle schema enforce, type errors catch |
| Component dùng browser supabase client client-side | TB | Move sang server actions |
| `cache()` từ React 19 + Drizzle conflict | THẤP | Test `getCurrentUser` cache hit |

## Security Considerations

- Mọi server action: permission check FIRST, query AFTER
- KHÔNG return `passwordHash` về client
- `person_details_private` queries: `requireAdmin()` mandatory
- `customEvents` update/delete: check `created_by === user.id` OR admin

## Next Steps

Phase 5: Migrate avatars Supabase Storage → Vercel Blob, migrate data prod qua pg_dump.
