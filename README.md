# Cloud Service Space

An open workspace for Python and other languages, without an application
framework or project dependencies selected in advance.

## GitHub Codespaces

On GitHub, select **Code > Codespaces > Create codespace on main**.
The official Universal dev container includes Python, Node.js/TypeScript,
C/C++, Java, Go, Ruby, PHP, and .NET. It checks Python, Node.js, and C/C++
when the container is created. No application server starts automatically.

Choose dependencies as your project grows. For Python, use a virtual environment:

```bash
python3 -m venv .venv
source .venv/bin/activate
python -m pip install <package>
```

For JavaScript or TypeScript, add the packages your project needs with npm.
No package manifest or lockfile is required for the environment itself.

## Environment checks

```bash
bash scripts/check-environment.sh
```

GitHub Actions runs this check on pushes, pull requests, and manual dispatches.
It verifies Python virtual environments, standard-library modules, Node.js,
and C/C++ compilation and execution.

For a fuller simulation, including package downloads from PyPI and npm:

```bash
python3 scripts/check-workflows.py
```

This checks isolated Python dependencies, UTF-8 file operations, SQLite
persistence, TypeScript builds, a clean npm reinstall, and starting and
restarting Python and Node.js HTTP servers. It uses temporary directories
and stops its servers after each check.

Actions runs both scripts on the hosted runner and inside the same dev
container used by Codespaces. These are environment checks; add application
tests when application code exists.

## Codex cloud

The Codex workspace is `/workspace/-vca001`. Its installed tools may differ
from Codespaces; Python, Node.js, and C/C++ are checked here too. Codex-specific
cache paths and startup instructions are stored in the cloud environment
settings, outside this repository.
