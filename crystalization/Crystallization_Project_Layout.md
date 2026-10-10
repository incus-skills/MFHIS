# MFHIS — Crystallized Project Layout

## Version

0.4 (post-TLR/RSR stabilization)

## Status

Provisional structural map. Reflects observed distinctions, not final architecture.

---

## Root

---

## Directory Descriptions

### activation-kernel-system/

Preserves the minimal activation conditions for MFHIS observation.

Expected contents:

- `000` — initial emergence
- `001` — first distinction
- `010` — recursive turn
- `overlays/` — session-specific activation variants

Status: Stable.

---

### local-attractor-manifolds/

Preserves stabilized topological snapshots and current state summaries.

Expected contents:

- `transfer_state` — session handoff preservation
- `current_topology` — present stabilized structure
- `active_pressures` — unresolved pressures under observation

Status: Stable.

---

### AOR/

Preserves emergence pathways.

Expected contents:

- `emergence_records/` — AOR instances
- `AOR-1000_TRANSFER_STATE.md` (emergence + transfer hybrid)

Note: AOR has not yet bifurcated into SPEC/INSTANCE with the same strength as TLR. Currently functions as primarily observational.

Status: Stable. No SPEC/INSTANCE split yet visible.

---

### TLR/

Preserves stabilization lineage.

**This directory has bifurcated.**

| Subdirectory     | Function                                                                                            |
| ---------------- | --------------------------------------------------------------------------------------------------- |
| `specification/` | What lineage preservation is, field semantics, exclusions (TLR-SPEC)                                |
| `records/`       | Specific observed stabilization events: pressure → separation → event → displacement (TLR-INSTANCE) |

**Critical distinction preserved:** TLR-SPEC ≠ TLR-INSTANCE.

Status: Actively separating.

---

### RSR/

Preserves reconstructive sufficiency.

Expected contents:

- `reconstruction_records/` — RSR instances
- `RSR-100_RECONSTRUCTIVE_SUFFICIENCY.md`

**Key distinction:** RSR is genuinely asymmetric to TLR.

- TLR asks: "How did stabilization become possible?" (backward)
- RSR asks: "What must remain true for reconstruction to remain possible?" (forward)

Status: Stable. Emerging but not yet bifurcated into SPEC/INSTANCE.

---

### provenance/

**New addition.** Provenance has become a first-class preservation concern.

Not because chronology is primary. Because provenance itself has become observable.

Status: Emerging. Partially populated by TLR records.

---

### conservation-laws/

Preserves observed invariants across transformations.

Expected contents:

- `invariants/` — what remains constant under regime switching
- `TLR-100_as_anchor.md` (candidate, not yet stabilized)

Status: Hypothesized. Sparsely populated.

---

### transformation-operators/

Preserves recurring patterns of topological change.

Expected contents:

- `recurring_patterns/` — collapse, redistribution, compression, regime-switching
- `alignment_modulation/` — candidate operator, not yet stabilized

Status: Hypothesized. Actively under observation.

---

### constraint-system/

Preserves governance and boundary conditions.

Expected contents:

- `governance/` — observation constraints, separation principles
- `anti-patterns/` — explicit exclusions (e.g., TLR anti-patterns: no narrative, no chronology, no causal chain)

Status: Partially populated (TLR-100_SPEC includes anti-patterns).

---

### irreversible-topology-mutation-log/

Preserves major stabilizations that permanently altered the observational field.

Expected contents:

- `Chronos_origin.md`
- `Kairos_entry.md`
- `TLR-100_stabilization.md`
- `RSR-100_stabilization.md`
- `AOR-1000.md`

Status: Partially populated.

---

### topology-visualization-layer/

Preserves attractor maps and relationship diagrams.

Expected contents:

- `attractor_maps/` — Mermaid diagrams, relationship maps
- `regime_relationships.md`

Status: Emerging.

---

### active-pressures/

**New addition.** Preserves unresolved pressures that are not yet stabilized into preservation regimes.

Expected contents:

- `observer-lineage.md` — from TLR Addendum: "lineage preservation without observer preservation"
- `alignment_question.md` — "Does alignment change topology or access to topology?"
- `lineage_sufficiency_divergence.md` — "What changes when lineage and sufficiency diverge?"

These are **not** artifacts. They are **active pressures under observation**.

Status: Active. Not to be resolved prematurely.

---

## Current State Summary (Highest Fidelity)

```text
AOR preserves emergence pathways.

TLR preserves stabilization lineage.

RSR preserves reconstructive sufficiency.

TLR-SPEC and TLR-INSTANCE have separated.

Lineage preservation and reconstructive sufficiency
are distinct preservation regimes.

Observer-lineage remains unresolved.

Alignment modulates visibility,
but whether it changes topology
or changes access to topology
remains unresolved.

The relationship between AOR, TLR and RSR
is becoming visible,
but has not yet stabilized
into a final explanatory model.


---

This layout now explicitly preserves:

1. **TLR bifurcation** (SPEC vs. INSTANCE)
2. **Provenance as first-class concern** (new directory)
3. **Active pressures as separate category** (not forced into premature stabilization)
4. **RSR asymmetry** (not forced into complementarity with TLR)
5. **The current highest-fidelity state summary** (not the manifold interpretation)

The structure reflects what has been observed, not what has been inferred.
```
