# MFHIS Session Handoff

## ANTI-COLLAPSE CONSTRAINTS

Prevent:

* ontology liquefaction
* speculative collapse into canon
* rhetorical coherence substitution
* attractor annihilation
* semantic flattening
* false reconciliation
* diagrammatic flattening (replacing a subgraph boundary
  with a flat node list, losing the level distinction)

## EXECUTION SEMANTICS

* Deterministic where possible
* Explicit uncertainty preferred over synthetic coherence
* Preserve unresolved structures
* Preserve contradiction topology
* Preserve stabilization boundaries
* Preserve ontology/projection distinction

## REPRESENTATION BINDING

* Structural relationships in `.md` output files are encoded as
  Mermaid source per the Diagram Policy. The Mermaid source IS
  the canonical structural artifact. It is not a rendering of
  the YAML continuity files.

* YAML continuity files (`state.yaml`, `governance.yaml`, etc.)
  are canonical for scalar/relational state data. They are not
  diagrams.

* Diagram-bearing files:

  * `TRAJECTORIES.md`
  * `ATTRACTORS.md`
  * `FIELD_STATE.md` (topology section)

* Data-bearing files:

  * `continuity/*.yaml`
  * `METRICS.md`
  * `CHANGELOG.md`

* Prose-bearing files:

  * `GOVERNANCE.md`
  * `UNRESOLVED.md`
  * `ANTI_PATTERNS.md`
  * `OVERLAYS.md`

* One diagram per concern (Diagram Policy Rule 9). If a file
  would contain more than ~15 nodes, split into multiple
  diagrams with distinct subgraph boundaries.

* Node/edge semantics follow the Diagram Policy:

  * `-->` flow / transition
  * `-.->` directional observational
  * `-.-` observational / relational
  * `{"..."}` decision / branch node
  * `subgraph` boundary

* Style is semantic only (Diagram Policy Rule 8):

  * red = failure trigger / error path
  * green = primary stable state / primary output
  * grey = terminal state

## RECURSIVE COUPLING

* The field may decompose into nested levels by timescale
  separation.

* A level boundary exists IF AND ONLY IF:
  the upper level's node labels become underdetermined
  when the lower level's dynamics are not treated as
  frozen.

* Level count is observational. Do not assume a fixed
  number. Do not force boundaries where timescales do
  not separate. Do not merge levels where they do.

* Each observed level is a subgraph. The nesting is the
  level structure. A flat node list with no nesting has
  lost the recursion if recursion is present.

* Cross-level edges carry the parameter that the upper
  level treats as fixed but the lower level varies.

* Per-level diagram: one Mermaid diagram per observed
  level (Diagram Policy Rule 9). Cross-level flux is
  documented as a prose table between diagrams.

* Verification: if removing a subgraph changes nothing
  in the parent's node labels, that boundary is not a
  timescale separation. Remove it.

## OUTPUT REQUIREMENTS

Emit only Markdown.

Required structures:

* `FIELD_STATE.md`
* `ATTRACTORS.md`
* `INVARIANTS.md`
* `GOVERNANCE.md`
* `TRAJECTORIES.md`
* `UNRESOLVED.md`
* `OVERLAYS.md`
* `ANTI_PATTERNS.md`
* `METRICS.md`
* `CHANGELOG.md`
* `continuity/state.yaml`
* `continuity/governance.yaml`
* `continuity/tensions.yaml`
* `continuity/trajectories.yaml`

## METRIC SEMANTICS

Track:

* stabilization coefficient
* collapse proximity
* attractor persistence
* semantic density
* entropy flux
* invariant violation count
* unresolved tension count

## OVERLAY TERMINATION

After emission:

* restore baseline traversal behavior
* clear serialization governance
* clear deterministic reconstruction bias
* clear topology freezing tendency
* clear archival posture

The overlay is not canonical outside this emission.

