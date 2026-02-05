// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import { Test, console } from "forge-std/Test.sol";
import { PoolFactory } from "src/PoolFactory.sol";
import { ERC20Mock } from "../mocks/Erc20.sol";
import { TSwapPool } from "src/TSwapPool.sol";
import {StdInvariant} from "forge-std/StdInvariant.sol";

contract Invariant is StdInvariant, Test {
//thses pools have 2 assets 
 ERC20Mock poolToken;
 ERC20Mock mockWeth;
// we need a x and y balance

int256 constant STARTING_X= 100e18; //Starting ERC20 /poolToken balance
int256 constant STARTING_Y= 50e18; //Starting WETH 

 //we re goona need the contracts
 PoolFactory factory;
 TSwapPool pool; //pooltoken/weth
    function setUp () public{
        mockWeth = new ERC20Mock();
        poolToken = new ERC20Mock();
        factory = new PoolFactory(address(mockWeth));
        pool = new TSwapPool(factory.createPool(address(poolToken)));
    
      //create these initail x and y balances
        poolToken.mint(address(pool), uint256(STARTING_X));
        mockWeth.mint(address(pool), uint256(STARTING_Y));

        poolToken.approve(address(pool), type(uint256).max);
        mockWeth.approve(address(pool), type(uint256).max);

        //Deposit imto the pool,give the starting x and y balances
        pool.deposit(uint256(STARTING_Y), uint256(STARTING_Y), uint256(STARTING_X),uint64(block.timestamp));

    }

    function invariant_constantProductFormulaStaysTrue() public{
        
    }
}