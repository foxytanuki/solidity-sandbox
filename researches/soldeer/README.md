# Soldeer Verification Project

A simple project to verify Soldeer package manager functionality with Foundry.

## Dependencies

- `forge-std` v1.12.0 - Foundry testing library (dev only, not for production)
- `@openzeppelin-contracts` v5.5.0 - OpenZeppelin Contracts

## Project Structure

```
.
├── src/
│   ├── SimpleToken.sol           # ERC20 token implementation
│   └── interfaces/
│       └── ISimpleToken.sol      # Token interface
├── test/
│   └── SimpleToken.t.sol         # Test suite
├── dependencies/                  # Soldeer managed dependencies
├── foundry.toml                   # Foundry + Soldeer config
├── soldeer.lock                   # Dependency lock file
└── remappings.txt                 # Import remappings
```

## Setup

```bash
# Install dependencies
forge soldeer install

# Build
forge build

# Test
forge test
```

## Contracts

### SimpleToken

A minimal ERC20 token with:

- **Mint** - Owner-only token minting
- **Burn** - Any holder can burn their tokens
- Inherits OpenZeppelin's `ERC20` and `Ownable`

## Test Coverage

| Test | Description |
|------|-------------|
| `test_Deployment` | Verifies initial state |
| `test_Mint_Success` | Owner can mint tokens |
| `test_Mint_RevertWhen_NotOwner` | Non-owner cannot mint |
| `testFuzz_Mint` | Fuzz testing for mint |
| `test_Burn_Success` | Token burning works |
| `test_Burn_RevertWhen_InsufficientBalance` | Cannot burn more than balance |
| `test_Transfer_Success` | ERC20 transfer works |
| `test_Approve_And_TransferFrom` | ERC20 approval flow works |
| `test_ImplementsInterface` | Interface compatibility |

## Init Logs

1. `foundryup`
2. `forge soldeer init`
3. `forge soldeer install @openzeppelin-contracts~5.5.0`
