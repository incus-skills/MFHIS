Here is a compact field protocol you can use as the operational version of the MFHIS loop.

## MFHIS Field Protocol

### 1) Receive

- Accept incoming material without assuming purpose.
- Do not integrate by default.

### 2) Infer role

Classify the material provisionally as one of:

- Observation
- Candidate Distinction
- Candidate Locus
- Candidate TLR
- Resistance Source
- Topology Stress Test
- Alternative Interpretation
- Reconstruction Aid
- Preservation Artifact

### 3) Apply 999

Ask:

- What new observations become visible if this material is treated as true?
- What topology does it imply?
- Where does it diverge from existing topology?
- What observations support it?
- What observations weaken it?
- What collapse pressures become visible?
- Is translation into existing topology possible?
- Does translation preserve meaning?
- What remains unresolved?

### 4) Decide whether to gate

If any of the following are present, invoke 998:

- Integration pressure.
- Premature crystallization risk.
- Distinction collapse risk.
- Hidden role ambiguity.

### 5) Apply 998 if needed

State explicitly:

- The role assigned.
- The resistance points.
- The collapse inventory.
- The admission choice.

Possible choices:

- Admit.
- Quarantine.
- Reject.
- Suspend ACO.

### 6) Map to MFHIS artifacts

Determine which preservation target is primary:

- **AOR** = visibility.
- **TLR** = possibility.
- **RSR** = reconstructability.

A single material may contribute to more than one, but one should usually dominate.

### 7) Preserve distinctions

Record separately:

- Observation vs interpretation.
- Lineage vs reconstructive sufficiency.
- Gating vs integration.
- Artifact vs topology.
- Compression vs recoverability.

### 8) Integrate provisionally

If integration is chosen:

- preserve the original role assignment,
- preserve the collapse inventory,
- preserve what remained unresolved.

Do not erase the seam.

### 9) Re-observe the ecology

Ask:

- What changed because this material now exists?
- What became newly visible?
- What became harder to see?
- What new pressures emerged?

## Minimal operating rule

> Role first. Pressure second. Gate third. Preserve distinctions always.

## Output format

When logging a case, use this structure:

```text
Material:
Provisional role:
AOR contribution:
TLR contribution:
RSR contribution:
Pressure detected:
999 analysis:
998 gate decision:
Admission outcome:
Unresolved:
```

## Use rule

Use **999** whenever material arrives and role is unclear.  
Use **998** whenever integration pressure threatens to collapse distinctions.  
Use **AOR/TLR/RSR** after role and pressure are established, not before.

## Single-sentence summary

MFHIS field discipline is: **classify the ecological role of incoming material, inspect its pressures, gate closure explicitly when needed, and preserve the distinctions required for future reconstruction.**

---
