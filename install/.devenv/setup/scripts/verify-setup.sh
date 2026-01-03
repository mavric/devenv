#!/bin/bash
# verify-setup.sh
# Comprehensive verification script for Apso + BetterAuth setup
#
# This script checks:
# - All prerequisites are installed
# - Backend and frontend are running
# - Database is accessible
# - Authentication endpoints work
# - Environment variables are configured
#
# Usage: ./scripts/verify-setup.sh [OPTIONS]
#   Options:
#     --backend-port PORT      Backend port (default: 3001)
#     --frontend-port PORT     Frontend port (default: 3003)
#     --db-name NAME           Database name (default: from backend .env)
#     --verbose                Show detailed output
#     --help                   Show this help message

set -e

# =============================================================================
# COLORS AND OUTPUT
# =============================================================================

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
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

print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

# =============================================================================
# CONFIGURATION
# =============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
BACKEND_DIR="$PROJECT_ROOT/backend"
FRONTEND_DIR="$PROJECT_ROOT/frontend"

BACKEND_PORT=3001
FRONTEND_PORT=3003
DB_NAME=""
VERBOSE=false

# Counters
TOTAL_CHECKS=0
PASSED_CHECKS=0
FAILED_CHECKS=0
WARNING_CHECKS=0

# =============================================================================
# ARGUMENT PARSING
# =============================================================================

show_help() {
    cat << EOF
Apso + BetterAuth Verification Script

Usage: $0 [OPTIONS]

Options:
    --backend-port PORT      Backend port (default: 3001)
    --frontend-port PORT     Frontend port (default: 3003)
    --db-name NAME           Database name (default: from backend .env)
    --verbose                Show detailed output
    --help                   Show this help message

Examples:
    # Basic verification
    ./scripts/verify-setup.sh

    # Custom ports
    ./scripts/verify-setup.sh --backend-port 3001 --frontend-port 3003

    # Verbose mode
    ./scripts/verify-setup.sh --verbose

EOF
    exit 0
}

parse_args() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            --backend-port)
                BACKEND_PORT="$2"
                shift 2
                ;;
            --frontend-port)
                FRONTEND_PORT="$2"
                shift 2
                ;;
            --db-name)
                DB_NAME="$2"
                shift 2
                ;;
            --verbose)
                VERBOSE=true
                shift
                ;;
            --help)
                show_help
                ;;
            *)
                print_error "Unknown option: $1"
                show_help
                ;;
        esac
    done
}

# =============================================================================
# VERIFICATION HELPERS
# =============================================================================

check_command() {
    if command -v "$1" &> /dev/null; then
        return 0
    fi
    return 1
}

run_check() {
    local description="$1"
    local command="$2"

    TOTAL_CHECKS=$((TOTAL_CHECKS + 1))

    if [ "$VERBOSE" = true ]; then
        echo -n "Checking: $description... "
    fi

    if eval "$command" > /dev/null 2>&1; then
        print_success "$description"
        PASSED_CHECKS=$((PASSED_CHECKS + 1))
        return 0
    else
        print_error "$description"
        FAILED_CHECKS=$((FAILED_CHECKS + 1))
        return 1
    fi
}

run_check_with_warning() {
    local description="$1"
    local command="$2"
    local warning_message="$3"

    TOTAL_CHECKS=$((TOTAL_CHECKS + 1))

    if eval "$command" > /dev/null 2>&1; then
        print_success "$description"
        PASSED_CHECKS=$((PASSED_CHECKS + 1))
        return 0
    else
        print_warning "$description - $warning_message"
        WARNING_CHECKS=$((WARNING_CHECKS + 1))
        return 1
    fi
}

# =============================================================================
# PREREQUISITE CHECKS
# =============================================================================

check_prerequisites() {
    print_header "CHECKING PREREQUISITES"

    run_check "Node.js is installed" "check_command node"

    if check_command node; then
        local node_version=$(node --version)
        local major_version=$(echo "$node_version" | sed 's/v\([0-9]*\).*/\1/')
        if [ "$major_version" -ge 18 ]; then
            print_success "Node.js version: $node_version (>= 18)"
            PASSED_CHECKS=$((PASSED_CHECKS + 1))
        else
            print_error "Node.js version: $node_version (< 18 required)"
            FAILED_CHECKS=$((FAILED_CHECKS + 1))
        fi
        TOTAL_CHECKS=$((TOTAL_CHECKS + 1))
    fi

    run_check "npm is installed" "check_command npm"
    run_check "PostgreSQL is installed" "check_command psql"
    run_check_with_warning "Git is installed" "check_command git" "Optional but recommended"
}

# =============================================================================
# DIRECTORY STRUCTURE CHECKS
# =============================================================================

