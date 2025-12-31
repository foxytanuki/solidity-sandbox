import type { HardhatPlugin } from "hardhat/types/plugins";

import { task } from "hardhat/config";
import { ArgumentType } from "hardhat/types/arguments";

/**
 * Hardhat 3 Custom Tasks Plugin
 *
 * This plugin provides the following tasks:
 * - hello: A simple greeting task
 * - accounts: Lists all accounts on the network
 * - balance: Shows the ETH balance of a specified address
 * - block: Shows block information
 */
const tasksPlugin: HardhatPlugin = {
  id: "custom:tasks",
  tasks: [
    // Simple hello task
    task("hello", "Prints a simple greeting message")
      .addOption({
        name: "name",
        description: "Name to greet",
        type: ArgumentType.STRING,
        defaultValue: "Hardhat 3",
      })
      .setAction(async () => import("./actions/hello.js"))
      .build(),

    // Task to list all accounts
    // Global option --network is automatically available
    task("accounts", "Lists all accounts on the network")
      .setAction(async () => import("./actions/accounts.js"))
      .build(),

    // Task to show ETH balance of an address
    // Global option --network is automatically available
    task("balance", "Shows the ETH balance of a specified address")
      .addPositionalArgument({
        name: "address",
        description: "Address to check balance",
        type: ArgumentType.STRING,
      })
      .setAction(async () => import("./actions/balance.js"))
      .build(),

    // Task to show block information
    // Global option --network is automatically available
    task("block", "Shows block information (latest block if not specified)")
      .addOption({
        name: "blockNumber",
        shortName: "b",
        description: "Block number (latest if not specified)",
        type: ArgumentType.BIGINT,
        defaultValue: -1n, // -1 means latest block
      })
      .setAction(async () => import("./actions/block.js"))
      .build(),
  ],
};

export default tasksPlugin;

