# Day 4 — Python CLI with Click

## 📖 Overview
Today’s focus: **Python CLI with Click**.  
We’ll build command-line interfaces (CLIs) using Python’s `click` library to create developer-friendly tools.

---

## 🎯 Learning Goals
- Understand the basics of the `click` library.
- Build simple and nested CLI commands.
- Handle arguments, options, and flags.
- Add colors, prompts, and error handling.
- Package the CLI for reuse.

---

## 🛠️ Lab Setup & Tasks

```text
1. Install Click
   pip install click

2. Hello world CLI
   python cli_hello.py --name "Alice"
   ✔ Greets the user by name.

3. Multi-command CLI
   python cli_tool.py greet --name "Bob"
   python cli_tool.py math add 3 5
   ✔ Supports subcommands with arguments.

4. Options, prompts, and defaults
   python cli_options.py greet
   python cli_options.py greet --name "Charlie" --caps
   ✔ Adds optional flags, default values, and user prompts.

5. Colors and error handling
   python cli_colors.py greet --name "Dana"
   python cli_colors.py math div 10 0
   ✔ Demonstrates colored output and error handling.

6. Package and run as script
   python -m pip install --editable .
   mycli greet --name "Eve"
   ✔ Shows how to package the CLI for global use.
