---
type: code-review
phase: 2
title: Phase 2 Gender Enhancement Review
date: 2026-03-16
files_reviewed:
  - components/FamilyStats.tsx (372 LOC)
  - components/BaseToolbar.tsx (234 LOC)
---

# Code Review: Phase 2 - Gender Enhancement

## Scope
- Files: `components/FamilyStats.tsx`, `components/BaseToolbar.tsx`
- LOC: ~606 combined
- Focus: Recent changes for gender-stacked bars, quick-view presets
- Dependents scouted: `TreeToolbar.tsx`, `MindmapToolbar.tsx`, `FamilyTree.tsx`, `MindmapTree.tsx`, `utils/treeHelpers.ts`, `types/index.ts`

## Overall Assessment

Solid implementation. Both files are clean, well-structured, and follow existing patterns. The gender-stacked generation bars and quick-view presets are functional and consistent with the app's design language. A few issues found, none critical.

---

## Critical Issues

None.

---

## High Priority

### H1. Division-by-zero in GenerationRow animation widths (FamilyStats.tsx:106,113)

The `pct`, `malePct`, `femalePct` local variables correctly guard against `max === 0` and `total === 0`. However, the `motion.div` animate widths on lines 106 and 113 compute `(male / max) * 100` and `(female / max) * 100` directly without using those guarded variables, bypassing the safety check.

If `max` is 0 (theoretically impossible since `max` is `stats.total` and the section only renders when `generationBreakdown.length > 0`, but defensive coding is warranted), this produces `NaN%` width.

**Lines 106, 113:**
```tsx
// Current (unguarded):
animate={{ width: `${(male / max) * 100}%` }}
animate={{ width: `${(female / max) * 100}%` }}

// Fix — reuse the guarded computation or inline guard:
animate={{ width: `${max > 0 ? (male / max) * 100 : 0}%` }}
animate={{ width: `${max > 0 ? (female / max) * 100 : 0}%` }}
```

The existing `pct` variable (line 94) already has this guard but is unused. Either use it to derive sub-widths, or add inline guards.

### H2. Gender "other" is silently dropped in stats and bars (FamilyStats.tsx:141-142, 174-185)

The `Gender` type includes `"other"`. Currently:
- `male` count: `gender === "male"`
- `female` count: `gender === "female"`
- Persons with `gender === "other"` are counted in `total` but appear in neither `male` nor `female`, creating a silent discrepancy where `male + female < total` in the generation breakdown.
- The stacked bar will undercount — the bar won't fill to `total`'s proportion.

**Impact:** Visual inaccuracy. The generation bar for a given row may not reach the expected width since `male + female` might not equal `total` for that generation.

**Fix options:**
1. Add an `other` counter and a third bar segment (gray) — most correct
2. Document the gap with a note in the UI ("* Khong tinh gioi tinh khac")
3. At minimum, the tooltip on line 121 should reflect this

### H3. Preset "Dong cha" semantics may be confusing (BaseToolbar.tsx:137-145)