check_directories() {
    print_header "CHECKING DIRECTORY STRUCTURE"

    run_check "Backend directory exists" "[ -d '$BACKEND_DIR' ]"
    run_check "Frontend directory exists" "[ -d '$FRONTEND_DIR' ]"
    run_check "Backend package.json exists" "[ -f '$BACKEND_DIR/package.json' ]"
    run_check "Frontend package.json exists" "[ -f '$FRONTEND_DIR/package.json' ]"
    run_check "Backend node_modules exists" "[ -d '$BACKEND_DIR/node_modules' ]"
    run_check "Frontend node_modules exists" "[ -d '$FRONTEND_DIR/node_modules' ]"
}

# =============================================================================
# ENVIRONMENT VARIABLE CHECKS
# =============================================================================

check_environment() {
    print_header "CHECKING ENVIRONMENT VARIABLES"

    # Check backend .env
    if [ -f "$BACKEND_DIR/.env" ]; then
        print_success "Backend .env file exists"
        PASSED_CHECKS=$((PASSED_CHECKS + 1))

        # Source the backend .env to get database name
        source "$BACKEND_DIR/.env"
        if [ -z "$DB_NAME" ] && [ -n "$DB_NAME_FROM_ENV" ]; then
            DB_NAME="$DB_NAME_FROM_ENV"
        fi

        # Check required variables
        local required_vars=("DB_HOST" "DB_PORT" "DB_USER" "DB_NAME" "PORT" "JWT_SECRET")
        for var in "${required_vars[@]}"; do
            if grep -q "^${var}=" "$BACKEND_DIR/.env"; then
                print_success "Backend .env has $var"
                PASSED_CHECKS=$((PASSED_CHECKS + 1))
            else
                print_error "Backend .env missing $var"
                FAILED_CHECKS=$((FAILED_CHECKS + 1))
            fi
            TOTAL_CHECKS=$((TOTAL_CHECKS + 1))
        done
    else
        print_error "Backend .env file not found"
        FAILED_CHECKS=$((FAILED_CHECKS + 1))
    fi
    TOTAL_CHECKS=$((TOTAL_CHECKS + 1))

    # Check frontend .env.local
    if [ -f "$FRONTEND_DIR/.env.local" ]; then
        print_success "Frontend .env.local file exists"
        PASSED_CHECKS=$((PASSED_CHECKS + 1))

        # Check required variables
        local required_vars=("NEXT_PUBLIC_API_URL" "BETTER_AUTH_SECRET")
        for var in "${required_vars[@]}"; do
            if grep -q "^${var}=" "$FRONTEND_DIR/.env.local"; then
                print_success "Frontend .env.local has $var"
                PASSED_CHECKS=$((PASSED_CHECKS + 1))
            else
                print_error "Frontend .env.local missing $var"
                FAILED_CHECKS=$((FAILED_CHECKS + 1))
            fi
            TOTAL_CHECKS=$((TOTAL_CHECKS + 1))
        done
    else
        print_error "Frontend .env.local file not found"
        FAILED_CHECKS=$((FAILED_CHECKS + 1))
    fi
    TOTAL_CHECKS=$((TOTAL_CHECKS + 1))
}

# =============================================================================
# DATABASE CHECKS
# =============================================================================

check_database() {
    print_header "CHECKING DATABASE"

    # Load database credentials from backend .env
    if [ -f "$BACKEND_DIR/.env" ]; then
        source "$BACKEND_DIR/.env"
    else
        print_error "Cannot check database - backend .env not found"
        return
    fi

    # Check PostgreSQL connection
    if PGPASSWORD="$DB_PASSWORD" psql -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -c '\q' 2>/dev/null; then
        print_success "PostgreSQL server is accessible"
        PASSED_CHECKS=$((PASSED_CHECKS + 1))
    else
        print_error "Cannot connect to PostgreSQL server"
        FAILED_CHECKS=$((FAILED_CHECKS + 1))
    fi
    TOTAL_CHECKS=$((TOTAL_CHECKS + 1))

    # Check if database exists
    if PGPASSWORD="$DB_PASSWORD" psql -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -lqt 2>/dev/null | cut -d \| -f 1 | grep -qw "$DB_NAME"; then
        print_success "Database '$DB_NAME' exists"
        PASSED_CHECKS=$((PASSED_CHECKS + 1))

        # Check for BetterAuth tables
        local auth_tables=$(PGPASSWORD="$DB_PASSWORD" psql -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -d "$DB_NAME" -t -c "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = 'public' AND table_name LIKE '%user%' OR table_name LIKE '%session%';" 2>/dev/null | xargs)

        if [ "$auth_tables" -gt 0 ]; then
            print_success "Authentication tables found ($auth_tables tables)"
            PASSED_CHECKS=$((PASSED_CHECKS + 1))
        else
            print_warning "No authentication tables found (may need to run migrations)"
            WARNING_CHECKS=$((WARNING_CHECKS + 1))
        fi
        TOTAL_CHECKS=$((TOTAL_CHECKS + 1))
    else
        print_error "Database '$DB_NAME' does not exist"
        FAILED_CHECKS=$((FAILED_CHECKS + 1))
    fi
    TOTAL_CHECKS=$((TOTAL_CHECKS + 1))
}

