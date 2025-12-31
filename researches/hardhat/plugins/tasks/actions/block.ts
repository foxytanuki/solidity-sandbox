import type { NewTaskActionFunction } from "hardhat/types/tasks";

interface BlockActionArguments {
  blockNumber: bigint;
}

/**
 * Action for the block task
 * Shows block information for a specified block number
 */
const blockAction: NewTaskActionFunction<BlockActionArguments> = async (
  { blockNumber },
  { network, globalOptions },
) => {
  // Get network name from global options (defaults to hardhatMainnet)
  const networkName = globalOptions.network ?? "hardhatMainnet";

  const { viem } = await network.connect({
    network: networkName,
    chainType: "l1",
  });

  const publicClient = await viem.getPublicClient();

  // If blockNumber is -1, get the latest block
  const block = await publicClient.getBlock(
    blockNumber === -1n ? {} : { blockNumber },
  );

  console.log(`\nNetwork: ${networkName}`);
  console.log("=".repeat(50));
  console.log("Block Information:");
  console.log(`  Number: ${block.number}`);
  console.log(`  Hash: ${block.hash}`);
  console.log(`  Timestamp: ${new Date(Number(block.timestamp) * 1000).toISOString()}`);
  console.log(`  Transactions: ${block.transactions.length}`);
  console.log(`  Gas Used: ${block.gasUsed}`);
  console.log(`  Gas Limit: ${block.gasLimit}`);
  console.log(`  Base Fee: ${block.baseFeePerGas ?? "N/A"}`);
  console.log(`  Miner/Validator: ${block.miner}`);
};

export default blockAction;

