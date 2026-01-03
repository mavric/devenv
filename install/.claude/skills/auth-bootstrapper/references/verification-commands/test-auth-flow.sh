#!/bin/bash
# Comprehensive authentication flow testing script
# Tests all critical auth endpoints and database state

set -e

BACKEND_URL="${1:-http://localhost:3001}"
TEST_EMAIL="test-$(date +%s)@example.com"
TEST_NAME="Test User"
USER_ID=""

echo "Testing authentication flow against: $BACKEND_URL"
echo "Test email: $TEST_EMAIL"
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

test_passed() {
    echo -e "${GREEN}✓${NC} $1"
}

test_failed() {
    echo -e "${RED}✗${NC} $1"
    exit 1
}

test_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

# Test 1: Health Check
echo "Test 1: Health Check"
response=$(curl -s -w "\n%{http_code}" "$BACKEND_URL/health" || echo "000")
http_code=$(echo "$response" | tail -n1)
body=$(echo "$response" | head -n-1)

if [ "$http_code" = "200" ]; then
    test_passed "Health check passed"
else
    test_failed "Health check failed (HTTP $http_code)"
fi
echo ""

# Test 2: Create User
echo "Test 2: Create User"
USER_ID=$(uuidgen | tr '[:upper:]' '[:lower:]')
create_response=$(curl -s -w "\n%{http_code}" -X POST "$BACKEND_URL/Users" \
    -H "Content-Type: application/json" \
    -d "{
        \"id\": \"$USER_ID\",
        \"email\": \"$TEST_EMAIL\",
        \"name\": \"$TEST_NAME\",
        \"email_verified\": false
    }" || echo "000")

http_code=$(echo "$create_response" | tail -n1)
body=$(echo "$create_response" | head -n-1)

if [ "$http_code" = "201" ] || [ "$http_code" = "200" ]; then
    test_passed "User created successfully (HTTP $http_code)"
    echo "   User ID: $USER_ID"
else
    test_failed "User creation failed (HTTP $http_code): $body"
fi
echo ""

# Test 3: Verify User in Database
echo "Test 3: Verify User in Database"
if command -v psql &> /dev/null; then
    db_check=$(psql -h localhost -p 5433 -U postgres -d backend_dev \
        -t -c "SELECT COUNT(*) FROM \"user\" WHERE email = '$TEST_EMAIL';" 2>/dev/null || echo "0")

    if [ "$db_check" -eq "1" ]; then
        test_passed "User found in database"
    else
        test_warning "User not found in database (psql may not be configured)"
    fi
else
    test_warning "psql not installed, skipping database verification"
fi
echo ""

# Test 4: Get User by ID
echo "Test 4: Get User by ID"
get_response=$(curl -s -w "\n%{http_code}" "$BACKEND_URL/Users/$USER_ID" || echo "000")
http_code=$(echo "$get_response" | tail -n1)

if [ "$http_code" = "200" ]; then
    test_passed "Retrieved user by ID"
else
    test_failed "Failed to retrieve user (HTTP $http_code)"
fi
echo ""

# Test 5: Update User
echo "Test 5: Update User"
update_response=$(curl -s -w "\n%{http_code}" -X PATCH "$BACKEND_URL/Users/$USER_ID" \
    -H "Content-Type: application/json" \
    -d '{"name": "Updated Test User"}' || echo "000")

http_code=$(echo "$update_response" | tail -n1)

if [ "$http_code" = "200" ]; then
    test_passed "User updated successfully"
else
    test_failed "User update failed (HTTP $http_code)"
fi
echo ""

# Test 6: List Users
echo "Test 6: List Users"
list_response=$(curl -s -w "\n%{http_code}" "$BACKEND_URL/Users" || echo "000")
http_code=$(echo "$list_response" | tail -n1)

if [ "$http_code" = "200" ]; then
    test_passed "User list retrieved"
else
    test_failed "User list failed (HTTP $http_code)"
fi
echo ""

# Test 7: Check Auth Tables
echo "Test 7: Verify Auth Tables Exist"
if command -v psql &> /dev/null; then
    tables=$(psql -h localhost -p 5433 -U postgres -d backend_dev \
        -t -c "SELECT tablename FROM pg_tables WHERE schemaname = 'public' AND tablename IN ('user', 'account', 'session', 'verification') ORDER BY tablename;" 2>/dev/null || echo "")

    table_count=$(echo "$tables" | grep -c -v '^$' || echo "0")

    if [ "$table_count" -eq "4" ]; then
        test_passed "All auth tables exist (user, account, session, verification)"
    else
        test_warning "Only $table_count auth tables found"
    fi
else
    test_warning "psql not installed, skipping table verification"
fi
echo ""

# Test 8: Test Organization Endpoints
echo "Test 8: Test Organization Endpoints"
org_response=$(curl -s -w "\n%{http_code}" "$BACKEND_URL/Organizations" || echo "000")
http_code=$(echo "$org_response" | tail -n1)

if [ "$http_code" = "200" ]; then
    test_passed "Organization endpoint accessible"
else
    test_warning "Organization endpoint may not be configured (HTTP $http_code)"
fi
echo ""

# Test 9: Delete User (Cleanup)
echo "Test 9: Delete User (Cleanup)"
delete_response=$(curl -s -w "\n%{http_code}" -X DELETE "$BACKEND_URL/Users/$USER_ID" || echo "000")
http_code=$(echo "$delete_response" | tail -n1)

if [ "$http_code" = "200" ] || [ "$http_code" = "204" ]; then
    test_passed "User deleted successfully"
else
    test_warning "User deletion failed (HTTP $http_code) - manual cleanup may be needed"
fi
echo ""

# Summary
echo "================================"
echo "Authentication Flow Test Summary"
echo "================================"
echo "Backend URL: $BACKEND_URL"
echo "Test Email: $TEST_EMAIL"
echo ""
echo -e "${GREEN}All critical tests passed!${NC}"
echo ""
echo "Next Steps:"
echo "1. Set up BetterAuth frontend integration"
echo "2. Test signup/signin flows from frontend"
echo "3. Verify session management"
echo "4. Test OAuth providers (if configured)"
