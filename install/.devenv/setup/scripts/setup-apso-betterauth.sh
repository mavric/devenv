#!/bin/bash
# setup-apso-betterauth.sh
# Complete Apso + BetterAuth setup in 5 minutes
#
# This script automates the entire setup process for a new Apso backend + Next.js frontend
# with BetterAuth authentication, PostgreSQL database, and development environment.
#
# Usage: ./scripts/setup-apso-betterauth.sh [OPTIONS]
#   Options:
#     --project-name NAME      Project name (default: prompts from user)
#     --backend-port PORT      Backend port (default: 3001)
#     --frontend-port PORT     Frontend port (default: 3003)
#     --db-name NAME           Database name (default: project_name_dev)
#     --skip-install           Skip npm install steps
#     --skip-db                Skip database initialization
#     --help                   Show this help message

set -e  # Exit on error

# =============================================================================
# COLORS AND OUTPUT
# =============================================================================

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Progress spinner
SPINNER_PID=""

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

print_step() {
    echo -e "\n${BOLD}$1${NC}"
}

spinner() {
    local pid=$1
    local message=$2
    local spinstr='⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏'

    echo -n "$message "
    while kill -0 $pid 2>/dev/null; do
        local temp=${spinstr#?}
        printf "[%c]" "$spinstr"
        local spinstr=$temp${spinstr%"$temp"}
        sleep 0.1
        printf "\b\b\b"
    done
    wait $pid
    local exit_code=$?
    if [ $exit_code -eq 0 ]; then
        echo -e "${GREEN}✓${NC}"
    else
        echo -e "${RED}✗${NC}"
    fi
    return $exit_code
}

# =============================================================================
# CONFIGURATION
# =============================================================================

# Default values
PROJECT_NAME=""
BACKEND_PORT=3001
FRONTEND_PORT=3003
DB_NAME=""
DB_USER="postgres"
DB_PASSWORD=""
DB_HOST="localhost"
DB_PORT=5432
SKIP_INSTALL=false
SKIP_DB=false

# Directory paths (will be set after project name is known)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
BACKEND_DIR=""
FRONTEND_DIR=""

# Temporary file for cleanup tracking
CLEANUP_FILE="/tmp/apso-setup-cleanup-$$"
touch "$CLEANUP_FILE"

# =============================================================================
# CLEANUP AND ERROR HANDLING
# =============================================================================

cleanup() {
    local exit_code=$?

    if [ $exit_code -ne 0 ]; then
        print_header "SETUP FAILED - ROLLING BACK"
        print_error "An error occurred. Rolling back changes..."

        # Kill any background processes
        if [ -n "$SPINNER_PID" ]; then
            kill $SPINNER_PID 2>/dev/null || true
        fi

        # Read cleanup file and perform rollback
        if [ -f "$CLEANUP_FILE" ]; then
            while IFS= read -r item; do
                if [ -d "$item" ]; then
                    print_warning "Removing directory: $item"
                    rm -rf "$item"
                elif [ -f "$item" ]; then
                    print_warning "Removing file: $item"
                    rm -f "$item"
                fi
            done < "$CLEANUP_FILE"
        fi

        print_error "Setup failed. Please check the error messages above."
        exit $exit_code
    fi

    # Clean up temporary files
    rm -f "$CLEANUP_FILE"
}

trap cleanup EXIT

# =============================================================================
# ARGUMENT PARSING
# =============================================================================

show_help() {
    cat << EOF
Apso + BetterAuth Setup Script

Usage: $0 [OPTIONS]

Options:
    --project-name NAME      Project name (default: interactive prompt)
    --backend-port PORT      Backend port (default: 3001)
    --frontend-port PORT     Frontend port (default: 3003)
    --db-name NAME           Database name (default: project_name_dev)
    --db-user USER           Database user (default: postgres)
    --db-password PASS       Database password (default: empty)
    --db-host HOST           Database host (default: localhost)
    --db-port PORT           Database port (default: 5432)
    --skip-install           Skip npm install steps
    --skip-db                Skip database initialization
    --help                   Show this help message

Examples:
    # Interactive setup
    ./scripts/setup-apso-betterauth.sh

    # Automated setup
    ./scripts/setup-apso-betterauth.sh \\
        --project-name my-saas \\
        --backend-port 3001 \\
        --frontend-port 3003

EOF
    exit 0
}

parse_args() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            --project-name)
                PROJECT_NAME="$2"
                shift 2
                ;;
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
            --db-user)
                DB_USER="$2"
                shift 2
                ;;
            --db-password)
                DB_PASSWORD="$2"
                shift 2
                ;;
            --db-host)
                DB_HOST="$2"
                shift 2
                ;;
            --db-port)
                DB_PORT="$2"
                shift 2
                ;;
            --skip-install)
                SKIP_INSTALL=true
                shift
                ;;
            --skip-db)
                SKIP_DB=true
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
# PREREQUISITE CHECKS
# =============================================================================

