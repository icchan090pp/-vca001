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
bash scripts/cloud-environment.sh setup
```

GitHub Actions runs this check on pushes, pull requests, and manual dispatches.
It verifies Python virtual environments, standard-library modules, Node.js,
and C/C++ compilation and execution.

For three consecutive verification runs, including package downloads from
PyPI and npm:

```bash
bash scripts/cloud-environment.sh verify
```

This checks isolated Python dependencies, UTF-8 file operations, SQLite
persistence, TypeScript builds, a clean npm reinstall, and starting and
restarting Python and Node.js HTTP servers. It uses temporary directories
and stops its servers after each check.

Each run includes the runtime checks and all four workflow simulations.
The command stops on the first failure and reports success only after all
three runs pass. Actions uses this same command on the hosted runner and
inside the Codespaces dev container. These are environment checks; add
application tests when application code exists.

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

The `run` command preserves the caller's working directory, arguments, and
exit status. Setup and verification locate the checkout automatically.

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
