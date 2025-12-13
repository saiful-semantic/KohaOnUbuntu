#!/bin/bash
set -e

echo "Verifying koha deployment setup..."

# Check source list
if [ ! -f /etc/apt/sources.list.d/koha.list ]; then
    echo "Error: /etc/apt/sources.list.d/koha.list not found."
    exit 1
fi
echo "OK: Source list exists."

# Check keyring
if [ ! -f /usr/share/keyrings/koha-keyring.gpg ]; then
    echo "Error: /usr/share/keyrings/koha-keyring.gpg not found."
    exit 1
fi
echo "OK: Keyring exists."

# Double check update success by ensuring package is available
# apt-cache policy returns exit code 0 even if package not found (just empty output), 
# so we grep for the Candidate version or the repo URL.
if ! apt-cache policy koha-common | grep -q "debian.koha-community.org"; then
    echo "Error: koha-common not found in apt cache from koha community repo."
    apt-cache policy koha-common # print for debug
    exit 1
fi
echo "OK: koha-common available from koha repo."

# Dry-run install
echo "Attempting dry-run install of koha-common..."
if apt-get install --dry-run koha-common -y; then
    echo "OK: dry-run install successful."
else
    echo "Error: dry-run install failed."
    exit 1
fi

echo "All checks passed."
