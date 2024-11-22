#!/bin/bash

set -o errexit -o nounset -o pipefail

VERBOSE=${VERBOSE:-false}

trap 'error "An unexpected error occurred."' ERR

log() {
    if [ "$VERBOSE" = true ]; then
        printf '%s [INFO] %s\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$1"
    fi
}

error() {
    printf '%s [ERROR] %s\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$1" >&2
}

check_command() {
    if ! command -v "$1" &>/dev/null; then
        error "$1 is not installed. Please install it before running this script."
        exit 1
    fi
}

configure_wakatime() {
    log "Configuring WakaTime settings..."
    WAKATIME_CONFIG_FILE="$HOME/.wakatime.cfg"
    {
        echo "[settings]"
        echo "api_url = https://waka.hackclub.com/api"
        echo "api_key = $BEARER_TOKEN"
    } >"$WAKATIME_CONFIG_FILE"
    chmod 600 "$WAKATIME_CONFIG_FILE"
    echo "✓ Wrote config to $WAKATIME_CONFIG_FILE"
    echo
}

check_vscode() {
    log "Checking for VS Code installation..."
    if ! command -v code &>/dev/null; then
        error "Couldn't detect VS Code! Install it from https://code.visualstudio.com/Download. If you already installed it, try this:"
        case "$OSTYPE" in
        darwin*)
            error "(In VS Code, press ⌘⇧P and type \"Shell Command: Install 'code' command in PATH\". Then press 'Enter'.)"
            ;;
        msys* | win32*)
            error "(In VS Code, press Ctrl+Shift+P and type \"Shell Command: Install 'code' command in PATH\". Then press 'Enter'.)"
            ;;
        *)
            error "(In VS Code, press Ctrl+Shift+P and type \"Shell Command: Install 'code' command in PATH\". Then press 'Enter'.)"
            ;;
        esac
        error "Once that's done, restart this script."
        exit 1
    fi
}

install_wakatime_extension() {
    log "Installing the WakaTime extension in VS Code..."
    if ! code --install-extension WakaTime.vscode-wakatime; then
        error "Failed to install WakaTime extension. Ensure you have network access and VS Code is in PATH."
        exit 1
    fi
    echo "✓ VS Code extension installed successfully"
    echo
}

send_heartbeat() {
    log "Sending test heartbeats to verify setup..."
    for i in {1..2}; do
        log "Sending heartbeat $i/2..."
        CURRENT_TIME=$(date +%s)

        case "$OSTYPE" in
        darwin*) OS_NAME="macOS" ;;
        linux*) OS_NAME="Linux" ;;
        msys* | win32*) OS_NAME="Windows" ;;
        *) OS_NAME="Unix" ;;
        esac

        HEARTBEAT_DATA=$(
            cat <<EOF
{
    "branch": "master",
    "category": "coding",
    "cursorpos": 1,
    "entity": "welcome.txt",
    "type": "file",
    "lineno": 1,
    "lines": 1,
    "project": "welcome",
    "time": $CURRENT_TIME,
    "user_agent": "wakatime/v1.102.1 ($OS_NAME)"
}
EOF
        )

        if [ "$VERBOSE" = true ]; then
            response=$(curl -s -w "%{http_code}" -X POST "https://waka.hackclub.com/api/heartbeat" \
                -H "Authorization: Bearer $BEARER_TOKEN" \
                -H "Content-Type: application/json" \
                -d "$HEARTBEAT_DATA")
            http_code="${response: -3}"
            response_body="${response%???}"
        else
            http_code=$(curl -s -o /dev/null -w "%{http_code}" -X POST "https://waka.hackclub.com/api/heartbeat" \
                -H "Authorization: Bearer $BEARER_TOKEN" \
                -H "Content-Type: application/json" \
                -d "$HEARTBEAT_DATA")
        fi

        if [ "$http_code" -eq 201 ]; then
            log "✓ Heartbeat $i sent successfully"
        else
            error_msg="Heartbeat $i failed with HTTP status $http_code."
            [ "$VERBOSE" = true ] && error_msg+=" Response: $response_body"
            error "$error_msg"
            exit 1
        fi

        [ "$i" -lt 2 ] && sleep 1
    done
    echo
}

main() {
    log "Starting Hackatime setup..."

    check_command "curl"

    if [ -z "${BEARER_TOKEN:-}" ]; then
        error "BEARER_TOKEN environment variable is not set. Please set it before running this script."
        exit 1
    fi

    configure_wakatime
    check_vscode
    install_wakatime_extension
    send_heartbeat

    echo "✨ Hackatime setup completed successfully!"
    echo "You can now return to the setup page for further instructions."
}

main "$@"
