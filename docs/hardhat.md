# Hardhat

## Overview

Hardhat is a JavaScript/TypeScript-based development environment for Ethereum smart contracts. Developed by Nomic Foundation.

- **Language**: JavaScript / TypeScript
- **Runtime**: Node.js
- **Package Manager**: npm / pnpm / yarn

## Installation

```bash
# Initialize project
npm init -y

# Install Hardhat
npm install --save-dev hardhat

# Create project
npx hardhat init
```

## Project Structure

```
├── hardhat.config.ts   # Configuration file
├── contracts/          # Solidity contracts
├── test/               # TypeScript/JavaScript tests
├── scripts/            # Deployment and automation scripts
├── ignition/           # Hardhat Ignition deployment modules
├── artifacts/          # Compiled contract artifacts
└── cache/              # Build cache
```

## Configuration

`hardhat.config.ts`:

```typescript
import { HardhatUserConfig, configVariable } from "hardhat/config";

const config: HardhatUserConfig = {
  paths: {
    sources: "./contracts",
    tests: "./test",
    cache: "./cache",
    artifacts: "./artifacts",
  },
  solidity: {
    version: "0.8.28",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200,
      },
    },
  },
  networks: {
    hardhat: {
      // Local development network
    },
    sepolia: {
      url: configVariable("SEPOLIA_RPC_URL"),
      accounts: [configVariable("SEPOLIA_PRIVATE_KEY")],
    },
  },
};

export default config;
```

## Key Features

### 1. Console.log Debugging

Import and use `console.log` directly in Solidity:

```solidity
import "hardhat/console.sol";

contract MyContract {
    function foo() public {
        console.log("Debug value:", someValue);
    }
}
```

### 2. Solidity Stack Traces

Detailed error traces when tests fail, showing exact line numbers in contracts.

### 3. Network Forking

Test against mainnet state:

```typescript
const config = {
  networks: {
    hardhat: {
      forking: {
        url: "https://mainnet.infura.io/v3/...",
        blockNumber: 18000000,
      },
    },
  },
};
```

### 4. Plugin Ecosystem

Rich ecosystem of plugins:
- `@nomicfoundation/hardhat-toolbox` — All-in-one testing tools
- `@nomicfoundation/hardhat-verify` — Etherscan verification
- `hardhat-deploy` — Deployment management
- `hardhat-gas-reporter` — Gas usage reports

### 5. Hardhat Ignition

Declarative deployment system:

```typescript
// ignition/modules/MyToken.ts
import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

export default buildModule("MyToken", (m) => {
  const token = m.contract("MyToken", ["MyToken", "MTK"]);
  return { token };
});
```

## CLI Commands

```bash
# Compile contracts
npx hardhat compile

# Run tests
npx hardhat test

# Run specific test
npx hardhat test test/MyContract.ts

# Start local node
npx hardhat node

# Run script
npx hardhat run scripts/deploy.ts

# Deploy with Ignition
npx hardhat ignition deploy ignition/modules/MyToken.ts

# Clean artifacts
npx hardhat clean

# Verify contract
npx hardhat verify --network sepolia <address> <constructor-args>
```

## Testing

Hardhat supports both JavaScript/TypeScript tests and Solidity tests (Hardhat 3+).

### TypeScript Tests (Mocha + Chai)

```typescript
import { expect } from "chai";
import { ethers } from "hardhat";

describe("MyContract", function () {
  it("Should return the correct value", async function () {
    const MyContract = await ethers.getContractFactory("MyContract");
    const contract = await MyContract.deploy();
    
    expect(await contract.getValue()).to.equal(0);
  });
});
```

### Solidity Tests (Hardhat 3+)

```solidity
// contracts/Counter.t.sol
import "forge-std/Test.sol";
import "./Counter.sol";

contract CounterTest is Test {
    Counter counter;

    function setUp() public {
        counter = new Counter();
    }

    function test_Increment() public {
        counter.increment();
        assertEq(counter.value(), 1);
    }
}
```

## Strengths

- ✅ TypeScript-first development
- ✅ Rich plugin ecosystem
- ✅ console.log debugging
- ✅ Excellent documentation
- ✅ Large community
- ✅ Hardhat Ignition for deployment
- ✅ Node.js ecosystem integration

## Weaknesses

- ❌ Slower compilation than Foundry
- ❌ Slower test execution
- ❌ Requires Node.js runtime
- ❌ Context switching between Solidity and JS/TS
