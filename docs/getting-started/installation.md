# Installation

Complete installation guide for Mavric AI Toolchain.

---

## System Requirements

| Requirement | Minimum | Recommended |
|-------------|---------|-------------|
| **Claude Code** | Latest | Latest |
| Node.js | 18.0.0 | 20.x LTS |
| npm | 9.0.0 | 10.x |
| PostgreSQL | 13.0 | 16.x |
| Memory | 4GB | 8GB+ |
| Disk | 2GB | 10GB+ |

!!! info "Claude Code is Required"
    Mavric AI Toolchain runs entirely through **Claude Code**, Anthropic's AI-powered development CLI. All toolchain commands, skills, and workflows are executed within Claude Code sessions.

---

## Step 1: Install Claude Code

Claude Code is the foundation of the Mavric AI Toolchain. Install it globally:

```bash
npm install -g @anthropic-ai/claude-code
```

Then authenticate with your Anthropic account:

```bash
claude login
```

Verify installation:

```bash
claude --version
```

---

## Step 2: Install System Prerequisites

=== "macOS"

    ```bash
    # Install Homebrew if not present
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Install Node.js and PostgreSQL
    brew install node postgresql

    # Start PostgreSQL
    brew services start postgresql
    ```

=== "Ubuntu/Debian"

    ```bash
    # Update package list
    sudo apt-get update

    # Install Node.js (via NodeSource)
    curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
    sudo apt-get install -y nodejs

    # Install PostgreSQL
    sudo apt-get install -y postgresql postgresql-client

    # Start PostgreSQL
    sudo systemctl start postgresql
    sudo systemctl enable postgresql
    ```

=== "Windows (WSL2)"

    ```bash
    # In WSL2 Ubuntu terminal
    sudo apt-get update

    # Install Node.js
    curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
    sudo apt-get install -y nodejs

    # Install PostgreSQL
    sudo apt-get install -y postgresql postgresql-client

    # Start PostgreSQL
    sudo service postgresql start
    ```

---

## Step 3: Create Your Project

Create a new folder for your project and copy the Mavric toolchain into it:

```bash
# Create your project folder
mkdir my-saas-project
cd my-saas-project

# Copy the toolchain (without git history)
npx degit mavric/devenv/install .

# Initialize your own git repo
git init
git add .
git commit -m "Initial commit: Mavric toolchain setup"
```

!!! info "Your Project, Your Repo"
    This copies the toolchain files into your project without the devenv git history. You get a clean starting point with your own repository.

**Alternative (without npx):**

```bash
mkdir my-saas-project
cd my-saas-project
git clone --depth 1 https://github.com/mavric/devenv.git temp
mv temp/install/* temp/install/.* . 2>/dev/null
rm -rf temp
git init
```

---

## Step 4: Verify Installation

```bash
# Check all prerequisites
claude --version   # Claude Code installed
node --version     # v18.x.x or higher
npm --version      # 9.x.x or higher
psql --version     # 13.x or higher
pg_isready         # Should show "accepting connections"
```

---

## Step 5: Start Using the Toolchain

Launch Claude Code in the toolchain directory:

```bash
claude
```

Claude Code will automatically detect the `.claude/` configuration and load all available skills and commands.

### Test the Installation

In Claude Code, try:

```
What skills do you have available?
```

You should see skills like:

- `saas-project-orchestrator`
- `discovery-interviewer`
- `backend-bootstrapper`
- `schema-architect`
- `test-generator`

---

## Directory Structure

After installation, your project will have:

```
my-saas-project/
├── .claude/                 # Claude Code configuration
│   ├── commands/            # Slash commands (/start-project)
│   ├── skills/              # AI skill modules
│   └── templates/           # Document templates
├── .devenv/                 # Development environment
│   ├── setup/
│   │   ├── scripts/         # Setup automation
│   │   └── templates/       # .apsorc schema templates
│   └── docs/                # Reference documentation
└── [your project files]     # Generated as you build
```

---

## Adding to an Existing Project

To add Mavric AI Toolchain to an existing project:

```bash
cd /path/to/your/project

# Copy toolchain into your project
npx degit mavric/devenv/install .
```

Or manually:

```bash
# Copy .claude folder (skills and commands)
cp -r /path/to/devenv/install/.claude /path/to/your/project/

# Copy .devenv folder (standards and templates)
cp -r /path/to/devenv/install/.devenv /path/to/your/project/
```

Then launch Claude Code in your project:

```bash
cd /path/to/your/project
claude
```

---

## Contributing to the Toolchain

If you want to contribute to Mavric AI Toolchain:

```bash
# Clone with full history
git clone https://github.com/mavric/devenv.git
cd devenv

# Install documentation dependencies (for local preview)
pip install -r requirements-docs.txt

# Preview documentation locally
mkdocs serve
# Opens at http://127.0.0.1:8000
```

---

## Updating

To update to the latest toolchain version:

```bash
# From your project directory
cd my-saas-project

# Pull latest toolchain files (preserves your customizations)
npx degit mavric/devenv/install/.claude .claude --force
npx degit mavric/devenv/install/.devenv .devenv --force
```

!!! tip "What Gets Updated"
    Only the toolchain configuration (`.claude/` and `.devenv/`) is updated. Your project code, schemas, and customizations remain untouched.

---

## Uninstalling

To remove Mavric AI Toolchain:

```bash
# Remove the devenv directory
rm -rf devenv

# Projects you created remain intact
# Only the toolchain configuration is removed
```

To uninstall Claude Code:

```bash
npm uninstall -g @anthropic-ai/claude-code
```

---

## Next Steps

- [Quick Start Guide](quickstart.md) - Get running in 5 minutes
- [Your First Project](first-project.md) - Build something real
- [Core Concepts](../concepts/overview.md) - Understand the methodology
