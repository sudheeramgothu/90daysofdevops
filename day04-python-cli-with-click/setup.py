from setuptools import setup, find_packages

setup(
    name="mycli",
    version="0.1.0",
    py_modules=["cli_tool"],
    install_requires=[
        "click",
    ],
    entry_points={
        "console_scripts": [
            "mycli=cli_tool:cli",
        ],
    },
)
