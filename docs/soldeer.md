# Soldeer

## Overview

Soldeer is a package manager for Solidity built in Rust and integrated into Foundry.

- **Language**: Rust
- **Runtime**: Native binary / Foundry integration
- **Registry**: [soldeer.xyz](https://soldeer.xyz)
- **Repository**: [github.com/mario-eth/soldeer](https://github.com/mario-eth/soldeer)

### Why Soldeer?

As Solidity development became more complex, existing dependency management methods had limitations:

- Git submodules are not a good solution for managing dependencies
- npmjs was built for the JS ecosystem, not for Solidity
- GitHub versioning of releases is painful and not all projects use it correctly

## Installation

### Foundry Integration (Recommended)

Soldeer is already integrated into Foundry. No additional installation required:

```bash
# Check version
forge soldeer version

# Help
forge soldeer --help
```

### Standalone

```bash
# Install via Cargo
cargo install soldeer

# Verify
soldeer help
```

## Project Structure

```
├── foundry.toml        # Configuration (with [dependencies])
├── soldeer.lock        # Lockfile (SHA-256 hashes)
├── dependencies/       # Installed packages
│   ├── @openzeppelin-contracts-5.0.2/
│   ├── forge-std-1.8.1/
│   └── ...
├── src/                # Solidity contracts
└── test/               # Tests
```

## Configuration

`foundry.toml`:

```toml
[profile.default]
src = "src"
out = "out"
libs = ["dependencies"]  # Important: use "dependencies" not "lib"

[dependencies]
"@openzeppelin-contracts" = { version = "5.0.2" }
"@uniswap-universal-router" = { version = "1.6.0" }
forge-std = { version = "1.8.1" }

[soldeer]
# Auto-generate remappings
remappings_generate = true

# Regenerate all remappings on install
remappings_regenerate = false

# Include version in remappings
remappings_version = true

# Prefix for remappings (e.g., "@")
remappings_prefix = ""

# Where to store remappings ("txt" or "config")
remappings_location = "txt"

# Recursively install sub-dependencies
recursive_deps = false
```

## Commands

### Initialize Project

```bash
# Initialize new project (auto-adds forge-std)
forge soldeer init

# Clean init (removes existing git submodules)
forge soldeer init --clean
```

### Add Dependencies

```bash
# From central registry
forge soldeer install @openzeppelin-contracts~5.0.2

# Version requirement examples
forge soldeer install @openzeppelin-contracts~^5.0.0   # 5.x.x
forge soldeer install @openzeppelin-contracts~>=5.0.0  # 5.0.0 or higher
forge soldeer install @openzeppelin-contracts~5        # 5.0.0 - 5.x.x
```

### Add from Git Repository

```bash
# Default branch
forge soldeer install forge-std~1.9.2 --git https://github.com/foundry-rs/forge-std.git

# Specific commit
forge soldeer install lib~v1 --git https://github.com/example/lib.git --rev abc123

# Specific branch
forge soldeer install lib~v1 --git https://github.com/example/lib.git --branch dev

# Specific tag
forge soldeer install lib~v1 --git https://github.com/example/lib.git --tag v1.0.0
```

### Add from Custom URL

```bash
# From ZIP file directly
forge soldeer install mylib~1.0.0 --url https://example.com/mylib.zip
```

### Install Existing Dependencies

```bash
# Install dependencies from foundry.toml/soldeer.toml
forge soldeer install

# Recursively install sub-dependencies
forge soldeer install --recursive-deps
```

### Update Dependencies

```bash
# Update to latest version within version range
forge soldeer update
```

### Remove Dependencies

```bash
forge soldeer uninstall @openzeppelin-contracts
```

### Publish Packages

```bash
# Login (after creating account on soldeer.xyz)
forge soldeer login

# Publish package
forge soldeer push my-project~1.0.0

# Publish specific directory
forge soldeer push my-project~1.0.0 ./contracts

# Dry run (creates ZIP only, no upload)
forge soldeer push my-project~1.0.0 --dry-run
```

## Version Requirements

Semantic versioning is supported:

| Syntax | Description |
|--------|-------------|
| `1.2.3` | Exact match (equivalent to `=1.2.3`) |
| `^1.2.3` | Patch/minor can change, major fixed |
| `~1.2.3` | Only patch can change |
| `>=1.2.3` | 1.2.3 or higher |
| `1` | `>=1.0.0 <2.0.0` |
| `1.2` | `>=1.2.0 <2.0.0` |
| `>1.2.3,<1.4.0` | Multiple requirements (comma-separated) |

## Security

The `soldeer.lock` file stores SHA-256 hashes for each dependency:

- Hash of downloaded ZIP file
- Hash of unzipped folder

This enables detection of file tampering.

## Soldeer vs Git Submodules

| Aspect | Git Submodules | Soldeer |
|--------|----------------|---------|
| **Design** | Generic Git feature | Built for Solidity |
| **Install Path** | `lib/` | `dependencies/` |
| **Versioning** | Commit hash / tag | Semantic versioning |
| **Central Registry** | ❌ None (direct GitHub) | ✅ soldeer.xyz |
| **Lockfile** | `.gitmodules` | `soldeer.lock` (with hashes) |
| **Command** | `forge install` | `forge soldeer install` |

## Strengths

- ✅ Package manager designed specifically for Solidity
- ✅ Semantic versioning support
- ✅ Central registry (soldeer.xyz) for easy package discovery
- ✅ Integrated into Foundry (no additional installation)
- ✅ SHA-256 hash verification for security
- ✅ Avoids complexity of Git submodules
- ✅ Familiar npm/pnpm-like experience

## Weaknesses

- ❌ Still new, ecosystem is growing
- ❌ Not all packages are registered in central registry
- ❌ `dependencies/` directory path is not customizable
- ❌ Migration required from existing git submodule projects

## References

- [Soldeer Homepage](https://soldeer.xyz/)
- [Soldeer Repository](https://github.com/mario-eth/soldeer)
- [Usage Guide](https://github.com/mario-eth/soldeer/blob/main/USAGE.md)
- [Foundry Book - Soldeer](https://book.getfoundry.sh/projects/soldeer)
