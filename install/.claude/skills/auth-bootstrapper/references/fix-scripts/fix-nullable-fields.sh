#!/bin/bash
# Fix nullable field constraints in User entity
# This fixes "null value in column 'X' violates not-null constraint" errors

set -e

BACKEND_DIR="${1:-backend}"
ENTITY_FILE="$BACKEND_DIR/src/autogen/User/User.entity.ts"

echo "Fixing nullable fields in User entity..."

if [ ! -f "$ENTITY_FILE" ]; then
    echo "❌ User entity not found at: $ENTITY_FILE"
    exit 1
fi

# Fields that MUST be nullable for Better Auth
NULLABLE_FIELDS=(
    "avatar_url"
    "password_hash"
    "oauth_provider"
    "oauth_id"
    "two_factor_secret"
    "banned_reason"
)

for field in "${NULLABLE_FIELDS[@]}"; do
    echo "  Checking $field..."

    # Check if field exists
    if ! grep -q "$field" "$ENTITY_FILE"; then
        echo "    ⚠ Field $field not found, skipping"
        continue
    fi

    # Check if already nullable
    if grep -A1 "@Column.*$field" "$ENTITY_FILE" | grep -q "nullable: true"; then
        echo "    ✓ $field already nullable"
        continue
    fi

    echo "    + Making $field nullable"

    # Add nullable: true to the @Column decorator
    # This handles various @Column formats
    sed -i '' "/@Column.*$field/,/)/s/@Column({/@Column({ nullable: true,/" "$ENTITY_FILE"
    sed -i '' "/@Column.*$field/,/)/s/@Column()/@Column({ nullable: true })/" "$ENTITY_FILE"
done

echo "✓ Nullable fields fixed!"
echo ""
echo "⚠ IMPORTANT: You must reset the database for these changes to take effect:"
echo "  1. DROP SCHEMA public CASCADE;"
echo "  2. CREATE SCHEMA public;"
echo "  3. npm run start:dev"
