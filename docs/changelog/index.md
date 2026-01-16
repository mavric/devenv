# Changelog

Release history for Mavric DevEnv.

---

## Version History

| Version | Date | Highlights |
|---------|------|------------|
| [v1.1](v1.1.md) | November 2025 | Discovery-first development, BDD testing |
| [v1.0](v1.0.md) | November 2025 | Initial skills system |

---

## Release Philosophy

DevEnv follows semantic versioning with a focus on **methodology evolution**:

- **Major versions** (2.0, 3.0): Significant changes to the development workflow
- **Minor versions** (1.1, 1.2): New skills, capabilities, or workflow enhancements
- **Patches**: Bug fixes and documentation updates

---

## What's in a Release

Each release may include:

- **New Skills**: Specialized AI modules for specific tasks
- **New Commands**: Slash commands for quick access to workflows
- **Methodology Updates**: Changes to the development process
- **Standards Updates**: New or updated architectural patterns
- **Documentation**: Guides, references, and examples

---

## Upgrade Notes

When upgrading DevEnv, re-run the install command from your project directory:

```bash
curl -fsSL https://raw.githubusercontent.com/mavric/devenv/main/install.sh | bash
```

The installer will:

1. Update skills in your `.claude/skills/` directory
2. Update commands in `.claude/commands/`
3. Update `.devenv/` standards and documentation
4. Preserve your project files and customizations

---

## Contributing

Found an issue or have a suggestion? [Open an issue](https://github.com/mavric/devenv/issues) on GitHub.
