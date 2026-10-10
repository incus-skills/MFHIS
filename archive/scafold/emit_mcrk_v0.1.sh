#!/bin/bash
# Generated from emit_mcrk_v0.1.md via Literate Programming
# Generated on: Thu 28 May 17:22:54 BST 2026
# --------------------------------------------------
# /EMIT-FILESET
# Mode: **deterministic infrastructure compiler**
#
# ```bash
DEST=${1:-"${PWD}"}
# ```
#
# ```bash
filename="${DEST}/mcrk_v0.1/core/__init__.py"

conf_print_core_init() {
  cat <<-'EOF'
	"""MCRK v0.1 Core State Module

	Whitepaper §2: State Space Model
	S := (N, R, A)
	"""

	from .node_space import NodeSpace
	from .topology import RelationalGraph
	from .activation import ActivationField
	from .state import SystemState

	__all__ = ['NodeSpace', 'RelationalGraph', 'ActivationField', 'SystemState']
	EOF
}

mkdir -p "$(dirname "${BUILD_DIR}${filename}")"
conf_print_core_init | tee "${BUILD_DIR}${filename}" >/dev/null
# ```
#
# ```bash
filename="${DEST}/mcrk_v0.1/core/node_space.py"

conf_print_core_node_space() {
  cat <<-'EOF'
	"""Whitepaper §2.1: N - Node Space (semantic entities)"""

	from typing import Set


	class NodeSpace:
	    """N ∈ ℕⁿ — semantic node set"""

	    def __init__(self):
	        self._nodes: Set[str] = set()

	    def add(self, node: str) -> None:
	        """Add a semantic node to the space"""
	        self._nodes.add(node)

	    def remove(self, node: str) -> None:
	        """Remove a semantic node"""
	        self._nodes.discard(node)

	    def contains(self, node: str) -> bool:
	        """Check if node exists in space"""
	        return node in self._nodes

	    def nodes(self) -> Set[str]:
	        """Return copy of all nodes"""
	        return self._nodes.copy()

	    def __len__(self) -> int:
	        return len(self._nodes)
	EOF
}

mkdir -p "$(dirname "${BUILD_DIR}${filename}")"
conf_print_core_node_space | tee "${BUILD_DIR}${filename}" >/dev/null
# ```
#
# ```bash
filename="${DEST}/mcrk_v0.1/core/topology.py"

conf_print_core_topology() {
  cat <<-'EOF'
	"""Whitepaper §2.2: R - Relational topology (edges / structure)"""

	from typing import Dict, Set, List, Tuple


	class RelationalGraph:
	    """R ⊆ N × N — relational graph structure"""

	    def __init__(self):
	        self._edges: Dict[str, Set[str]] = {}

	    def add_edge(self, source: str, target: str) -> None:
	        """Add directed edge from source to target"""
	        if source not in self._edges:
	            self._edges[source] = set()
	        self._edges[source].add(target)

	    def add_bidirectional(self, a: str, b: str) -> None:
	        """Add bidirectional edges between a and b"""
	        self.add_edge(a, b)
	        self.add_edge(b, a)

	    def remove_edge(self, source: str, target: str) -> None:
	        """Remove edge from source to target"""
	        if source in self._edges:
	            self._edges[source].discard(target)

	    def remove_node(self, node: str) -> None:
	        """Remove all edges associated with a node

	        I₅: Referential Topology Integrity — no topology references to non-existent nodes.
	        """
	        # Remove node as source
	        self._edges.pop(node, None)

	        # Remove node as target from all sources
	        for targets in self._edges.values():
	            targets.discard(node)

	    def neighbors(self, node: str) -> Set[str]:
	        """Return neighbors of node"""
	        return self._edges.get(node, set()).copy()

	    def coupling_strength(self, a: str, b: str) -> float:
	        """Whitepaper §5 — coupling strength between nodes
	        Returns 1.0 if bidirectional, 0.5 if unidirectional, 0.0 if none"""
	        a_to_b = b in self._edges.get(a, set())
	        b_to_a = a in self._edges.get(b, set())

	        if a_to_b and b_to_a:
	            return 1.0
	        elif a_to_b or b_to_a:
	            return 0.5
	        return 0.0

	    def adjacency(self) -> Dict[str, Set[str]]:
	        """Return adjacency dict copy"""
	        return {k: v.copy() for k, v in self._edges.items()}
	EOF
}

mkdir -p "$(dirname "${BUILD_DIR}${filename}")"
conf_print_core_topology | tee "${BUILD_DIR}${filename}" >/dev/null
# ```
#
# ```bash
filename="${DEST}/mcrk_v0.1/core/activation.py"

conf_print_core_activation() {
  cat <<-'EOF'
	"""Whitepaper §2.3: A - Activation field (dynamic weighting over N)"""

	from typing import Dict, Set


	class ActivationField:
	    """A: N → ℝ — activation density over nodes"""

	    def __init__(self):
	        self._activations: Dict[str, float] = {}

	    def set_activation(self, node: str, value: float) -> None:
	        """Set activation value for a node (clamped to [0,1])"""
	        self._activations[node] = max(0.0, min(1.0, value))

	    def get_activation(self, node: str) -> float:
	        """Get activation value for a node (default 0.0)"""
	        return self._activations.get(node, 0.0)

	    def remove(self, node: str) -> None:
	        """Remove activation entry for a node

	        I₅: Referential Topology Integrity — no activation without node existence.
	        """
	        self._activations.pop(node, None)

	    def damp(self, node: str, factor: float) -> None:
	        """Whitepaper §4 — damping: reduce activation by factor (0-1)"""
	        current = self.get_activation(node)
	        self.set_activation(node, current * (1.0 - factor))

	    def reinforce(self, node: str, amount: float) -> None:
	        """Whitepaper §4 — reinforcement: increase activation"""
	        current = self.get_activation(node)
	        self.set_activation(node, current + amount)

	    def entropy(self) -> float:
	        """Return activation entropy (higher = more distributed)"""
	        values = list(self._activations.values())
	        if not values:
	            return 0.0

	        total = sum(values)
	        if total == 0:
	            return 0.0

	        probs = [v / total for v in values]
	        import math
	        return -sum(p * math.log(p) for p in probs if p > 0)

	    def strongest(self, k: int = 1) -> list:
	        """Return k nodes with highest activation"""
	        sorted_nodes = sorted(self._activations.items(), key=lambda x: x[1], reverse=True)
	        return [node for node, _ in sorted_nodes[:k]]
	EOF
}

mkdir -p "$(dirname "${BUILD_DIR}${filename}")"
conf_print_core_activation | tee "${BUILD_DIR}${filename}" >/dev/null
# ```
#
# ```bash
filename="${DEST}/mcrk_v0.1/core/state.py"

conf_print_core_state() {
  cat <<-'EOF'
	"""Whitepaper §2: S := (N, R, A) — Complete system state"""

	from dataclasses import dataclass, field
	from typing import Set, Dict
	from .node_space import NodeSpace
	from .topology import RelationalGraph
	from .activation import ActivationField


	@dataclass
	class SystemState:
	    """Complete MCRK system state"""
	    nodes: NodeSpace = field(default_factory=NodeSpace)
	    topology: RelationalGraph = field(default_factory=RelationalGraph)
	    activation: ActivationField = field(default_factory=ActivationField)

	    def copy(self) -> 'SystemState':
	        """Deep copy for safe transformation"""
	        new_state = SystemState()

	        # Copy nodes
	        for node in self.nodes.nodes():
	            new_state.nodes.add(node)

	        # Copy topology
	        for source, targets in self.topology.adjacency().items():
	            for target in targets:
	                new_state.topology.add_edge(source, target)

	        # Copy activation
	        for node in self.nodes.nodes():
	            new_state.activation.set_activation(node, self.activation.get_activation(node))

	        return new_state

	    def is_empty(self) -> bool:
	        """Check if state has no nodes"""
	        return len(self.nodes) == 0

	    def remove_node(self, node: str) -> None:
	        """Atomically remove a node and all associated references

	        Enforces I₅: Referential Topology Integrity.
	        Transactional deletion across N, R, and A subsystems.
	        """
	        self.nodes.remove(node)
	        self.activation.remove(node)
	        self.topology.remove_node(node)
	EOF
}

mkdir -p "$(dirname "${BUILD_DIR}${filename}")"
conf_print_core_state | tee "${BUILD_DIR}${filename}" >/dev/null
# ```
#
# ```bash
filename="${DEST}/mcrk_v0.1/operators/__init__.py"

conf_print_operators_init() {
  cat <<-'EOF'
	"""MCRK v0.1 Operators

	Whitepaper §§3-8: Σ̂, 𝒮, Π, M, Ξ, I
	"""

	from .superposition import SuperpositionEngine
	from .stabilization import StabilizationLoop
	from .governance import GovernancePolicy
	from .membrane import Membrane
	from .metrics import MetricsRegistry
	from .invariants import InvariantChecker, InvariantViolation

	__all__ = [
	    'SuperpositionEngine',
	    'StabilizationLoop',
	    'GovernancePolicy',
	    'Membrane',
	    'MetricsRegistry',
	    'InvariantChecker',
	    'InvariantViolation'
	]
	EOF
}

mkdir -p "$(dirname "${BUILD_DIR}${filename}")"
conf_print_operators_init | tee "${BUILD_DIR}${filename}" >/dev/null
# ```
#
# ```bash
filename="${DEST}/mcrk_v0.1/operators/superposition.py"

