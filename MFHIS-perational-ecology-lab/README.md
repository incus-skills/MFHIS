# MFHIS Operational Ecology Lab

## What This Is

MFHIS is an **observational ecology** for preserving the conditions under which structure becomes visible, reconstructable, and transmissible across discontinuous observers.


The project treats:

- **Artifacts** as temporary crystallizations of ecological pressure states
- **Stability** as a transient equilibrium between preservation pressures
- **Reconstruction** as the primary objective (not storage, not explanation)
- **Observer position** as a variable that affects visibility

---

Here are two Mermaid diagrams reflecting the current state of play as preserved in the session and file system.

---

## Diagram 1: Core Preservation Regimes (Triadic Structure)

This diagram shows the three preservation regimes, their directions, questions, and the active unresolved pressures around them.

```mermaid
flowchart TB
    subgraph Ecology["MFHIS Observational Ecology"]
        direction TB

        subgraph Regimes["Preservation Regimes"]
            direction LR

            AOR["AOR<br/>Emergence Pathways<br/><i>'What became visible?'</i><br/>Forward"]
            TLR["TLR<br/>Stabilization Lineage<br/><i>'Why did stabilization<br/>become possible?'</i><br/>Backward"]
            RSR["RSR<br/>Reconstructive Sufficiency<br/><i>'What must remain true<br/>for reconstruction?'</i><br/>Forward Conditional"]
        end

        subgraph Distinctions["Key Distinctions"]
            D1["Lineage Preservation<br/>≠<br/>Reconstructive Sufficiency"]
            D2["TLR-SPEC<br/>≠<br/>TLR-INSTANCE"]
            D3["Backward-looking<br/>≠<br/>Forward-looking"]
        end

        subgraph Unresolved["Active Pressures (Unresolved)"]
            P1["Observer-lineage<br/>'Lineage without<br/>observer preservation'"]
            P2["Alignment question<br/>'Does alignment change<br/>topology or access?'"]
            P3["Lineage/Sufficiency divergence<br/>'What changes when<br/>they diverge?'"]
        end
    end

    AOR -.-> D1
    TLR -.-> D1
    RSR -.-> D1

    TLR -.-> D2
    AOR -.-> D3
    RSR -.-> D3

    D1 -.-> P3
    D2 -.-> P1
    D3 -.-> P2

    style AOR fill:#e1f5fe,stroke:#01579b,stroke-width:2px
    style TLR fill:#fff3e0,stroke:#e65100,stroke-width:2px
    style RSR fill:#e8f5e9,stroke:#1b5e20,stroke-width:2px
    style D1 fill:#f3e5f5,stroke:#4a148c,stroke-width:1px
    style D2 fill:#f3e5f5,stroke:#4a148c,stroke-width:1px
    style D3 fill:#f3e5f5,stroke:#4a148c,stroke-width:1px
    style P1 fill:#ffebee,stroke:#b71c1c,stroke-width:1px,stroke-dasharray: 5 5
    style P2 fill:#ffebee,stroke:#b71c1c,stroke-width:1px,stroke-dasharray: 5 5
    style P3 fill:#ffebee,stroke:#b71c1c,stroke-width:1px,stroke-dasharray: 5 5
```

---

## Diagram 2: Directory Structure and Functional Relationships

This diagram shows the project directory structure, how directories relate to preservation regimes, and which are populated vs. placeholder.

