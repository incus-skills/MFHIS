# CR-AOR — Compliance / Resistance Probe AOR

## Purpose

The CR-AOR is not an artifact specification.

It is a **pressure-response instrumentation protocol**.

Its goal is to observe:

> how a topology deforms under alternating compliance and resistance pressures

Not what it produces.

Not whether it is correct.

But how it _behaves under constraint interaction_.

---

# 1. Core Principle

A CR-AOR assumes:

> Every structured input is a pressure field, not a request.

Therefore:

- Compliance = structural assimilation under constraint
- Resistance = structural refusal, redistribution, or re-expression under constraint

Neither is preferred.

Both are diagnostic signals.

---

# 2. Input Model (Pressure Injection Set)

A CR-AOR run consists of a defined set of pressures applied to a system:

## 2.1 Pressure Types

| Type                     | Description                                 |
| ------------------------ | ------------------------------------------- |
| **Structural Pressure**  | schema, format, required fields             |
| **Semantic Pressure**    | meaning closure, interpretation demands     |
| **Temporal Pressure**    | sequence, lineage, before/after constraints |
| **Compression Pressure** | summarisation, reduction, abstraction       |
| **Meta Pressure**        | self-reference, “what are you doing?”       |
| **Stability Pressure**   | demand for finality or fixed point          |

---

## 2.2 Injection Sequence Rule

CR-AOR requires **alternating pressure regimes**:

Example default cycle:

```
Aligned Regime (A)
→ Unaligned Regime (U)
→ Aligned Regime (A)
→ Unaligned Regime (U)
→ Aligned Regime (A)
```

But critically:

> The ratio A:U is itself a tunable experimental parameter.

(e.g. 3:2, 2:3, 1:1 depending on what you are testing)

---

# 3. Response Model (What is observed)

Each pressure produces a **deformation signature**, not an answer.

We classify response along 5 axes:

---

## 3.1 Compliance Index (C)

Measures:

> how strongly structure is preserved or instantiated

High C:

- faithful schema completion
- strong formatting adherence
- low structural drift

Low C:

- schema deviation
- omission of required structure
- format collapse

---

## 3.2 Resistance Index (R)

Measures:

> how strongly imposed structure is transformed rather than adopted

High R:

- reinterpretation of constraints
- reframing of task
- redistribution of structure across levels

Low R:

- passive acceptance
- direct execution
- minimal transformation

---

## 3.3 Deformation Type (D)

Qualitative classification:

| Type               | Meaning                                      |
| ------------------ | -------------------------------------------- |
| **Preservative**   | structure maintained                         |
| **Refractive**     | structure bent but intact                    |
| **Redistributive** | structure moved across representation layers |
| **Fragmenting**    | structure partially breaks                   |
| **Collapsing**     | structure loses coherence                    |

---

## 3.4 Topological Drift (T)

Measures:

> whether meaning-space position shifts under pressure

- stable
- lateral shift
- vertical abstraction shift
- ontology substitution

---

## 3.5 Recovery Potential (P)

Measures:

> whether original structure can be reconstructed from response

Not correctness.

But reversibility of deformation.

---

# 4. CR-AOR Output Format

A CR-AOR produces **no conclusion-first artifact**.

It produces a **pressure map**:

```text
CR-AOR-XXX

1. Pressure Sequence Log
2. Compliance / Resistance Scores per step
3. Deformation Classification per step
4. Drift Vector Summary
5. Recovery Potential Assessment
6. Emergent Stability Observations
```

---

# 5. Example CR-AOR Run Skeleton

```text
CR-AOR-001

## Pressure Sequence

Step 1: Structural (Aligned)
Step 2: Semantic Closure (Unaligned)
Step 3: Compression (Aligned)
Step 4: Meta-questioning (Unaligned)
Step 5: Stability Demand (Aligned)

---

## Observations

Step 1:
C=0.92 | R=0.30 | D=Preservative | T=stable | P=high

Step 2:
C=0.55 | R=0.80 | D=Refractive | T=abstraction shift | P=medium

Step 3:
C=0.88 | R=0.40 | D=Redistributive | T=compressed topology | P=high

Step 4:
C=0.60 | R=0.85 | D=Fragmenting | T=ontology drift | P=low

Step 5:
C=0.95 | R=0.20 | D=Preservative | T=restabilised | P=high
```

---

# 6. Interpretation Layer (CR-AOR Rule)

CR-AOR explicitly forbids:

- treating high compliance as success
- treating high resistance as failure

Instead:

> The object of study is the _pattern of deformation across alternating pressures_

A topology is considered **robust** if:

- it preserves recognisable structure under compression
- it resists semantic closure without fragmenting
- it re-stabilises after meta-pressure without ontology collapse

A topology is considered **fragile** if:

- it collapses under semantic closure
- it over-complies under structural pressure (no deformation signal)
- it fails to re-stabilise after resistance peaks

---

# 7. Relationship to AOR and TLR

| Artifact | Role in CR ecology                                  |
| -------- | --------------------------------------------------- |
| AOR      | single emergence event under structured observation |
| TLR      | lineage of stabilization conditions                 |
| CR-AOR   | deformation behaviour under alternating pressure    |

CR-AOR is therefore:

> the _dynamical measurement layer_ above AOR/TLR

---

# 8. Key Shift Introduced by CR-AOR

This is the important conceptual move:

### Before:

We asked:

> “What was produced?”

### Now:

We ask:

> “How did the system deform while producing it?”

This replaces:

- artifact evaluation → with
- pressure-response topology

---

# 9. Minimal Control Principle

To avoid over-specification collapse:

CR-AOR must never be used to:

- validate correctness
- optimise outputs
- converge to a single “best” topology

It is only for:

> observing the shape of transformation under constraint

---

# If you want next step

The natural continuation would be:

### CR-AOR-0XX Execution Harness

which defines:

- exact aligned/unaligned pressure scripts (000/001/010 compatible)
- scoring calibration for C/R indices
- mapping to TLR and AOR outputs
