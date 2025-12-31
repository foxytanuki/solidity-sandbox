# Foundry

## Overview

Foundry is a blazing-fast, portable, and modular toolkit for Ethereum application development, written in Rust.

- **Language**: Rust (tools), Solidity (tests/scripts)
- **Runtime**: Native binary
- **Package Manager**: Git submodules / Soldeer

## Components

| Tool | Description |
|------|-------------|
| **Forge** | Build, test, fuzz, deploy, verify contracts |
| **Cast** | CLI for interacting with EVM (send txs, query state) |
| **Anvil** | Local Ethereum node (like Ganache/Hardhat Network) |
| **Chisel** | Solidity REPL for quick experimentation |

## Installation

```bash
# Install foundryup (installer)
curl -L https://foundry.paradigm.xyz | bash

# Install Foundry tools
foundryup

# Install nightly (optional)
foundryup -i nightly
```

## Project Structure

```
├── foundry.toml        # Configuration file
├── src/                # Solidity contracts
├── test/               # Solidity tests
├── script/             # Deployment scripts (Solidity)
├── lib/                # Dependencies (git submodules)
└── out/                # Compiled artifacts
```

## Configuration

`foundry.toml`:

```toml
[profile.default]
src = "src"
out = "out"
libs = ["lib"]
solc_version = "0.8.28"
optimizer = true
optimizer_runs = 200
via_ir = false

# Remappings
remappings = [
    "@openzeppelin/contracts/=lib/openzeppelin-contracts/contracts/",
]

# Gas reporting
gas_reports = ["*"]

# File system permissions for scripts
fs_permissions = [{ access = "read", path = "./" }]

# Fuzz testing
[fuzz]
runs = 256
max_test_rejects = 65536

# Invariant testing
[invariant]
runs = 256
depth = 15
fail_on_revert = false
```

## Forge: Build & Test

### Build

```bash
# Compile contracts
forge build

# Build with specific compiler
forge build --use solc:0.8.28

# Clean and rebuild
forge clean && forge build
```

### Test

```bash
# Run all tests
forge test

# Run with verbosity
forge test -vvvv

# Run specific test
forge test --match-test testIncrement

# Run tests in specific contract
forge test --match-contract CounterTest

# Run with gas report
forge test --gas-report

# Watch mode
forge test --watch
```

### Test Structure

```solidity
// test/Counter.t.sol
import "forge-std/Test.sol";
import "../src/Counter.sol";

contract CounterTest is Test {
    Counter public counter;

    function setUp() public {
        counter = new Counter();
    }

    function test_Increment() public {
        counter.increment();
        assertEq(counter.number(), 1);
    }

    function testFail_Decrement() public {
        counter.decrement(); // Reverts on underflow
    }

    function test_RevertWhen_Unauthorized() public {
        vm.expectRevert("Unauthorized");
        counter.restrictedFunction();
    }
}
```

## Cheatcodes

Foundry provides powerful cheatcodes via `vm`:

```solidity
// Pranks (change msg.sender)
vm.prank(alice);
vm.startPrank(alice);
vm.stopPrank();

// Time manipulation
vm.warp(block.timestamp + 1 days);
vm.roll(block.number + 100);

// Storage manipulation
vm.store(address(contract), slot, value);
bytes32 val = vm.load(address(contract), slot);

// Expectations
vm.expectRevert("Error message");
vm.expectEmit(true, true, false, true);
emit Transfer(from, to, amount);

// Mocking
vm.mockCall(
    address(token),
    abi.encodeWithSelector(IERC20.balanceOf.selector, user),
    abi.encode(1000 ether)
);

// State snapshots
uint256 snapshot = vm.snapshot();
vm.revertTo(snapshot);

// Forking
vm.createFork("mainnet");
vm.selectFork(forkId);
```

## Fuzz Testing

```solidity
function testFuzz_Deposit(uint256 amount) public {
    // Bound input to reasonable range
    amount = bound(amount, 1, 1000 ether);
    
    vm.deal(alice, amount);
    vm.prank(alice);
    vault.deposit{value: amount}();
    
    assertEq(vault.balanceOf(alice), amount);
}
```

## Invariant Testing

```solidity
contract VaultInvariantTest is Test {
    Vault vault;

    function setUp() public {
        vault = new Vault();
        targetContract(address(vault));
    }

    function invariant_TotalSupplyMatchesBalance() public {
        assertEq(vault.totalSupply(), address(vault).balance);
    }
}
```

## Cast: EVM Interaction

```bash
# Get balance
cast balance 0x... --rpc-url $RPC_URL

# Call function (read)
cast call $CONTRACT "balanceOf(address)" $ADDR --rpc-url $RPC_URL

# Send transaction
cast send $CONTRACT "transfer(address,uint256)" $TO $AMOUNT \
    --rpc-url $RPC_URL --private-key $PK

# Decode data
cast decode-calldata "transfer(address,uint256)" 0x...

# ABI encode
cast abi-encode "constructor(string,string)" "MyToken" "MTK"

# Get storage
cast storage $CONTRACT $SLOT --rpc-url $RPC_URL

# Get block
cast block latest --rpc-url $RPC_URL
```

## Anvil: Local Node

```bash
# Start local node
anvil

# Fork mainnet
anvil --fork-url $MAINNET_RPC_URL

# Fork at specific block
anvil --fork-url $RPC_URL --fork-block-number 18000000

# Custom chain ID
anvil --chain-id 1337

# Auto-mine disabled
anvil --no-mining
```

## Chisel: REPL

```bash
# Start REPL
chisel

# In REPL
!help                    # Show help
uint256 x = 42;         # Define variable
x + 1                    # Evaluate expression
!source                  # Show source
!clear                   # Clear session
```

## Deployment Scripts

```solidity
// script/Deploy.s.sol
import "forge-std/Script.sol";
import "../src/Counter.sol";

contract DeployScript is Script {
    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        
        vm.startBroadcast(deployerPrivateKey);
        
        Counter counter = new Counter();
        console.log("Deployed at:", address(counter));
        
        vm.stopBroadcast();
    }
}
```

```bash
# Simulate deployment
forge script script/Deploy.s.sol --rpc-url $RPC_URL

# Broadcast (actual deployment)
forge script script/Deploy.s.sol --rpc-url $RPC_URL --broadcast

# Verify after deploy
forge script script/Deploy.s.sol --rpc-url $RPC_URL --broadcast --verify
```

## Contract Verification

```bash
forge verify-contract \
    --chain-id 11155111 \
    --compiler-version v0.8.28+commit.xxx \
    --etherscan-api-key $ETHERSCAN_API_KEY \
    $CONTRACT_ADDRESS \
    src/Counter.sol:Counter
```

## Coverage

```bash
# Generate coverage report
forge coverage

# Generate LCOV report
forge coverage --report lcov
```

## Strengths

- ✅ Blazing fast compilation & testing
- ✅ Tests written in Solidity (no context switch)
- ✅ Powerful cheatcodes
- ✅ Native fuzz & invariant testing
- ✅ Single binary (no Node.js required)
- ✅ Fork testing built-in
- ✅ Chisel REPL for experimentation

## Weaknesses

- ❌ Smaller plugin ecosystem
- ❌ Git submodules for dependencies (can be complex)
- ❌ Less mature than Hardhat
- ❌ No JS/TS integration (scripting in Solidity only)
- ❌ Steeper learning curve for cheatcodes