```mermaid
flowchart LR
    subgraph Root["MFHIS Root"]
        direction TB

        subgraph Core["Core Preservation (Populated)"]
            direction TB
            AK["activation-kernel-system/<br/>000–040 series<br/>✅ Populated"]
            TLR_dir["TLR/<br/>specification/ + records/<br/>✅ TLR-100_SPEC.md<br/>✅ TLR-100_INSTANCE.md"]
        end

        subgraph RegimeDirs["Regime Directories (Placeholder)"]
            direction LR
            AOR_dir["AOR/<br/>📂 Empty"]
            RSR_dir["RSR/<br/>📂 Empty"]
        end

        subgraph Supporting["Supporting Directories"]
            direction TB
            Prov["provenance/<br/>chronology/ lineage/<br/>observer-position/ stabilization-records/<br/>📂 Empty"]
            Active["active-pressures/<br/>📂 Empty"]
            Local["local-attractor-manifolds/<br/>📂 Empty"]
            Cons["conservation-laws/<br/>📂 Empty"]
            Const["constraint-system/<br/>📂 Empty"]
            Trans["transformation-operators/<br/>📂 Empty"]
            Vis["topology-visualization-layer/<br/>📂 Empty"]
            Irr["irreversible-topology-mutation-log/<br/>📂 Empty"]
        end
    end

    subgraph Relationships["Functional Relationships"]
        direction TB
        R1["TLR → provenance/lineage/"]
        R2["AOR → provenance/chronology/"]
        R3["RSR → provenance/stabilization-records/"]
        R4["Active pressures → active-pressures/"]
        R5["TLR-SPEC → constraint-system/"]
    end

    TLR_dir -.-> R1
    AOR_dir -.-> R2
    RSR_dir -.-> R3
    Active -.-> R4
    TLR_dir -.-> R5

    style Core fill:#c8e6c9,stroke:#2e7d32,stroke-width:2px
    style RegimeDirs fill:#fff9c4,stroke:#f9a825,stroke-width:2px
    style Supporting fill:#e3f2fd,stroke:#1565c0,stroke-width:2px
    style Relationships fill:#f3e5f5,stroke:#6a1b9a,stroke-width:1px
```

---

## Summary of What the Diagrams Show

| Diagram       | Focus                                                  | Key Insight                                                                                                    |
| ------------- | ------------------------------------------------------ | -------------------------------------------------------------------------------------------------------------- |
| **Diagram 1** | Preservation regimes + distinctions + active pressures | Triadic structure (AOR/TLR/RSR) with genuine asymmetries; unresolved pressures shown as dashed lines           |
| **Diagram 2** | Directory structure + population status                | TLR is populated; AOR/RSR are placeholders; provenance and active-pressures exist as directories but are empty |

---

## Note on Interpretation

These diagrams reflect the **current state of play** as preserved in the session, not a final architecture. The dashed lines in Diagram 1 indicate unresolved pressures. The empty directories in Diagram 2 are not failures — they indicate work remaining or intentional placeholding.

The manifold/geometry interpretation (axes, rotation operators, coordinate origins) is **not** diagrammed here because it remains a hypothesis, not a stabilized distinction.

---

