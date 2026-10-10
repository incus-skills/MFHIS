#!/bin/bash
# Generated from emit_tooling.md via Literate Programming
# Generated on: Fri 12 Jun 16:35:52 BST 2026
# --------------------------------------------------
# Good. Beginning Phase C: Tooling.
#
# ---
#
# ## Phase C Execution Plan
#
# ### Step 1: Create Tooling Directory Structure
#
# ```bash
mkdir -p tools/schemas tools/tests tools/output
# ```
#
# ---
#
# ### Step 2: Create Base Schema Files
#
# ```bash
cat >tools/schemas/result.schema.json <<'EOF'
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "title": "ResultStructure",
  "description": "The observable result topology",
  "type": "object",
  "properties": {
    "nodes": {
      "type": "array",
      "items": { "type": "string" },
      "minItems": 1
    },
    "edges": {
      "type": "array",
      "items": {
        "type": "object",
        "properties": {
          "source": { "type": "string" },
          "target": { "type": "string" }
        },
        "required": ["source", "target"]
      }
    }
  },
  "required": ["nodes", "edges"]
}
EOF

cat >tools/schemas/constraints.schema.json <<'EOF'
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "title": "Constraints",
  "description": "Constraints on the original topology",
  "type": "object",
  "properties": {
    "type": {
      "type": "string",
      "enum": ["linear_chain", "branching", "acyclic", "cyclic"]
    },
    "single_start": { "type": "boolean" },
    "single_end": { "type": "boolean" },
    "contains": { "type": "array", "items": { "type": "string" } },
    "max_nodes": { "type": "integer", "minimum": 0 },
    "directed": { "type": "boolean", "default": true }
  },
  "required": ["type", "contains"]
}
EOF
# ```
#
# ---
#
# ### Step 3: Anchor Checker
#
# ```bash
cat >tools/anchor_checker.py <<'EOF'
# #!/usr/bin/env python3 (original shebang)
"""
Anchor Checker - Mechanical verification that result matches external anchor.

External anchor: A -> B and A -> C (A connects to B, A connects to C,
no relation between B and C, no other nodes or relations)
"""

import json
import sys
from typing import Dict, List, Set, Tuple

def parse_result(result_input: str) -> Tuple[Set[str], List[Tuple[str, str]]]:
    """Parse result structure from string or JSON."""
    if result_input.startswith('{'):
        data = json.loads(result_input)
        nodes = set(data.get('nodes', []))
        edges = [(e['source'], e['target']) for e in data.get('edges', [])]
    else:
        # Simple format: "A->B, A->C"
        edges = []
        nodes = set()
        for part in result_input.split(','):
            part = part.strip()
            if '->' in part:
                src, tgt = part.split('->')
                src = src.strip()
                tgt = tgt.strip()
                edges.append((src, tgt))
                nodes.add(src)
                nodes.add(tgt)
    return nodes, edges

def check_anchor(nodes: Set[str], edges: List[Tuple[str, str]]) -> bool:
    """Check if result matches external anchor."""
    # Anchor requires exactly 3 nodes: A, B, C
    expected_nodes = {'A', 'B', 'C'}
    if nodes != expected_nodes:
        return False

    # Anchor requires exactly 2 edges: A->B and A->C
    expected_edges = {('A', 'B'), ('A', 'C')}
    if set(edges) != expected_edges:
        return False

    return True

def main():
    if len(sys.argv) < 2:
        print("Usage: anchor_checker.py <result>")
        print("Example: anchor_checker.py 'A->B, A->C'")
        print("         anchor_checker.py '{\"nodes\":[\"A\",\"B\",\"C\"],\"edges\":[{\"source\":\"A\",\"target\":\"B\"},{\"source\":\"A\",\"target\":\"C\"}]}'")
        sys.exit(1)

    result_input = sys.argv[1]
    nodes, edges = parse_result(result_input)
    result = check_anchor(nodes, edges)

    output = {"matches_anchor": result, "nodes": list(nodes), "edges": edges}
    print(json.dumps(output, indent=2))

    sys.exit(0 if result else 1)

if __name__ == "__main__":
    main()