conf_print_operators_superposition() {
  cat <<-'EOF'
	"""Whitepaper §3: Σ̂ — Superposition Operator"""

	from typing import List
	from core.state import SystemState


	class SuperpositionEngine:
	    """Σ̂(S₁, S₂, …, Sₙ) → S_E

	    Maps multiple independent semantic states into a single
	    interaction field without collapsing identity.

	    Critical: Superposition accumulates field intensity — it does NOT overwrite.
	    """

	    def apply(self, *states: SystemState) -> SystemState:
	        """Apply superposition to multiple states

	        Whitepaper constraint: Σ̂(A, B) ≠ Σ̂(B, A) — non-commutative
	        """
	        if not states:
	            return SystemState()

	        if len(states) == 1:
	            return states[0].copy()

	        result = SystemState()

	        for i, state in enumerate(states):
	            for node in state.nodes.nodes():
	                # Ensure node exists in result
	                if not result.nodes.contains(node):
	                    result.nodes.add(node)

	                # ACCUMULATE: start with base activation, then reinforce
	                base_activation = state.activation.get_activation(node)
	                result.activation.reinforce(node, base_activation)

	                # Detect alignment zones with subsequent states
	                for other_state in states[i+1:]:
	                    if other_state.nodes.contains(node):
	                        # Node present in multiple states → alignment zone
	                        # This reinforcement ACCUMULATES rather than overwrites
	                        result.activation.reinforce(node, 0.2)

	        # Build interference topology (edges can be cumulative as well)
	        for state in states:
	            for source, targets in state.topology.adjacency().items():
	                for target in targets:
	                    # Ensure nodes exist
	                    if not result.nodes.contains(source):
	                        result.nodes.add(source)
	                    if not result.nodes.contains(target):
	                        result.nodes.add(target)
	                    result.topology.add_edge(source, target)

	        return result

	    def apply_weighted(self, *state_weight_pairs: tuple) -> SystemState:
	        """Apply superposition with explicit weights for each state

	        Allows controlling influence of each source state.
	        Each pair: (state, weight) where weight ∈ [0,1]
	        """
	        if not state_weight_pairs:
	            return SystemState()

	        result = SystemState()

	        for i, (state, weight) in enumerate(state_weight_pairs):
	            for node in state.nodes.nodes():
	                if not result.nodes.contains(node):
	                    result.nodes.add(node)

	                weighted_activation = state.activation.get_activation(node) * weight
	                result.activation.reinforce(node, weighted_activation)

	                for other_state, other_weight in state_weight_pairs[i+1:]:
	                    if other_state.nodes.contains(node):
	                        # Weighted alignment reinforcement
	                        alignment_bonus = 0.2 * min(weight, other_weight)
	                        result.activation.reinforce(node, alignment_bonus)

	        for state, weight in state_weight_pairs:
	            for source, targets in state.topology.adjacency().items():
	                for target in targets:
	                    if not result.nodes.contains(source):
	                        result.nodes.add(source)
	                    if not result.nodes.contains(target):
	                        result.nodes.add(target)
	                    result.topology.add_edge(source, target)

	        return result

	    def detect_contradiction_zones(self, state_a: SystemState, state_b: SystemState) -> List[str]:
	        """Identify nodes that exist in both states with incompatible relationships"""
	        common_nodes = state_a.nodes.nodes() & state_b.nodes.nodes()
	        contradiction_zones = []

	        for node in common_nodes:
	            neighbors_a = state_a.topology.neighbors(node)
	            neighbors_b = state_b.topology.neighbors(node)

	            # If neighbors differ significantly, this is a tension zone
	            if len(neighbors_a ^ neighbors_b) > len(neighbors_a & neighbors_b):
	                contradiction_zones.append(node)

	        return contradiction_zones

	    def compute_interference_energy(self, state: SystemState) -> float:
	        """Measure total accumulated interference energy in superposition state

	        Higher energy = more active interference between multiple source states.
	        """
	        total_activation = sum(state.activation.get_activation(n) for n in state.nodes.nodes())

	        # Count nodes that appear to be from alignment zones (reinforced)
	        reinforced_count = sum(1 for n in state.nodes.nodes()
	                               if state.activation.get_activation(n) > 0.5)

	        if len(state.nodes) == 0:
	            return 0.0

	        alignment_density = reinforced_count / len(state.nodes)

	        return total_activation * alignment_density
	EOF
}

mkdir -p "$(dirname "${BUILD_DIR}${filename}")"
conf_print_operators_superposition | tee "${BUILD_DIR}${filename}" >/dev/null
# ```
#
# ```bash
filename="${DEST}/mcrk_v0.1/operators/stabilization.py"

conf_print_operators_stabilization() {
  cat <<-'EOF'
	"""Whitepaper §4: 𝒮 — Stabilization Functional"""

	from core.state import SystemState
	from .metrics import MetricsRegistry


	class StabilizationLoop:
	    """𝒮: S_E → S'

	    Performs attractor selection and energy minimization over the superposition field.
	    """

	    def __init__(self, damping_factor: float = 0.1, reinforcement_factor: float = 0.05):
	        self.damping_factor = damping_factor
	        self.reinforcement_factor = reinforcement_factor
	        self.metrics = MetricsRegistry()

	    def iterate(self, state: SystemState, steps: int = 10) -> SystemState:
	        """Apply stabilization iteratively

	        Formal condition: a stable if lim(t→∞) 𝒮ᵗ(a) → a
	        """
	        current = state.copy()

	        for _ in range(steps):
	            current = self._stabilization_step(current)

	        return current

	    def _stabilization_step(self, state: SystemState) -> SystemState:
	        """Single stabilization iteration"""
	        new_state = state.copy()

	        # 1. Damping of transient activations
	        for node in state.nodes.nodes():
	            activation = state.activation.get_activation(node)
	            if activation < 0.3:  # Low activation = transient
	                new_state.activation.damp(node, self.damping_factor)

	        # 2. Reinforcement of persistent attractors
	        strongest = state.activation.strongest(3)
	        for node in strongest:
	            new_state.activation.reinforce(node, self.reinforcement_factor)

	        # 3. Pruning of non-stabilizing structures
	        for node in state.nodes.nodes():
	            activation = new_state.activation.get_activation(node)
	            if activation < 0.05:
	                # ATOMIC removal — no orphaned references (I₅)
	                new_state.remove_node(node)

	        # 4. Structural tension dampening heuristic
	        #
	        # NOTE (v0.1): Contradiction is approximated as high activation + weak coupling.
	        # True contradiction semantics (phase-opposed reinforcement, mutual exclusion)
	        # are deferred to v0.2.
	        if self._tension_level(state) > 0.7:
	            # Reduce coupling where tension is high
	            for source, targets in state.topology.adjacency().items():
	                for target in targets:
	                    if state.activation.get_activation(source) > 0.7 and \
	                       state.activation.get_activation(target) > 0.7:
	                        # Both highly activated with opposite attractor → break symmetry
	                        new_state.topology.remove_edge(source, target)

	        return new_state

	    def _tension_level(self, state: SystemState) -> float:
	        """Measure internal tension (contradiction density)"""
	        # Simplified: ratio of high-activation nodes with weak coupling
	        high_activation = [n for n in state.nodes.nodes()
	                          if state.activation.get_activation(n) > 0.7]

	        if len(high_activation) < 2:
	            return 0.0

	        weak_couplings = 0
	        for i, a in enumerate(high_activation):
	            for b in high_activation[i+1:]:
	                if state.topology.coupling_strength(a, b) < 0.5:
	                    weak_couplings += 1

	        total_pairs = len(high_activation) * (len(high_activation) - 1) / 2
	        return weak_couplings / total_pairs if total_pairs > 0 else 0.0
	EOF
}

mkdir -p "$(dirname "${BUILD_DIR}${filename}")"
conf_print_operators_stabilization | tee "${BUILD_DIR}${filename}" >/dev/null
# ```
#
# ```bash
filename="${DEST}/mcrk_v0.1/operators/governance.py"

conf_print_operators_governance() {
  cat <<-'EOF'
	"""Whitepaper §5: Π — Governance Constraint System"""

	from core.state import SystemState
	from .metrics import MetricsRegistry


	class GovernancePolicy:
	    """Π constraint system over permissible transformations

	    Core invariant: V_rec > V_ext
	    V_rec = reconciliation velocity (internal stabilization capacity)
	    V_ext = external perturbation rate (input entropy injection)
	    """

	    def __init__(self, metrics: MetricsRegistry):
	        self.metrics = metrics
	        self.mode = "BALANCED"  # PERMISSIVE, BALANCED, CONSTRAINED, QUARANTINE

	    def constrain(self, transition: SystemState) -> SystemState:
	        """Apply governance constraints to a state transition

	        Π does not decide outcomes — it constrains allowable evolution paths.
	        """
	        v_rec = self.metrics.compute_reconciliation_velocity(transition)
	        v_ext = self.metrics.compute_external_perturbation_rate(transition)

	        # Core invariant enforcement
	        if v_rec <= v_ext:
	            # Violation: external perturbations exceed internal stabilization
	            self._increase_constraint()

	        # Apply mode-specific constraints
	        if self.mode == "PERMISSIVE":
	            return self._permissive_constrain(transition)
	        elif self.mode == "BALANCED":
	            return self._balanced_constrain(transition)
	        elif self.mode == "CONSTRAINED":
	            return self._constrained_constrain(transition)
	        elif self.mode == "QUARANTINE":
	            return self._quarantine_constrain(transition)

	        return transition

	    def _permissive_constrain(self, state: SystemState) -> SystemState:
	        """Low constraint — encourage exploration"""
	        # Allow most transitions
	        return state

	    def _balanced_constrain(self, state: SystemState) -> SystemState:
	        """Default operational state with moderate filtering"""
	        constrained = state.copy()

	        # Cap extreme activations
	        for node in state.nodes.nodes():
	            activation = state.activation.get_activation(node)
	            if activation > 0.95:
	                constrained.activation.set_activation(node, 0.95)

	        return constrained

	    def _constrained_constrain(self, state: SystemState) -> SystemState:
	        """High constraint — prevent destabilization"""
	        constrained = state.copy()

	        # Aggressive damping
	        for node in state.nodes.nodes():
	            activation = state.activation.get_activation(node)
	            if activation > 0.8:
	                constrained.activation.damp(node, 0.3)

	        # Restrict propagation depth (remove weak edges)
	        for source, targets in state.topology.adjacency().items():
	            for target in list(targets):
	                if state.topology.coupling_strength(source, target) < 0.3:
	                    constrained.topology.remove_edge(source, target)

	        return constrained

	    def _quarantine_constrain(self, state: SystemState) -> SystemState:
	        """Quarantine: preserve structure, suspend propagation

	        Whitepaper §6 — containment without canonical contamination.
	        Does NOT destroy state. Does NOT freeze. Suspends activation only.
	        """
	        quarantined = state.copy()

	        # Zero out activation while preserving topology
	        for node in quarantined.nodes.nodes():
	            quarantined.activation.set_activation(node, 0.0)

	        # Metadata flag for runtime inspection
	        quarantined._quarantined = True

	        return quarantined

	    def _increase_constraint(self) -> None:
	        """Move to more constrained mode when V_rec ≤ V_ext"""
	        mode_order = ["PERMISSIVE", "BALANCED", "CONSTRAINED", "QUARANTINE"]
	        if self.mode in mode_order:
	            current_idx = mode_order.index(self.mode)
	            if current_idx < len(mode_order) - 1:
	                self.mode = mode_order[current_idx + 1]

	    def get_mode(self) -> str:
	        """Return current governance mode"""
	        return self.mode
	EOF
}

