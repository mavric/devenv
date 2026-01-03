#!/bin/bash
# fresh-start.sh
# Complete clean slate - removes everything and runs fresh setup
#
# WARNING: This will DELETE:
# - backend/ directory
# - frontend/ directory
# - Database (if exists)
# - All generated files
#
# Usage: ./scripts/fresh-start.sh [OPTIONS]

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

print_header() {
    echo -e "\n${CYAN}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${CYAN}${BOLD}  $1${NC}"
    echo -e "${CYAN}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
BACKEND_DIR="$PROJECT_ROOT/backend"
FRONTEND_DIR="$PROJECT_ROOT/frontend"

clear

print_header "FRESH START - COMPLETE RESET"

echo -e "${RED}${BOLD}WARNING: This will DELETE:${NC}"
echo "  - backend/ directory and all files"
echo "  - frontend/ directory and all files"
echo "  - Database (you'll be prompted for name)"
echo "  - All generated environment files"
echo "  - All logs and PID files"
echo ""
echo -e "${YELLOW}This action CANNOT be undone!${NC}"
echo ""
echo -n "Are you ABSOLUTELY sure? Type 'yes' to continue: "
read confirmation

if [ "$confirmation" != "yes" ]; then
    print_warning "Cancelled by user"
    exit 0
fi

echo ""
print_header "STEP 1: STOPPING SERVERS"

# Stop servers
if [ -f "$PROJECT_ROOT/dev-servers.pid" ]; then
    source "$PROJECT_ROOT/dev-servers.pid"
    if [ -n "$BACKEND_PID" ] && kill -0 "$BACKEND_PID" 2>/dev/null; then
        kill "$BACKEND_PID" 2>/dev/null
        print_success "Stopped backend (PID: $BACKEND_PID)"
    fi
    if [ -n "$FRONTEND_PID" ] && kill -0 "$FRONTEND_PID" 2>/dev/null; then
        kill "$FRONTEND_PID" 2>/dev/null
        print_success "Stopped frontend (PID: $FRONTEND_PID)"
    fi
    rm -f "$PROJECT_ROOT/dev-servers.pid"
fi

# Kill any processes on common ports
lsof -ti:3001 | xargs kill -9 2>/dev/null && print_success "Killed process on port 3001" || true
lsof -ti:3003 | xargs kill -9 2>/dev/null && print_success "Killed process on port 3003" || true

print_header "STEP 2: REMOVING DIRECTORIES"

# Remove backend
if [ -d "$BACKEND_DIR" ]; then
    print_warning "Removing backend directory..."
    rm -rf "$BACKEND_DIR"
    print_success "Backend removed"
fi

# Remove frontend
if [ -d "$FRONTEND_DIR" ]; then
    print_warning "Removing frontend directory..."
    rm -rf "$FRONTEND_DIR"
    print_success "Frontend removed"
fi

print_header "STEP 3: DATABASE CLEANUP"

# Prompt for database name
echo -n "Enter database name to drop (or leave empty to skip): "
read db_name

if [ -n "$db_name" ]; then
    echo -n "Database user [postgres]: "
    read db_user
    db_user="${db_user:-postgres}"

    echo -n "Database password (leave empty if none): "
    read -s db_password
    echo ""

    # Try to drop database
    if PGPASSWORD="$db_password" psql -h localhost -U "$db_user" -c "DROP DATABASE IF EXISTS \"$db_name\";" 2>/dev/null; then
        print_success "Database '$db_name' dropped"
    else
        print_warning "Could not drop database (may not exist or no permissions)"
    fi
else
    print_warning "Skipping database cleanup"
fi

print_header "STEP 4: CLEANING LOGS AND TEMP FILES"

# Remove log files
rm -f /tmp/backend-dev.log
rm -f /tmp/frontend-dev.log
rm -f /tmp/backend-install.log
rm -f /tmp/frontend-create.log
rm -f /tmp/frontend-better-auth.log
rm -f /tmp/backend-build.log
rm -f /tmp/db-drop.log
rm -f /tmp/db-create.log
rm -f /tmp/migration-run.log
rm -f /tmp/apso-setup-cleanup-*

print_success "Logs cleaned"

print_header "CLEANUP COMPLETE"

echo ""
echo -e "${GREEN}${BOLD}✓ Fresh slate ready!${NC}"
echo ""
echo -e "${BOLD}Next step:${NC}"
echo "  Run setup to start fresh:"
echo -e "  ${CYAN}./scripts/setup-apso-betterauth.sh${NC}"
echo ""

# Ask if they want to run setup now
echo -n "Run setup script now? [Y/n]: "
read run_setup

if [[ ! "$run_setup" =~ ^[Nn] ]]; then
    echo ""
    exec "$SCRIPT_DIR/setup-apso-betterauth.sh" "$@"
else
    echo ""
    print_success "All clean! Run ./scripts/setup-apso-betterauth.sh when ready."
    echo ""
fi
