import type { NewTaskActionFunction } from "hardhat/types/tasks";

/**
 * Action for the accounts task
 * Lists all accounts on the network
 */
const accountsAction: NewTaskActionFunction = async (
  _taskArgs,
  { network, globalOptions },
) => {
  // Get network name from global options (defaults to hardhatMainnet)
  const networkName = globalOptions.network ?? "hardhatMainnet";

  const { viem } = await network.connect({
    network: networkName,
    chainType: "l1",
  });

  const walletClients = await viem.getWalletClients();

  console.log(`\nNetwork: ${networkName}`);
  console.log("=".repeat(50));
  console.log("Accounts:");

  for (let i = 0; i < walletClients.length; i++) {
    const client = walletClients[i];
    console.log(`  [${i}] ${client.account.address}`);
  }

  console.log(`\nTotal: ${walletClients.length} accounts`);
};

export default accountsAction;

