#!/usr/bin/env bash
set -euo pipefail

repository_root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
operation="${1:-setup}"
if (( $# > 0 )); then
    shift
fi

case "$operation" in
    setup|verify)
        if (( $# != 0 )); then
            printf 'The %s command does not take arguments.\n' "$operation" >&2
            exit 2
        fi
        ;;
    run)
        if (( $# == 0 )); then
            printf 'Usage: bash scripts/cloud-environment.sh run COMMAND [ARG...]\n' >&2
            exit 2
        fi
        ;;
    *)
        printf 'Usage: bash scripts/cloud-environment.sh {setup|verify|run COMMAND [ARG...]}\n' >&2
        exit 2
        ;;
esac

# Repository-local defaults also work when the cloud home directory is read-only.
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-"$repository_root/.cache"}"
export npm_config_cache="${npm_config_cache:-"$XDG_CACHE_HOME/npm"}"
mkdir -p -- "$XDG_CACHE_HOME" "$npm_config_cache"
for cache_directory in "$XDG_CACHE_HOME" "$npm_config_cache"; do
    if [[ ! -w "$cache_directory" ]]; then
        printf 'Cache directory is not writable: %s\n' "$cache_directory" >&2
        exit 1
    fi
done

if [[ "$operation" == run ]]; then
    exec "$@"
fi

cd -- "$repository_root"
if [[ "$operation" == setup ]]; then
    exec bash scripts/check-environment.sh
fi

for attempt in 1 2 3; do
    printf '\nVerification %s/3\n' "$attempt"
    bash scripts/check-environment.sh
    python3 scripts/check-workflows.py
    printf 'PASS: verification %s/3\n' "$attempt"
done
printf '\nPASS: all 3 consecutive verification runs\n'
