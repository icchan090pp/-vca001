# Cloud Service Space

A Python-first cloud workspace that also supports JavaScript/TypeScript,
C/C++, and other languages. No application framework is selected in advance.

## Python development

Prepare the workspace once:

```bash
bash scripts/cloud-environment.sh setup
```

This creates `.venv` with the available Python 3.12+ interpreter and installs
the pinned `pytest`, `Ruff`, and Playwright tools from `requirements-dev.txt`.
Setup can be repeated without replacing the virtual environment. Application
dependencies remain yours to choose.

Setup reuses installed Chromium/Chrome when available. Otherwise it installs
Playwright's Chromium headless shell and required system libraries using the
official installer; this needs package-download access and system-package
permissions on a new machine.

Run commands with the virtual environment and writable caches selected:

```bash
bash scripts/cloud-environment.sh run python --version
bash scripts/cloud-environment.sh run python -m pytest
bash scripts/cloud-environment.sh run python -m ruff check .
bash scripts/cloud-environment.sh run python -m ruff format .
```

For an interactive session, use `source .venv/bin/activate`, or start a shell
with `bash scripts/cloud-environment.sh run bash` to include the cache settings.

## GitHub Codespaces

On GitHub, select **Code > Codespaces > Create codespace on main**.
The official Universal dev container includes Python, Node.js/TypeScript,
C/C++, Java, Go, Ruby, PHP, and .NET. Python, Pylance, and Ruff editor
extensions are configured, with `.venv` as the default Python interpreter.
The container runs setup when created. No application server starts automatically.

Other languages stay available: use Node.js/npm for JavaScript or TypeScript,
GCC/G++ for C/C++, or the image's other toolchains as needed.

## Environment checks

For three consecutive verification runs, including package downloads from
PyPI and npm:

```bash
bash scripts/cloud-environment.sh verify
```

This checks Python virtual environments, isolated dependencies, editable
package installation, UTF-8 files, SQLite persistence, TypeScript builds,
a clean npm reinstall, and Python/Node.js HTTP servers with restart. C/C++
compilation and execution are also checked. Tests use temporary directories
and stop their servers after each check.

Each run includes the runtime checks, Ruff lint/format checks, five workflow
simulations, and browser checks at desktop and mobile sizes. The browser checks
verify visible content, button updates, canvas pixels/animation, reloads after
file changes, and console/network errors. Screenshots are saved under
`artifacts/browser/`. These fixtures check the tools, not a future application's
behavior; actual sites and games must also be tested as described in `AGENTS.md`.
JUnit reports and slow-test timings identify failures and are saved for each
run under `artifacts/verification/`; Actions uploads the reports and screenshots.
The command stops on the first failure and reports success only after all
three runs pass. Actions runs this same command on pushes, pull requests, and
manual dispatches, both on a hosted runner with Python 3.12 and inside the
multilingual Codespaces container. Add application tests under `tests/`
when application code exists.

## Cloud Environment integration

The Codex workspace is `/workspace/-vca001`. The setup command above is also
used by the saved Cloud Environment setup and startup instructions. Its
installed tools may differ from Codespaces; both environments run the same
verification commands.

The wrapper creates writable pip/uv and npm cache locations. It honors
existing `XDG_CACHE_HOME` and `npm_config_cache` values, otherwise using
the ignored `.cache` directory in this checkout. It works from any working
directory and does not require changes to the shell profile. To run a command
with these settings, including an interactive shell:

```bash
bash scripts/cloud-environment.sh run bash
```

The `run` command selects `.venv` and preserves the caller's working directory,
arguments, and exit status. Setup and verification locate the checkout automatically.

The Cloud Environment plugin provides the agent with runtime status and
network/credential readiness. These platform controls are separate from
repository scripts: the scripts do not install the plugin or activate saved
network policy. The agent should inspect the running environment status when
diagnosing connectivity. Saved configuration is a draft until applied through
the environment settings.

Package checks use PyPI and npm. GitHub API operations additionally require
`api.github.com`; local Universal-image downloads require `mcr.microsoft.com`
and `*.data.mcr.microsoft.com`. GitHub's existing platform authentication is
reused; credentials do not belong in this repository.
