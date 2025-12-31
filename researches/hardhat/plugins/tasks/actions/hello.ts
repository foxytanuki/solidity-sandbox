import type { NewTaskActionFunction } from "hardhat/types/tasks";

interface HelloActionArguments {
  name: string;
}

/**
 * Action for the hello task
 * Prints a greeting message with the specified name
 */
const helloAction: NewTaskActionFunction<HelloActionArguments> = async ({
  name,
}) => {
  console.log(`Hello, ${name}!`);
  console.log("Task executed successfully on Hardhat 3 🎉");
};

export default helloAction;