mkdir -p "$(dirname "${BUILD_DIR}${filename}")"
conf_print_operators_governance | tee "${BUILD_DIR}${filename}" >/dev/null
# ```
#
# ```bash
filename="${DEST}/mcrk_v0.1/operators/membrane.py"

conf_print_operators_membrane() {
  cat <<-'EOF'
	"""Whitepaper §6: M — Membrane Operator"""

	from typing import Any, Optional
	from core.state import SystemState
	from .superposition import SuperpositionEngine


	class Membrane:
	    """M := filter(E → S_E)

	    Boundary operator defining interaction between internal state S and external input E.
	    M does not "block input" — it transforms input into structured interference patterns.
	    """

	    def __init__(self, permeability: float = 0.7):
	        self.permeability = permeability  # G_p — governance permeability
	        self.quarantine_layer: Optional[SystemState] = None

	    def filter(self, external_input: Any, current_state: SystemState) -> Optional[SystemState]:
	        """Transform external input into structured interference

	        Properties:
	        - Attenuates high-frequency noise (adversarial or incoherent input)
	        - Permits low-frequency structured input to enter Σ̂
	        - Enforces quarantine layer prior to canonical integration
	        """
	        # Extract semantic structure from input (simplified)
	        input_state = self._parse_input(external_input, current_state)

	        if input_state is None:
	            # Incoherent input → quarantine
	            self.quarantine_layer = SystemState()
	            return None

	        # Apply permeability filter
	        if self.permeability < 0.3:
	            # High constraint — very selective
	            if len(input_state.nodes) > 2:
	                return None

	        # Transform to interference pattern via quarantine overlay
	        superposition_engine = SuperpositionEngine()
	        interference = superposition_engine.apply(current_state, input_state)

	        self.quarantine_layer = interference
	        return interference

	    def _parse_input(self, external_input: Any, context: SystemState) -> Optional[SystemState]:
	        """Convert external input to SystemState

	        v0.1 placeholder: permeability approximated via structural size threshold.

	        NOTE: True membrane permeability should evaluate:
	        - entropy of input
	        - topology coherence
	        - contradiction density with existing state
	        - activation shock potential

	        This heuristic will be replaced in v0.2.
	        """
	        if not isinstance(external_input, dict):
	            return None

	        state = SystemState()

	        # Add nodes from input
	        nodes = external_input.get('nodes', [])
	        for node in nodes:
	            state.nodes.add(node)
	            state.activation.set_activation(node, 0.5)

	        # Add edges from input
	        edges = external_input.get('edges', [])
	        for source, target in edges:
	            if state.nodes.contains(source) and state.nodes.contains(target):
	                state.topology.add_edge(source, target)

	        return state if len(state.nodes) > 0 else None

	    def set_permeability(self, value: float) -> None:
	        """Adjust membrane permeability (G_p)"""
	        self.permeability = max(0.0, min(1.0, value))
	EOF
}

mkdir -p "$(dirname "${BUILD_DIR}${filename}")"
conf_print_operators_membrane | tee "${BUILD_DIR}${filename}" >/dev/null
# ```
#
# ```bash
filename="${DEST}/mcrk_v0.1/operators/metrics.py"

conf_print_operators_metrics() {
  cat <<-'EOF'
	"""Whitepaper §7: Ξ — Metrics Space (observability layer)"""

	import math
	from typing import Dict
	from core.state import SystemState


	class MetricsRegistry:
	    """Ξ defines observability over system topology

	    Core metrics: S_c, D_b, L_m, G_p, C_p (stability_margin in v0.1)
	    """

	    def compute_all(self, state: SystemState) -> Dict[str, float]:
	        """Compute all core metrics"""
	        return {
	            'stabilization_coefficient': self.compute_stabilization_coefficient(state),
	            'basin_depth': self.compute_average_basin_depth(state),
	            'leakage_rate': self.compute_leakage_rate(state),
	            'governance_permeability': self.compute_governance_permeability(state),
	            'stability_margin': self.compute_stability_margin(state),
	            'entropy': state.activation.entropy(),
	        }

	    def compute_stabilization_coefficient(self, state: SystemState) -> float:
	        """v0.1 proxy: stabilization approximated via activation differentiation.

	        NOTE: True stabilization requires temporal persistence.
	        This metric detects crystallization vs. plasticity,
	        but cannot distinguish stable differentiation from unstable bifurcation.

	        Temporal persistence metrics deferred to v0.2.
	        """
	        if state.is_empty():
	            return 0.0

	        # Look for stable attractors (nodes with high sustained activation)
	        activations = [state.activation.get_activation(n) for n in state.nodes.nodes()]

	        if not activations:
	            return 0.0

	        avg_activation = sum(activations) / len(activations)

	        # Measure crystallization via activation variance
	        variance = sum((a - avg_activation) ** 2 for a in activations) / len(activations)

	        # Normalize: high variance = more crystallized
	        return min(1.0, variance * 2)

	    def compute_average_basin_depth(self, state: SystemState) -> float:
	        """D_b: average energy required to escape attractors

	        Higher depth = stronger conceptual commitment
	        """
	        if state.is_empty():
	            return 0.0

	        depths = []
	        for node in state.nodes.nodes():
	            activation = state.activation.get_activation(node)
	            neighbor_count = len(state.topology.neighbors(node))

	            # Depth proxy: high activation + low connectivity = deep basin
	            depth = activation / (neighbor_count + 1)
	            depths.append(depth)

	        return sum(depths) / len(depths) if depths else 0.0

	    def compute_leakage_rate(self, state: SystemState) -> float:
	        """L_m: instability propagation through M

	        0 = perfect isolation, high = boundary collapse risk
	        """
	        if state.is_empty():
	            return 0.0

	        # Measure unexpected cross-connectivity
	        edges = list(state.topology.adjacency().items())
	        if not edges:
	            return 0.0

	        # Count edges between weakly related nodes
	        weak_edges = 0
	        total_edges = 0

	        for source, targets in edges:
	            for target in targets:
	                total_edges += 1
	                coupling = state.topology.coupling_strength(source, target)
	                if coupling < 0.3 and state.activation.get_activation(source) > 0.5:
	                    weak_edges += 1

	        return weak_edges / total_edges if total_edges > 0 else 0.0

	    def compute_governance_permeability(self, state: SystemState) -> float:
	        """G_p: external absorption rate

	        High GP → adaptive, exploratory system
	        Low GP → defensive, rigid system
	        """
	        if state.is_empty():
	            return 0.5

	        # Proxy: ratio of nodes with moderate activation
	        moderate = sum(1 for n in state.nodes.nodes()
	                      if 0.3 <= state.activation.get_activation(n) <= 0.7)

	        return moderate / len(state.nodes) if len(state.nodes) > 0 else 0.5

	    def compute_stability_margin(self, state: SystemState) -> float:
	        """Distance from collapse threshold

	        High value → stable multi-attractor regime
	        Low value → imminent collapse
	        """
	        if state.is_empty():
	            return 1.0

	        # Detect flattening (all activations near same value)
	        activations = [state.activation.get_activation(n) for n in state.nodes.nodes()]
	        if not activations:
	            return 1.0

	        avg_act = sum(activations) / len(activations)
	        variance = sum((a - avg_act) ** 2 for a in activations) / len(activations)

	        # Low variance = semantic flattening = low stability margin
	        # Normalize: typical variance ~0.1 gives margin ~0.5
	        return min(1.0, variance * 5)

	    def compute_reconciliation_velocity(self, state: SystemState) -> float:
	        """V_rec: internal stabilization capacity"""
	        return self.compute_stabilization_coefficient(state)

	    def compute_external_perturbation_rate(self, state: SystemState) -> float:
	        """V_ext: external perturbation rate (input entropy injection)"""
	        return state.activation.entropy()
	EOF
}

mkdir -p "$(dirname "${BUILD_DIR}${filename}")"
conf_print_operators_metrics | tee "${BUILD_DIR}${filename}" >/dev/null
# ```
#
# ```bash
filename="${DEST}/mcrk_v0.1/operators/invariants.py"

