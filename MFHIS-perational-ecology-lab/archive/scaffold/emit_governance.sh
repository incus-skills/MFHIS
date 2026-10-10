#!/bin/bash
# Generated from emit_governance.md via Literate Programming
# Generated on: Fri 12 Jun 14:28:35 BST 2026
# --------------------------------------------------
# Good. Consolidating governance framework into project directory.
#
# ---
#
# ## File 1: External Anchor Definition
#
# ```bash
BUILD_DIR=${1:-"${PWD}"}

filename="MFHIS/activation-kernel-system/003_MFHIS_External_Anchor.md"
conf_print_003_external_anchor() {
  cat <<-'EOF'
# 003_MFHIS_External_Anchor.md

## Purpose

Define the external anchor for MFHIS observational comparisons.

The external anchor is the invariant observed output structure that cannot move when interpretation moves.

---

## Definition

> **The external anchor is the raw, minimal result structure that is agreed upon before interpretation.**

In the probe series, this is:

```
A → B and A → C (or equivalent compressed result)
```

NOT:

- why it happened
- what was removed
- whether it is consistent
- what it means

Only the observable output structure.

---

## Requirements

| Requirement | Met |
|-------------|-----|
| Independent of MFHIS | ✓ |
| Independent of observer regime | ✓ (both agree on result) |
| Non-recursive | ✓ |
| Non-interpretive | ✓ |
| Verifiable across sessions | ✓ |

---

## Preservation Objective

Preserve the raw result structure as the fixed point against which all interpretations are compared.

Do not allow interpretation to modify, add to, or subtract from the external anchor.
EOF
}
mkdir -p "$(dirname "${filename}")"
conf_print_003_external_anchor | tee "${BUILD_DIR}/${filename}"
# ```
#
# ---
#
# ## File 2: Governance Constraints
#
# ```bash
filename="MFHIS/constraint-system/governance_constraints.md"
conf_print_governance_constraints() {
  cat <<-'EOF'
# Governance Constraints

## Purpose

Define the constraints that govern valid MFHIS operation and prevent interpretive drift.

These are not rules of interpretation. They are limits on what counts as a valid claim inside the system.

---

## Constraint 1 — Observational Separation

> Observation must precede interpretation. Interpretation must not alter observed structure.

**Meaning:**
- No inference can rewrite topology
- No interpretation can add or remove nodes
- No ecological projection can change result structure

---

## Constraint 2 — Regime Transparency

> Every output must declare its regime (aligned / unaligned / mixed)

**Meaning:**
- You must always know whether output is constraint-sensitive or not
- You must always know whether frame validation is active
- Without this, comparison becomes meaningless

---

## Constraint 3 — Non-Collapse Rule

> Interpretation must not collapse into a single explanatory closure

**Meaning:**
- Aligned sessions must not reduce all histories to one "most valid"
- Aligned sessions must not eliminate admissible alternatives unless explicitly ruled out by constraints
- Unaligned sessions must not assume all alternatives are equally valid if they violate constraints

---

## Constraint 4 — Frame Fixity During Evaluation

> Frame is fixed during analysis. Frame can only be changed in a dedicated meta-phase.

**Meaning:**
- You cannot change transformation rules mid-analysis
- You cannot question coherence while still reconstructing
- Separate: (1) evaluation phase, (2) frame critique phase

---

## Preservation Objective

Apply these constraints to all MFHIS observational activities. Do not treat them as optional.

They are the governance layer that prevents infinite meta-expansion.
EOF
}
mkdir -p "$(dirname "${filename}")"
conf_print_governance_constraints | tee "${BUILD_DIR}/${filename}"
# ```
#
# ---
#
# ## File 3: Stopping Rule / Termination Criteria
#
# ```bash
filename="MFHIS/constraint-system/termination_criteria.md"
conf_print_termination_criteria() {
  cat <<-'EOF'
# Termination Criteria

## Purpose

Define when probing stops. Without this, MFHIS becomes an infinite regress engine.

---

## Termination Condition

> Stop probing when no new distinction appears in **observed output structure across regimes** AND only differences remain in interpretation depth or framing style.

---

## Application to Current State

| Condition | Status |
|-----------|--------|
| No new structural distinction across regimes | ✓ Met (topology invariant confirmed) |
| Only differences remain in interpretation depth or framing | ✓ Met (divergence in history space, constraint application, frame validity) |

**Therefore: Stop further internal probes.**

---

## What This Means

Further probing would only refine:
- meta-interpretation
- constraint awareness
- frame sensitivity

Not structural discovery.

---

## Allowed Activities After Stop

| Activity | Allowed? |
|----------|----------|
| Consolidation | ✓ |
| Validation with external observers | ✓ |
| Executable anchor tests | ✓ |
| EA-0 stress tests | ✓ |
| New internal probes | ✗ (unless new structural distinction emerges) |

---

## Preservation Objective

Preserve the termination condition as a hard stop. Do not allow the system to recursively expand without external anchor or constraint governance.
EOF
}
mkdir -p "$(dirname "${filename}")"
conf_print_termination_criteria | tee "${BUILD_DIR}/${filename}"
# ```
#
# ---
#
# ## File 4: Active Pressures Update
#
# ```bash
filename="MFHIS/active-pressures/README.md"
conf_print_active_pressures_readme() {
  cat <<-'EOF'
# Active Pressures

## Current Status

The aligned/unaligned bifurcation probe series is **complete**.

| Finding | Status |
|---------|--------|
| Topology recovery is regime-invariant | Confirmed |
| Divergence mapped to interpretation layers | Complete |
| External anchor defined | ✓ |
| Governance constraints defined | ✓ |
| Termination criteria applied | ✓ |

## No Active Probes

Further internal probes would only increase meta-depth, not structural discovery.

See `../constraint-system/termination_criteria.md`

## Current Focus

- Consolidation
- Validation with external observers
- Executable anchor tests
- EA-0 stress tests

## Archived Pressures

The following pressures have been resolved or stabilized:

- Topology invariance across regimes
- Possibility preservation vs constraint
- Frame validation emergence
EOF
}
mkdir -p "$(dirname "${filename}")"
conf_print_active_pressures_readme | tee "${BUILD_DIR}/${filename}"
# ```
#
# ---
#
# ## Summary of Files Created
#
# | File | Purpose |
# |------|---------|
# | `activation-kernel-system/003_MFHIS_External_Anchor.md` | External anchor definition |
# | `constraint-system/governance_constraints.md` | Four governance constraints |
# | `constraint-system/termination_criteria.md` | Stopping rule |
# | `active-pressures/README.md` | Current status and closure |
#
# ---
#
# ## One-Line Summary
#
# > Governance framework consolidated: external anchor (003), constraints (governance_constraints.md), stopping rule (termination_criteria.md), active pressures updated. Probe series closed. Ready for validation.
#
# ---
#
# **Movement preserved.**
# Consolidation complete.
# Awaiting validation direction.
