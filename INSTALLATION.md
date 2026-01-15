# Installation Guide

Install the Mavric DevEnv skills for Claude Code in your project.

## Quick Install (Recommended)

Run this in your project directory:

```bash
curl -fsSL https://raw.githubusercontent.com/mavric/devenv/main/install.sh | bash
```

That's it! The installer will add:
- `.claude/` - AI skills and commands
- `.devenv/` - Development standards and references

## Alternative Methods

### Option 2: Clone and Copy

```bash
# Clone the repo
git clone --depth 1 https://github.com/mavric/devenv.git /tmp/devenv

# Copy to your project
cp -r /tmp/devenv/install/.claude .
cp -r /tmp/devenv/install/.devenv .

# Cleanup
rm -rf /tmp/devenv
```

### Option 3: Git Submodule (for version control)

If you want to track updates and keep the skills under version control:

```bash
# Add as submodule
git submodule add https://github.com/mavric/devenv.git .devenv-source

# Create symlinks
ln -s .devenv-source/install/.claude .claude
ln -s .devenv-source/install/.devenv .devenv
```

To update:
```bash
git submodule update --remote
```

### Option 4: Direct Download

Download the install folder directly:

```bash
# Download and extract just the install folder
curl -L https://github.com/mavric/devenv/archive/refs/heads/main.tar.gz | tar -xz --strip-components=2 devenv-main/install
```

## Verify Installation

After installing, check that the directories exist:

```bash
ls -la .claude .devenv
```

You should see:
```
.claude/
  commands/      # Slash commands (/start-project, etc.)
  skills/        # AI skills (discovery-interviewer, etc.)
  templates/     # Prompt templates

.devenv/
  docs/          # Reference documentation
  standards/     # Development standards
  setup/         # Setup scripts and templates
```

## What Gets Installed

### `.claude/` - AI Skills and Commands

| Component | Description |
|-----------|-------------|
| `skills/discovery-interviewer` | 90-minute structured requirements interview |
| `skills/schema-architect` | Database schema design from requirements |
| `skills/backend-bootstrapper` | Apso/NestJS backend setup |
| `skills/auth-bootstrapper` | BetterAuth integration |
| `skills/test-generator` | BDD/Gherkin test generation |
| `skills/feature-builder` | Full-stack feature implementation |
| `skills/product-brief-writer` | PRD generation |
| `commands/start-project` | Start new project workflow |
| `commands/discovery-only` | Run discovery interview only |

### `.devenv/` - Standards and References

| Component | Description |
|-----------|-------------|
| `standards/saas/` | SaaS patterns and templates |
| `standards/apso/` | Apso schema guide |
| `standards/foundations/` | Development methodology |
| `standards/rules/` | Claude Code enforcement rules |
| `docs/` | Reference documentation |
| `setup/` | Setup scripts and config templates |

## Getting Started

1. **Open Claude Code** in your project directory
2. **Say:** "I want to build a SaaS for [your idea]"

The AI will guide you through:
- Discovery interview (90 min)
- Requirements extraction
- Schema design
- Backend setup
- Feature implementation

## Available Commands

| Command | Description |
|---------|-------------|
| `/start-project` | Full project setup with discovery |
| `/discovery-only` | Run discovery interview only |
| `/schema` | Design database schema |
| `/tests` | Generate BDD tests |
| `/verify` | Verify project setup |

## Updating

To update to the latest version, re-run the install command:

```bash
curl -fsSL https://raw.githubusercontent.com/mavric/devenv/main/install.sh | bash
```

The installer will prompt before overwriting existing files.

## Uninstalling

To remove the skills:

```bash
rm -rf .claude .devenv
```

## Troubleshooting

### "Permission denied"

Make sure you have write access to the target directory:
```bash
ls -la .
```

### "git not found"

Install git first:
- macOS: `xcode-select --install`
- Ubuntu: `sudo apt install git`
- Windows: Download from https://git-scm.com

### Skills not working in Claude Code

1. Make sure you're in the project root directory
2. Restart Claude Code
3. Check that `.claude/skills/` exists and has content

## Support

- Documentation: https://mavric.github.io/devenv
- Issues: https://github.com/mavric/devenv/issues
