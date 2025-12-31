# Hardhat vs Foundry Comparison

## Quick Summary

| Aspect | Hardhat | Foundry |
|--------|---------|---------|
| **Language** | JavaScript/TypeScript | Rust (tools), Solidity (tests) |
| **Test Language** | JS/TS (+ Solidity in v3) | Solidity |
| **Speed** | Moderate | Very Fast |
| **Package Manager** | npm/pnpm/yarn | Git submodules / Soldeer |
| **Maturity** | Mature (since 2018) | Newer (since 2021) |
| **Plugin Ecosystem** | Large | Growing |

## Detailed Comparison

### 1. Development Experience

| Feature | Hardhat | Foundry |
|---------|---------|---------|
| Configuration | `hardhat.config.ts` | `foundry.toml` |
| Compilation Speed | ~10-30s | ~1-5s |
| Test Execution | Slower (JS runtime) | Faster (native) |
| Hot Reload | Via plugins | Built-in (`--watch`) |

### 2. Testing

| Feature | Hardhat | Foundry |
|---------|---------|---------|
| Test Language | JS/TS primary | Solidity only |
| Fuzz Testing | Via plugins | Native |
| Invariant Testing | Via plugins | Native |
| Coverage | Via plugins | Native |
| Gas Reports | Via plugin | Native |
| Forking | ✅ | ✅ |
| Cheatcodes | Limited | Extensive (`vm.*`) |
| Stack Traces | ✅ | ✅ |

#### Testing Philosophy

**Hardhat**: Write tests in JavaScript/TypeScript. Good for developers familiar with JS testing patterns (Mocha, Chai). Integration with web3.js/ethers.js for frontend testing.

```typescript
// Hardhat test
describe("Counter", function () {
  it("Should increment", async function () {
    const counter = await ethers.deployContract("Counter");
    await counter.increment();
    expect(await counter.number()).to.equal(1);
  });
});
```

**Foundry**: Write tests in Solidity. No context switching. Closer to the actual contract logic.

```solidity
// Foundry test
function test_Increment() public {
    counter.increment();
    assertEq(counter.number(), 1);
}
```

### 3. Debugging

| Feature | Hardhat | Foundry |
|---------|---------|---------|
| console.log | ✅ Native | ✅ Via forge-std |
| Stack Traces | ✅ Detailed | ✅ Detailed |
| REPL | `npx hardhat console` | `chisel` |
| Debugger | Via plugins | `forge debug` |

### 4. Deployment

| Feature | Hardhat | Foundry |
|---------|---------|---------|
| Script Language | JS/TS | Solidity |
| Deployment Framework | Hardhat Ignition | Forge Scripts |
| Verification | Via plugin | Native `forge verify-contract` |
| Multi-chain | ✅ | ✅ |

### 5. Dependencies

**Hardhat**: Uses npm packages. Familiar to JS developers.

```bash
npm install @openzeppelin/contracts
```

**Foundry**: Uses Git submodules (or Soldeer). Can be tricky with versioning.

```bash
forge install OpenZeppelin/openzeppelin-contracts
```

### 6. CLI Tools

| Tool | Hardhat | Foundry |
|------|---------|---------|
| Compile | `npx hardhat compile` | `forge build` |
| Test | `npx hardhat test` | `forge test` |
| Deploy | `npx hardhat run` | `forge script` |
| Local Node | `npx hardhat node` | `anvil` |
| Interact | `npx hardhat console` | `cast` |
| REPL | — | `chisel` |

### 7. Ecosystem Integration

| Integration | Hardhat | Foundry |
|-------------|---------|---------|
| OpenZeppelin | ✅ | ✅ |
| Etherscan | ✅ Via plugin | ✅ Native |
| TypeChain | ✅ | ❌ (not needed) |
| Frontend Testing | ✅ (ethers.js) | Limited |
| CI/CD | ✅ | ✅ |

## When to Use What?

### Choose Hardhat if:

- 🎯 Team is comfortable with JavaScript/TypeScript
- 🎯 Need TypeScript types for frontend integration
- 🎯 Require specific plugins (gas-reporter, deploy, etc.)
- 🎯 Building full-stack dApp with JS/TS frontend
- 🎯 Need Hardhat Ignition for complex deployments
- 🎯 Prefer mature, battle-tested tooling

### Choose Foundry if:

- 🎯 Want fastest possible compile & test times
- 🎯 Team prefers writing tests in Solidity
- 🎯 Need advanced fuzz/invariant testing
- 🎯 Want powerful cheatcodes (pranks, storage manipulation)
- 🎯 Building protocol-level or security-focused projects
- 🎯 Prefer single-binary with no Node.js dependency

### Hybrid Approach

Many projects use **both**:

```
project/
├── contracts/          # Shared Solidity contracts
├── test/
│   ├── hardhat/        # Integration tests (JS)
│   └── foundry/        # Unit tests (Solidity)
├── hardhat.config.ts
└── foundry.toml
```

**Why hybrid?**
- Foundry for fast unit tests and fuzzing
- Hardhat for integration tests and deployment
- Best of both worlds

## Performance Benchmarks

*Note: Results vary by project size and complexity*

| Operation | Hardhat | Foundry | Difference |
|-----------|---------|---------|------------|
| Compile (100 contracts) | ~30s | ~3s | ~10x faster |
| Test Suite (1000 tests) | ~60s | ~10s | ~6x faster |
| Fork Mainnet | ~5s | ~2s | ~2.5x faster |

## Migration

### Hardhat → Foundry

1. Install Foundry: `curl -L https://foundry.paradigm.xyz | bash && foundryup`
2. Create `foundry.toml` with remappings
3. Convert JS tests to Solidity tests
4. Replace npm dependencies with Git submodules

### Foundry → Hardhat

1. Install Hardhat: `npm install --save-dev hardhat`
2. Create `hardhat.config.ts`
3. Convert Solidity tests to JS/TS tests
4. Replace Git submodules with npm packages

## Conclusion

| Use Case | Recommendation |
|----------|----------------|
| Rapid Prototyping | Foundry |
| Full-Stack dApp | Hardhat |
| Security Auditing | Foundry |
| Enterprise/Large Team | Either (or both) |
| Learning Solidity | Either |

Both tools are excellent. The "right" choice depends on team expertise, project requirements, and personal preference. The hybrid approach offers maximum flexibility.