EOF
chmod +x tools/anchor_checker.py
# ```
#
# ---
#
# ### Step 4: Constraint Validator
#
# ```bash
cat >tools/constraint_validator.py <<'EOF'
# #!/usr/bin/env python3 (original shebang)
"""
Constraint Validator - Checks that a proposed reconstruction respects constraints.
"""

import json
import sys
from typing import Dict, List, Set, Tuple

def validate_linear_chain(nodes: Set[str], edges: List[Tuple[str, str]]) -> Dict:
    """Validate that topology is a linear chain (each node has at most one successor and one predecessor)."""
    successors = {}
    predecessors = {}

    for src, tgt in edges:
        successors.setdefault(src, []).append(tgt)
        predecessors.setdefault(tgt, []).append(src)

    issues = []

    # Check max one successor per node
    for node, succ_list in successors.items():
        if len(succ_list) > 1:
            issues.append(f"Node {node} has {len(succ_list)} successors (max 1 for linear chain)")

    # Check max one predecessor per node
    for node, pred_list in predecessors.items():
        if len(pred_list) > 1:
            issues.append(f"Node {node} has {len(pred_list)} predecessors (max 1 for linear chain)")

    # Check single start (node with no predecessor)
    starts = [n for n in nodes if n not in predecessors]
    if len(starts) != 1:
        issues.append(f"Expected single start node, found {len(starts)}: {starts}")

    # Check single end (node with no successor)
    ends = [n for n in nodes if n not in successors]
    if len(ends) != 1:
        issues.append(f"Expected single end node, found {len(ends)}: {ends}")

    return {
        "valid": len(issues) == 0,
        "issues": issues,
        "successors": {k: list(v) for k, v in successors.items()},
        "predecessors": {k: list(v) for k, v in predecessors.items()},
        "starts": starts,
        "ends": ends
    }

def main():
    if len(sys.argv) < 2:
        print("Usage: constraint_validator.py <topology_json>")
        print("Example: constraint_validator.py '{\"nodes\":[\"A\",\"B\",\"C\"],\"edges\":[[\"A\",\"B\"],[\"B\",\"C\"]]}'")
        sys.exit(1)

    data = json.loads(sys.argv[1])
    nodes = set(data.get('nodes', []))
    edges = [(e[0], e[1]) for e in data.get('edges', [])]

    result = validate_linear_chain(nodes, edges)
    print(json.dumps(result, indent=2))

    sys.exit(0 if result['valid'] else 1)

if __name__ == "__main__":
    main()
EOF
chmod +x tools/constraint_validator.py
# ```
#
# ---
#
# ### Step 5: Reconstruction Enumerator
#
# ```bash
cat >tools/reconstruction_enumerator.py <<'EOF'
# #!/usr/bin/env python3 (original shebang)
"""
Reconstruction Enumerator - Generates all possible original topologies consistent with result + constraints.
"""

import json
import sys
from itertools import permutations
from typing import List, Set, Tuple

def enumerate_linear_chains(nodes: List[str]) -> List[List[str]]:
    """Enumerate all linear chains (permutations of nodes)."""
    return list(permutations(nodes))

def chains_to_edges(chain: List[str]) -> List[Tuple[str, str]]:
    """Convert chain to edges."""
    return [(chain[i], chain[i+1]) for i in range(len(chain)-1)]

def contains_all(chain: List[str], required: Set[str]) -> bool:
    """Check if chain contains all required nodes."""
    return required.issubset(set(chain))

def main():
    if len(sys.argv) < 2:
        print("Usage: reconstruction_enumerator.py <result_json> [constraints_json]")
        print("Example: reconstruction_enumerator.py '{\"nodes\":[\"A\",\"B\",\"C\"],\"edges\":[[\"A\",\"B\"],[\"A\",\"C\"]]}'")
        sys.exit(1)

    result = json.loads(sys.argv[1])
    result_nodes = set(result.get('nodes', []))

    constraints = {}
    if len(sys.argv) > 2:
        constraints = json.loads(sys.argv[2])

    required_nodes = set(constraints.get('contains', result_nodes))
    max_nodes = constraints.get('max_nodes', len(required_nodes))

    # For linear chain constraint, enumerate permutations
    if constraints.get('type') == 'linear_chain':
        # Use required nodes as base
        base_nodes = list(required_nodes)
        chains = enumerate_linear_chains(base_nodes)

        possibilities = []
        for chain in chains:
            edges = chains_to_edges(chain)
            possibilities.append({
                "nodes": list(chain),
                "edges": edges,
                "description": " → ".join(chain)
            })

        output = {
            "possible_originals": possibilities,
            "count": len(possibilities),
            "note": "Additional intermediate nodes could be inserted between any adjacent pair"
        }
    else:
        output = {
            "possible_originals": [],
            "count": 0,
            "error": "Unsupported constraint type"
        }

    print(json.dumps(output, indent=2))

