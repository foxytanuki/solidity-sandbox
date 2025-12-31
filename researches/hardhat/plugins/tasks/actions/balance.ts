import type { NewTaskActionFunction } from "hardhat/types/tasks";

import { formatEther, type Address } from "viem";

interface BalanceActionArguments {
  address: string;
}

/**
 * Action for the balance task
 * Shows the ETH balance of a specified address
 */
const balanceAction: NewTaskActionFunction<BalanceActionArguments> = async (
  { address },
  { network, globalOptions },
) => {
  // Get network name from global options (defaults to hardhatMainnet)
  const networkName = globalOptions.network ?? "hardhatMainnet";

  const { viem } = await network.connect({
    network: networkName,
    chainType: "l1",
  });

  const publicClient = await viem.getPublicClient();

  const balance = await publicClient.getBalance({
    address: address as Address,
  });

  console.log(`\nNetwork: ${networkName}`);
  console.log("=".repeat(50));
  console.log(`Address: ${address}`);
  console.log(`Balance: ${formatEther(balance)} ETH`);
  console.log(`Balance (wei): ${balance.toString()}`);
};

export default balanceAction;

