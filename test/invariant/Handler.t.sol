// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import { Test, console } from "forge-std/Test.sol";
import { PoolFactory } from "src/PoolFactory.sol";
import { ERC20Mock } from "../mocks/Erc20.sol";
import { TSwapPool } from "src/TSwapPool.sol";
import {StdInvariant} from "forge-std/StdInvariant.sol";

contract Handler is Test {
TSwapPool public pool;
 ERC20Mock weth;
 ERC20Mock poolToken;

 //Gost variables
 int256 startingY;
  int256 startingX;

int256 public expectedDeltaY;
int256 public expectedDeltaX;
int256 public actualDeltaY;
int256 public actualDeltaX;

address liquidityProvider = makeAddr("lp");
address user = makeAddr("swapper");




constructor(TSwapPool _pool) {
 
    pool = _pool;
    weth = ERC20Mock(pool.getWeth());
    poolToken = ERC20Mock(pool.getPoolToken());
   
}




function swapPoolTokenForWethBasedOnOutputWeth(uint256 outputWeth) public{

outputWeth = bound(outputWeth,0,type(uint64).max); //between 0 and 18 WETH
if(outputWeth >= weth.balanceOf(address(pool))){
    return;

}

uint256 poolTokenAmount = pool.getInputAmountBasedOnOutput(outputWeth, poolToken.balanceOf(address(pool)), weth.balanceOf(address(pool)));

if(poolTokenAmount > type(uint64).max){
    return;
}


  startingY =  int256(weth.balanceOf(address(this)));
    startingX = int256(poolToken.balanceOf(address(this)));
  expectedDeltaY = int256(-1) * int256(outputWeth);
  expectedDeltaX = int256(pool.getPoolTokensToDepositBasedOnWeth(poolTokenAmount));
 
if(poolToken.balanceOf(user) < poolTokenAmount){
   poolToken.mint(user,poolTokenAmount - poolToken.balanceOf(user) + 1);

}


vm.startPrank(user);
    poolToken.approve(address(pool),type(uint64).max);
   pool.swapExactOutput(poolToken,weth,outputWeth,uint64(block.timestamp));
   
 vm.stopPrank();




  
 uint256 endingY = weth.balanceOf(address(this));
 uint256 endingX = poolToken.balanceOf(address(this));

 
 actualDeltaY = int256(endingY) - int256(startingY);
 actualDeltaX = int256(endingX) - int256(startingX);





}





//deposit, swapExactOutPut

 function  deposit(uint256 wethAmount) public{


    // lets make sure is a reasonable  amount
    //avoid oweird overflows errors
     
     wethAmount = bound(wethAmount,0,type(uint64).max); //between 0 and 18 WETH
  
  startingY =  int256(weth.balanceOf(address(this)));
    startingX = int256(poolToken.balanceOf(address(this)));
  expectedDeltaY = int256(wethAmount);
  expectedDeltaX = int256(pool.getPoolTokensToDepositBasedOnWeth(wethAmount));
 


 //deposit
 vm.startPrank(liquidityProvider);
    weth.mint(liquidityProvider,wethAmount);
    poolToken.mint(liquidityProvider,uint256(expectedDeltaX));
    weth.approve(address(pool),type(uint256).max);
    poolToken.approve(address(pool),type(uint256).max);

    pool.deposit(wethAmount,0,uint256(expectedDeltaX),uint64(block.timestamp));
 vm.stopPrank();


 //actuall

 uint256 endingY = weth.balanceOf(address(this));
 uint256 endingX = poolToken.balanceOf(address(this));

 
 actualDeltaY = int256(endingY) - int256(startingY);
 actualDeltaX = int256(endingX) - int256(startingX);


 }


}