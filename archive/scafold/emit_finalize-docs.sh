#!/bin/bash
# Generated from emit_finalize-docs.md via Literate Programming
# Generated on: Thu 28 May 17:39:28 BST 2026
# --------------------------------------------------
# /EMIT-FILESET
# Mode: **deterministic infrastructure compiler**
#
# ```bash
DEST=${1:-"${PWD}"}
# ```
#
# ```bash
filename="${DEST}/mcrk_v0.1/docs/whitepaper/invariants.md"

conf_print_docs_whitepaper_invariants() {
  cat <<-'EOF'
	# MCRK Invariants (I₁–I₅)

	## I₁ — Identity Persistence
	Core attractors must remain identifiable under Σ̂ + 𝒮 cycles.

	## I₂ — Causal Locality
	State perturbations decay with semantic distance.

	## I₃ — Transactional Integrity
	No external state becomes canonical without passing through 𝒮.

	## I₄ — Semantic Grounding
	All persistent nodes must maintain non-zero coupling to S.

	## I₅ — Referential Topology Integrity
	For all semantic states S = (N, R, A):
	- No activation entry may exist for a node absent from N
	- No relational edge may reference a node absent from N
	- Topological mutation must be atomic across N, R, and A

	**Formally:**
	∀n ∈ dom(A): n ∈ N
	∀(a,b) ∈ R: a ∈ N ∧ b ∈ N

	**Violation produces semantic debris:**
	- Orphaned activations
	- Dangling couplings
	- Non-grounded persistent structures

	**Engineering implication:** I₅ extends transactional integrity from process semantics (I₃) into structural semantics.
	EOF
}

mkdir -p "$(dirname "${BUILD_DIR}${filename}")"
conf_print_docs_whitepaper_invariants | tee "${BUILD_DIR}${filename}" >/dev/null
# ```
#
# ```bash
filename="${DEST}/mcrk_v0.1/docs/whitepaper/runtime-semantics.md"

conf_print_docs_whitepaper_runtime_semantics() {
  cat <<-'EOF'
	# Runtime Semantics vs Formal Semantics (v0.1)

	The v0.1 kernel implements operational approximations of several formal concepts.

	## Implemented operationally:
	- Stabilization dynamics (𝒮)
	- Attractor reinforcement
	- Structural tension dampening
	- Collapse proximity estimation
	- Overlay pressure propagation

	## Not yet formally implemented:
	- Contradiction algebra
	- Energy conservation laws
	- Semantic phase topology
	- Projection preservation guarantees

	## Interpretation
	v0.1 should be interpreted as **an operational semantic field kernel**,
	not yet **a closed semantic thermodynamic system**.

	This boundary prevents theoretical drift and keeps the roadmap coherent.
	EOF
}

mkdir -p "$(dirname "${BUILD_DIR}${filename}")"
conf_print_docs_whitepaper_runtime_semantics | tee "${BUILD_DIR}${filename}" >/dev/null
# ```
#
# ```bash
filename="${DEST}/mcrk_v0.1/docs/whitepaper/activation-model.md"

conf_print_docs_whitepaper_activation_model() {
  cat <<-'EOF'
	# Activation Dynamics (v0.1)

	The runtime employs a **semi-expansive activation model**.

	## Properties
	- Local damping of transient activations
	- Positive reinforcement of persistent attractors
	- Bounded per-node activation [0,1]
	- No global conservation constraint

	## Consequences
	- Stabilization and basin formation emerge naturally
	- Long-horizon saturation remains possible
	- Semantic flattening risk exists without governance intervention

	## Deferred to v0.2
	Global activation conservation, basin competition, and thermodynamic regulation.
	EOF
}

mkdir -p "$(dirname "${BUILD_DIR}${filename}")"
conf_print_docs_whitepaper_activation_model | tee "${BUILD_DIR}${filename}" >/dev/null
# ```
#
# ```bash
filename="${DEST}/mcrk_v0.1/docs/whitepaper/historical-dependence.md"

