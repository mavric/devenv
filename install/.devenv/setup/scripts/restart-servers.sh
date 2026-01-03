#!/bin/bash
# restart-servers.sh
# Restart backend and frontend development servers
#
# Usage: ./scripts/restart-servers.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Stopping servers..."
"$SCRIPT_DIR/stop-servers.sh"

echo ""
echo "Waiting 2 seconds..."
sleep 2

echo ""
echo "Starting servers..."

PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
BACKEND_DIR="$PROJECT_ROOT/backend"
FRONTEND_DIR="$PROJECT_ROOT/frontend"

# Start backend
cd "$BACKEND_DIR"
npm run start:dev > /tmp/backend-dev.log 2>&1 &
BACKEND_PID=$!

# Start frontend
cd "$FRONTEND_DIR"
npm run dev > /tmp/frontend-dev.log 2>&1 &
FRONTEND_PID=$!

# Save PIDs
cat > "$PROJECT_ROOT/dev-servers.pid" << EOF
BACKEND_PID=$BACKEND_PID
FRONTEND_PID=$FRONTEND_PID
EOF

echo ""
echo "Servers restarted successfully!"
echo "Backend PID: $BACKEND_PID"
echo "Frontend PID: $FRONTEND_PID"
echo ""
echo "View logs: ./scripts/view-logs.sh"
echo ""
