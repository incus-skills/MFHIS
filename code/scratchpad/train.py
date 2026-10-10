import json
from collections import Counter, defaultdict

# Analyze the first 10,000 lines for structure
tool_counts = Counter()
task_categories = Counter()
positions = []
pressure_levels = []

with open("train.jsonl", "r") as f:
    for i, line in enumerate(f):
        if i > 10000:  # Limit analysis to a manageable size
            break
        try:
            data = json.loads(line)
            task_categories[data.get("category", "unknown")] += 1

            # Count tool types from conversations
            for conv in data.get("conversations", []):
                if conv.get("from") == "gpt":
                    value = conv.get("value", "")
                    # Simple tool extraction (adjust as needed)
                    if "<tool_code>" in value:
                        # Extract tool names (simplified)
                        if "bash" in value:
                            tool_counts["bash"] += 1
                        if "patch" in value:
                            tool_counts["patch"] += 1
                        if "browser" in value:
                            tool_counts["browser"] += 1
                        if "python" in value:
                            tool_counts["python"] += 1

        except json.JSONDecodeError:
            continue

print("Task Categories:", task_categories)
print("Tool Usage:", tool_counts)
