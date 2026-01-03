#!/bin/bash
# Fix missing 'id' field in Create DTOs
# This is a common issue after Apso code generation

set -e

BACKEND_DIR="${1:-backend}"

echo "Fixing DTO id fields in $BACKEND_DIR..."

# Function to add id field to a DTO file
fix_dto() {
    local file=$1
    local class_name=$2

    if [ ! -f "$file" ]; then
        echo "  ⚠ File not found: $file"
        return 1
    fi

    # Check if id field already exists
    if grep -q "id: string" "$file"; then
        echo "  ✓ $class_name already has id field"
        return 0
    fi

    echo "  + Adding id field to $class_name"

    # Add id field after class declaration
    sed -i '' "/export class $class_name {/a\\
  @ApiProperty()\\
  @IsUUID()\\
  id: string;\\
" "$file"

    # Ensure IsUUID and IsOptional are imported
    if ! grep -q "IsUUID" "$file"; then
        sed -i '' "s/import { \(.*\) } from 'class-validator';/import { \1, IsUUID } from 'class-validator';/" "$file"
    fi
}

# Fix User DTO
if [ -f "$BACKEND_DIR/src/autogen/User/dtos/User.dto.ts" ]; then
    echo "Fixing User DTOs..."
    fix_dto "$BACKEND_DIR/src/autogen/User/dtos/User.dto.ts" "UserCreate"
fi

# Fix account DTO
if [ -f "$BACKEND_DIR/src/autogen/account/dtos/account.dto.ts" ]; then
    echo "Fixing account DTOs..."
    fix_dto "$BACKEND_DIR/src/autogen/account/dtos/account.dto.ts" "accountCreate"
fi

# Fix session DTO
if [ -f "$BACKEND_DIR/src/autogen/session/dtos/session.dto.ts" ]; then
    echo "Fixing session DTOs..."
    fix_dto "$BACKEND_DIR/src/autogen/session/dtos/session.dto.ts" "sessionCreate"
fi

# Fix verification DTO
if [ -f "$BACKEND_DIR/src/autogen/Verification/dtos/Verification.dto.ts" ]; then
    echo "Fixing Verification DTOs..."
    fix_dto "$BACKEND_DIR/src/autogen/Verification/dtos/Verification.dto.ts" "VerificationCreate"
fi

# Fix Organization DTO
if [ -f "$BACKEND_DIR/src/autogen/Organization/dtos/Organization.dto.ts" ]; then
    echo "Fixing Organization DTOs..."
    fix_dto "$BACKEND_DIR/src/autogen/Organization/dtos/Organization.dto.ts" "OrganizationCreate"
fi

echo "✓ DTO id fields fixed!"
