import json
import re
from collections import Counter, defaultdict

SAMPLE_SIZE = 2000

tool_counts = Counter()
task_categories = Counter()
tool_count_per_trace = []
lineage_depths = []
insufficiency_signals = Counter()
pressure_indicators = {"failure_count": 0, "success_count": 0, "retry_count": 0}
tool_response_types = Counter()

with open("train.jsonl", "r") as f:
    for i, line in enumerate(f):
        if i >= SAMPLE_SIZE:
            break

        try:
            data = json.loads(line)
            category = data.get("category", "unknown")
            task_categories[category] += 1

            trace_tool_count = 0
            chain_length = 0
            trace_failures = 0
            trace_successes = 0

            for conv in data.get("conversations", []):
                if conv.get("from") == "gpt":
                    value = conv.get("value", "")

                    # Extract tool_call blocks
                    tool_blocks = re.findall(
                        r"<tool_call>(.*?)</tool_call>", value, re.DOTALL
                    )

                    for block in tool_blocks:
                        trace_tool_count += 1
                        try:
                            # Parse JSON in the block
                            tool_data = json.loads(block.strip())
                            tool_name = tool_data.get("name", "unknown")
                            tool_counts[tool_name] += 1
                        except json.JSONDecodeError:
                            # Fallback: regex for name
                            name_match = re.search(r'"name":\s*"([^"]+)"', block)
                            if name_match:
                                tool_counts[name_match.group(1)] += 1
                            else:
                                tool_counts["parse_error"] += 1

                    # Count think blocks
                    think_blocks = re.findall(r"<think>(.*?)</think>", value, re.DOTALL)
                    chain_length += len(think_blocks)

                    # Detect insufficiency signals
                    if "install" in value.lower() or "need to" in value.lower():
                        insufficiency_signals["install_or_need"] += 1
                    if "learn" in value.lower() or "understand" in value.lower():
                        insufficiency_signals["learning"] += 1
                    if "error" in value.lower() or "fail" in value.lower():
                        insufficiency_signals["error_handling"] += 1
                    if (
                        "not available" in value.lower()
                        or "unavailable" in value.lower()
                    ):
                        insufficiency_signals["unavailable"] += 1

                # Count tool responses
                if conv.get("from") == "tool":
                    value = conv.get("value", "")
                    response_blocks = re.findall(
                        r"<tool_response>(.*?)</tool_response>", value, re.DOTALL
                    )
                    for block in response_blocks:
                        try:
                            response_data = json.loads(block.strip())
                            # Check for success/failure
                            content = response_data.get("content", {})
                            if isinstance(content, dict):
                                if content.get("success") is False:
                                    trace_failures += 1
                                elif content.get("success") is True:
                                    trace_successes += 1
                                # Check for error messages
                                if "error" in str(content).lower():
                                    trace_failures += 1
                            # Track response types
                            if "error" in str(block).lower():
                                tool_response_types["error"] += 1
                            else:
                                tool_response_types["success"] += 1
                        except json.JSONDecodeError:
                            pass

            tool_count_per_trace.append(trace_tool_count)
            lineage_depths.append(chain_length)
            if trace_failures > 0:
                pressure_indicators["failure_count"] += 1
            if trace_successes > 0:
                pressure_indicators["success_count"] += 1
            if trace_failures > 1:
                pressure_indicators["retry_count"] += 1

        except json.JSONDecodeError as e:
            continue
        except Exception as e:
            continue

# Print results
print("=" * 60)
print("TASK CATEGORIES:")
for category, count in task_categories.most_common():
    print(f"  {category}: {count} ({count / SAMPLE_SIZE * 100:.1f}%)")

print("\nTOOL USAGE:")
for tool, count in tool_counts.most_common(20):
    print(f"  {tool}: {count}")

print(
    f"\nAVERAGE TOOLS PER TRACE: {sum(tool_count_per_trace) / len(tool_count_per_trace):.2f}"
)
print(
    f"AVERAGE THINK BLOCKS PER TRACE: {sum(lineage_depths) / len(lineage_depths):.2f}"
)

print("\nINSUFFICIENCY SIGNALS:")
for signal, count in insufficiency_signals.most_common():
    print(f"  {signal}: {count} ({count / SAMPLE_SIZE * 100:.1f}%)")

print("\nPRESSURE INDICATORS:")
print(
    f"  Traces with failures: {pressure_indicators['failure_count']} ({pressure_indicators['failure_count'] / SAMPLE_SIZE * 100:.1f}%)"
)
print(
    f"  Traces with retries: {pressure_indicators['retry_count']} ({pressure_indicators['retry_count'] / SAMPLE_SIZE * 100:.1f}%)"
)

print("\nTOOL RESPONSE TYPES:")
for resp_type, count in tool_response_types.most_common():
    print(f"  {resp_type}: {count}")
