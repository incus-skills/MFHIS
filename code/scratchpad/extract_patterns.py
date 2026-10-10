import json
import re
from collections import defaultdict, Counter

SAMPLE_SIZE = 2000  # Process 2000 traces

# Pattern extraction containers
patterns = {
    "replanning": [],
    "anticipated_failure": [],
    "abandoned_paths": [],
    "budget_adaptation": [],
    "tool_substitution": [],
    "recovery": [],
}

# Track tool usage per trace for abandoned paths
tool_sequences = []
budget_warnings = []

with open("train.jsonl", "r") as f:
    for i, line in enumerate(f):
        if i >= SAMPLE_SIZE:
            break

        try:
            data = json.loads(line)
            trace_id = data.get("id", f"trace_{i}")
            conversations = data.get("conversations", [])

            # Extract think blocks and tool calls
            think_blocks = []
            tool_calls = []
            tool_responses = []
            budget_events = []

            for conv in conversations:
                if conv.get("from") == "gpt":
                    value = conv.get("value", "")

                    # Extract think blocks
                    think_matches = re.findall(
                        r"<think>(.*?)</think>", value, re.DOTALL
                    )
                    think_blocks.extend([t.strip() for t in think_matches])

                    # Extract tool calls
                    tool_matches = re.findall(
                        r"<tool_call>(.*?)</tool_call>", value, re.DOTALL
                    )
                    for block in tool_matches:
                        try:
                            tool_data = json.loads(block.strip())
                            tool_calls.append(tool_data)
                        except:
                            pass

                    # Detect budget warnings
                    if "BUDGET" in value:
                        budget_events.append(value.strip())

                elif conv.get("from") == "tool":
                    value = conv.get("value", "")
                    response_matches = re.findall(
                        r"<tool_response>(.*?)</tool_response>", value, re.DOTALL
                    )
                    for block in response_matches:
                        try:
                            tool_responses.append(json.loads(block.strip()))
                        except:
                            tool_responses.append({"raw": block[:200]})

            # --- PATTERN 1: REPLANNING ---
            # Detect: Think block followed by different tool type after failure
            for j, think in enumerate(think_blocks):
                if j < len(tool_calls) - 1:
                    # Check if think contains "I should", "Let me", "I need to"
                    if any(
                        phrase in think.lower()
                        for phrase in [
                            "i should",
                            "let me",
                            "i need to",
                            "instead",
                            "try",
                            "alternative",
                        ]
                    ):
                        # Check if the next tool call is different from previous
                        if j > 0 and j < len(tool_calls):
                            prev_tool = tool_calls[j - 1].get("name", "")
                            next_tool = tool_calls[j].get("name", "")
                            if prev_tool and next_tool and prev_tool != next_tool:
                                patterns["replanning"].append(
                                    {
                                        "trace": trace_id,
                                        "think": think[:200],
                                        "from_tool": prev_tool,
                                        "to_tool": next_tool,
                                    }
                                )

            # --- PATTERN 2: ANTICIPATED FAILURE ---
            # Detect: Budget warnings or explicit anticipation statements
            if budget_events:
                for event in budget_events:
                    # Check if followed by behavior change
                    budget_idx = None
                    for idx, think in enumerate(think_blocks):
                        if "BUDGET" in think:
                            budget_idx = idx
                            break

                    if budget_idx is not None and budget_idx < len(tool_calls) - 1:
                        # Check if tool calls after budget are different
                        before = [tc.get("name") for tc in tool_calls[: budget_idx + 1]]
                        after = [tc.get("name") for tc in tool_calls[budget_idx + 1 :]]
                        if before and after and set(before) != set(after):
                            patterns["anticipated_failure"].append(
                                {
                                    "trace": trace_id,
                                    "budget_event": event[:200],
                                    "before_tools": before[:5],
                                    "after_tools": after[:5],
                                }
                            )

            # --- PATTERN 3: ABANDONED PATHS ---
            # Detect: Tools that appear only once in a trace
            tool_counter = Counter()
            for tc in tool_calls:
                tool_counter[tc.get("name", "unknown")] += 1

            abandoned = [tool for tool, count in tool_counter.items() if count == 1]
            if abandoned:
                patterns["abandoned_paths"].append(
                    {
                        "trace": trace_id,
                        "abandoned_tools": abandoned,
                        "total_tools": len(tool_calls),
                    }
                )

            # --- PATTERN 4: BUDGET ADAPTATION ---
            # Detect: Change in tool usage before vs after budget warning
            budget_line = None
            for idx, conv in enumerate(conversations):
                if conv.get("from") == "gpt" and "BUDGET" in conv.get("value", ""):
                    budget_line = idx
                    break

            if budget_line:
                # Compare tool counts before and after
                before_calls = []
                after_calls = []
                for idx, conv in enumerate(conversations[:budget_line]):
                    if conv.get("from") == "gpt":
                        value = conv.get("value", "")
                        matches = re.findall(
                            r"<tool_call>(.*?)</tool_call>", value, re.DOTALL
                        )
                        before_calls.extend(matches)

                for idx, conv in enumerate(conversations[budget_line:]):
                    if conv.get("from") == "gpt":
                        value = conv.get("value", "")
                        matches = re.findall(
                            r"<tool_call>(.*?)</tool_call>", value, re.DOTALL
                        )
                        after_calls.extend(matches)

                if before_calls and after_calls:
                    patterns["budget_adaptation"].append(
                        {
                            "trace": trace_id,
                            "before_count": len(before_calls),
                            "after_count": len(after_calls),
                            "ratio": len(after_calls) / len(before_calls)
                            if before_calls
                            else 0,
                        }
                    )

            # --- PATTERN 5: TOOL SUBSTITUTION ---
            # Detect: Tool call fails, next call uses different tool
            for idx, response in enumerate(tool_responses):
                if idx < len(tool_calls) - 1:
                    # Check if response indicates failure
                    if isinstance(response, dict):
                        content = response.get("content", {})
                        if (
                            isinstance(content, dict)
                            and content.get("success") is False
                        ):
                            # Check next tool call is different
                            current_tool = (
                                tool_calls[idx].get("name", "")
                                if idx < len(tool_calls)
                                else ""
                            )
                            next_tool = (
                                tool_calls[idx + 1].get("name", "")
                                if idx + 1 < len(tool_calls)
                                else ""
                            )
                            if current_tool and next_tool and current_tool != next_tool:
                                patterns["tool_substitution"].append(
                                    {
                                        "trace": trace_id,
                                        "failed_tool": current_tool,
                                        "substitute_tool": next_tool,
                                    }
                                )

            # --- PATTERN 6: RECOVERY ---
            # Detect: Failure followed by success within 3 tool calls
            for idx, response in enumerate(tool_responses):
                if idx < len(tool_calls) - 3:
                    if isinstance(response, dict):
                        content = response.get("content", {})
                        if (
                            isinstance(content, dict)
                            and content.get("success") is False
                        ):
                            # Check if any of next 3 tool calls succeed
                            for j in range(idx + 1, min(idx + 4, len(tool_responses))):
                                if isinstance(tool_responses[j], dict):
                                    next_content = tool_responses[j].get("content", {})
                                    if (
                                        isinstance(next_content, dict)
                                        and next_content.get("success") is True
                                    ):
                                        patterns["recovery"].append(
                                            {
                                                "trace": trace_id,
                                                "failed_tool": tool_calls[idx].get(
                                                    "name", ""
                                                ),
                                                "successful_tool": tool_calls[j].get(
                                                    "name", ""
                                                ),
                                                "steps_to_recover": j - idx,
                                            }
                                        )
                                        break

        except Exception as e:
            continue

# Output results
print("=" * 70)
print("HERMES OBSERVATION SET 001: PATTERN EXTRACTION")
print("=" * 70)

for pattern_name, examples in patterns.items():
    print(f"\n{pattern_name.upper()}: {len(examples)} examples")
    if examples:
        # Show first 3 examples
        for ex in examples[:3]:
            print(f"  - {json.dumps(ex)[:200]}...")
        if len(examples) > 3:
            print(f"  ... and {len(examples) - 3} more")