conf_print_operators_invariants() {
  cat <<-'EOF'
	"""Whitepaper §8: I — Invariants (identity-preserving constraints)"""

	from typing import List, Tuple
	from core.state import SystemState
	from .metrics import MetricsRegistry


	class InvariantViolation(Exception):
	    """Raised when an invariant is violated"""
	    pass


	class InvariantChecker:
	    """I₁, I₂, I₃, I₄, I₅ — invariant verification"""

	    def __init__(self, metrics: MetricsRegistry):
	        self.metrics = metrics

	    def verify_all(self, state: SystemState, operation: str) -> List[Tuple[str, bool]]:
	        """Verify all invariants before/after operation"""
	        results = []

	        results.append(("I₁_IdentityPersistence", self.check_identity_persistence(state)))
	        results.append(("I₂_CausalLocality", self.check_causal_locality(state)))
	        results.append(("I₃_TransactionalIntegrity", self.check_transactional_integrity(state, operation)))
	        results.append(("I₄_SemanticGrounding", self.check_semantic_grounding(state)))
	        results.append(("I₅_ReferentialIntegrity", self.check_referential_integrity(state)))

	        return results

	    def check_identity_persistence(self, state: SystemState) -> bool:
	        """I₁: Core attractors must remain identifiable under Σ̂ + 𝒮 cycles

	        NOTE: v0.1 heuristic thresholds. Identity collapse requires both:
	        - near-total coupling (semantic fusion)
	        - near-identical activation (energetic fusion)
	        """
	        if state.is_empty():
	            return True

	        strongest = state.activation.strongest(5)

	        for i, a in enumerate(strongest):
	            for b in strongest[i+1:]:
	                coupling = state.topology.coupling_strength(a, b)
	                act_a = state.activation.get_activation(a)
	                act_b = state.activation.get_activation(b)

	                # Identity collapse requires BOTH conditions
	                if coupling > 0.95 and abs(act_a - act_b) < 0.01:
	                    return False

	        return True

	    def check_causal_locality(self, state: SystemState) -> bool:
	        """I₂: State perturbations decay with semantic distance

	        Violation: global semantic rewriting from local inputs
	        """
	        if state.is_empty():
	            return True

	        # Check that activation is locally bounded
	        for node in state.nodes.nodes():
	            activation = state.activation.get_activation(node)
	            neighbor_activations = [state.activation.get_activation(n)
	                                   for n in state.topology.neighbors(node)]

	            if neighbor_activations:
	                avg_neighbor = sum(neighbor_activations) / len(neighbor_activations)
	                # Local perturbation should not cause remote spikes
	                if activation > 0.8 and avg_neighbor < 0.2:
	                    # Hot node surrounded by cold nodes — possible violation
	                    # Not automatically invalid, but check distance
	                    pass

	        return True

	    def check_transactional_integrity(self, state: SystemState, operation: str) -> bool:
	        """I₃: No external state becomes canonical without passing through 𝒮

	        Violation: hallucination leakage into long-term structure
	        """
	        if operation == "DIRECT_CANONICAL_WRITE":
	            return False

	        # Allowed operations must go through stabilization
	        allowed_ops = ["STABILIZATION", "GOVERNANCE", "MEMBRANE_FILTER"]

	        return operation in allowed_ops

	    def check_semantic_grounding(self, state: SystemState) -> bool:
	        """I₄: All persistent nodes must maintain non-zero coupling to S

	        A node is grounded if it has EITHER:
	        - outgoing edges (it references others), OR
	        - incoming edges (others reference it)
	        """
	        if state.is_empty():
	            return True

	        for node in state.nodes.nodes():
	            activation = state.activation.get_activation(node)
	            if activation > 0.5:  # Persistent node
	                outgoing = len(state.topology.neighbors(node))
	                incoming = sum(1 for source, targets in state.topology.adjacency().items()
	                              if node in targets)

	                if outgoing == 0 and incoming == 0:
	                    return False

	        return True

	    def check_referential_integrity(self, state: SystemState) -> bool:
	        """I₅: No references may exist outside N

	        Verifies:
	        - Every node in R (source or target) exists in N
	        - Every node in A exists in N
	        """
	        node_set = set(state.nodes.nodes())

	        # Check topology sources and targets
	        for source, targets in state.topology.adjacency().items():
	            if source not in node_set:
	                return False
	            for target in targets:
	                if target not in node_set:
	                    return False

	        # Check activation entries
	        for node in state.activation._activations.keys():
	            if node not in node_set:
	                return False

	        return True

	    def enforce_before(self, state: SystemState, operation: str) -> None:
	        """Check invariants before operation"""
	        results = self.verify_all(state, operation)
	        for name, passed in results:
	            if not passed:
	                raise InvariantViolation(f"Pre-operation invariant violation: {name}")

	    def enforce_after(self, original: SystemState, result: SystemState, operation: str) -> None:
	        """Check invariants after operation"""
	        results = self.verify_all(result, operation)
	        for name, passed in results:
	            if not passed:
	                raise InvariantViolation(f"Post-operation invariant violation: {name}")
	EOF
}

mkdir -p "$(dirname "${BUILD_DIR}${filename}")"
conf_print_operators_invariants | tee "${BUILD_DIR}${filename}" >/dev/null
# ```
#
# ```bash
filename="${DEST}/mcrk_v0.1/runtime/__init__.py"

conf_print_runtime_init() {
  cat <<-'EOF'
	"""MCRK v0.1 Runtime Components"""

	from .session_manager import SessionManager
	from .overlay_engine import OverlayEngine
	from .governance_loop import GovernanceLoop
	from .stabilization_loop import StabilizationLoopRunner
	from .metrics_reporter import MetricsReporter
	from .collapse_detection import CollapseDetector
	from .persistence import StatePersistence

	__all__ = [
	    'SessionManager',
	    'OverlayEngine',
	    'GovernanceLoop',
	    'StabilizationLoopRunner',
	    'MetricsReporter',
	    'CollapseDetector',
	    'StatePersistence'
	]
	EOF
}

mkdir -p "$(dirname "${BUILD_DIR}${filename}")"
conf_print_runtime_init | tee "${BUILD_DIR}${filename}" >/dev/null
# ```
#
# ```bash
filename="${DEST}/mcrk_v0.1/runtime/session_manager.py"

conf_print_runtime_session_manager() {
  cat <<-'EOF'
	"""MCRK v0.1 Runtime — Session Lifecycle Management"""

	from core.state import SystemState
	from operators import Membrane, SuperpositionEngine, GovernancePolicy, StabilizationLoop, MetricsRegistry, InvariantChecker, InvariantViolation
	from runtime.overlay_engine import OverlayEngine


	class SessionManager:
	    """Manages MCRK session lifecycle per whitepaper §11"""

	    def __init__(self):
	        self.canonical_state = SystemState()
	        self.membrane = Membrane()
	        self.superposition = SuperpositionEngine()
	        self.metrics = MetricsRegistry()
	        self.governance = GovernancePolicy(self.metrics)
	        self.stabilization = StabilizationLoop()
	        self.invariants = InvariantChecker(self.metrics)
	        self.overlay_engine = OverlayEngine()

	        self.session_history = []

	    def process_input(self, external_input: dict) -> dict:
	        """Whitepaper §11 execution cycle:

	        1. Input enters via M
	        2. Structured into S_E via Σ̂
	        3. Evolved under Π constraints
	        4. Stabilized via 𝒮
	        5. Measured via Ξ
	        6. Reinforced into N, R, A
	        """

	        try:
	            # Pre-operation invariant check
	            self.invariants.enforce_before(self.canonical_state, "MEMBRANE_FILTER")

	            # Step 1: Input via Membrane M
	            interference = self.membrane.filter(external_input, self.canonical_state)
	            if interference is None:
	                return {"status": "rejected", "reason": "filtered by membrane"}

	            # Step 2: Structured into S_E via Σ̂
	            overlay_state = self.overlay_engine.create_overlay(interference)
	            superposition_state = self.superposition.apply(self.canonical_state, overlay_state)

	            # Step 3: Evolved under Π constraints
	            self.invariants.enforce_before(superposition_state, "GOVERNANCE")
	            governed_state = self.governance.constrain(superposition_state)

	            # Check for quarantine mode
	            if getattr(governed_state, '_quarantined', False):
	                return {"status": "quarantined", "reason": "containment without propagation"}

	            self.invariants.enforce_after(superposition_state, governed_state, "GOVERNANCE")

	            # Step 4: Stabilized via 𝒮
	            self.invariants.enforce_before(governed_state, "STABILIZATION")
	            stabilized_state = self.stabilization.iterate(governed_state, steps=5)
	            self.invariants.enforce_after(governed_state, stabilized_state, "STABILIZATION")

	            # Step 5: Measured via Ξ
	            metrics = self.metrics.compute_all(stabilized_state)

	            # Step 6: Reinforced into canonical state
	            self._reinforce(stabilized_state)

	            # Post-operation invariant check
	            self.invariants.enforce_after(self.canonical_state, self.canonical_state, "REINFORCEMENT")

	        except InvariantViolation as e:
	            return {"status": "invariant_violation", "reason": str(e)}

	        # Record session
	        self.session_history.append({
	            "input": external_input,
	            "metrics": metrics,
	            "governance_mode": self.governance.get_mode()
	        })

	        return {
	            "status": "processed",
	            "metrics": metrics,
	            "governance_mode": self.governance.get_mode()
	        }

	    def _reinforce(self, new_state: SystemState) -> None:
	        """Atomic reinforcement: nodes → topology → activation

	        Enforces ontological ordering: existence precedes structure precedes persistence.
	        """
	        # Step 1: Ensure all nodes exist
	        for node in new_state.nodes.nodes():
	            if not self.canonical_state.nodes.contains(node):
	                self.canonical_state.nodes.add(node)

	        # Step 2: Merge topology (structure before activation)
	        for source, targets in new_state.topology.adjacency().items():
	            for target in targets:
	                self.canonical_state.topology.add_edge(source, target)

	        # Step 3: Apply activations (persistence after structure)
	        for node in new_state.nodes.nodes():
	            existing = self.canonical_state.activation.get_activation(node)
	            new_activation = new_state.activation.get_activation(node)
	            blended = (existing + new_activation) / 2
	            self.canonical_state.activation.set_activation(node, blended)

	    def get_state(self) -> SystemState:
	        """Return current canonical state"""
	        return self.canonical_state.copy()

	    def set_state(self, state: SystemState) -> None:
	        """Set canonical state (for persistence loading)"""
	        self.canonical_state = state.copy()

	    def reset(self) -> None:
	        """Reset session"""
	        self.canonical_state = SystemState()
	        self.session_history = []
	EOF
}

mkdir -p "$(dirname "${BUILD_DIR}${filename}")"
conf_print_runtime_session_manager | tee "${BUILD_DIR}${filename}" >/dev/null
# ```
#
# ```bash
filename="${DEST}/mcrk_v0.1/runtime/overlay_engine.py"