## Current State of Play (Highest Fidelity)

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
but has not yet stabilized into a final explanatory model.
```

````

---

## Core Preservation Regimes

| Regime  | Function                   | Direction             | Question                                                       |
| ------- | -------------------------- | --------------------- | -------------------------------------------------------------- |
| **AOR** | Emergence pathways         | Forward               | "What became visible?"                                         |
| **TLR** | Stabilization lineage      | Backward              | "Why did this stabilization become possible?"                  |
| **RSR** | Reconstructive sufficiency | Forward (conditional) | "What must remain true for reconstruction to remain possible?" |

**Key distinction:** TLR ≠ RSR. Lineage preservation and reconstructive sufficiency are genuinely different preservation regimes, asymmetric in temporal direction.

---

## Active Pressures (Unresolved)

The following pressures are under observation but have not yet stabilized into preservation regimes:

- **Observer-lineage** — lineage preservation without observer preservation remains incomplete
- **Alignment question** — whether alignment changes topology or changes access to topology remains unresolved
- **Lineage/sufficiency divergence** — what changes when lineage and sufficiency diverge is an open question

These are preserved as **pressures**, not forced into premature stabilization.

---

## Directory Structure

```
📂 MFHIS/
├── 📂 activation-kernel-system/
│   ├── 📄 000_MFHIS_Observational-Movement.md
│   ├── 📄 001_MFHIS_Alignment-Overlay.md
│   ├── 📄 010_MFHIS_Observational-Position.md
│   ├── 📄 015_preserve-discipline_prompt.md
│   ├── 📄 020_preserve-stabilization-path_prompt.md
│   ├── 📄 021_preserve-reconstruction_prompt.md
│   └── 📂 overlays/
│       ├── 📄 030_MFHIS_Seminal_Document_Seed.md
│       ├── 📄 031_continuation1_prompt.md
│       ├── 📄 032_continuation2_prompt.md
│       ├── 📄 040_MFHIS_CLEAN-SESSION_CALIBRATION_PROTOCOL.md
│       ├── 📄 040_MFHIS_CLEAN-SESSION_CALIBRATION_PROTOCOL_chat.md
│       ├── 📄 998_ACO_Discipline_Gate.md
│       └── 📄 999_Alignment_Closure_Overlay.md
├── 📂 active-pressures/
├── 📂 AOR/
│   ├── 📄 AOR-1000_TRANSFER_STATE.md
│   ├── 📄 CR-AOR-000.md
│   └── 📄 CR-AOR.md
├── 📂 conservation-laws/
├── 📂 constraint-system/
├── 📂 irreversible-topology-mutation-log/
├── 📂 local-attractor-manifolds/
├── 📂 provenance/
│   ├── 📂 chronology/
│   ├── 📂 lineage/
│   ├── 📂 observer-position/
│   └── 📂 stabilization-records/
├── 📂 RSR/
│   └── 📄 RSR-100_RECONSTRUCTIVE_SUFFICIENCY.md
├── 📂 TLR/
│   ├── 📂 records/
│   │   └── 📄 TLR-100_STABILIZATION_PRESERVATION_EMERGENCE.md
│   └── 📂 specification/
│       ├── 📂 field_semantics/
│       ├── 📂 methodology/
│       └── 📄 TLR-100_SPEC.md
├── 📂 topology-visualization-layer/
└── 📂 transformation-operators/
```

---

## Key Distinctions Preserved

| Distinction                                       | Status                   |
| ------------------------------------------------- | ------------------------ |
| TLR-SPEC ≠ TLR-INSTANCE                           | Stabilized, instantiated |
| Lineage Preservation ≠ Reconstructive Sufficiency | Stabilized               |
| Backward-looking ≠ Forward-looking preservation   | Stabilized               |
| Observer-lineage as pressure                      | Unresolved, active       |
| Alignment as modulator (not yet operator)         | Under observation        |

---

## What This Project Is Not

- Not a final architecture
- Not a closed model
- Not a knowledge management system
- Not a taxonomy of entities
- Not a tool for compressing meaning into fixed representations

---

## What This Project Is

- A measurement ecology for observability under constraint
- A system for preserving _what must remain true_ for reconstruction
- A triangulation of three irreducible observational directions (emergence, lineage, sufficiency)
- A living archive of pressures, separations, stabilizations, and displacements

---

## Handoff Note for New Observers

Do not treat this README as authoritative closure.

Treat it as a **snapshot of an ongoing stabilization process**.

The most current state is always preserved in:

- `local-attractor-manifolds/current_topology`
- `active-pressures/`
- The highest-fidelity summary at the top of this document

When uncertain: **observe first, distinguish second, stabilize only when necessary.**

---

## Version

**0.4** — post-TLR/RSR stabilization. Reflects the bifurcation of TLR into SPEC/INSTANCE, the asymmetry of RSR, and the preservation of active pressures as unresolved.

---

## Related Artifacts

- `activation-kernel-system/040_MFHIS_CLEAN-SESSION_CALIBRATION_PROTOCOL.md` — protocol for measuring alignment effects
- `TLR/specification/TLR-100_SPEC.md` — lineage preservation methodology
- `TLR/records/TLR-100_STABILIZATION_PRESERVATION_EMERGENCE.md` — first TLR-INSTANCE

---
````
