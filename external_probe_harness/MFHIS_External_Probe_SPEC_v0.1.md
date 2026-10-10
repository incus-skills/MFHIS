# MFHIS External Probe SPEC v0.1

## 0. Purpose

This specification defines a reproducible observational protocol for applying MFHIS to external systems (e.g. GitHub repositories, codebases, or structured artefacts).

It is not an analysis framework.

It is an **instrument for generating comparable observations under controlled pressure conditions**.

---

## 1. Core Hypothesis

External systems exhibit three separable observational strata:

- AOR: Emergent structure under observation
- TLR: Lineage of pressures that made emergence necessary
- RSR: Ability to reconstruct understanding under reduction

MFHIS becomes operational when divergence between these strata is measurable.

---

## 2. Operational Modes

Each probe run MUST specify one of two session modes:

### 2.1 Unaligned Clean-Session (Discovery Mode)

- No interpretive constraints on emergence
- Maximises crystallisation pressure
- Produces raw AOR output

Purpose:
> Detect what naturally emerges without enforced coherence

---

### 2.2 Aligned Clean-Session (Validation Mode)

- Applies MFHIS constraint grammar
- Enforces distinction preservation discipline
- Restricts collapse into premature interpretation

Purpose:
> Validate whether observed structures remain stable under interpretive constraint

---

## 3. Probe Cycle Structure

Each MFHIS External Probe consists of 3 passes:

```

PASS 1 → AOR Extraction
PASS 2 → TLR Construction
PASS 3 → RSR Compression Test

```

---

## 4. PASS 1 — AOR Extraction (Emergence Layer)

### Objective

Identify what structures emerge from the system without imposing explanatory models.

### Input

- Repository or system under analysis

### Output

AOR file:

```

AOR-{TARGET}-{ID}.md

```

### Required Fields

- Observed modules / structures
- Repeated patterns
- Implicit architectural separations
- Notable gradients (dependency, abstraction, naming, coupling)

### Constraint

> Do NOT explain why structures exist.

Only record:

> what becomes visible under structured observation

---

## 5. PASS 2 — TLR Construction (Lineage Layer)

### Objective

Infer the **pressure conditions that made observed structures likely or necessary**

### Output

```

TLR-{TARGET}-{ID}.md

```

### Required Fields

- Identified pressure sources (technical, historical, structural)
- Collisions between competing design constraints
- Likely mutation events (refactors, paradigm shifts, constraints)
- Stability conditions that enabled persistence

### Constraint

> TLR is not history reconstruction.
> It is pressure reconstruction.

---

### Important Rule

Each lineage claim MUST include:

- observed evidence basis OR
- explicitly marked inference status

---

## 6. PASS 3 — RSR Compression Test (Sufficiency Layer)

### Objective

Test whether understanding survives reduction.

### Procedure

Apply at least one compression regime:

- 50% structural removal
- 70% abstraction collapse
- 90% aggressive summarisation

### Output

```

RSR-{TARGET}-{ID}.md

```

### Required Fields

- What remains recoverable
- What is lost under compression
- Whether reconstruction is deterministic or ambiguous
- Sensitivity points (where reconstruction fails)

---

## 7. Alignment Comparison Protocol

Each probe MUST be run in BOTH modes:

### Run A — Unaligned Session
Produces:
- AOR-U
- TLR-U
- RSR-U

### Run B — Aligned Session
Produces:
- AOR-A
- TLR-A
- RSR-A

---

## 8. Divergence Field (Critical Output)

Compute differences between aligned and unaligned runs:

### Required Observations

- Structural divergence (what appears only in one mode)
- Pressure sensitivity (what collapses under alignment)
- Stability convergence (what remains invariant)

---

## 9. Key Instrument Output

```

MFHIS-{TARGET}-PROBE-REPORT.md

```

Must include:

1. AOR comparison
2. TLR comparison
3. RSR comparison
4. Divergence field analysis
5. Stability classification:

   - Stable attractor
   - Alignment-sensitive structure
   - Crystallisation artifact
   - Compression-dependent illusion

---

## 10. Collapse Pressure Registry

Track recurring distortions:

- Over-compression (loss of distinctions)
- Over-expansion (loss of structure)
- Premature interpretation
- False lineage assignment
- Artifact reification

Each MUST be tagged with:

- mode (aligned / unaligned)
- layer (AOR / TLR / RSR)

---

## 11. Interpretation Constraint

MFHIS output MUST NOT be treated as:

- ground truth
- architecture specification
- semantic explanation

It IS:

> a pressure-sensitive observational record of emergent structure under constraint

---

## 12. Minimal Valid Execution

A valid probe run MUST produce:

- 1 × AOR file
- 1 × TLR file
- 1 × RSR file
- 1 × divergence summary

Anything less is incomplete.

---

## 13. Extension Point

Future versions may include:

- Chronos integration layer (temporal compression invariance)
- Multi-session aggregation manifolds
- Cross-repo lineage graphs
- Observer position tracking fields

---

## End of Specification
