import json

# Look at the first 3 traces in detail
with open("train.jsonl", "r") as f:
    for i, line in enumerate(f):
        if i >= 3:
            break
        try:
            data = json.loads(line)
            print(f"\n{'=' * 60}")
            print(f"TRACE {i + 1}:")
            print(f"Category: {data.get('category', 'unknown')}")
            print(f"Task: {data.get('task', '')[:100]}...")

            # Print the structure of the first conversation
            convs = data.get("conversations", [])
            print(f"Number of conversations: {len(convs)}")

            for j, conv in enumerate(convs):
                from_field = conv.get("from", "unknown")
                value = conv.get("value", "")
                print(f"\n  Conversation {j + 1} (from: {from_field}):")

                # Show first 500 characters of the value
                preview = value[:500]
                print(f"    Preview: {preview}...")

                # Explicitly check for tool patterns
                if "<tool_code>" in value:
                    print("    [FOUND] <tool_code> tag present")
                    # Show what's inside
                    import re

                    tool_blocks = re.findall(
                        r"<tool_code>(.*?)</tool_code>", value, re.DOTALL
                    )
                    print(f"    Number of tool_blocks: {len(tool_blocks)}")
                    if tool_blocks:
                        print(
                            f"    First tool block (truncated): {tool_blocks[0][:200]}..."
                        )
                else:
                    print("    [NOT FOUND] <tool_code> tag")

                if "<think>" in value:
                    print("    [FOUND] <think> tag present")

        except Exception as e:
            print(f"Error on line {i}: {e}")
