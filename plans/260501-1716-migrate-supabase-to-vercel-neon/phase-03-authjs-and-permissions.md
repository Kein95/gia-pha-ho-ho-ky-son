---
phase: 3
title: Auth.js v5 + Permission Helpers
status: pending
priority: P1
effort: ~5h
---

# Phase 3: Auth.js v5 + Permission Helpers (Replace RLS)

## Context Links

- [Plan overview](plan.md)
- Existing files: `utils/supabase/{server,client,middleware,queries}.ts`, `proxy.ts`, `app/login/page.tsx`

## Overview

Setup Auth.js v5 với Credentials provider (email + password bcrypt). Tạo permission helpers thay 15 RLS policies + 5 RPC functions. KHÔNG xoá Supabase code phase này — để Phase 4-6 cleanup.

## Key Insights

- **Auth.js v5** dùng `auth()` server function thay `useSession()` cũ
- **Credentials provider** không hỗ trợ DB sessions chuẩn → dùng JWT strategy
- **First user auto-admin BỎ** (user chọn invite-only) → admin seed qua script Phase 5
- **bcryptjs** compatible với Supabase `crypt(pw, gen_salt('bf'))` → password hash migrate được
- **`auth.uid()` Supabase** → `(await auth())?.user?.id`
- **`is_admin()` SQL function** → `await requireAdmin()` TypeScript helper

## Requirements

**Functional:**
- Email/password sign in via Auth.js Credentials
- Session persists qua JWT cookie
- Permission helpers: `requireAuth()`, `requireAdmin()`, `requireEditor()`, `getCurrentUser()`
- 5 admin RPC functions implement TypeScript: `getAdminUsers`, `setUserRole`, `deleteUser`, `adminCreateUser`, `setUserActiveStatus`
- Middleware redirect protected routes nếu chưa login

**Non-functional:**
- Type-safe session via Auth.js types
- Permission helpers throw error nếu fail (server actions catch + return UI error)

## Architecture

```
lib/
├── auth/
│   ├── config.ts               # Auth.js config (providers, callbacks)
│   ├── index.ts                # Re-export auth(), signIn, signOut
│   ├── permissions.ts          # requireAuth, requireAdmin, requireEditor
│   └── admin-actions.ts        # 5 RPC function replacements
└── db/...
```

### Permission flow

```
Server Action / Page
    ↓
const session = await auth()
    ↓
requireAdmin(session) → throw if not admin
    ↓
Drizzle query (KHÔNG có RLS, app code là gate duy nhất)
```

## Related Code Files

**Create:**
- `auth.ts` (root) — Auth.js NextAuth instance
- `auth.config.ts` (root) — middleware-safe config
- `lib/auth/permissions.ts`
- `lib/auth/admin-actions.ts`
- `middleware.ts` (root, replace `proxy.ts`) — Auth.js middleware

**Modify (later phases):**
- `app/login/page.tsx` — đổi sang Auth.js signIn
- `components/UserProvider.tsx` — đổi sang Auth.js session
- `components/LogoutButton.tsx` — đổi sang Auth.js signOut

**Read for context:**
- `docs/schema.sql` (RPC functions section)
- `app/login/page.tsx`
- `proxy.ts`

## Implementation Steps

### 1. Create auth.config.ts (middleware-safe, no DB imports)

```ts
import type { NextAuthConfig } from "next-auth";

export const authConfig = {
  pages: { signIn: "/login" },
  providers: [],  // populated in auth.ts (DB-dependent)
  callbacks: {
    authorized({ auth, request: { nextUrl } }) {
      const isLoggedIn = !!auth?.user;
      const isProtected = nextUrl.pathname.startsWith("/dashboard");
      const isLoginPage = nextUrl.pathname.startsWith("/login");
      if (isProtected && !isLoggedIn) return false;  // redirect to /login
      if (isLoginPage && isLoggedIn) {
        return Response.redirect(new URL("/dashboard", nextUrl));
      }
      return true;
    },
    jwt({ token, user }) {
      if (user) {
        token.id = user.id;
        token.role = user.role;
        token.isActive = user.isActive;
      }
      return token;
    },
    session({ session, token }) {
      if (token && session.user) {
        session.user.id = token.id as string;
        session.user.role = token.role as "admin" | "editor" | "member";
        session.user.isActive = token.isActive as boolean;
      }
      return session;
    },
  },
  session: { strategy: "jwt" },
} satisfies NextAuthConfig;
```

### 2. Create auth.ts (full config with Credentials provider)

```ts
import NextAuth from "next-auth";
import Credentials from "next-auth/providers/credentials";
import bcrypt from "bcryptjs";
import { eq } from "drizzle-orm";
import { db } from "@/lib/db";
import { users } from "@/lib/db/schema";
import { authConfig } from "./auth.config";

export const { handlers, auth, signIn, signOut } = NextAuth({
  ...authConfig,
  providers: [
    Credentials({
      credentials: {
        email: { label: "Email", type: "email" },
        password: { label: "Password", type: "password" },
      },
      async authorize(credentials) {
        const email = credentials?.email as string;
        const password = credentials?.password as string;
        if (!email || !password) return null;

        const [user] = await db.select().from(users).where(eq(users.email, email));
        if (!user || !user.passwordHash) return null;
        if (!user.isActive) return null;  // Inactive user blocked

        const ok = await bcrypt.compare(password, user.passwordHash);
        if (!ok) return null;

        return {
          id: user.id,
          email: user.email,
          name: user.name,
          role: user.role,
          isActive: user.isActive,
        };
      },
    }),
  ],
});
```