"Dong cha" (paternal line) sets `hideFemales: true` + `hideDaughtersInLaw: true`. This hides ALL females including biological daughters. In Vietnamese genealogy, "dong cha" typically means tracing lineage through the father but still showing daughters (they just don't continue the line). Hiding all females removes them entirely from view.

**Impact:** User confusion. The preset removes ALL women from the tree rather than showing the paternal lineage structure (which includes daughters).

**Recommendation:** Verify with domain expert whether "dong cha" should hide all females or only hide daughters-in-law (keeping daughters visible). If the intent is truly to show ONLY males in the tree, the label might be better as "Chi nam" (males only). Same logic applies to "Dong me" in reverse.

---

## Medium Priority

### M1. Unused computed variables in GenerationRow (FamilyStats.tsx:94-96)

`pct`, `malePct`, and `femalePct` are computed but only `malePct` and `femalePct` are used in the title attribute (line 121). `pct` is completely unused. The actual bar widths use raw `(male / max) * 100` inline instead of these pre-computed values. Either use them or remove them to reduce confusion.

### M2. Quick-view presets trigger 6 state updates per click (BaseToolbar.tsx:126-132, 139-145, 152-158)

Each preset button calls 6 individual `set*` functions. In React 18+ with automatic batching, these will batch inside event handlers, so no extra re-renders. However, if the parent ever moves these to async contexts (e.g., in a `setTimeout` or after an `await`), each call would trigger a separate render.

**Recommendation (low urgency):** Consider consolidating filter state into a single object `{ hideMales, hideFemales, ... }` with one setter. This is a future improvement, not blocking.

### M3. No active-state visual feedback on preset buttons (BaseToolbar.tsx:133, 146, 159)

The quick-view buttons always show the same style regardless of which preset is currently active. Users can't tell if "Dong cha" is active or if they manually set the same filters. Adding a visual indicator (e.g., ring, bold border) when the current filter state matches a preset would improve UX.

### M4. File approaching 200-line limit (BaseToolbar.tsx: 234 LOC)

Per project rules, files should stay under 200 LOC. BaseToolbar.tsx is at 234. Consider extracting the filter panel content (lines 106-222) into a separate `FilterPanel.tsx` component.

---

## Low Priority

### L1. Hardcoded color strings repeated across FamilyStats.tsx

`bg-blue-400` and `bg-pink-400` appear in multiple places (StatCard colors, GenerationRow bars, legend, gender ratio section). If the color scheme changes, multiple locations need updating. Could extract to constants:
```tsx
const GENDER_COLORS = { male: "bg-blue-400", female: "bg-pink-400" } as const;
```

### L2. Magic number for generation bar max (FamilyStats.tsx:310)

`max={stats.total}` means the generation bar widths are relative to the total person count, not the max generation count. This is a deliberate design choice (proportional to whole family), but means small generations may have barely visible bars. An alternative: `max={Math.max(...stats.generationBreakdown.map(g => g.total))}` would make bars relative to the largest generation. Either approach is valid — this is a design decision, not a bug.

---

## Edge Cases Found by Scouting

1. **Gender "other" gap:** `types/index.ts` defines `Gender = "male" | "female" | "other"` but the stats and bars only handle male/female. Persons with `"other"` gender will be counted in totals but invisible in breakdowns. See H2.

2. **Filter state sync between presets and checkboxes:** Clicking "Dong cha" sets `hideFemales: true`, which also checks the "An nu" checkbox in the filter panel below. This is correct behavior — the UI stays in sync because both reference the same state. No bug here.

3. **All filters ON simultaneously:** If a user enables "An nam" AND "An nu" individually, the tree becomes empty. The presets don't create this state, but manual checkboxes can. No crash — the tree simply shows nothing. Acceptable behavior, though a warning toast could be a nice-to-have.

4. **Generation null values:** The code correctly skips persons with `generation == null` (line 175: `if (p.generation != null)`). The footnote on line 316 documents this for users. Good.

5. **Empty persons array:** Both components handle empty arrays gracefully. `stats.total === 0` guards division, `generationBreakdown.length > 0` guards the section render. The gender ratio section uses `stats.total > 0` guard. Clean.

---

## Positive Observations

- **Proper memoization:** `useMemo` with correct dependency array `[persons, relationships]` on the stats computation
- **Division-by-zero guards** on StatCard (line 39) and gender ratio (lines 356, 363) — well done
- **Accessible tooltips:** `title` attributes on bar segments and summary spans provide hover context
- **Animation staggering:** Progressive delays on generation rows create a polished appearance
- **Default filters verified:** Both FamilyTree.tsx and MindmapTree.tsx initialize all `hide*` states to `false` — females are shown by default. Phase 2 requirement met.
- **Clean component boundaries:** GenerationRow as a separate function component keeps FamilyStats readable
- **Portal-based toolbar:** BaseToolbar's portal pattern correctly supports both Tree and Mindmap toolbar variants without duplication
- **Consistent design language:** Colors (blue-400, pink-400), rounded-2xl cards, stone color palette all match existing components

---

## Recommended Actions

1. **[Fix]** Guard division in GenerationRow animate widths (H1) — simple inline fix
2. **[Discuss]** Decide how to handle `gender === "other"` in stats (H2) — add third segment or document exclusion
3. **[Verify]** Confirm "Dong cha" / "Dong me" semantics with domain expert (H3)
4. **[Refactor]** Remove or use the unused `pct` variable in GenerationRow (M1)
5. **[UX]** Add active-state indicator on preset buttons (M3) — nice-to-have
6. **[Refactor]** Extract filter panel to stay under 200 LOC limit (M4)

---

## Metrics

| Metric | Value |
|--------|-------|
| Type Safety | Good — all props typed, interfaces defined |
| Division Guards | Partial — StatCard guarded, GenerationRow widths unguarded |
| Accessibility | Basic — title attrs present, no aria-labels |
| File Size | FamilyStats: 372 LOC (over limit), BaseToolbar: 234 LOC (over limit) |
| Linting Issues | 0 syntax errors expected |
| Gender "other" Coverage | Missing from stats/bars |

---

## Todo Checklist Verification (Phase 2)

| Todo Item | Status |
|-----------|--------|
| Verify default filters do not hide females | DONE - all defaults `false` |
| Color coding nodes by gender (Tree + Mindmap) | Not in scope of these files |
| Avatar placeholder by gender | Not in scope of these files |
| Gender ratio in FamilyStats | DONE - ratio bar + legend + percentages |
| Matrilineal view toggle | PARTIAL - "Dong me" preset added, not a full matrilineal view |
| Stats: gender breakdown by generation | DONE - stacked bars per generation |

---

## Unresolved Questions

1. Should `gender === "other"` be represented in generation breakdown bars and gender ratio? If yes, what color?
2. Does "Dong cha" mean "show only males" or "show paternal lineage including daughters"? The current implementation hides all females.
3. Should the generation bar max be relative to `stats.total` (current) or to the largest generation count? This affects visual proportionality.
4. FamilyStats.tsx (372 LOC) and BaseToolbar.tsx (234 LOC) both exceed the 200-line guideline — should these be split now or deferred?