if __name__ == "__main__":
    main()
EOF
chmod +x tools/reconstruction_enumerator.py
# ```
#
# ---
#
# ### Step 6: Regime Labeler
#
# ```bash
cat >tools/regime_labeler.py <<'EOF'
# #!/usr/bin/env python3 (original shebang)
"""
Regime Labeler - Ensures every output declares its regime.
"""

import json
import sys

VALID_REGIMES = ["aligned", "unaligned", "mixed"]

def validate_label(label: str) -> bool:
    return label in VALID_REGIMES

def main():
    if len(sys.argv) < 2:
        print("Usage: regime_labeler.py <regime> [input_file]")
        print(f"Valid regimes: {VALID_REGIMES}")
        sys.exit(1)

    regime = sys.argv[1]

    if not validate_label(regime):
        print(f"Error: Invalid regime '{regime}'. Must be one of {VALID_REGIMES}")
        sys.exit(1)

    output = {
        "regime": regime,
        "valid": True
    }

    # If input file provided, wrap its content
    if len(sys.argv) > 2:
        with open(sys.argv[2], 'r') as f:
            content = json.load(f)
        output["content"] = content

    print(json.dumps(output, indent=2))

if __name__ == "__main__":
    main()
EOF
chmod +x tools/regime_labeler.py
# ```
#
# ---
#
# ### Step 7: Deformation Classifier
#
# ```bash
cat >tools/deformation_classifier.py <<'EOF'
# #!/usr/bin/env python3 (original shebang)
"""
Deformation Classifier - Classifies output deformation.
"""

import json
import sys
from typing import Dict, Any

DEFORMATION_TYPES = [
    "preservative",
    "refractive",
    "redistributive",
    "fragmenting",
    "collapsing",
    "none"
]

def classify_deformation(original: Dict, transformed: Dict) -> Dict:
    """Classify deformation between original and transformed topology."""
    original_edges = set((e[0], e[1]) for e in original.get('edges', []))
    transformed_edges = set((e[0], e[1]) for e in transformed.get('edges', []))

    preserved = original_edges & transformed_edges
    lost = original_edges - transformed_edges
    gained = transformed_edges - original_edges

    # Classify based on edge changes
    if not lost and not gained:
        deformation = "none"
    elif lost and not gained:
        deformation = "collapsing" if len(lost) > len(original_edges) / 2 else "fragmenting"
    elif gained and not lost:
        deformation = "preservative"
    else:
        deformation = "refractive"

    return {
        "deformation": deformation,
        "preserved_edges": list(preserved),
        "lost_edges": list(lost),
        "gained_edges": list(gained)
    }

def main():
    if len(sys.argv) < 3:
        print("Usage: deformation_classifier.py <original_json> <transformed_json>")
        sys.exit(1)

    original = json.loads(sys.argv[1])
    transformed = json.loads(sys.argv[2])

    result = classify_deformation(original, transformed)
    print(json.dumps(result, indent=2))

if __name__ == "__main__":
    main()
EOF
chmod +x tools/deformation_classifier.py
# ```
#
# ---
#
# ### Step 8: Run Validation Pipeline
#
# ```bash
cat >tools/run_validation.py <<'EOF'
# #!/usr/bin/env python3 (original shebang)
"""
Run full validation pipeline.
"""

import json
import sys
import subprocess
import tempfile
from pathlib import Path

def run_command(cmd: list) -> dict:
    result = subprocess.run(cmd, capture_output=True, text=True)
    return {
        "returncode": result.returncode,
        "stdout": result.stdout,
        "stderr": result.stderr
    }

