#!/bin/bash

# Enable pipefail to catch pipeline errors
set -o pipefail

# Script Version
VERSION="0.1.0"

# Logger Function
log() {
  local message="$1"
  local type="$2"
  local timestamp
  timestamp=$(date '+%Y-%m-%d %H:%M:%S')
  local color
  local endcolor="\033[0m"

  case "$type" in
    "info") color="\033[38;5;79m" ;;
    "success") color="\033[1;32m" ;;
    "error") color="\033[1;31m" ;;
    *) color="\033[1;34m" ;;
  esac

  echo -e "${color}${timestamp} - ${message}${endcolor}"
}

# Error handler function  
handle_error() {
  local exit_code=$1
  local error_message="$2"
  log "Error: $error_message (Exit Code: $exit_code)" "error"
  exit "$exit_code"
}

check_root() {
    if [[ $EUID -ne 0 ]]; then
       handle_error "1" "This script must be run as root"
    fi
}

check_os() {
    if ! [ -f "/etc/debian_version" ]; then
        echo "Error: This script is only supported on Debian-based systems."
        exit 1
    fi
}

# Function to Install the script pre-requisites
install_pre_reqs() {
    log "Installing pre-requisites" "info"

    # Run 'apt-get update'
    if ! apt-get update -y; then
        handle_error "$?" "Failed to run 'apt-get update'"
    fi

    # Run 'apt-get install'
    if ! apt-get install -y apt-transport-https ca-certificates curl gnupg2 lsb-release; then
        handle_error "$?" "Failed to install packages"
    fi

    mkdir -p /usr/share/keyrings
    rm -f /usr/share/keyrings/koha-keyring.gpg
    rm -f /etc/apt/sources.list.d/koha.list

    # Run 'curl' and 'gpg'
    if ! curl -fsSL https://debian.koha-community.org/koha/gpg.asc | gpg --dearmor -o /usr/share/keyrings/koha-keyring.gpg; then
      handle_error "$?" "Failed to download and import the Koha signing key"
    fi
}

# Function to configure the Repo
configure_repo() {
    local KOHA_RELEASE=${KOHA_RELEASE:-$1}

    arch=$(dpkg --print-architecture)
    if [[ ! "$arch" =~ ^(i386|amd64|arm64|armhf)$ ]]; then
      handle_error "1" "Unsupported architecture: $arch. Only i386, amd64, arm64, and armhf are supported."
    fi

    echo "deb [signed-by=/usr/share/keyrings/koha-keyring.gpg] https://debian.koha-community.org/koha $KOHA_RELEASE main" | tee /etc/apt/sources.list.d/koha.list > /dev/null

    # Run 'apt-get update'
    if ! apt-get update -y; then
        handle_error "$?" "Failed to run 'apt-get update'"
    else
        log "Repository configured successfully (Release: $KOHA_RELEASE). To install Koha, run: apt-get install koha-common -y" "success"
    fi
}

# Argument parsing for version
if [[ "$1" == "--version" ]]; then
    echo "koha_setup.sh v${VERSION}"
    exit 0
fi

# Define Default Koha Release if not set via env
KOHA_RELEASE=${KOHA_RELEASE:-"stable"}

# Main execution
check_root
check_os
install_pre_reqs || handle_error $? "Failed installing pre-requisites"
configure_repo "$KOHA_RELEASE" || handle_error $? "Failed configuring repository"
