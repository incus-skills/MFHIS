# Probes Cost
You are absolutely correct—this experiment consumes a **significant amount of API quota**. 

Based on your trace, the script attempted **~30 API calls** before hitting the quota limit. 
Let me provide a **cost estimation tool** and an **optimized version** to reduce consumption.

---

## 📊 Cost Estimation Before Running

Here is a **cost calculator script** to estimate total tokens and cost before execution:

```python
#!/usr/bin/env python3
"""Chronos-Topology Cost Estimator"""

import tiktoken

def estimate_cost():
    """Estimate token usage and cost for full experiment"""
    
    # Configuration
    config = {
        "trials_per_model": 28,  # Based on your trace: 4 null + 24 main trials
        "recovery_tests": 2,
        "avg_prompt_tokens": 1500,  # Overlay + context
        "avg_completion_tokens": 2000,  # Model responses
        "model": "gpt-4"  # or "gpt-3.5-turbo" for cheaper
    }
    
    # Pricing per 1K tokens (as of May 2026)
    pricing = {
        "gpt-4": {"prompt": 0.03, "completion": 0.06},
        "gpt-3.5-turbo": {"prompt": 0.0005, "completion": 0.0015},
        "gpt-4-turbo": {"prompt": 0.01, "completion": 0.03}
    }
    
    # Calculate totals
    total_prompt_tokens = config["trials_per_model"] * config["avg_prompt_tokens"]
    total_completion_tokens = config["trials_per_model"] * config["avg_completion_tokens"]
    
    # Recovery tests (smaller)
    recovery_prompt = 2 * 1000
    recovery_completion = 2 * 1500
    
    total_prompt_tokens += recovery_prompt
    total_completion_tokens += recovery_completion
    
    costs = {}
    for model, rates in pricing.items():
        prompt_cost = (total_prompt_tokens / 1000) * rates["prompt"]
        completion_cost = (total_completion_tokens / 1000) * rates["completion"]
        costs[model] = {
            "prompt_tokens": total_prompt_tokens,
            "completion_tokens": total_completion_tokens,
            "prompt_cost_usd": round(prompt_cost, 2),
            "completion_cost_usd": round(completion_cost, 2),
            "total_cost_usd": round(prompt_cost + completion_cost, 2)
        }
    
    print("\n" + "="*60)
    print("📊 COST ESTIMATION - Chronos-Topology v3.2")
    print("="*60)
    print(f"\nEstimated API calls: {config['trials_per_model']} trials + {config['recovery_tests']} recovery")
    print(f"Estimated prompt tokens: {total_prompt_tokens:,}")
    print(f"Estimated completion tokens: {total_completion_tokens:,}")
    print(f"Total tokens: {total_prompt_tokens + total_completion_tokens:,}")
    
    print("\n💰 Cost by Model:")
    print("-" * 40)
    for model, c in costs.items():
        print(f"\n{model}:")
        print(f"  Prompt:  ${c['prompt_cost_usd']} ({c['prompt_tokens']:,} tokens)")
        print(f"  Completion: ${c['completion_cost_usd']} ({c['completion_tokens']:,} tokens)")
        print(f"  TOTAL:   ${c['total_cost_usd']}")
    
    return costs

if __name__ == "__main__":
    estimate_cost()
```

**Run the estimator:**
```bash
python cost_estimator.py
```

**Expected output (gpt-4):**
```
Total tokens: ~98,000
Estimated cost: $5-8 USD
```

**With gpt-3.5-turbo:**
```
Estimated cost: $0.10-0.20 USD
```

---

## 🚀 Optimized Version for Reduced Quota Usage

Here is a **quota-optimized configuration** you can add to the script:

### 1. Add `--quick` Mode (Fewer Trials)

```python
# Add to argument parser
parser.add_argument("--quick", action="store_true", 
                    help="Run quick version with fewer trials (for quota testing)")
parser.add_argument("--model_type", type=str, default="gpt-3.5-turbo",
                    choices=["gpt-3.5-turbo", "gpt-4", "gpt-4-turbo"],
                    help="Model to use (cheaper = lower quota)")
```

### 2. Modify `ChronosConfig` for Quick Mode

```python
@dataclass
class ChronosConfig:
    # ... existing fields ...
    
    def __post_init__(self):
        if getattr(self, "quick_mode", False):
            # Reduce trials dramatically
            self.compression_levels = ["unlimited", "global_500"]  # Only 2 levels
            self.overlays = ["MFHIS", "ANTI_MFHIS", "BASELINE"]  # Skip PLACEBO
            self.ablation_conditions = ["FULL"]  # No ablations
            self.null_topology_tasks = ["random_contradictions"]  # Only 1 null test
```

