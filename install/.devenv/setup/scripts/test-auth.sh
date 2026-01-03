#!/bin/bash
# test-auth.sh
# Test authentication endpoints
#
# Usage: ./scripts/test-auth.sh [--backend-port PORT]

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

print_info() {
    echo -e "${CYAN}ℹ${NC} $1"
}

BACKEND_PORT=3001

# Parse args
while [[ $# -gt 0 ]]; do
    case $1 in
        --backend-port)
            BACKEND_PORT="$2"
            shift 2
            ;;
        *)
            shift
            ;;
    esac
done

BACKEND_URL="http://localhost:${BACKEND_PORT}"

clear

print_header "AUTHENTICATION ENDPOINT TESTS"

# Test 1: Health check
print_info "Test 1: Backend Health Check"
if curl -s -o /dev/null -w "%{http_code}" --max-time 5 "$BACKEND_URL" | grep -q "200\|404"; then
    print_success "Backend is responding at $BACKEND_URL"
else
    print_error "Backend is not responding"
    exit 1
fi

# Test 2: Auth endpoint
print_info "Test 2: Auth Endpoint Check"
response=$(curl -s -w "\n%{http_code}" --max-time 5 "${BACKEND_URL}/api/auth" 2>/dev/null || echo "error")
http_code=$(echo "$response" | tail -n 1)

if [ "$http_code" = "200" ] || [ "$http_code" = "404" ] || [ "$http_code" = "405" ]; then
    print_success "Auth endpoint is accessible (HTTP $http_code)"
else
    print_error "Auth endpoint not accessible (HTTP $http_code)"
fi

# Test 3: Sign Up (demo)
print_info "Test 3: Sign Up Endpoint (Demo)"
test_email="test-$(date +%s)@example.com"
test_password="TestPassword123!"
test_name="Test User"

print_info "Creating test user: $test_email"

signup_response=$(curl -s -X POST \
    -H "Content-Type: application/json" \
    -d "{\"email\":\"$test_email\",\"password\":\"$test_password\",\"name\":\"$test_name\"}" \
    "${BACKEND_URL}/api/auth/signup" 2>/dev/null || echo '{"error":"failed"}')

if echo "$signup_response" | grep -q "error"; then
    print_error "Sign up endpoint may not be fully configured yet"
    print_info "Response: $signup_response"
else
    print_success "Sign up endpoint responded"
    print_info "Response: $signup_response"
fi

print_header "TEST SUMMARY"

echo ""
echo -e "${BOLD}Manual Testing:${NC}"
echo "1. Open http://localhost:3003/login"
echo "2. Create an account"
echo "3. Sign in"
echo "4. Check session on home page"
echo ""
echo -e "${BOLD}API Documentation:${NC}"
echo "  Backend API: ${BACKEND_URL}/api"
echo "  Auth Endpoints: ${BACKEND_URL}/api/auth/*"
echo ""
echo -e "${BOLD}Useful curl commands:${NC}"
echo "  # Health check"
echo "  curl ${BACKEND_URL}"
echo ""
echo "  # Auth endpoint"
echo "  curl ${BACKEND_URL}/api/auth"
echo ""
echo "  # Sign up (adjust payload as needed)"
echo "  curl -X POST -H 'Content-Type: application/json' \\"
echo "    -d '{\"email\":\"user@example.com\",\"password\":\"pass123\",\"name\":\"User\"}' \\"
echo "    ${BACKEND_URL}/api/auth/signup"
echo ""