check_command() {
    if ! command -v "$1" &> /dev/null; then
        return 1
    fi
    return 0
}

check_prerequisites() {
    print_header "CHECKING PREREQUISITES"

    local missing_deps=()

    # Check Node.js
    print_step "Checking Node.js..."
    if check_command node; then
        local node_version=$(node --version)
        print_success "Node.js installed: $node_version"

        # Check if version >= 18
        local major_version=$(echo "$node_version" | sed 's/v\([0-9]*\).*/\1/')
        if [ "$major_version" -lt 18 ]; then
            print_error "Node.js version 18 or higher required (found: $node_version)"
            missing_deps+=("node>=18")
        fi
    else
        print_error "Node.js not found"
        missing_deps+=("node")
    fi

    # Check npm
    print_step "Checking npm..."
    if check_command npm; then
        local npm_version=$(npm --version)
        print_success "npm installed: v$npm_version"
    else
        print_error "npm not found"
        missing_deps+=("npm")
    fi

    # Check PostgreSQL
    print_step "Checking PostgreSQL..."
    if check_command psql; then
        local pg_version=$(psql --version | awk '{print $3}')
        print_success "PostgreSQL installed: $pg_version"

        # Try to connect to PostgreSQL
        if PGPASSWORD="$DB_PASSWORD" psql -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -c '\q' 2>/dev/null; then
            print_success "PostgreSQL connection successful"
        else
            print_warning "Cannot connect to PostgreSQL (this may be okay if using custom credentials)"
        fi
    else
        print_error "PostgreSQL (psql) not found"
        missing_deps+=("postgresql")
    fi

    # Check Git
    print_step "Checking Git..."
    if check_command git; then
        local git_version=$(git --version | awk '{print $3}')
        print_success "Git installed: $git_version"
    else
        print_warning "Git not found (optional)"
    fi

    # Check for Apso CLI
    print_step "Checking Apso CLI..."
    if check_command apso; then
        local apso_version=$(apso --version 2>/dev/null || echo "unknown")
        print_success "Apso CLI installed: $apso_version"
    else
        print_warning "Apso CLI not found - will install locally"
    fi

    # Report missing dependencies
    if [ ${#missing_deps[@]} -gt 0 ]; then
        print_error "Missing required dependencies:"
        for dep in "${missing_deps[@]}"; do
            echo "  - $dep"
        done
        echo ""
        print_info "Please install missing dependencies:"
        echo ""
        echo "  macOS (Homebrew):"
        echo "    brew install node postgresql"
        echo ""
        echo "  Ubuntu/Debian:"
        echo "    sudo apt-get install nodejs npm postgresql postgresql-client"
        echo ""
        echo "  Windows (Chocolatey):"
        echo "    choco install nodejs postgresql"
        echo ""
        exit 1
    fi

    print_success "All prerequisites satisfied"
}

# =============================================================================
# INTERACTIVE CONFIGURATION
# =============================================================================

prompt_config() {
    print_header "PROJECT CONFIGURATION"

    # Project name
    if [ -z "$PROJECT_NAME" ]; then
        echo -n "Enter project name (e.g., my-saas): "
        read PROJECT_NAME
        while [ -z "$PROJECT_NAME" ]; do
            print_error "Project name cannot be empty"
            echo -n "Enter project name: "
            read PROJECT_NAME
        done
    fi

    # Validate project name (alphanumeric and dashes only)
    if ! [[ "$PROJECT_NAME" =~ ^[a-zA-Z0-9-]+$ ]]; then
        print_error "Project name must contain only letters, numbers, and dashes"
        exit 1
    fi

    # Set directory paths
    BACKEND_DIR="$PROJECT_ROOT/backend"
    FRONTEND_DIR="$PROJECT_ROOT/frontend"

    # Database name
    if [ -z "$DB_NAME" ]; then
        local default_db="${PROJECT_NAME//-/_}_dev"
        echo -n "Database name [$default_db]: "
        read db_input
        DB_NAME="${db_input:-$default_db}"
    fi

    # Database password
    if [ -z "$DB_PASSWORD" ]; then
        echo -n "Database password (leave empty if none): "
        read -s db_pass
        echo ""
        DB_PASSWORD="$db_pass"
    fi

    # Confirm configuration
    echo ""
    print_step "Configuration Summary:"
    echo "  Project Name:    $PROJECT_NAME"
    echo "  Backend Port:    $BACKEND_PORT"
    echo "  Frontend Port:   $FRONTEND_PORT"
    echo "  Database Name:   $DB_NAME"
    echo "  Database User:   $DB_USER"
    echo "  Database Host:   $DB_HOST:$DB_PORT"
    echo "  Backend Path:    $BACKEND_DIR"
    echo "  Frontend Path:   $FRONTEND_DIR"
    echo ""
    echo -n "Proceed with setup? [Y/n]: "
    read confirm

    if [[ "$confirm" =~ ^[Nn] ]]; then
        print_warning "Setup cancelled by user"
        exit 0
    fi
}

# =============================================================================
# BACKEND SETUP
# =============================================================================

create_backend() {
    print_header "CREATING BACKEND (Apso + BetterAuth)"

    # Check if backend already exists
    if [ -d "$BACKEND_DIR" ]; then
        print_warning "Backend directory already exists at: $BACKEND_DIR"
        echo -n "Do you want to recreate it? This will DELETE existing files. [y/N]: "
        read recreate
        if [[ "$recreate" =~ ^[Yy] ]]; then
            print_warning "Removing existing backend..."
            rm -rf "$BACKEND_DIR"
        else
            print_info "Skipping backend creation"
            return 0
        fi
    fi

    print_step "Creating backend with Apso CLI..."

    # Check if we're already in a directory with Apso CLI available
    if [ -f "$PROJECT_ROOT/backend/node_modules/.bin/apso" ]; then
        APSO_CMD="$PROJECT_ROOT/backend/node_modules/.bin/apso"
    elif check_command apso; then
        APSO_CMD="apso"
    else
        print_error "Apso CLI not found. Please install it first:"
        echo "  npm install -g @apso/cli"
        exit 1
    fi

    # Create backend directory
    mkdir -p "$BACKEND_DIR"
    echo "$BACKEND_DIR" >> "$CLEANUP_FILE"

    # Initialize Apso project (if not already initialized)
    cd "$BACKEND_DIR"

    if [ ! -f "package.json" ]; then
        print_info "Initializing NestJS project..."

        # Create package.json
        cat > package.json << EOF
{
  "name": "${PROJECT_NAME}-backend",
  "version": "0.0.1",
  "description": "Backend for $PROJECT_NAME using Apso + BetterAuth",
  "author": "",
  "private": true,
  "license": "MIT",
  "scripts": {
    "build": "nest build",
    "format": "prettier --write \\"src/**/*.ts\\" \\"test/**/*.ts\\"",
    "start": "nest start",
    "start:dev": "nest start --watch",
    "start:debug": "nest start --debug --watch",
    "start:prod": "node dist/main",
    "lint": "eslint \\"{src,apps,libs,test}/**/*.ts\\" --fix",
    "test": "jest",
    "test:watch": "jest --watch",
    "test:cov": "jest --coverage",
    "test:debug": "node --inspect-brk -r tsconfig-paths/register -r ts-node/register node_modules/.bin/jest --runInBand",
    "test:e2e": "jest --config ./test/jest-e2e.json",
    "typeorm": "typeorm-ts-node-commonjs",
    "migration:generate": "npm run typeorm -- migration:generate -d src/config/typeorm.config.ts",
    "migration:run": "npm run typeorm -- migration:run -d src/config/typeorm.config.ts",
    "migration:revert": "npm run typeorm -- migration:revert -d src/config/typeorm.config.ts"
  },
  "dependencies": {
    "@nestjs/common": "^10.0.0",
    "@nestjs/core": "^10.0.0",
    "@nestjs/platform-express": "^10.0.0",
    "@nestjs/typeorm": "^10.0.0",
    "@nestjs/config": "^3.0.0",
    "typeorm": "^0.3.17",
    "pg": "^8.11.0",
    "better-auth": "^1.0.0",
    "reflect-metadata": "^0.1.13",
    "rxjs": "^7.8.1",
    "class-validator": "^0.14.0",
    "class-transformer": "^0.5.1"
  },
  "devDependencies": {
    "@nestjs/cli": "^10.0.0",
    "@nestjs/schematics": "^10.0.0",
    "@nestjs/testing": "^10.0.0",
    "@types/express": "^4.17.17",
    "@types/jest": "^29.5.2",
    "@types/node": "^20.3.1",
    "@types/supertest": "^2.0.12",
    "@typescript-eslint/eslint-plugin": "^6.0.0",
    "@typescript-eslint/parser": "^6.0.0",
    "eslint": "^8.42.0",
    "eslint-config-prettier": "^9.0.0",
    "eslint-plugin-prettier": "^5.0.0",
    "jest": "^29.5.0",
    "prettier": "^3.0.0",
    "source-map-support": "^0.5.21",
    "supertest": "^6.3.3",
    "ts-jest": "^29.1.0",
    "ts-loader": "^9.4.3",
    "ts-node": "^10.9.1",
    "tsconfig-paths": "^4.2.0",
    "typescript": "^5.1.3"
  },
  "jest": {
    "moduleFileExtensions": [
      "js",
      "json",
      "ts"
    ],
    "rootDir": "src",
    "testRegex": ".*\\\\.spec\\\\.ts$",
    "transform": {
      "^.+\\\\.(t|j)s$": "ts-jest"
    },
    "collectCoverageFrom": [
      "**/*.(t|j)s"
    ],
    "coverageDirectory": "../coverage",
    "testEnvironment": "node"
  }
}
EOF
    fi

    # Install dependencies
    if [ "$SKIP_INSTALL" = false ]; then
        print_step "Installing backend dependencies..."
        npm install > /tmp/backend-install.log 2>&1 &
        spinner $! "Installing packages"
        if [ $? -ne 0 ]; then
            print_error "Failed to install backend dependencies. Check /tmp/backend-install.log"
            exit 1
        fi
    fi

    # Create directory structure
    print_step "Creating backend directory structure..."
    mkdir -p src/{config,auth,modules,common/{guards,decorators,filters,interceptors}}

    # Create TypeORM configuration
    cat > src/config/typeorm.config.ts << 'EOF'
import { DataSource, DataSourceOptions } from 'typeorm';
import { config } from 'dotenv';

config();

export const dataSourceOptions: DataSourceOptions = {
  type: 'postgres',
  host: process.env.DB_HOST || 'localhost',
  port: parseInt(process.env.DB_PORT || '5432'),
  username: process.env.DB_USER || 'postgres',
  password: process.env.DB_PASSWORD || '',
  database: process.env.DB_NAME || 'dev',
  entities: ['dist/**/*.entity.js'],
  migrations: ['dist/migrations/*.js'],
  synchronize: false,
  logging: process.env.NODE_ENV === 'development',
};

const dataSource = new DataSource(dataSourceOptions);
export default dataSource;
EOF

    # Create BetterAuth configuration
    cat > src/auth/auth.config.ts << 'EOF'
import { betterAuth } from 'better-auth';
import { DataSource } from 'typeorm';

export const createAuthConfig = (dataSource: DataSource) => {
  return betterAuth({
    database: {
      type: 'postgres',
      connection: dataSource.manager.connection,
    },
    emailAndPassword: {
      enabled: true,
      requireEmailVerification: true,
    },
    socialProviders: {
      google: {
        clientId: process.env.GOOGLE_CLIENT_ID || '',
        clientSecret: process.env.GOOGLE_CLIENT_SECRET || '',
        enabled: !!process.env.GOOGLE_CLIENT_ID,
      },
      github: {
        clientId: process.env.GITHUB_CLIENT_ID || '',
        clientSecret: process.env.GITHUB_CLIENT_SECRET || '',
        enabled: !!process.env.GITHUB_CLIENT_ID,
      },
    },
    session: {
      expiresIn: 60 * 60 * 24 * 7, // 7 days
      updateAge: 60 * 60 * 24, // 1 day
    },
  });
};
EOF

    # Create auth module
    cat > src/auth/auth.module.ts << 'EOF'
import { Module } from '@nestjs/common';
import { AuthService } from './auth.service';
import { AuthController } from './auth.controller';

@Module({
  controllers: [AuthController],
  providers: [AuthService],
  exports: [AuthService],
})
export class AuthModule {}
EOF

    # Create auth service
    cat > src/auth/auth.service.ts << 'EOF'
import { Injectable } from '@nestjs/common';
import { InjectDataSource } from '@nestjs/typeorm';
import { DataSource } from 'typeorm';
import { createAuthConfig } from './auth.config';

@Injectable()
export class AuthService {
  private auth: ReturnType<typeof createAuthConfig>;

  constructor(@InjectDataSource() private dataSource: DataSource) {
    this.auth = createAuthConfig(dataSource);
  }

  getAuth() {
    return this.auth;
  }
}
EOF

    # Create auth controller
    cat > src/auth/auth.controller.ts << 'EOF'
import { All, Controller, Req, Res } from '@nestjs/common';
import { Request, Response } from 'express';
import { AuthService } from './auth.service';

@Controller('api/auth')
export class AuthController {
  constructor(private readonly authService: AuthService) {}

  @All('*')
  async handleAuth(@Req() req: Request, @Res() res: Response) {
    const auth = this.authService.getAuth();
    return auth.handler(req, res);
  }
}
EOF

    # Create main.ts
    cat > src/main.ts << EOF
import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { ValidationPipe } from '@nestjs/common';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);

  // Enable CORS
  app.enableCors({
    origin: process.env.FRONTEND_URL || 'http://localhost:${FRONTEND_PORT}',
    credentials: true,
  });

  // Enable validation
  app.useGlobalPipes(new ValidationPipe({
    whitelist: true,
    transform: true,
  }));

  // Start server
  const port = process.env.PORT || ${BACKEND_PORT};
  await app.listen(port);
  console.log(\`Backend running on http://localhost:\${port}\`);
}

bootstrap();
EOF

    # Create app.module.ts
    cat > src/app.module.ts << 'EOF'
import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { TypeOrmModule } from '@nestjs/typeorm';
import { dataSourceOptions } from './config/typeorm.config';
import { AuthModule } from './auth/auth.module';

@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
    }),
    TypeOrmModule.forRoot(dataSourceOptions),
    AuthModule,
  ],
})
export class AppModule {}
EOF

    # Create tsconfig.json
    cat > tsconfig.json << 'EOF'
{
  "compilerOptions": {
    "module": "commonjs",
    "declaration": true,
    "removeComments": true,
    "emitDecoratorMetadata": true,
    "experimentalDecorators": true,
    "allowSyntheticDefaultImports": true,
    "target": "ES2021",
    "sourceMap": true,
    "outDir": "./dist",
    "baseUrl": "./",
    "incremental": true,
    "skipLibCheck": true,
    "strictNullChecks": false,
    "noImplicitAny": false,
    "strictBindCallApply": false,
    "forceConsistentCasingInFileNames": false,
    "noFallthroughCasesInSwitch": false
  }
}
EOF

    # Create nest-cli.json
    cat > nest-cli.json << 'EOF'
{
  "$schema": "https://json.schemastore.org/nest-cli",
  "collection": "@nestjs/schematics",
  "sourceRoot": "src",
  "compilerOptions": {
    "deleteOutDir": true
  }
}
EOF

    print_success "Backend created successfully"
}

# =============================================================================
# FRONTEND SETUP
# =============================================================================

create_frontend() {
    print_header "CREATING FRONTEND (Next.js + BetterAuth)"

    # Check if frontend already exists
    if [ -d "$FRONTEND_DIR" ]; then
        print_warning "Frontend directory already exists at: $FRONTEND_DIR"
        echo -n "Do you want to recreate it? This will DELETE existing files. [y/N]: "
        read recreate
        if [[ "$recreate" =~ ^[Yy] ]]; then
            print_warning "Removing existing frontend..."
            rm -rf "$FRONTEND_DIR"
        else
            print_info "Skipping frontend creation"
            return 0
        fi
    fi

    print_step "Creating Next.js application..."

    # Create frontend with Next.js
    cd "$PROJECT_ROOT"

    # Create Next.js app non-interactively
    npx create-next-app@latest "$FRONTEND_DIR" \
        --typescript \
        --tailwind \
        --app \
        --no-src-dir \
        --import-alias "@/*" \
        --eslint > /tmp/frontend-create.log 2>&1 &

    spinner $! "Creating Next.js app"
    if [ $? -ne 0 ]; then
        print_error "Failed to create frontend. Check /tmp/frontend-create.log"
        exit 1
    fi

    echo "$FRONTEND_DIR" >> "$CLEANUP_FILE"

    cd "$FRONTEND_DIR"

    # Install BetterAuth client
    if [ "$SKIP_INSTALL" = false ]; then
        print_step "Installing BetterAuth client..."
        npm install better-auth > /tmp/frontend-better-auth.log 2>&1 &
        spinner $! "Installing better-auth"
        if [ $? -ne 0 ]; then
            print_error "Failed to install better-auth. Check /tmp/frontend-better-auth.log"
            exit 1
        fi
    fi

    # Create lib directory for auth client
    mkdir -p lib

    # Create BetterAuth client
    cat > lib/auth-client.ts << EOF
import { createAuthClient } from 'better-auth/client';

export const authClient = createAuthClient({
  baseURL: process.env.NEXT_PUBLIC_API_URL || 'http://localhost:${BACKEND_PORT}',
});

export const {
  signIn,
  signUp,
  signOut,
  useSession,
} = authClient;
EOF

    # Create auth API route
    mkdir -p app/api/auth/[...all]
    cat > app/api/auth/[...all]/route.ts << 'EOF'
import { authClient } from '@/lib/auth-client';

export const { GET, POST } = authClient.handler();
EOF

    # Create a simple login page
    cat > app/login/page.tsx << 'EOF'
'use client';

import { useState } from 'react';
import { useRouter } from 'next/navigation';
import { signIn, signUp } from '@/lib/auth-client';

export default function LoginPage() {
  const router = useRouter();
  const [isSignUp, setIsSignUp] = useState(false);
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [name, setName] = useState('');
  const [error, setError] = useState('');
  const [loading, setLoading] = useState(false);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setError('');
    setLoading(true);

    try {
      if (isSignUp) {
        await signUp.email({
          email,
          password,
          name,
        });
      } else {
        await signIn.email({
          email,
          password,
        });
      }
      router.push('/');
    } catch (err: any) {
      setError(err.message || 'Authentication failed');
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="min-h-screen flex items-center justify-center bg-gray-50">
      <div className="max-w-md w-full space-y-8 p-8 bg-white rounded-lg shadow">
        <div>
          <h2 className="text-3xl font-bold text-center">
            {isSignUp ? 'Create Account' : 'Sign In'}
          </h2>
        </div>

        <form className="mt-8 space-y-6" onSubmit={handleSubmit}>
          {error && (
            <div className="bg-red-50 text-red-500 p-3 rounded">
              {error}
            </div>
          )}

          {isSignUp && (
            <div>
              <label htmlFor="name" className="block text-sm font-medium">
                Name
              </label>
              <input
                id="name"
                type="text"
                required={isSignUp}
                value={name}
                onChange={(e) => setName(e.target.value)}
                className="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md"
              />
            </div>
          )}

          <div>
            <label htmlFor="email" className="block text-sm font-medium">
              Email
            </label>
            <input
              id="email"
              type="email"
              required
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              className="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md"
            />
          </div>

          <div>
            <label htmlFor="password" className="block text-sm font-medium">
              Password
            </label>
            <input
              id="password"
              type="password"
              required
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              className="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md"
            />
          </div>

          <button
            type="submit"
            disabled={loading}
            className="w-full py-2 px-4 bg-blue-600 hover:bg-blue-700 text-white rounded-md disabled:opacity-50"
          >
            {loading ? 'Loading...' : (isSignUp ? 'Sign Up' : 'Sign In')}
          </button>

          <div className="text-center">
            <button
              type="button"
              onClick={() => setIsSignUp(!isSignUp)}
              className="text-blue-600 hover:text-blue-700"
            >
              {isSignUp ? 'Already have an account? Sign in' : "Don't have an account? Sign up"}
            </button>
          </div>
        </form>
      </div>
    </div>
  );
}
EOF

    # Update home page to show session
    cat > app/page.tsx << 'EOF'
'use client';

import { useSession, signOut } from '@/lib/auth-client';
import { useRouter } from 'next/navigation';

export default function Home() {
  const { data: session, isLoading } = useSession();
  const router = useRouter();

  if (isLoading) {
    return (
      <div className="min-h-screen flex items-center justify-center">
        <p>Loading...</p>
      </div>
    );
  }

  if (!session) {
    router.push('/login');
    return null;
  }

  return (
    <div className="min-h-screen p-8">
      <div className="max-w-4xl mx-auto">
        <div className="flex justify-between items-center mb-8">
          <h1 className="text-3xl font-bold">Welcome!</h1>
          <button
            onClick={() => signOut()}
            className="px-4 py-2 bg-red-600 hover:bg-red-700 text-white rounded-md"
          >
            Sign Out
          </button>
        </div>

        <div className="bg-white p-6 rounded-lg shadow">
          <h2 className="text-xl font-semibold mb-4">Session Info</h2>
          <pre className="bg-gray-50 p-4 rounded overflow-x-auto">
            {JSON.stringify(session, null, 2)}
          </pre>
        </div>
      </div>
    </div>
  );
}
EOF

    print_success "Frontend created successfully"
}

# =============================================================================
# ENVIRONMENT CONFIGURATION
# =============================================================================

configure_env() {
    print_header "CONFIGURING ENVIRONMENT VARIABLES"

    # Generate random secrets
    print_step "Generating secure secrets..."
    JWT_SECRET=$(openssl rand -base64 32 2>/dev/null || head -c 32 /dev/urandom | base64)
    AUTH_SECRET=$(openssl rand -base64 32 2>/dev/null || head -c 32 /dev/urandom | base64)

    # Backend .env
    print_step "Creating backend .env file..."
    cat > "$BACKEND_DIR/.env" << EOF
# Database Configuration
DB_HOST=${DB_HOST}
DB_PORT=${DB_PORT}
DB_USER=${DB_USER}
DB_PASSWORD=${DB_PASSWORD}
DB_NAME=${DB_NAME}

# Server Configuration
PORT=${BACKEND_PORT}
NODE_ENV=development
FRONTEND_URL=http://localhost:${FRONTEND_PORT}

# Authentication
JWT_SECRET=${JWT_SECRET}
AUTH_SECRET=${AUTH_SECRET}

# OAuth Providers (optional - add your credentials)
# GOOGLE_CLIENT_ID=your-google-client-id
# GOOGLE_CLIENT_SECRET=your-google-client-secret
# GITHUB_CLIENT_ID=your-github-client-id
# GITHUB_CLIENT_SECRET=your-github-client-secret

# Email Configuration (optional - for email verification)
# SMTP_HOST=smtp.example.com
# SMTP_PORT=587
# SMTP_USER=your-email@example.com
# SMTP_PASSWORD=your-password
# SMTP_FROM=noreply@example.com
EOF

    # Frontend .env.local
    print_step "Creating frontend .env.local file..."
    cat > "$FRONTEND_DIR/.env.local" << EOF
# API Configuration
NEXT_PUBLIC_API_URL=http://localhost:${BACKEND_PORT}

# Authentication
BETTER_AUTH_SECRET=${AUTH_SECRET}
BETTER_AUTH_URL=http://localhost:${FRONTEND_PORT}
EOF

    print_success "Environment variables configured"
}

# =============================================================================
# DATABASE INITIALIZATION
# =============================================================================

init_database() {
    if [ "$SKIP_DB" = true ]; then
        print_warning "Skipping database initialization"
        return 0
    fi

    print_header "INITIALIZING DATABASE"

    # Check if database exists
    print_step "Checking database existence..."

    if PGPASSWORD="$DB_PASSWORD" psql -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -lqt 2>/dev/null | cut -d \| -f 1 | grep -qw "$DB_NAME"; then
        print_warning "Database '$DB_NAME' already exists"
        echo -n "Drop and recreate? This will DELETE all data. [y/N]: "
        read drop_db
        if [[ "$drop_db" =~ ^[Yy] ]]; then
            print_step "Dropping existing database..."
            PGPASSWORD="$DB_PASSWORD" psql -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -c "DROP DATABASE IF EXISTS \"$DB_NAME\";" 2>&1 | tee /tmp/db-drop.log
            if [ ${PIPESTATUS[0]} -ne 0 ]; then
                print_error "Failed to drop database. Check /tmp/db-drop.log"
                exit 1
            fi
        else
            print_info "Keeping existing database"
            return 0
        fi
    fi

    # Create database
    print_step "Creating database '$DB_NAME'..."
    PGPASSWORD="$DB_PASSWORD" psql -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -c "CREATE DATABASE \"$DB_NAME\";" 2>&1 | tee /tmp/db-create.log
    if [ ${PIPESTATUS[0]} -ne 0 ]; then
        print_error "Failed to create database. Check /tmp/db-create.log"
        exit 1
    fi

    print_success "Database created successfully"

    # Run migrations
    print_step "Running database migrations..."
    cd "$BACKEND_DIR"

    # Build the backend first
    npm run build > /tmp/backend-build.log 2>&1 &
    spinner $! "Building backend"
    if [ $? -ne 0 ]; then
        print_warning "Backend build had warnings (this may be okay). Check /tmp/backend-build.log"
    fi

    # Run TypeORM migrations
    print_info "Running TypeORM migrations..."
    npm run migration:run > /tmp/migration-run.log 2>&1
    if [ $? -ne 0 ]; then
        print_warning "Migrations had warnings (this may be okay if no migrations exist yet)"
    fi

    print_success "Database initialized"
}

# =============================================================================
# START SERVICES
# =============================================================================

start_services() {
    print_header "STARTING DEVELOPMENT SERVERS"

    print_step "Starting backend server..."
    cd "$BACKEND_DIR"

    # Start backend in background
    npm run start:dev > /tmp/backend-dev.log 2>&1 &
    BACKEND_PID=$!
    echo "Backend PID: $BACKEND_PID" > /tmp/apso-services.pid

    print_info "Backend starting (PID: $BACKEND_PID)..."
    sleep 3

    # Check if backend is still running
    if ! kill -0 $BACKEND_PID 2>/dev/null; then
        print_error "Backend failed to start. Check /tmp/backend-dev.log"
        exit 1
    fi

    print_step "Starting frontend server..."
    cd "$FRONTEND_DIR"

    # Start frontend in background
    npm run dev > /tmp/frontend-dev.log 2>&1 &
    FRONTEND_PID=$!
    echo "Frontend PID: $FRONTEND_PID" >> /tmp/apso-services.pid

    print_info "Frontend starting (PID: $FRONTEND_PID)..."
    sleep 3

    # Check if frontend is still running
    if ! kill -0 $FRONTEND_PID 2>/dev/null; then
        print_error "Frontend failed to start. Check /tmp/frontend-dev.log"
        kill $BACKEND_PID 2>/dev/null
        exit 1
    fi

    print_success "Both servers started successfully"

    # Save PIDs for later reference
    cat > "$PROJECT_ROOT/dev-servers.pid" << EOF
BACKEND_PID=$BACKEND_PID
FRONTEND_PID=$FRONTEND_PID
EOF
}

# =============================================================================
# VERIFICATION
# =============================================================================

verify_setup() {
    print_header "VERIFYING SETUP"

    print_step "Waiting for services to be ready..."
    sleep 5

    # Check backend health
    print_step "Checking backend health..."
    local backend_url="http://localhost:${BACKEND_PORT}"

    if curl -s -o /dev/null -w "%{http_code}" "$backend_url" | grep -q "200\|404"; then
        print_success "Backend is responding at $backend_url"
    else
        print_warning "Backend may not be fully ready yet (this is normal)"
    fi

    # Check frontend health
    print_step "Checking frontend health..."
    local frontend_url="http://localhost:${FRONTEND_PORT}"

    if curl -s -o /dev/null -w "%{http_code}" "$frontend_url" | grep -q "200"; then
        print_success "Frontend is responding at $frontend_url"
    else
        print_warning "Frontend may not be fully ready yet (this is normal)"
    fi

    # Check database connection
    print_step "Checking database connection..."
    if PGPASSWORD="$DB_PASSWORD" psql -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -d "$DB_NAME" -c '\q' 2>/dev/null; then
        print_success "Database connection successful"
    else
        print_warning "Database connection check failed"
    fi

    print_success "Setup verification complete"
}

# =============================================================================
# FINAL SUMMARY
# =============================================================================

print_summary() {
    print_header "SETUP COMPLETE!"

    echo ""
    echo -e "${GREEN}${BOLD}Your Apso + BetterAuth application is ready!${NC}"
    echo ""
    echo -e "${BOLD}Access your application:${NC}"
    echo -e "  Frontend:  ${CYAN}http://localhost:${FRONTEND_PORT}${NC}"
    echo -e "  Backend:   ${CYAN}http://localhost:${BACKEND_PORT}${NC}"
    echo -e "  API Docs:  ${CYAN}http://localhost:${BACKEND_PORT}/api${NC}"
    echo ""
    echo -e "${BOLD}Database:${NC}"
    echo -e "  Name:      ${CYAN}${DB_NAME}${NC}"
    echo -e "  Host:      ${CYAN}${DB_HOST}:${DB_PORT}${NC}"
    echo -e "  User:      ${CYAN}${DB_USER}${NC}"
    echo ""
    echo -e "${BOLD}Next steps:${NC}"
    echo "  1. Open your browser to http://localhost:${FRONTEND_PORT}"
    echo "  2. Create an account using the sign-up form"
    echo "  3. Start building your application!"
    echo ""
    echo -e "${BOLD}Useful commands:${NC}"
    echo "  Stop servers:      ./scripts/stop-servers.sh"
    echo "  View backend logs: tail -f /tmp/backend-dev.log"
    echo "  View frontend logs: tail -f /tmp/frontend-dev.log"
    echo "  Run verification:  ./scripts/verify-setup.sh"
    echo ""
    echo -e "${BOLD}File locations:${NC}"
    echo -e "  Backend:   ${CYAN}${BACKEND_DIR}${NC}"
    echo -e "  Frontend:  ${CYAN}${FRONTEND_DIR}${NC}"
    echo ""

    # Show process information
    if [ -f "$PROJECT_ROOT/dev-servers.pid" ]; then
        source "$PROJECT_ROOT/dev-servers.pid"
        echo -e "${BOLD}Running processes:${NC}"
        echo -e "  Backend PID:  ${CYAN}${BACKEND_PID}${NC}"
        echo -e "  Frontend PID: ${CYAN}${FRONTEND_PID}${NC}"
        echo ""
    fi

    print_success "Happy coding!"
}

# =============================================================================
# MAIN EXECUTION
# =============================================================================

main() {
    clear

    print_header "APSO + BETTERAUTH SETUP"
    echo -e "${BOLD}Complete full-stack setup in 5 minutes${NC}\n"

    # Parse command line arguments
    parse_args "$@"

    # Run setup steps
    check_prerequisites
    prompt_config
    create_backend
    create_frontend
    configure_env
    init_database
    start_services
    verify_setup
    print_summary

    # Clean up temporary files
    rm -f "$CLEANUP_FILE"
}

# Run main function
main "$@"