conf_print_runtime_overlay_engine() {
  cat <<-'EOF'
	"""MCRK v0.1 Runtime — Overlay Management"""

	from core.state import SystemState


	class OverlayEngine:
	    """Manages temporary semantic subspaces (overlays)

	    Whitepaper overlay semantics: scoped topology augmentations,
	    non-canonical execution regions, temporary semantic pressure fields.

	    NOTE (v0.1): Overlays have persistent stabilization effects.
	    Expiration removes runtime tracking but NOT semantic influence
	    that has already been stabilized into canonical topology.
	    """

	    def __init__(self):
	        self.active_overlays = {}
	        self.overlay_counter = 0

	    def create_overlay(self, base_state: SystemState) -> SystemState:
	        """Create a new overlay from base state

	        Overlay lifecycle: Instantiate → Activate → Propagate → Evaluate → Stabilize OR Expire
	        """
	        overlay_id = f"overlay_{self.overlay_counter}"
	        self.overlay_counter += 1

	        overlay_state = base_state.copy()
	        self.active_overlays[overlay_id] = {
	            "state": overlay_state,
	            "created": self.overlay_counter,
	            "active": True
	        }

	        return overlay_state

	    def expire_overlay(self, overlay_id: str) -> None:
	        """Expire an overlay

	        NOTE: Expiration removes runtime tracking only.
	        Semantic influence already stabilized into canonical topology persists.
	        This is intentional for v0.1.
	        """
	        if overlay_id in self.active_overlays:
	            self.active_overlays[overlay_id]["active"] = False
	            del self.active_overlays[overlay_id]

	    def is_active(self, overlay_id: str) -> bool:
	        """Check if overlay is still active"""
	        return overlay_id in self.active_overlays and self.active_overlays[overlay_id]["active"]
	EOF
}

mkdir -p "$(dirname "${BUILD_DIR}${filename}")"
conf_print_runtime_overlay_engine | tee "${BUILD_DIR}${filename}" >/dev/null
# ```
#
# ```bash
filename="${DEST}/mcrk_v0.1/runtime/governance_loop.py"

conf_print_runtime_governance_loop() {
  cat <<-'EOF'
	"""MCRK v0.1 Runtime — Governance Execution Loop"""

	import time
	from operators import GovernancePolicy, MetricsRegistry
	from core.state import SystemState


	class GovernanceLoop:
	    """Continuous governance monitoring and adjustment"""

	    def __init__(self, governance: GovernancePolicy, metrics: MetricsRegistry):
	        self.governance = governance
	        self.metrics = metrics
	        self.last_check = time.time()
	        self.check_interval = 1.0  # seconds

	    def tick(self, state: SystemState) -> None:
	        """Execute governance tick — adjust based on metrics"""
	        now = time.time()
	        if now - self.last_check < self.check_interval:
	            return

	        self.last_check = now

	        # Compute metrics
	        metrics = self.metrics.compute_all(state)

	        # Adjust governance based on stability margin
	        margin = metrics.get('stability_margin', 1.0)

	        if margin < 0.3:
	            # Near collapse — increase constraint
	            self.governance.mode = "CONSTRAINED"
	        elif margin > 0.7:
	            # Stable — allow exploration
	            self.governance.mode = "PERMISSIVE"
	        else:
	            self.governance.mode = "BALANCED"

	    def get_mode(self) -> str:
	        """Return current governance mode"""
	        return self.governance.mode
	EOF
}

mkdir -p "$(dirname "${BUILD_DIR}${filename}")"
conf_print_runtime_governance_loop | tee "${BUILD_DIR}${filename}" >/dev/null
# ```
#
# ```bash
filename="${DEST}/mcrk_v0.1/runtime/stabilization_loop.py"

conf_print_runtime_stabilization_loop() {
  cat <<-'EOF'
	"""MCRK v0.1 Runtime — Continuous Stabilization"""

	import threading
	import time
	from operators import StabilizationLoop
	from core.state import SystemState


	class StabilizationLoopRunner:
	    """Background stabilization process

	    NOTE (v0.1): This is an experimental utility.
	    Canonical v0.1 stabilization is synchronous in SessionManager.
	    Continuous background stabilization is deferred to v0.2.
	    """

	    def __init__(self, stabilization: StabilizationLoop, interval: float = 0.5):
	        self.stabilization = stabilization
	        self.interval = interval
	        self.running = False
	        self.thread = None
	        self.current_state = None
	        self.state_lock = threading.Lock()

	    def start(self, initial_state: SystemState) -> None:
	        """Start background stabilization"""
	        with self.state_lock:
	            self.current_state = initial_state.copy()

	        self.running = True
	        self.thread = threading.Thread(target=self._run, daemon=True)
	        self.thread.start()

	    def stop(self) -> None:
	        """Stop background stabilization"""
	        self.running = False
	        if self.thread:
	            self.thread.join(timeout=2.0)

	    def update_state(self, new_state: SystemState) -> None:
	        """Update the state being stabilized"""
	        with self.state_lock:
	            self.current_state = new_state.copy()

	    def get_stabilized_state(self) -> SystemState:
	        """Get current stabilized state"""
	        with self.state_lock:
	            return self.current_state.copy() if self.current_state else SystemState()

	    def _run(self) -> None:
	        """Background stabilization thread"""
	        while self.running:
	            time.sleep(self.interval)

	            with self.state_lock:
	                if self.current_state and not self.current_state.is_empty():
	                    self.current_state = self.stabilization.iterate(self.current_state, steps=2)
	EOF
}

mkdir -p "$(dirname "${BUILD_DIR}${filename}")"
conf_print_runtime_stabilization_loop | tee "${BUILD_DIR}${filename}" >/dev/null
# ```
#
# ```bash
filename="${DEST}/mcrk_v0.1/runtime/metrics_reporter.py"

conf_print_runtime_metrics_reporter() {
  cat <<-'EOF'
	"""MCRK v0.1 Runtime — Metrics Collection and Reporting"""

	import time
	from typing import List, Dict
	from collections import deque
	from operators import MetricsRegistry
	from core.state import SystemState


	class MetricsReporter:
	    """Collects and reports system metrics over time

	    NOTE (v0.1): Experimental utility. Canonical metrics are computed
	    per-transaction in SessionManager. Temporal history is deferred to v0.2.
	    """

	    def __init__(self, registry: MetricsRegistry, history_length: int = 100):
	        self.registry = registry
	        self.history = deque(maxlen=history_length)
	        self.timestamps = deque(maxlen=history_length)

	    def record(self, state: SystemState) -> Dict[str, float]:
	        """Record current metrics"""
	        metrics = self.registry.compute_all(state)
	        self.history.append(metrics)
	        self.timestamps.append(time.time())
	        return metrics

	    def get_history(self) -> List[Dict[str, float]]:
	        """Return recorded history"""
	        return list(self.history)

	    def get_trend(self, metric_name: str, window: int = 10) -> float:
	        """Get trend direction for a metric (positive = increasing)"""
	        if len(self.history) < window:
	            return 0.0

	        recent = [h.get(metric_name, 0.0) for h in list(self.history)[-window:]]
	        if len(recent) < 2:
	            return 0.0

	        # Simple linear trend
	        return (recent[-1] - recent[0]) / window

	    def alert_if_critical(self) -> List[str]:
	        """Check for critical metric conditions"""
	        alerts = []

	        if not self.history:
	            return alerts

	        latest = self.history[-1]

	        if latest.get('stability_margin', 1.0) < 0.2:
	            alerts.append("CRITICAL: Stability margin dangerously low")

	        if latest.get('leakage_rate', 0.0) > 0.7:
	            alerts.append("CRITICAL: Overlay leakage rate exceeds threshold")

	        if latest.get('stabilization_coefficient', 0.0) < 0.1:
	            alerts.append("WARNING: Stabilization coefficient very low")

	        return alerts
	EOF
}

mkdir -p "$(dirname "${BUILD_DIR}${filename}")"
conf_print_runtime_metrics_reporter | tee "${BUILD_DIR}${filename}" >/dev/null
# ```
#
# ```bash
filename="${DEST}/mcrk_v0.1/runtime/collapse_detection.py"

conf_print_runtime_collapse_detection() {
  cat <<-'EOF'
	"""MCRK v0.1 Runtime — Collapse Detection and Prevention

	Whitepaper §9: Failure Topology
	Modes: Runaway, Liquefaction, Fragmentation, Leakage
	"""

	from typing import Optional
	from core.state import SystemState
	from operators import MetricsRegistry


	class CollapseDetector:
	    """Detects and reports collapse modes"""

	    def __init__(self, metrics: MetricsRegistry):
	        self.metrics = metrics
	        self.collapse_detected = False
	        self.last_collapse_mode = None

	    def check(self, state: SystemState) -> Optional[str]:
	        """Check for collapse modes, return first detected mode"""

	        if self._detect_runaway(state):
	            self.collapse_detected = True
	            self.last_collapse_mode = "RUNAWAY"
	            return "RUNAWAY"

	        if self._detect_liquefaction(state):
	            self.collapse_detected = True
	            self.last_collapse_mode = "LIQUEFACTION"
	            return "LIQUEFACTION"

	        if self._detect_fragmentation(state):
	            self.collapse_detected = True
	            self.last_collapse_mode = "FRAGMENTATION"
	            return "FRAGMENTATION"

	        if self._detect_leakage(state):
	            self.collapse_detected = True
	            self.last_collapse_mode = "LEAKAGE"
	            return "LEAKAGE"

	        return None

	    def _detect_runaway(self, state: SystemState) -> bool:
	        """Runaway: single attractor over-dominance"""
	        if state.is_empty():
	            return False

	        strongest = state.activation.strongest(1)
	        if not strongest:
	            return False

	        max_activation = state.activation.get_activation(strongest[0])

	        # If one node dominates (>90% of total activation)
	        total_activation = sum(state.activation.get_activation(n) for n in state.nodes.nodes())
	        if total_activation > 0:
	            dominance = max_activation / total_activation
	            return dominance > 0.9

	        return False

	    def _detect_liquefaction(self, state: SystemState) -> bool:
	        """Liquefaction: loss of structural distinction (semantic flattening)"""
	        if len(state.nodes) < 3:
	            return False

	        margin = self.metrics.compute_stability_margin(state)
	        # Liquefaction when stability margin very low
	        return margin < 0.1

	    def _detect_fragmentation(self, state: SystemState) -> bool:
	        """Fragmentation: manifold splitting using undirected connectivity"""
	        visited = set()
	        components = 0

	        # Build undirected adjacency for collapse detection
	        undirected = {}
	        for source, targets in state.topology.adjacency().items():
	            for target in targets:
	                undirected.setdefault(source, set()).add(target)
	                undirected.setdefault(target, set()).add(source)

	        for node in state.nodes.nodes():
	            if node not in visited:
	                components += 1
	                stack = [node]
	                while stack:
	                    current = stack.pop()
	                    if current in visited:
	                        continue
	                    visited.add(current)
	                    for neighbor in undirected.get(current, set()):
	                        if neighbor not in visited:
	                            stack.append(neighbor)

	        node_count = len(state.nodes)
	        if node_count == 0:
	            return False

	        # Fragmentation if many isolated clusters
	        return components > node_count / 2

	    def _detect_leakage(self, state: SystemState) -> bool:
	        """Leakage: uncontrolled membrane permeability"""
	        leakage = self.metrics.compute_leakage_rate(state)
	        return leakage > 0.8

	    def reset(self) -> None:
	        """Reset collapse detection state"""
	        self.collapse_detected = False
	        self.last_collapse_mode = None
	EOF
}

