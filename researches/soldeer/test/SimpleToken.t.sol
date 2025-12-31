// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test} from "forge-std-1.12.0/src/Test.sol";
import {SimpleToken} from "../src/SimpleToken.sol";
import {ISimpleToken} from "../src/interfaces/ISimpleToken.sol";
import {Ownable} from "@openzeppelin-contracts-5.5.0/access/Ownable.sol";

/**
 * @title SimpleTokenTest
 * @notice Test suite for SimpleToken
 */
contract SimpleTokenTest is Test {
    SimpleToken public token;

    address public owner = makeAddr("owner");
    address public alice = makeAddr("alice");
    address public bob = makeAddr("bob");

    string constant TOKEN_NAME = "Simple Token";
    string constant TOKEN_SYMBOL = "SIMPLE";

    function setUp() public {
        vm.prank(owner);
        token = new SimpleToken(TOKEN_NAME, TOKEN_SYMBOL, owner);
    }

    /*//////////////////////////////////////////////////////////////
                            DEPLOYMENT TESTS
    //////////////////////////////////////////////////////////////*/

    function test_Deployment() public view {
        assertEq(token.name(), TOKEN_NAME);
        assertEq(token.symbol(), TOKEN_SYMBOL);
        assertEq(token.decimals(), 18);
        assertEq(token.owner(), owner);
        assertEq(token.totalSupply(), 0);
    }

    /*//////////////////////////////////////////////////////////////
                              MINT TESTS
    //////////////////////////////////////////////////////////////*/

    function test_Mint_Success() public {
        uint256 amount = 1000 ether;

        vm.prank(owner);
        token.mint(alice, amount);

        assertEq(token.balanceOf(alice), amount);
        assertEq(token.totalSupply(), amount);
    }

    function test_Mint_RevertWhen_NotOwner() public {
        uint256 amount = 1000 ether;

        vm.prank(alice);
        vm.expectRevert(abi.encodeWithSelector(Ownable.OwnableUnauthorizedAccount.selector, alice));
        token.mint(alice, amount);
    }

    function testFuzz_Mint(address to, uint256 amount) public {
        vm.assume(to != address(0));
        vm.assume(amount > 0 && amount < type(uint256).max);

        vm.prank(owner);
        token.mint(to, amount);

        assertEq(token.balanceOf(to), amount);
    }

    /*//////////////////////////////////////////////////////////////
                              BURN TESTS
    //////////////////////////////////////////////////////////////*/

    function test_Burn_Success() public {
        uint256 mintAmount = 1000 ether;
        uint256 burnAmount = 400 ether;

        vm.prank(owner);
        token.mint(alice, mintAmount);

        vm.prank(alice);
        token.burn(burnAmount);

        assertEq(token.balanceOf(alice), mintAmount - burnAmount);
        assertEq(token.totalSupply(), mintAmount - burnAmount);
    }

    function test_Burn_RevertWhen_InsufficientBalance() public {
        uint256 mintAmount = 100 ether;
        uint256 burnAmount = 200 ether;

        vm.prank(owner);
        token.mint(alice, mintAmount);

        vm.prank(alice);
        vm.expectRevert();
        token.burn(burnAmount);
    }

    /*//////////////////////////////////////////////////////////////
                            TRANSFER TESTS
    //////////////////////////////////////////////////////////////*/

    function test_Transfer_Success() public {
        uint256 amount = 1000 ether;
        uint256 transferAmount = 300 ether;

        vm.prank(owner);
        token.mint(alice, amount);

        vm.prank(alice);
        bool success = token.transfer(bob, transferAmount);

        assertTrue(success);
        assertEq(token.balanceOf(alice), amount - transferAmount);
        assertEq(token.balanceOf(bob), transferAmount);
    }

    function test_Approve_And_TransferFrom() public {
        uint256 amount = 1000 ether;
        uint256 approveAmount = 500 ether;
        uint256 transferAmount = 300 ether;

        vm.prank(owner);
        token.mint(alice, amount);

        vm.prank(alice);
        token.approve(bob, approveAmount);

        assertEq(token.allowance(alice, bob), approveAmount);

        vm.prank(bob);
        bool success = token.transferFrom(alice, bob, transferAmount);

        assertTrue(success);
        assertEq(token.balanceOf(alice), amount - transferAmount);
        assertEq(token.balanceOf(bob), transferAmount);
        assertEq(token.allowance(alice, bob), approveAmount - transferAmount);
    }

    /*//////////////////////////////////////////////////////////////
                          INTERFACE TESTS
    //////////////////////////////////////////////////////////////*/

    function test_ImplementsInterface() public view {
        // Verify it can be used as ISimpleToken interface
        ISimpleToken iToken = ISimpleToken(address(token));

        assertEq(iToken.name(), TOKEN_NAME);
        assertEq(iToken.symbol(), TOKEN_SYMBOL);
        assertEq(iToken.decimals(), 18);
        assertEq(iToken.owner(), owner);
    }
}
