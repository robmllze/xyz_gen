## File Generation Process

1. **Create a File Tree:**

Read all files from a directory to construct a file tree structure.

2. **Categorize Files:**

Organize files by type, such as templates, source files, or configuration files.

3. **Combine gen.md Files:**

Read all gen.md files or files ending with .gen.md from a directory.
Treat snippets within these files as actual files in the same directory.
Integrate these snippets into the file tree.

4. **Generate Insights:**

Create an 'insight' for each configuration or annotation found in the source files.

5. **Process Insights:**

For every insight, run a specific function.

6. **Replacement Map:**

Define a replacement map function according to the requirements of the specific generator.

7. **Generate Outputs:**

Combine insights, templates, and the replacement map to produce the final output files.