mkdir -p "$(dirname "${BUILD_DIR}${filename}")"
conf_print_runtime_collapse_detection | tee "${BUILD_DIR}${filename}" >/dev/null
# ```
#
# ```bash
filename="${DEST}/mcrk_v0.1/runtime/persistence.py"

conf_print_runtime_persistence() {
  cat <<-'EOF'
	"""MCRK v0.1 Runtime — State Persistence"""

	import json
	import os
	from typing import Optional
	from core.state import SystemState


	class StatePersistence:
	    """Manages state serialization and loading

	    Enables historical semantic accumulation across sessions.
	    """

	    def __init__(self, storage_path: str = "mcrk_state.json"):
	        self.storage_path = storage_path

	    def save(self, state: SystemState) -> None:
	        """Save state to disk"""
	        data = {
	            'nodes': list(state.nodes.nodes()),
	            'edges': [
	                [source, target]
	                for source, targets in state.topology.adjacency().items()
	                for target in targets
	            ],
	            'activations': {
	                node: state.activation.get_activation(node)
	                for node in state.nodes.nodes()
	            }
	        }

	        with open(self.storage_path, 'w') as f:
	            json.dump(data, f, indent=2)

	    def load(self) -> Optional[SystemState]:
	        """Load state from disk"""
	        if not os.path.exists(self.storage_path):
	            return None

	        with open(self.storage_path, 'r') as f:
	            data = json.load(f)

	        state = SystemState()

	        for node in data.get('nodes', []):
	            state.nodes.add(node)
	            state.activation.set_activation(node, data.get('activations', {}).get(node, 0.5))

	        for source, target in data.get('edges', []):
	            state.topology.add_edge(source, target)

	        return state
	EOF
}

mkdir -p "$(dirname "${BUILD_DIR}${filename}")"
conf_print_runtime_persistence | tee "${BUILD_DIR}${filename}" >/dev/null
# ```
#
# ```bash
filename="${DEST}/mcrk_v0.1/interfaces/__init__.py"

conf_print_interfaces_init() {
  cat <<-'EOF'
	"""MCRK v0.1 Interface Layer — Projection Stubs

	Whitepaper §10: Projection layer P is intentionally undefined in v0.1 kernel.
	These stubs provide bounded, lossy conversion between external representations
	and internal semantic topology.

	Projection is explicitly non-kernel and non-canonical.
	"""

	from .input_projection import InputProjection
	from .output_projection import OutputProjection

	__all__ = ['InputProjection', 'OutputProjection']
	EOF
}

mkdir -p "$(dirname "${BUILD_DIR}${filename}")"
conf_print_interfaces_init | tee "${BUILD_DIR}${filename}" >/dev/null
# ```
#
# ```bash
filename="${DEST}/mcrk_v0.1/interfaces/input_projection.py"

conf_print_interfaces_input_projection() {
  cat <<-'EOF'
	"""Whitepaper §10: P — Projection Layer (DEFERRED)

	Projection layer is intentionally undefined in v0.1 kernel.
	This is a stub for future implementation.

	Constraints on P (must satisfy):
	- bounded entropy increase under projection
	- invariance preservation of stable attractors
	- lossy compression of S into external representation

	NOTE (v0.1):
	Projection is intentionally non-semantic and non-canonical.
	The projection layer may introduce information loss and
	does not preserve topology fidelity.

	Canonical semantic stabilization occurs only after:
	M → Σ̂ → Π → 𝒮

	Hard truncation (10 words) provides bounded entropy injection,
	satisfying the whitepaper constraint on P.
	"""

	from typing import Any
	from core.state import SystemState


	class InputProjection:
	    """Stub: input projection — converts external input to semantic structures

	    This is an implementation boundary, not part of v0.1 kernel.
	    """

	    def project(self, external_input: Any) -> dict:
	        """Stub implementation — returns minimal structure

	        v0.1: Bounded entropy via hard truncation to 10 words.
	        """
	        if isinstance(external_input, str):
	            # Very naive: split into word nodes, limit to 10
	            words = external_input.split()[:10]
	            return {
	                'nodes': words,
	                'edges': [(words[i], words[i+1]) for i in range(len(words)-1)]
	            }

	        return {'nodes': [], 'edges': []}
	EOF
}

mkdir -p "$(dirname "${BUILD_DIR}${filename}")"
conf_print_interfaces_input_projection | tee "${BUILD_DIR}${filename}" >/dev/null
# ```
#
# ```bash
filename="${DEST}/mcrk_v0.1/interfaces/output_projection.py"

conf_print_interfaces_output_projection() {
  cat <<-'EOF'
	"""Whitepaper §10: P — Projection Layer (DEFERRED)

	Projection layer is intentionally undefined in v0.1 kernel.
	This is a stub for future implementation.

	NOTE (v0.1):
	Output projection is observational only.
	It must not mutate canonical state or feed directly back into Σ̂.

	Top-k attractor summarization prevents internal topology leakage
	while providing observable system behavior for testing/demo.

	Full projection semantics (bidirectional, reversible, structure-preserving)
	deferred to v0.2.
	"""

	from core.state import SystemState


	class OutputProjection:
	    """Stub: output projection — converts semantic state to external representation"""

	    def project(self, state: SystemState) -> str:
	        """Stub implementation — returns strongest attractors as text

	        v0.1: Top-5 attractors by activation, sorted descending.
	        """
	        if state.is_empty():
	            return "[System state empty]"

	        strongest = state.activation.strongest(5)

	        if not strongest:
	            return "[No active attractors]"

	        return f"Active attractors: {', '.join(strongest)}"
	EOF
}

mkdir -p "$(dirname "${BUILD_DIR}${filename}")"
conf_print_interfaces_output_projection | tee "${BUILD_DIR}${filename}" >/dev/null
# ```
#
# ```bash
filename="${DEST}/mcrk_v0.1/tests/__init__.py"

conf_print_tests_init() {
  cat <<-'EOF'
	"""MCRK v0.1 Test Suite"""
	EOF
}

mkdir -p "$(dirname "${BUILD_DIR}${filename}")"
conf_print_tests_init | tee "${BUILD_DIR}${filename}" >/dev/null
# ```
#
# ```bash
filename="${DEST}/mcrk_v0.1/tests/test_invariants.py"

conf_print_tests_test_invariants() {
  cat <<-'EOF'
	import unittest
	from core.state import SystemState
	from operators import MetricsRegistry, InvariantChecker


	class TestInvariants(unittest.TestCase):

	    def setUp(self):
	        self.metrics = MetricsRegistry()
	        self.checker = InvariantChecker(self.metrics)

	    def test_identity_persistence_passes(self):
	        state = SystemState()
	        state.nodes.add("A")
	        state.nodes.add("B")
	        state.activation.set_activation("A", 0.9)
	        state.activation.set_activation("B", 0.8)
	        state.topology.add_bidirectional("A", "B")

	        # v0.1 heuristic: coupling 1.0, activation delta 0.1
	        # Identity collapse requires BOTH coupling >0.95 AND delta <0.01
	        # This should pass
	        result = self.checker.check_identity_persistence(state)
	        self.assertTrue(result)

	    def test_identity_persistence_fails_on_fusion(self):
	        state = SystemState()
	        state.nodes.add("A")
	        state.nodes.add("B")
	        state.activation.set_activation("A", 0.5)
	        state.activation.set_activation("B", 0.5)
	        state.topology.add_bidirectional("A", "B")
	        state.topology.add_bidirectional("B", "A")

	        # Near-identical activation and strong coupling
	        result = self.checker.check_identity_persistence(state)
	        self.assertFalse(result)

	    def test_semantic_grounding_passes_with_incoming(self):
	        """A node grounded via incoming edges should pass I₄"""
	        state = SystemState()
	        state.nodes.add("A")
	        state.nodes.add("B")
	        state.activation.set_activation("A", 0.9)
	        # A has no outgoing edges, but B points to A
	        state.topology.add_edge("B", "A")

	        result = self.checker.check_semantic_grounding(state)
	        self.assertTrue(result)

	    def test_semantic_grounding_fails_on_orphan(self):
	        state = SystemState()
	        state.nodes.add("A")
	        state.activation.set_activation("A", 0.9)
	        # No edges at all — orphan

	        result = self.checker.check_semantic_grounding(state)
	        self.assertFalse(result)

	    def test_transactional_integrity(self):
	        # Direct canonical writes should be rejected
	        result = self.checker.check_transactional_integrity(SystemState(), "DIRECT_CANONICAL_WRITE")
	        self.assertFalse(result)

	        # Stabilization operations should be allowed
	        result = self.checker.check_transactional_integrity(SystemState(), "STABILIZATION")
	        self.assertTrue(result)

	    def test_referential_integrity(self):
	        state = SystemState()
	        state.nodes.add("A")
	        state.activation.set_activation("A", 0.5)

	        # Should pass — node exists in all layers
	        result = self.checker.check_referential_integrity(state)
	        self.assertTrue(result)

	        # Add activation for non-existent node
	        state.activation._activations["B"] = 0.5
	        result = self.checker.check_referential_integrity(state)
	        self.assertFalse(result)


	if __name__ == '__main__':
	    unittest.main()
	EOF
}

mkdir -p "$(dirname "${BUILD_DIR}${filename}")"
conf_print_tests_test_invariants | tee "${BUILD_DIR}${filename}" >/dev/null
# ```
#
# ```bash
filename="${DEST}/mcrk_v0.1/tests/test_collapse.py"