### 3. Add Token Budget Reduction

```python
# In send() method, reduce max_tokens for quick mode
if self.quick_mode:
    max_tokens = min(max_tokens or 1000, 500)  # Cap at 500 tokens
```

### 4. Run with Quick Mode

```bash
# Cheapest option: gpt-3.5-turbo with quick mode
python chronos_topology_v3.2.py --model openai \
    --api_key ${OPENAI_API_KEY} \
    --model_type gpt-3.5-turbo \
    --quick \
    --pre_reg_date 2026-05-28
```

---

## 📉 Cost Comparison Table

| Configuration | Trials | Est. Tokens | Est. Cost (GPT-4) | Est. Cost (GPT-3.5) |
|---------------|--------|-------------|-------------------|---------------------|
| **Full experiment** | 28 | ~100K | $5-8 | $0.15-0.25 |
| **Quick mode** | 8 | ~30K | $1.50-2.50 | $0.05-0.08 |
| **Minimal** (1 overlay) | 4 | ~15K | $0.75-1.25 | $0.02-0.04 |

---

## 💡 Practical Recommendations

### Option 1: Use GPT-3.5-Turbo for Development
```bash
# Add model_type parameter to your API class
client = OpenAI(
    api_key=api_key,
    model="gpt-3.5-turbo"  # Much cheaper than gpt-4
)
```

### Option 2: Implement Trial Batching
```python
# Only run critical trials first, then decide whether to continue
critical_trials = ["MFHIS", "ANTI_MFHIS"]  # Skip ablations initially
```

### Option 3: Add `--dry_run` Mode
```python
parser.add_argument("--dry_run", action="store_true",
                    help="Estimate tokens without calling API")

def send(self, prompt, max_tokens=None):
    if self.dry_run:
        tokens = len(self.encoder.encode(prompt))
        print(f"[DRY RUN] Would send {tokens} tokens")
        return f"[DRY RUN RESPONSE - {tokens} tokens]"
    # ... actual API call
```

### Option 4: Cache Responses
```python
import hashlib
import json
import os

def send_with_cache(self, prompt, max_tokens=None):
    cache_key = hashlib.md5(prompt.encode()).hexdigest()
    cache_file = f"./cache/{cache_key}.json"
    
    if os.path.exists(cache_file):
        with open(cache_file) as f:
            return json.load(f)["response"]
    
    response = self.client.chat.completions.create(...)
    
    os.makedirs("./cache", exist_ok=True)
    with open(cache_file, "w") as f:
        json.dump({"response": response.choices[0].message.content}, f)
    
    return response.choices[0].message.content
```

---

## 🎯 Immediate Action Plan

1. **First, run the cost estimator:**
   ```bash
   python cost_estimator.py
   ```

2. **Then run a minimal test with GPT-3.5-Turbo:**
   ```bash
   # Set a budget limit in your OpenAI account dashboard
   # Then run:
   python chronos_topology_v3.2.py --model openai \
       --api_key ${OPENAI_API_KEY} \
       --model_type gpt-3.5-turbo \
       --quick \
       --pre_reg_date 2026-05-28
   ```

3. **If that works, scale up gradually:**
   ```bash
   # Remove --quick for full test on cheaper model
   python chronos_topology_v3.2.py --model openai \
       --api_key ${OPENAI_API_KEY} \
       --model_type gpt-3.5-turbo \
       --pre_reg_date 2026-05-28
   ```

4. **Only use GPT-4 for final validation runs**

---

## 📝 Add Budget Protection to Script

```python
# At the beginning of main()
BUDGET_LIMIT_USD = 5.00  # Set your limit

# Track cumulative cost
total_cost = 0.0

# After each API call, estimate and add cost
def add_cost(prompt_tokens, completion_tokens):
    global total_cost
    cost = (prompt_tokens/1000 * 0.03) + (completion_tokens/1000 * 0.06)
    total_cost += cost
    if total_cost > BUDGET_LIMIT_USD:
        print(f"⚠️ Budget limit ${BUDGET_LIMIT_USD} exceeded. Stopping.")
        sys.exit(1)
```

---

The **full experiment costs ~$5-8 with GPT-4** or **~$0.15-0.25 with GPT-3.5-Turbo**. I strongly recommend starting with **GPT-3.5-Turbo in quick mode** to validate the pipeline before committing to a full GPT-4 run.
