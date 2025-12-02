// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import {Test} from "forge-std/Test.sol";
import {console} from "forge-std/console.sol";
import {ERC20} from "../src/ERC20.sol";

contract ERC20Test is Test {
    ERC20 public erc20;
    address public alice = makeAddr("alice");
    address public bob = makeAddr("bob");
    address public founder = makeAddr("founder");

    function setUp() public {
        // Fund alice for pre-sale
        vm.deal(alice, 10 ether);

        // Deploy ERC20 as founder
        vm.prank(founder);
        erc20 = new ERC20( "shxt", "SHXT",1e12,0.0001 ether);
        vm.prank(founder);
        erc20.divertState();
        // Sanity checks
        assertEq(erc20.Owner(), founder);
        assertEq(erc20.totalSupply(), 1e12);

    }

    function testBuy() public {
        vm.startPrank(alice);

        // Buy tokens via pre-sale
        (bool success, ) = payable(address(erc20)).call{value: 1 ether}('');
        require(success, "failed TX");

        // Token balance
        assertEq(erc20.balanceOf(alice), 1 ether*(10**erc20.Decimals())/erc20.Price(),"balanceOf");

        // ETH balances after forward
        assertEq(founder.balance, 1 ether);
        assertEq(alice.balance, 9 ether);

        vm.stopPrank();
    }

    function testTransfer() public {
        vm.startPrank(alice);

        // Buy first
        (bool success, ) = payable(address(erc20)).call{value: 1 ether}('');
        require(success, "failed TX");

        // Transfer 500 tokens to bob
        success = erc20.transfer(bob, 500);
        assertTrue(success,"failed transfer");

        // Balances after transfer
        assertEq(erc20.balanceOf(alice), 1 ether*(10**erc20.Decimals())/erc20.Price() - 500);
        assertEq(erc20.balanceOf(bob), 500);

        vm.stopPrank();
    }

    function testBurn() public {
        vm.startPrank(alice);

        // Buy tokens first
        (bool success, ) = payable(address(erc20)).call{value: 1 ether}('');
        require(success, "failed TX");

        // Burn 900 tokens
        erc20.burn(900);
        uint _prets=erc20.totalSupply();
        assertEq(erc20.balanceOf(alice), 1 ether*(10**erc20.Decimals())/erc20.Price() - 900,"Bad balance");
        assertEq(erc20.totalSupply(),_prets );

        // Trying to transfer more than balance should revert
        vm.expectRevert();
        erc20.transfer(bob, 1e10);

        // Trying to burn more than balance should revert
        vm.expectRevert();
        erc20.burn(1e10);

        vm.stopPrank();
    }

    function test_Doubling() public {
        vm.startPrank(founder);
        console.log("No Doubling Founder",erc20.totalPhases(), erc20.balanceOf(founder)/10**erc20.Decimals());
        uint _preprice=erc20.Price();
        erc20.Doubling();
        console.log("1 Doubling Founder",erc20.totalPhases(), erc20.balanceOf(founder)/10**erc20.Decimals());

        assertTrue(_preprice*2==erc20.Price());
        console.log("Cuurent totalSupply",erc20.totalPhases(), erc20.TotalSupply()/10**erc20.Decimals());
        erc20.Doubling();
        console.log("2 Doubling Founder",erc20.totalPhases(), erc20.balanceOf(founder)/10**erc20.Decimals());

        erc20.Doubling();
        console.log("3 Doubling Founder",erc20.totalPhases(), erc20.balanceOf(founder)/10**erc20.Decimals());

        erc20.Doubling();
        console.log("4 Doubling Founder",erc20.totalPhases(), erc20.balanceOf(founder)/10**erc20.Decimals());

        erc20.Doubling();
        console.log("5 Doubling Founder",erc20.totalPhases(), erc20.balanceOf(founder)/10**erc20.Decimals());

        erc20.Doubling();
        console.log("6 Doubling Founder",erc20.totalPhases(), erc20.balanceOf(founder)/10**erc20.Decimals());

        erc20.Doubling();
        console.log("7 Doubling Founder",erc20.totalPhases(), erc20.balanceOf(founder)/10**erc20.Decimals());

        erc20.Doubling();
        console.log("8 Doubling Founder",erc20.totalPhases(), erc20.balanceOf(founder)/10**erc20.Decimals());

        erc20.Doubling();
        console.log("9 Doubling Founder",erc20.totalPhases(), erc20.balanceOf(founder)/10**erc20.Decimals());

        erc20.Doubling();
        console.log("10 Doubling Founder",erc20.totalPhases(), erc20.balanceOf(founder)/10**erc20.Decimals());

        vm.expectRevert();
        erc20.Doubling();
        console.log("This Reverted 11 Doubling Founder",erc20.totalPhases(), erc20.balanceOf(founder)/10**erc20.Decimals());
    }
}