# =============================================================================
# SERVICE CHECKS
# =============================================================================

check_services() {
    print_header "CHECKING RUNNING SERVICES"

    # Check backend
    local backend_url="http://localhost:${BACKEND_PORT}"

    if curl -s -o /dev/null -w "%{http_code}" --max-time 5 "$backend_url" 2>/dev/null | grep -q "200\|404\|401"; then
        print_success "Backend is running at $backend_url"
        PASSED_CHECKS=$((PASSED_CHECKS + 1))

        # Check auth endpoint
        if curl -s -o /dev/null -w "%{http_code}" --max-time 5 "${backend_url}/api/auth" 2>/dev/null | grep -q "200\|404\|405"; then
            print_success "Auth endpoint is accessible"
            PASSED_CHECKS=$((PASSED_CHECKS + 1))
        else
            print_warning "Auth endpoint not accessible (may still be starting)"
            WARNING_CHECKS=$((WARNING_CHECKS + 1))
        fi
        TOTAL_CHECKS=$((TOTAL_CHECKS + 1))
    else
        print_error "Backend is not responding at $backend_url"
        FAILED_CHECKS=$((FAILED_CHECKS + 1))
    fi
    TOTAL_CHECKS=$((TOTAL_CHECKS + 1))

    # Check frontend
    local frontend_url="http://localhost:${FRONTEND_PORT}"

    if curl -s -o /dev/null -w "%{http_code}" --max-time 5 "$frontend_url" 2>/dev/null | grep -q "200"; then
        print_success "Frontend is running at $frontend_url"
        PASSED_CHECKS=$((PASSED_CHECKS + 1))
    else
        print_error "Frontend is not responding at $frontend_url"
        FAILED_CHECKS=$((FAILED_CHECKS + 1))
    fi
    TOTAL_CHECKS=$((TOTAL_CHECKS + 1))

    # Check if processes are running
    if [ -f "$PROJECT_ROOT/dev-servers.pid" ]; then
        source "$PROJECT_ROOT/dev-servers.pid"

        if kill -0 "$BACKEND_PID" 2>/dev/null; then
            print_success "Backend process is running (PID: $BACKEND_PID)"
            PASSED_CHECKS=$((PASSED_CHECKS + 1))
        else
            print_warning "Backend process not found (PID file may be stale)"
            WARNING_CHECKS=$((WARNING_CHECKS + 1))
        fi
        TOTAL_CHECKS=$((TOTAL_CHECKS + 1))

        if kill -0 "$FRONTEND_PID" 2>/dev/null; then
            print_success "Frontend process is running (PID: $FRONTEND_PID)"
            PASSED_CHECKS=$((PASSED_CHECKS + 1))
        else
            print_warning "Frontend process not found (PID file may be stale)"
            WARNING_CHECKS=$((WARNING_CHECKS + 1))
        fi
        TOTAL_CHECKS=$((TOTAL_CHECKS + 1))
    else
        print_warning "No PID file found - servers may not be running"
        WARNING_CHECKS=$((WARNING_CHECKS + 1))
        TOTAL_CHECKS=$((TOTAL_CHECKS + 1))
    fi
}

# =============================================================================
# CODE STRUCTURE CHECKS
# =============================================================================

check_code_structure() {
    print_header "CHECKING CODE STRUCTURE"

    # Backend structure
    local backend_files=(
        "src/main.ts"
        "src/app.module.ts"
        "src/auth/auth.module.ts"
        "src/auth/auth.service.ts"
        "src/auth/auth.controller.ts"
        "src/auth/auth.config.ts"
        "src/config/typeorm.config.ts"
    )

    for file in "${backend_files[@]}"; do
        if [ -f "$BACKEND_DIR/$file" ]; then
            print_success "Backend: $file exists"
            PASSED_CHECKS=$((PASSED_CHECKS + 1))
        else
            print_error "Backend: $file missing"
            FAILED_CHECKS=$((FAILED_CHECKS + 1))
        fi
        TOTAL_CHECKS=$((TOTAL_CHECKS + 1))
    done

    # Frontend structure
    local frontend_files=(
        "app/page.tsx"
        "app/login/page.tsx"
        "lib/auth-client.ts"
        "app/api/auth/[...all]/route.ts"
    )

    for file in "${frontend_files[@]}"; do
        if [ -f "$FRONTEND_DIR/$file" ]; then
            print_success "Frontend: $file exists"
            PASSED_CHECKS=$((PASSED_CHECKS + 1))
        else
            print_error "Frontend: $file missing"
            FAILED_CHECKS=$((FAILED_CHECKS + 1))
        fi
        TOTAL_CHECKS=$((TOTAL_CHECKS + 1))
    done
}

