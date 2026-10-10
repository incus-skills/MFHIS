This metrics framework is exceptionally robust, particularly the **Topology Preservation Index (TPI)**. By multiplying the mean of F1 and Role Similarity by the inverse of the Hallucination Rate, you've created a "Purity Score" that penalizes models that maintain structure through fabrication.

Here is a breakdown of how these metrics interact and a suggestion for your **Role Similarity** calculation to ensure it scales with graph complexity.

---

## 1. Deep Dive: Metric Interactions

The interplay between your primary metrics provides a "thermal map" of model degradation:

- **High F1 + Low Role Similarity:** This suggests a **Label-Heavy** model. It remembers the entities but loses the "structural meaning" of how they interact within the system.
- **Low F1 + High Role Similarity:** This suggests a **Structural Mimic**. The model forgets the specific ground truth entities but successfully recreates the _pattern_ of the graph (a common occurrence in recursive "forgetting").
- **The TPI Penalty:** Since $TPI$ uses $(1 - \text{hallucination\_rate})$ as a multiplier, a model with a 50% hallucination rate loses half its preservation score instantly, even if its F1 on the _remaining_ 50% is perfect.

---

## 2. Refined Role Similarity Formula

For your `match(gt_roles, output_roles)` function, using a **Jaccard Similarity** approach on the role signatures (vectors) usually yields the most stable results for the "Role Similarity" metric:

$$RoleSimilarity = \frac{\sum_{i=1}^{n} \text{cos\_sim}(V_{gt,i}, V_{out,i})}{N}$$

Where $V$ is a vector representation of:

- $InDegree$
- $OutDegree$
- $Centrality$

---

## 3. The Extraction Method Distribution (Heuristic Value)

The **Extraction Method Distribution** is actually a brilliant proxy for **Inference Latency** and **Compute Cost**.

- `mq_parser` is computationally "cheap" (O(1) or O(n) linear scan).
- `brace_aware` and `regex_fallback` often require more complex backtracking and multiple passes.

If your distribution shifts toward `regex_fallback` over recursive cycles, you aren't just seeing a quality collapse—you are seeing an **Efficiency Collapse**.

---

## 4. Proposed Enhancement: Edge Polarity Weighting

In Section 1, your F1 score treats all edges as equal. However, in many Chronos-style graphs (like Argument Mapping), a **CONTRADICTS** edge is semantically "heavier" than a **SUPPORTS** edge.

**Consider adding a Weighted F1 option:**

> If `relation_type` in `(source, target, relation)` is inverted (e.g., Support vs. Oppose), the `correct_edges` count receives a penalty ($0.5$ instead of $1.0$) rather than being treated as a total miss.

---

## 5. Metric Lock Verification

The **Version 4.0.0 Lock** is wise. It ensures that any "Survival Depth" recorded in June 2026 is directly comparable to tests run in December.

> **Protocol Observation:** Your **Recursive Drift** formula ($1 - fidelity$) assumes a linear degradation. Have you considered logging if the drift is **Asymptotic** (leveling off) versus **Catastrophic** (sudden drop to zero)?

How are you currently handling "Node Merging" (where two ground truth nodes are collapsed into one in the output) within your F1 calculation—does it count as one deletion and one hallucination?
