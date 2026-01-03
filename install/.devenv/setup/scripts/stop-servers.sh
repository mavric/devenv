#!/bin/bash
# stop-servers.sh
# Stop backend and frontend development servers
#
# Usage: ./scripts/stop-servers.sh

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_info() {
    echo -e "${CYAN}ℹ${NC} $1"
}

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
PID_FILE="$PROJECT_ROOT/dev-servers.pid"

echo ""
echo -e "${CYAN}${BOLD}Stopping Development Servers${NC}"
echo ""

if [ ! -f "$PID_FILE" ]; then
    print_warning "No PID file found. Servers may not be running."
    print_info "Attempting to kill any Node processes on development ports..."

    # Try to kill processes on common development ports
    lsof -ti:3001 | xargs kill -9 2>/dev/null && print_success "Killed process on port 3001" || print_info "No process on port 3001"
    lsof -ti:3003 | xargs kill -9 2>/dev/null && print_success "Killed process on port 3003" || print_info "No process on port 3003"

    exit 0
fi

# Load PIDs
source "$PID_FILE"

# Stop backend
if [ -n "$BACKEND_PID" ]; then
    if kill -0 "$BACKEND_PID" 2>/dev/null; then
        kill "$BACKEND_PID" 2>/dev/null && print_success "Backend stopped (PID: $BACKEND_PID)" || print_error "Failed to stop backend"
    else
        print_warning "Backend process not found (PID: $BACKEND_PID)"
    fi
else
    print_warning "No backend PID found"
fi

# Stop frontend
if [ -n "$FRONTEND_PID" ]; then
    if kill -0 "$FRONTEND_PID" 2>/dev/null; then
        kill "$FRONTEND_PID" 2>/dev/null && print_success "Frontend stopped (PID: $FRONTEND_PID)" || print_error "Failed to stop frontend"
    else
        print_warning "Frontend process not found (PID: $FRONTEND_PID)"
    fi
else
    print_warning "No frontend PID found"
fi

# Clean up PID file
rm -f "$PID_FILE"
print_success "PID file removed"

echo ""
print_success "All servers stopped"
echo ""