# =============================================================================
# DEPENDENCY CHECKS
# =============================================================================

check_dependencies() {
    print_header "CHECKING DEPENDENCIES"

    # Backend dependencies
    cd "$BACKEND_DIR"

    local backend_deps=("@nestjs/common" "@nestjs/core" "typeorm" "pg" "better-auth")
    for dep in "${backend_deps[@]}"; do
        if npm list "$dep" > /dev/null 2>&1; then
            print_success "Backend: $dep installed"
            PASSED_CHECKS=$((PASSED_CHECKS + 1))
        else
            print_error "Backend: $dep not installed"
            FAILED_CHECKS=$((FAILED_CHECKS + 1))
        fi
        TOTAL_CHECKS=$((TOTAL_CHECKS + 1))
    done

    # Frontend dependencies
    cd "$FRONTEND_DIR"

    local frontend_deps=("next" "react" "react-dom" "better-auth")
    for dep in "${frontend_deps[@]}"; do
        if npm list "$dep" > /dev/null 2>&1; then
            print_success "Frontend: $dep installed"
            PASSED_CHECKS=$((PASSED_CHECKS + 1))
        else
            print_error "Frontend: $dep not installed"
            FAILED_CHECKS=$((FAILED_CHECKS + 1))
        fi
        TOTAL_CHECKS=$((TOTAL_CHECKS + 1))
    done
}

# =============================================================================
# SUMMARY
# =============================================================================

print_summary() {
    print_header "VERIFICATION SUMMARY"

    local success_rate=0
    if [ $TOTAL_CHECKS -gt 0 ]; then
        success_rate=$((PASSED_CHECKS * 100 / TOTAL_CHECKS))
    fi

    echo ""
    echo -e "${BOLD}Results:${NC}"
    echo -e "  Total Checks:   ${CYAN}$TOTAL_CHECKS${NC}"
    echo -e "  Passed:         ${GREEN}$PASSED_CHECKS${NC}"
    echo -e "  Failed:         ${RED}$FAILED_CHECKS${NC}"
    echo -e "  Warnings:       ${YELLOW}$WARNING_CHECKS${NC}"
    echo -e "  Success Rate:   ${CYAN}${success_rate}%${NC}"
    echo ""

    if [ $FAILED_CHECKS -eq 0 ]; then
        if [ $WARNING_CHECKS -eq 0 ]; then
            echo -e "${GREEN}${BOLD}✓ All checks passed! Your setup is perfect.${NC}"
        else
            echo -e "${YELLOW}${BOLD}⚠ Setup is functional but has some warnings.${NC}"
        fi
        echo ""
        echo -e "${BOLD}You can access your application at:${NC}"
        echo -e "  Frontend: ${CYAN}http://localhost:${FRONTEND_PORT}${NC}"
        echo -e "  Backend:  ${CYAN}http://localhost:${BACKEND_PORT}${NC}"
        return 0
    else
        echo -e "${RED}${BOLD}✗ Setup has critical issues that need to be fixed.${NC}"
        echo ""
        echo -e "${BOLD}Recommended actions:${NC}"

        if [ ! -d "$BACKEND_DIR" ] || [ ! -d "$FRONTEND_DIR" ]; then
            echo "  1. Run the setup script: ./scripts/setup-apso-betterauth.sh"
        fi

        if [ $FAILED_CHECKS -gt 0 ]; then
            echo "  2. Check the error messages above"
            echo "  3. Review log files in /tmp/"
            echo "  4. Ensure all services are running"
        fi

        return 1
    fi
}

# =============================================================================
# MAIN EXECUTION
# =============================================================================

main() {
    clear

    print_header "APSO + BETTERAUTH VERIFICATION"
    echo -e "${BOLD}Comprehensive setup verification${NC}\n"

    # Parse arguments
    parse_args "$@"

    # Run all checks
    check_prerequisites
    check_directories
    check_environment
    check_database
    check_code_structure
    check_dependencies
    check_services

    # Print summary
    print_summary

    exit_code=$?
    exit $exit_code
}

# Run main function
main "$@"
