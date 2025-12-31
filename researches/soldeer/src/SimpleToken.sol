// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ERC20} from "@openzeppelin-contracts-5.5.0/token/ERC20/ERC20.sol";
import {Ownable} from "@openzeppelin-contracts-5.5.0/access/Ownable.sol";
import {ISimpleToken} from "./interfaces/ISimpleToken.sol";

/**
 * @title SimpleToken
 * @notice A simple ERC20 token implementation for Soldeer verification
 * @dev Inherits from OpenZeppelin's ERC20 and Ownable
 */
contract SimpleToken is ERC20, Ownable, ISimpleToken {
    /**
     * @notice Constructor
     * @param name_ Token name
     * @param symbol_ Token symbol
     * @param initialOwner Initial owner address
     */
    constructor(
        string memory name_,
        string memory symbol_,
        address initialOwner
    ) ERC20(name_, symbol_) Ownable(initialOwner) {}

    /**
     * @inheritdoc ISimpleToken
     */
    function mint(address to, uint256 amount) external onlyOwner {
        _mint(to, amount);
    }

    /**
     * @inheritdoc ISimpleToken
     */
    function burn(uint256 amount) external {
        _burn(msg.sender, amount);
    }

    /**
     * @notice Returns the owner address
     * @dev Implementation for ISimpleToken interface
     */
    function owner() public view override(Ownable, ISimpleToken) returns (address) {
        return super.owner();
    }

    /**
     * @notice Returns the token name
     * @dev Override from both ERC20 and ISimpleToken
     */
    function name() public view override(ERC20, ISimpleToken) returns (string memory) {
        return super.name();
    }

    /**
     * @notice Returns the token symbol
     * @dev Override from both ERC20 and ISimpleToken
     */
    function symbol() public view override(ERC20, ISimpleToken) returns (string memory) {
        return super.symbol();
    }

    /**
     * @notice Returns the number of decimals
     * @dev Override from both ERC20 and ISimpleToken
     */
    function decimals() public view override(ERC20, ISimpleToken) returns (uint8) {
        return super.decimals();
    }
}
