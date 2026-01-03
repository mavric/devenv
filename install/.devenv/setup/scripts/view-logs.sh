#!/bin/bash
# view-logs.sh
# View development server logs
#
# Usage: ./scripts/view-logs.sh [backend|frontend|both]

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_info() {
    echo -e "${CYAN}ℹ${NC} $1"
}

LOG_TYPE="${1:-both}"

case "$LOG_TYPE" in
    backend)
        if [ -f /tmp/backend-dev.log ]; then
            print_info "Showing backend logs (Press Ctrl+C to exit)"
            echo ""
            tail -f /tmp/backend-dev.log
        else
            print_error "Backend log file not found at /tmp/backend-dev.log"
            exit 1
        fi
        ;;
    frontend)
        if [ -f /tmp/frontend-dev.log ]; then
            print_info "Showing frontend logs (Press Ctrl+C to exit)"
            echo ""
            tail -f /tmp/frontend-dev.log
        else
            print_error "Frontend log file not found at /tmp/frontend-dev.log"
            exit 1
        fi
        ;;
    both)
        if [ -f /tmp/backend-dev.log ] && [ -f /tmp/frontend-dev.log ]; then
            print_info "Showing both backend and frontend logs (Press Ctrl+C to exit)"
            echo ""
            echo -e "${CYAN}${BOLD}=== BACKEND ===${NC}"
            tail -n 20 /tmp/backend-dev.log
            echo ""
            echo -e "${CYAN}${BOLD}=== FRONTEND ===${NC}"
            tail -n 20 /tmp/frontend-dev.log
            echo ""
            print_info "Following logs..."
            tail -f /tmp/backend-dev.log /tmp/frontend-dev.log
        else
            print_error "Log files not found"
            exit 1
        fi
        ;;
    *)
        print_error "Invalid argument. Use: backend, frontend, or both"
        echo ""
        echo "Usage: ./scripts/view-logs.sh [backend|frontend|both]"
        exit 1
        ;;
esac
