import json
import re
from collections import Counter, defaultdict

# Sample size: first 2000 lines for initial analysis
SAMPLE_SIZE = 2000

tool_counts = Counter()
task_categories = Counter()
tool_count_per_trace = []
lineage_depths = []
insufficiency_signals = Counter()

with open("train.jsonl", "r") as f:
    for i, line in enumerate(f):
        if i >= SAMPLE_SIZE:
            break

        try:
            data = json.loads(line)
            category = data.get("category", "unknown")
            task_categories[category] += 1

            # Track tool usage from conversations
            trace_tool_count = 0
            chain_length = 0

            for conv in data.get("conversations", []):
                if conv.get("from") == "gpt":
                    value = conv.get("value", "")

                    # Extract tool_code blocks
                    tool_blocks = re.findall(
                        r"<tool_code>(.*?)</tool_code>", value, re.DOTALL
                    )

                    for block in tool_blocks:
                        trace_tool_count += 1
                        # Try to parse JSON in the block
                        try:
                            # Look for 'name': '...' or "name": "..."
                            name_match = re.search(
                                r'["\']name["\']:\s*["\']([^"\']+)["\']', block
                            )
                            if name_match:
                                tool_name = name_match.group(1)
                                tool_counts[tool_name] += 1
                            else:
                                # Fallback: look for function name patterns
                                func_match = re.search(r"(\w+)\s*\(", block)
                                if func_match:
                                    tool_counts[func_match.group(1)] += 1
                                else:
                                    tool_counts["unknown"] += 1
                        except Exception:
                            tool_counts["parse_error"] += 1

                    # Count think blocks for lineage depth
                    think_blocks = re.findall(r"<think>(.*?)</think>", value, re.DOTALL)
                    chain_length += len(think_blocks)

                    # Detect insufficiency signals
                    if "install" in value.lower() or "need to" in value.lower():
                        insufficiency_signals["install_or_need"] += 1
                    if "learn" in value.lower() or "understand" in value.lower():
                        insufficiency_signals["learning"] += 1
                    if "error" in value.lower() or "fail" in value.lower():
                        insufficiency_signals["error_handling"] += 1

            tool_count_per_trace.append(trace_tool_count)
            lineage_depths.append(chain_length)

        except json.JSONDecodeError as e:
            print(f"Error on line {i}: {e}")
            continue
        except Exception as e:
            print(f"Unexpected error on line {i}: {e}")
            continue

# Print results
print("=" * 60)
print("TASK CATEGORIES:")
for category, count in task_categories.most_common():
    print(f"  {category}: {count} ({count / SAMPLE_SIZE * 100:.1f}%)")

print("\nTOOL USAGE:")
for tool, count in tool_counts.most_common(15):
    print(f"  {tool}: {count}")

print(
    f"\nAVERAGE TOOLS PER TRACE: {sum(tool_count_per_trace) / len(tool_count_per_trace):.2f}"
)
print(
    f"AVERAGE THINK BLOCKS PER TRACE: {sum(lineage_depths) / len(lineage_depths):.2f}"
)

print("\nINSUFFICIENCY SIGNALS:")
for signal, count in insufficiency_signals.items():
    print(f"  {signal}: {count} ({count / SAMPLE_SIZE * 100:.1f}%)")