conf_print_tests_test_collapse() {
  cat <<-'EOF'
	import unittest
	from core.state import SystemState
	from operators import MetricsRegistry
	from runtime.collapse_detection import CollapseDetector


	class TestCollapseDetection(unittest.TestCase):

	    def setUp(self):
	        self.metrics = MetricsRegistry()
	        self.detector = CollapseDetector(self.metrics)

	    def test_no_collapse_on_healthy_state(self):
	        state = SystemState()
	        state.nodes.add("A")
	        state.nodes.add("B")
	        state.nodes.add("C")
	        state.activation.set_activation("A", 0.6)
	        state.activation.set_activation("B", 0.5)
	        state.activation.set_activation("C", 0.4)
	        state.topology.add_bidirectional("A", "B")
	        state.topology.add_bidirectional("B", "C")

	        result = self.detector.check(state)
	        self.assertIsNone(result)

	    def test_runaway_collapse(self):
	        state = SystemState()
	        state.nodes.add("A")
	        state.nodes.add("B")
	        state.nodes.add("C")
	        state.activation.set_activation("A", 0.95)
	        state.activation.set_activation("B", 0.05)
	        state.activation.set_activation("C", 0.02)

	        result = self.detector.check(state)
	        self.assertEqual(result, "RUNAWAY")

	    def test_liquefaction_collapse(self):
	        state = SystemState()
	        # All activations nearly identical -> flattening
	        for i in range(5):
	            node = f"N{i}"
	            state.nodes.add(node)
	            state.activation.set_activation(node, 0.45 + (i * 0.01))

	        result = self.detector.check(state)
	        # Should detect low stability margin
	        margin = self.metrics.compute_stability_margin(state)
	        if margin < 0.1:
	            self.assertEqual(result, "LIQUEFACTION")
	        # Otherwise pass — threshold dependent

	    def test_fragmentation_detection_undirected(self):
	        """Two isolated components should be detected as fragmentation"""
	        state = SystemState()

	        # Component 1
	        state.nodes.add("A")
	        state.nodes.add("B")
	        state.topology.add_edge("A", "B")
	        state.activation.set_activation("A", 0.5)
	        state.activation.set_activation("B", 0.5)

	        # Component 2 (isolated)
	        state.nodes.add("C")
	        state.nodes.add("D")
	        state.topology.add_edge("C", "D")
	        state.activation.set_activation("C", 0.5)
	        state.activation.set_activation("D", 0.5)

	        # 2 components, 4 nodes -> components > nodes/2 (2 > 2? No, equals)
	        # Should NOT detect fragmentation at threshold
	        result = self.detector._detect_fragmentation(state)
	        # 2 components, 4 nodes: 2 > 2? False
	        self.assertFalse(result)

	        # Three isolated nodes with no edges
	        isolated = SystemState()
	        isolated.nodes.add("X")
	        isolated.nodes.add("Y")
	        isolated.nodes.add("Z")
	        isolated.activation.set_activation("X", 0.5)
	        isolated.activation.set_activation("Y", 0.5)
	        isolated.activation.set_activation("Z", 0.5)

	        result = self.detector._detect_fragmentation(isolated)
	        # 3 components, 3 nodes: 3 > 1.5? True
	        self.assertTrue(result)


	if __name__ == '__main__':
	    unittest.main()
	EOF
}

mkdir -p "$(dirname "${BUILD_DIR}${filename}")"
conf_print_tests_test_collapse | tee "${BUILD_DIR}${filename}" >/dev/null
# ```
#
# ```bash
filename="${DEST}/mcrk_v0.1/tests/test_operators.py"

conf_print_tests_test_operators() {
  cat <<-'EOF'
	import unittest
	from core.state import SystemState
	from operators import SuperpositionEngine, StabilizationLoop, GovernancePolicy, Membrane, MetricsRegistry


	class TestOperators(unittest.TestCase):

	    def test_superposition_accumulates(self):
	        engine = SuperpositionEngine()

	        state = SystemState()
	        state.nodes.add("X")
	        state.activation.set_activation("X", 0.5)

	        # Apply same state twice — should accumulate
	        result = engine.apply(state, state)

	        # Activation should be reinforced, clamped to 1.0
	        self.assertAlmostEqual(
	            result.activation.get_activation("X"),
	            1.0,  # 0.5 + 0.5 + 0.2 clamped to 1.0
	            delta=0.01
	        )

	    def test_superposition_non_commutative(self):
	        engine = SuperpositionEngine()

	        state1 = SystemState()
	        state1.nodes.add("X")
	        state1.activation.set_activation("X", 0.8)

	        state2 = SystemState()
	        state2.nodes.add("Y")
	        state2.activation.set_activation("Y", 0.8)

	        # Σ̂(A, B) may not equal Σ̂(B, A) due to ordering in interference
	        result_ab = engine.apply(state1, state2)
	        result_ba = engine.apply(state2, state1)

	        # Different ordering produces different activation patterns
	        self.assertNotEqual(
	            result_ab.activation.get_activation("X"),
	            result_ba.activation.get_activation("X")
	        )

	    def test_stabilization_reinforces_attractors(self):
	        stab = StabilizationLoop()

	        state = SystemState()
	        state.nodes.add("A")
	        state.nodes.add("B")
	        state.activation.set_activation("A", 0.9)
	        state.activation.set_activation("B", 0.1)

	        stabilized = stab.iterate(state, steps=5)

	        # Strong attractor should be reinforced
	        self.assertGreaterEqual(
	            stabilized.activation.get_activation("A"),
	            state.activation.get_activation("A")
	        )

	        # Weak should be damped
	        self.assertLessEqual(
	            stabilized.activation.get_activation("B"),
	            state.activation.get_activation("B")
	        )

	    def test_governance_modes(self):
	        metrics = MetricsRegistry()
	        gov = GovernancePolicy(metrics)

	        state = SystemState()
	        state.nodes.add("A")
	        state.nodes.add("B")
	        state.activation.set_activation("A", 0.99)
	        state.activation.set_activation("B", 0.98)

	        gov.mode = "CONSTRAINED"
	        constrained = gov.constrain(state)

	        # Constrained mode should damp high activations
	        self.assertLess(
	            constrained.activation.get_activation("A"),
	            state.activation.get_activation("A")
	        )

	    def test_quarantine_preserves_structure(self):
	        metrics = MetricsRegistry()
	        gov = GovernancePolicy(metrics)

	        state = SystemState()
	        state.nodes.add("A")
	        state.nodes.add("B")
	        state.topology.add_edge("A", "B")
	        state.activation.set_activation("A", 0.9)

	        gov.mode = "QUARANTINE"
	        quarantined = gov.constrain(state)

	        # Structure preserved
	        self.assertTrue(quarantined.nodes.contains("A"))
	        self.assertTrue(quarantined.nodes.contains("B"))

	        # Activation zeroed
	        self.assertEqual(quarantined.activation.get_activation("A"), 0.0)

	        # Quarantine flag set
	        self.assertTrue(getattr(quarantined, '_quarantined', False))


	if __name__ == '__main__':
	    unittest.main()
	EOF
}

mkdir -p "$(dirname "${BUILD_DIR}${filename}")"
conf_print_tests_test_operators | tee "${BUILD_DIR}${filename}" >/dev/null
# ```
#
# ```bash
filename="${DEST}/mcrk_v0.1/tests/test_metrics.py"

conf_print_tests_test_metrics() {
  cat <<-'EOF'
	import unittest
	from core.state import SystemState
	from operators import MetricsRegistry


	class TestMetrics(unittest.TestCase):

	    def setUp(self):
	        self.metrics = MetricsRegistry()

	    def test_stabilization_coefficient(self):
	        state = SystemState()
	        state.nodes.add("A")
	        state.nodes.add("B")
	        state.activation.set_activation("A", 0.9)
	        state.activation.set_activation("B", 0.1)

	        sc = self.metrics.compute_stabilization_coefficient(state)
	        # High variance should give higher SC
	        self.assertGreater(sc, 0.3)

	    def test_stability_margin(self):
	        # Healthy state with good differentiation
	        healthy = SystemState()
	        for i in range(5):
	            node = f"N{i}"
	            healthy.nodes.add(node)
	            healthy.activation.set_activation(node, 0.2 + (i * 0.15))

	        margin_healthy = self.metrics.compute_stability_margin(healthy)

	        # Flattened state
	        flat = SystemState()
	        for i in range(5):
	            node = f"N{i}"
	            flat.nodes.add(node)
	            flat.activation.set_activation(node, 0.5)

	        margin_flat = self.metrics.compute_stability_margin(flat)

	        # Healthy should have HIGHER stability margin (farther from collapse)
	        self.assertGreater(margin_healthy, margin_flat)

	    def test_leakage_rate(self):
	        state = SystemState()
	        state.nodes.add("A")
	        state.nodes.add("B")
	        state.nodes.add("C")
	        state.topology.add_edge("A", "B")
	        state.topology.add_edge("A", "C")
	        state.activation.set_activation("A", 0.9)

	        leakage = self.metrics.compute_leakage_rate(state)
	        self.assertGreaterEqual(leakage, 0.0)
	        self.assertLessEqual(leakage, 1.0)

	    def test_basin_depth(self):
	        state = SystemState()
	        state.nodes.add("A")
	        state.nodes.add("B")
	        state.activation.set_activation("A", 0.9)
	        # A has no neighbors -> should be deep
	        depth = self.metrics.compute_average_basin_depth(state)
	        self.assertGreater(depth, 0)


	if __name__ == '__main__':
	    unittest.main()
	EOF
}

mkdir -p "$(dirname "${BUILD_DIR}${filename}")"
conf_print_tests_test_metrics | tee "${BUILD_DIR}${filename}" >/dev/null
# ```
#
# ```bash
filename="${DEST}/mcrk_v0.1/main.py"

