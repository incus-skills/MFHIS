import os


def clean_snowball_markdown(input_file, output_file):
    with open(input_file, "r", encoding="utf-8") as f:
        # Splitting by double newlines is usually best for Markdown
        blocks = f.read().split("\n\n")

    if not blocks:
        print("File is empty.")
        return

    # We use a list to store the unique/longest versions of each block
    final_blocks = [blocks[0]]

    for i in range(1, len(blocks)):
        prev = final_blocks[-1].strip()
        current = blocks[i].strip()

        # Logic: If the current block contains the previous block entirely,
        # it means the current block is the 'new' version of the snowball.
        # We replace the previous one with this longer version.
        if current.startswith(prev) or prev in current:
            final_blocks[-1] = blocks[i]
        else:
            # If it's not a continuation, it's a new unique piece of info
            final_blocks.append(blocks[i])

    with open(output_file, "w", encoding="utf-8") as f:
        f.write("\n\n".join(final_blocks))

    print(f"Done! Cleaned file saved as: {output_file}")


# Usage
clean_snowball_markdown("seminal-document-construction_CLEAN.md", "cleaned_history.md")
