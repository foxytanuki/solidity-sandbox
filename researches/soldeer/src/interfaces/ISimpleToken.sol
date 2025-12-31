// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {IERC20} from "@openzeppelin-contracts-5.5.0/token/ERC20/IERC20.sol";

/**
 * @title ISimpleToken
 * @notice Interface for a simple ERC20 token
 */
interface ISimpleToken is IERC20 {
    /// @notice Returns the token name
    function name() external view returns (string memory);

    /// @notice Returns the token symbol
    function symbol() external view returns (string memory);

    /// @notice Returns the number of decimals
    function decimals() external view returns (uint8);

    /// @notice Returns the owner address
    function owner() external view returns (address);

    /// @notice Mints new tokens (owner only)
    /// @param to Recipient address
    /// @param amount Amount to mint
    function mint(address to, uint256 amount) external;

    /// @notice Burns tokens from the caller
    /// @param amount Amount to burn
    function burn(uint256 amount) external;
}