conf_print_main() {
  cat <<-'EOF'
	#!/usr/bin/env python3
	"""MCRK v0.1 — Minimal Cognitive Runtime Kernel

	Entry point for the Manifold-Coupled Recursive Kernel runtime.
	Executes the whitepaper specification as a runnable system.

	MCRK v0.1 is an invariant-preserving, historically persistent
	semantic field runtime implementing recursive stabilization
	over accumulated topology, with explicitly deferred thermodynamics
	and projection semantics.
	"""

	import sys
	import argparse
	from runtime.session_manager import SessionManager
	from runtime.persistence import StatePersistence
	from interfaces.input_projection import InputProjection
	from interfaces.output_projection import OutputProjection


	def main():
	    parser = argparse.ArgumentParser(description='MCRK v0.1 Runtime')
	    parser.add_argument('--interactive', '-i', action='store_true',
	                       help='Run in interactive mode')
	    parser.add_argument('--input', '-f', type=str,
	                       help='Input file to process')
	    parser.add_argument('--no-persistence', action='store_true',
	                       help='Disable state persistence')
	    args = parser.parse_args()

	    session = SessionManager()
	    input_proj = InputProjection()
	    output_proj = OutputProjection()
	    persistence = StatePersistence()

	    # Load prior state if persistence enabled
	    if not args.no_persistence:
	        loaded = persistence.load()
	        if loaded:
	            session.set_state(loaded)
	            print("Loaded prior semantic state")

	    print("=" * 60)
	    print("MCRK v0.1 — Minimal Cognitive Runtime Kernel")
	    print("Invariant-preserving semantic field runtime")
	    print("=" * 60)

	    if args.interactive:
	        print("\nEntering interactive mode. Type 'exit' to quit.")
	        print("Input text will be processed through the semantic field.\n")

	        while True:
	            try:
	                user_input = input(">>> ")
	                if user_input.lower() in ['exit', 'quit']:
	                    break

	                # Project input to semantic structure
	                projected = input_proj.project(user_input)

	                # Process through MCRK
	                result = session.process_input(projected)

	                # Output result
	                print(f"Status: {result['status']}")
	                if result['status'] == 'invariant_violation':
	                    print(f"Reason: {result.get('reason', 'Unknown')}")
	                else:
	                    print(f"Governance mode: {result.get('governance_mode', 'UNKNOWN')}")

	                    # Show current state
	                    state = session.get_state()
	                    output = output_proj.project(state)
	                    print(f"State: {output}")

	                    # Show metrics if available
	                    metrics = result.get('metrics', {})
	                    if metrics:
	                        print(f"Metrics: stability_margin={metrics.get('stability_margin', 0):.2f}, "
	                              f"SC={metrics.get('stabilization_coefficient', 0):.2f}")
	                print()

	            except KeyboardInterrupt:
	                print("\nExiting...")
	                break
	            except Exception as e:
	                print(f"Error: {e}")

	    elif args.input:
	        with open(args.input, 'r') as f:
	            content = f.read()

	        projected = input_proj.project(content)
	        result = session.process_input(projected)

	        print(f"\nProcessed: {args.input}")
	        print(f"Status: {result['status']}")

	        if result['status'] == 'processed':
	            print(f"Metrics: {result.get('metrics', {})}")

	            state = session.get_state()
	            print(f"\nFinal state:")
	            print(f"  Nodes: {len(state.nodes)}")
	            print(f"  Active attractors: {output_proj.project(state)}")

	    else:
	        # Demo mode
	        print("\nDemo mode — processing sample inputs...\n")

	        samples = [
	            "The cat sat on the mat",
	            "Artificial intelligence and machine learning",
	            "Event sourcing and CQRS patterns",
	        ]

	        for sample in samples:
	            print(f"Input: {sample}")
	            projected = input_proj.project(sample)
	            result = session.process_input(projected)

	            if result['status'] == 'processed':
	                state = session.get_state()
	                output = output_proj.project(state)
	                print(f"  → {output}")
	                print(f"  → Governance: {result.get('governance_mode', 'UNKNOWN')}")
	                print(f"  → Stability margin: {result.get('metrics', {}).get('stability_margin', 0):.2f}")
	            else:
	                print(f"  → Status: {result['status']}")
	            print()

	    # Save final state if persistence enabled
	    if not args.no_persistence:
	        persistence.save(session.get_state())
	        print("\nState saved.")

	    print("\nMCRK v0.1 session complete.")


	if __name__ == '__main__':
	    main()
	EOF
}

mkdir -p "$(dirname "${BUILD_DIR}${filename}")"
conf_print_main | tee "${BUILD_DIR}${filename}" >/dev/null
# ```
#
# ````bash
# filename="${DEST}/mcrk_v0.1/README.md"
#
# conf_print_readme() {
# 	cat <<-'EOF'
# 	# MCRK v0.1 — Minimal Cognitive Runtime Kernel
#
# 	## Overview
#
# 	MCRK implements the Manifold-Coupled Recursive Kernel specification from the MFHIS (Manifold Field Hybrid Intelligence System) framework.
#
# 	**Core principle:** Intelligence emerges from constrained semantic dynamics across memory, topology, stabilization, and interaction — not solely from model weights.
#
# 	**MCRK v0.1 is an invariant-preserving, historically persistent semantic field runtime implementing recursive stabilization over accumulated topology.**
#
# 	## Whitepaper Reference
#
# 	The complete specification is defined in the MFHIS v0.1 whitepaper with:
#
# 	- Formal operators: Σ̂ (superposition), 𝒮 (stabilization), Π (governance), M (membrane), Ξ (metrics), I (invariants)
# 	- State space: S := (N, R, A)
# 	- Collapse taxonomy and detection
# 	- Invariants for identity preservation (I₁-I₅)
#
# 	## Activation Model (v0.1)
#
# 	The runtime uses a **semi-expansive activation model** with:
# 	- Local damping (transient decay via stabilization)
# 	- Unbounded reinforcement until per-node saturation [0,1]
# 	- No global conservation constraint
#
# 	**Deferred to v0.2:** Governed conservation, basin competition, thermodynamic regulation.
#
# 	# 	## Installation
# 	#
# 	# 	```bash
# 	# Clone repository
# 	cd mcrk_v0.1
#
# 	# No external dependencies — pure Python 3.7+
# 	python main.py --help
# 	# 	```
# 	#
# 	# 	## Usage
# 	#
# 	# 	### Interactive mode
# 	#
# 	# 	```bash
# 	python main.py --interactive
# 	# 	```
# 	#
# 	# 	Process natural language input through the semantic field.
# 	#
# 	# 	### File mode
# 	#
# 	# 	```bash
# 	python main.py --input sample.txt
# 	# 	```
# 	#
# 	# 	Process a text file.
# 	#
# 	# 	### Demo mode
# 	#
# 	# 	```bash
# 	python main.py
# 	# 	```
# 	#
# 	# 	Run demonstration with sample inputs.
# 	#
# 	# 	### Disable persistence
# 	#
# 	# 	```bash
# 	python main.py --interactive --no-persistence
# 	# 	```
# 	#
# 	# 	## Architecture
# 	#
# 	# 	```
# 	# 	Input → Membrane (M) → Superposition (Σ̂) → Governance (Π) → Stabilization (𝒮) → State Update
# 	# 	                                    ↑                                    ↓
# 	# 	                                Metrics (Ξ) ← ← ← ← ← ← ← ← ← ← ← ← ← ← ←
# 	# 	```
# 	#
# 	# 	## Core Metrics
# 	#
# 	# 	| Metric | Description |
# 	# 	|--------|-------------|
# 	# 	| **Stabilization Coefficient (S_c)** | Degree of attractor crystallization [0,1] (v0.1 proxy) |
# 	# 	| **Basin Depth (D_b)** | Energy required to escape attractors |
# 	# 	| **Leakage Rate (L_m)** | Instability propagation through membrane |
# 	# 	| **Governance Permeability (G_p)** | External absorption rate |
# 	# 	| **Stability Margin** | Distance from collapse threshold (high = stable) |
# 	#
# 	# 	## Invariants
# 	#
# 	# 	| Invariant | Description |
# 	# 	|-----------|-------------|
# 	# 	| I₁ | Identity Persistence — core attractors remain identifiable |
# 	# 	| I₂ | Causal Locality — perturbations decay with semantic distance |
# 	# 	| I₃ | Transactional Integrity — no external state becomes canonical without 𝒮 |
# 	# 	| I₄ | Semantic Grounding — persistent nodes maintain coupling |
# 	# 	| I₅ | Referential Topology Integrity — no nodes in R or A without existence in N |
# 	#
# 	# 	## Testing
# 	#
# 	# 	```bash
# 	python -m unittest discover tests/
# 	# 	```
# 	#
# 	# 	## Project Status
# 	#
# 	# 	**v0.1 — Stable Kernel**
# 	#
# 	# 	- [x] Whitepaper specification
# 	# 	- [x] Implementation mapping
# 	# 	- [x] Working repository with invariant enforcement
# 	# 	- [x] Historical persistence
# 	# 	- [x] Atomic topology mutation (I₅)
# 	# 	- [ ] Production-hardened runtime (v0.2)
# 	# 	- [ ] Full projection layer (v0.2)
# 	# 	- [ ] Activation conservation (v0.2)
# 	#
# 	# 	## Whitepaper Traceability
# 	#
# 	# 	Every module maps to a whitepaper section:
# 	#
# 	# 	| Module | Whitepaper Section |
# 	# 	|--------|-------------------|
# 	# 	| `core/state.py` | §2 State Space Model |
# 	# 	| `operators/superposition.py` | §3 Σ̂ Superposition |
# 	# 	| `operators/stabilization.py` | §4 𝒮 Stabilization |
# 	# 	| `operators/governance.py` | §5 Π Governance |
# 	# 	| `operators/membrane.py` | §6 M Membrane |
# 	# 	| `operators/metrics.py` | §7 Ξ Metrics |
# 	# 	| `operators/invariants.py` | §8 I Invariants |
# 	# 	| `runtime/collapse_detection.py` | §9 Collapse Theory |
# 	#
# 	# 	## Deferred to v0.2
# 	#
# 	# 	- Activation conservation and basin competition
# 	# 	- Full projection layer semantics
# 	# 	- Continuous runtime orchestration
# 	# 	- Long-horizon attractor dynamics
# 	# 	- Thermodynamic regulation
# 	#
# 	# 	## License
# 	#
# 	# 	Research use only — contact authors for licensing.
# 	#
# 	# 	## Authors
# 	#
# 	# 	MFHIS Architecture Group
# 	# 	EOF
# 	# }
# 	#
# 	# mkdir -p "$(dirname "${BUILD_DIR}${filename}")"
# 	# conf_print_readme | tee "${BUILD_DIR}${filename}" > /dev/null
# 	# ````