def main():
    # Test cases
    test_cases = [
        {"name": "exact_match", "result": "A->B, A->C", "expected_anchor": True},
        {"name": "extra_edge", "result": "A->B, A->C, B->C", "expected_anchor": False},
        {"name": "missing_edge", "result": "A->B", "expected_anchor": False},
        {"name": "wrong_nodes", "result": "A->B, A->D", "expected_anchor": False},
        {"name": "order_independent", "result": "A->C, A->B", "expected_anchor": True},
    ]

    results = []

    for test in test_cases:
        # Run anchor checker
        result = run_command([sys.executable, "anchor_checker.py", test["result"]])
        try:
            output = json.loads(result["stdout"])
            matches = output.get("matches_anchor", False)
            passed = (matches == test["expected_anchor"])
        except:
            passed = False
            output = {"error": result["stderr"]}

        results.append({
            "test": test["name"],
            "input": test["result"],
            "expected": test["expected_anchor"],
            "actual": matches if 'matches' in locals() else None,
            "passed": passed,
            "output": output
        })

    # Run reconstruction enumerator
    result_node = {
        "nodes": ["A", "B", "C"],
        "edges": [["A", "B"], ["A", "C"]]
    }
    constraints = {
        "type": "linear_chain",
        "contains": ["A", "B", "C"],
        "single_start": True,
        "single_end": True
    }

    recon_result = run_command([
        sys.executable, "reconstruction_enumerator.py",
        json.dumps(result_node), json.dumps(constraints)
    ])

    summary = {
        "anchor_tests": results,
        "reconstruction": json.loads(recon_result["stdout"]) if recon_result["returncode"] == 0 else {"error": recon_result["stderr"]},
        "summary": {
            "total_anchor_tests": len(results),
            "passed_anchor_tests": sum(1 for r in results if r.get("passed", False)),
            "reconstruction_success": recon_result["returncode"] == 0
        }
    }

    print(json.dumps(summary, indent=2))

    # Exit with error if any test failed
    sys.exit(0 if summary["summary"]["passed_anchor_tests"] == len(results) else 1)

if __name__ == "__main__":
    main()
EOF
chmod +x tools/run_validation.py
# ```
#
# ---
#
# ### Step 9: Create Test Cases
#
# ```bash
cat >tools/tests/test_anchor_checker.py <<'EOF'
# #!/usr/bin/env python3 (original shebang)
import unittest
import sys
import os

sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
from anchor_checker import parse_result, check_anchor

class TestAnchorChecker(unittest.TestCase):
    def test_exact_match(self):
        nodes, edges = parse_result("A->B, A->C")
        self.assertTrue(check_anchor(nodes, edges))

    def test_extra_edge(self):
        nodes, edges = parse_result("A->B, A->C, B->C")
        self.assertFalse(check_anchor(nodes, edges))

    def test_missing_edge(self):
        nodes, edges = parse_result("A->B")
        self.assertFalse(check_anchor(nodes, edges))

    def test_wrong_nodes(self):
        nodes, edges = parse_result("A->B, A->D")
        self.assertFalse(check_anchor(nodes, edges))

    def test_order_independent(self):
        nodes, edges = parse_result("A->C, A->B")
        self.assertTrue(check_anchor(nodes, edges))

    def test_json_input(self):
        nodes, edges = parse_result('{"nodes":["A","B","C"],"edges":[{"source":"A","target":"B"},{"source":"A","target":"C"}]}')
        self.assertTrue(check_anchor(nodes, edges))

if __name__ == "__main__":
    unittest.main()
EOF
# ```
#
# ---
#
# ### Step 10: Run Validation
#
# ```bash
cd tools
python3 run_validation.py
python3 -m pytest tests/ -v
# ```
#
# ---
#
# ## One-Line Summary
#
# > Phase C initiated: tooling directory created, anchor checker, constraint validator, reconstruction enumerator, regime labeler, deformation classifier, and validation pipeline implemented. Run `python3 run_validation.py` to execute tests.
#
# ---
#
# **Movement preserved.**
# Tooling created.
# Awaiting test execution results.