### 3. Type augmentation cho Auth.js

`types/next-auth.d.ts`:

```ts
import "next-auth";
import "next-auth/jwt";

declare module "next-auth" {
  interface User {
    role: "admin" | "editor" | "member";
    isActive: boolean;
  }
  interface Session {
    user: {
      id: string;
      email: string;
      name?: string | null;
      role: "admin" | "editor" | "member";
      isActive: boolean;
    };
  }
}

declare module "next-auth/jwt" {
  interface JWT {
    id: string;
    role: "admin" | "editor" | "member";
    isActive: boolean;
  }
}
```

### 4. Create middleware.ts (replace proxy.ts)

```ts
import NextAuth from "next-auth";
import { authConfig } from "./auth.config";

export default NextAuth(authConfig).auth;

export const config = {
  matcher: ["/((?!api|_next/static|_next/image|favicon.ico|.*\\.png$).*)"],
};
```

### 5. Create lib/auth/permissions.ts

```ts
import { auth } from "@/auth";
import { unauthorized, forbidden } from "next/navigation";  // Next.js 15+

export async function getCurrentUser() {
  const session = await auth();
  return session?.user ?? null;
}

export async function requireAuth() {
  const user = await getCurrentUser();
  if (!user) unauthorized();  // 401
  return user;
}

export async function requireAdmin() {
  const user = await requireAuth();
  if (user.role !== "admin") forbidden();  // 403
  return user;
}

export async function requireEditor() {
  const user = await requireAuth();
  if (user.role !== "admin" && user.role !== "editor") forbidden();
  return user;
}

export async function isAdmin() {
  const user = await getCurrentUser();
  return user?.role === "admin";
}
```

### 6. Create lib/auth/admin-actions.ts (replace 5 RPC functions)

```ts
"use server";
import { db } from "@/lib/db";
import { users } from "@/lib/db/schema";
import { eq } from "drizzle-orm";
import bcrypt from "bcryptjs";
import { requireAdmin } from "./permissions";

export async function getAdminUsers() {
  await requireAdmin();
  return db.select({
    id: users.id,
    email: users.email,
    role: users.role,
    isActive: users.isActive,
    createdAt: users.createdAt,
  }).from(users).orderBy(users.createdAt);
}

export async function setUserRole(targetUserId: string, newRole: "admin" | "editor" | "member") {
  await requireAdmin();
  await db.update(users).set({ role: newRole }).where(eq(users.id, targetUserId));
}

export async function deleteUser(targetUserId: string) {
  const admin = await requireAdmin();
  if (admin.id === targetUserId) {
    throw new Error("Cannot delete yourself");
  }
  await db.delete(users).where(eq(users.id, targetUserId));
}

export async function adminCreateUser(input: {
  email: string;
  password: string;
  role: "admin" | "editor" | "member";
  isActive: boolean;
}) {
  await requireAdmin();
  const passwordHash = await bcrypt.hash(input.password, 10);
  const [user] = await db.insert(users).values({
    email: input.email,
    passwordHash,
    role: input.role,
    isActive: input.isActive,
  }).returning({ id: users.id });
  return user.id;
}

export async function setUserActiveStatus(targetUserId: string, isActive: boolean) {
  await requireAdmin();
  await db.update(users).set({ isActive }).where(eq(users.id, targetUserId));
}
```

### 7. Add SIGN-IN/OUT API route

`app/api/auth/[...nextauth]/route.ts`:

```ts
export { GET, POST } from "@/auth";
```

### 8. Verify build

```bash
bun run build
```

Phải pass — `auth()`, `requireAdmin()` types resolve OK.

## Todo List

- [ ] Create `auth.config.ts`
- [ ] Create `auth.ts`
- [ ] Create `types/next-auth.d.ts`
- [ ] Create `middleware.ts` (replace proxy.ts logic)
- [ ] Create `lib/auth/permissions.ts`
- [ ] Create `lib/auth/admin-actions.ts`
- [ ] Create `app/api/auth/[...nextauth]/route.ts`
- [ ] Add Auth.js env vars vào Vercel
- [ ] `bun run build` pass

## Success Criteria

- TypeScript build pass với types augmented
- `auth()` callable từ server components
- `requireAdmin()` throw forbidden khi không phải admin
- `signIn("credentials", { email, password })` work
- Middleware redirect `/dashboard` → `/login` khi chưa auth

## Risk Assessment

| Risk | Mitigation |
|---|---|
| Auth.js v5 beta breaking change | Lock version exact: `"next-auth": "5.0.0-beta.X"`. Có thể fallback v4 nếu vỡ |
| Password hash format mismatch | Test với 1 user existing trước khi migrate full |
| JWT secret rotation = invalidate all sessions | Document rõ trong README |
| Middleware infinite redirect loop | Test thủ công các path: /, /login, /dashboard, /dashboard/x |

## Security Considerations

- `AUTH_SECRET` 32 bytes random, KHÔNG commit
- Password hash với bcrypt cost 10 (Supabase default)
- `isActive: false` → block login (Credentials authorize trả null)
- `passwordHash` KHÔNG return về client qua session
- Admin actions luôn check `requireAdmin()` trước Drizzle query

## Next Steps

Phase 4: Rewrite 31 files dùng Supabase SDK sang Drizzle queries + Auth.js session.