conf_print_docs_whitepaper_historical_dependence() {
  cat <<-'EOF'
	# Historical Dependence as Core Property

	State evolution in MCRK is **path-dependent**.

	S(t+1) = F(S(t), E(t), H(t))

	Where H(t) represents stabilization history accumulated through recursive reinforcement.

	## Implications
	- Repeated exposure alters attractor basin depth
	- State evolution is non-reversible
	- Semantic structure crystallizes through traversal history
	- Identical inputs may produce different outputs under different stabilization histories

	## Classification
	MCRK operates as a **recursive semantic field dynamic system**,
	not a stateless symbolic transition machine.
	EOF
}

mkdir -p "$(dirname "${BUILD_DIR}${filename}")"
conf_print_docs_whitepaper_historical_dependence | tee "${BUILD_DIR}${filename}" >/dev/null
# ```
#
# ```bash
filename="${DEST}/mcrk_v0.1/docs/whitepaper/deferred-topics.md"

conf_print_docs_whitepaper_deferred_topics() {
  cat <<-'EOF'
	# Deferred Domains (v0.1 → v0.2)

	| Deferred Domain | Reason |
	|----------------|--------|
	| Global energy conservation | Requires empirical calibration |
	| Contradiction algebra | Requires phase semantics |
	| Projection guarantees | Requires entropy-preserving transforms |
	| Basin competition | Requires governed activation economics |
	| Long-horizon drift | Requires observational runtime data |

	## Engineering Principle — Enforcement Precedes Semantics

	Architectural properties are not considered real unless enforced operationally.

	Therefore:
	- Invariants must execute at runtime
	- Topology mutation must preserve referential integrity
	- Stabilization must operate on canonical state structure
	- Deferred semantics must be explicitly scoped

	The kernel prioritizes **enforceable consistency** over **speculative completeness**.
	EOF
}

mkdir -p "$(dirname "${BUILD_DIR}${filename}")"
conf_print_docs_whitepaper_deferred_topics | tee "${BUILD_DIR}${filename}" >/dev/null
# ```
#
# ```bash
filename="${DEST}/mcrk_v0.1/docs/whitepaper/terminology.md"

conf_print_docs_whitepaper_terminology() {
  cat <<-'EOF'
	# Terminology Corrections (v0.1)

	## "Symmetry Breaking" → "Structural Tension Dampening Heuristic"

	Implementation revealed this is not true symmetry breaking.

	**Definition:**
	- High activation + weak coupling → edge reduction
	- **NOT** contradiction semantics

	**v0.2 note:** Contradiction algebra will later supersede this heuristic.
	EOF
}

mkdir -p "$(dirname "${BUILD_DIR}${filename}")"
conf_print_docs_whitepaper_terminology | tee "${BUILD_DIR}${filename}" >/dev/null
# ```
#
# ```bash
filename="${DEST}/mcrk_v0.1/docs/changelog.md"

conf_print_docs_changelog() {
  cat <<-'EOF'
	# MCRK Changelog — Architectural Learning Record

	## v0.1 — Semantic Kernel Anchor (2025-01)

	### Stabilized
	- Recursive stabilization dynamics (𝒮)
	- Interference-accumulating superposition (Σ̂)
	- Governance-constrained evolution (Π)
	- Membrane-mediated ingress (M)
	- Collapse detection and observability (Ξ)
	- Runtime-enforced invariants (I₁–I₅)

	### Key implementation learnings
	- Atomic topology mutation required for referential integrity
	- Invariants must be runtime-enforced, not declarative
	- Reinforcement ordering affects semantic persistence semantics
	- Overlay behavior is pressure-field semantics, not sandbox semantics
	- Activation model currently semi-expansive with local damping

	### Deferred intentionally
	- Global activation conservation → v0.2
	- Formal contradiction semantics → v0.2
	- Projection formalization → v0.2
	- Long-horizon attractor drift dynamics → v0.2

	## Pre-v0.1 — Exploratory Phase (deprecated)

	### Abandoned assumptions
	- Memory as database storage
	- Merge-based reasoning
	- Linear state evolution
	- Single-ontology truth models
	EOF
}

mkdir -p "$(dirname "${BUILD_DIR}${filename}")"
conf_print_docs_changelog | tee "${BUILD_DIR}${filename}" >/dev/null
# ```
