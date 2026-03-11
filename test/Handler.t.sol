// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import { Test, console2 } from "forge-std/Test.sol";
import { TSwapPool } from "../src/TSwapPool.sol";
import { ERC20Mock } from "@openzeppelin/contracts/mocks/token/ERC20Mock.sol";

contract Handler is Test {
    TSwapPool pool;
    ERC20Mock weth;
    ERC20Mock poolToken;

    address liquidityProvider = makeAddr("liquidityProvider");
    address user = makeAddr("user");

    uint256 public wethBalanceAfter;
    uint256 public poolTokenBalanceAfter;
    int256 public expectedWethDelta;
    int256 public expectedPoolTokenDelta;

    constructor(ERC20Mock _weth, ERC20Mock _poolToken, TSwapPool _pool) {
        weth = _weth;
        poolToken = _poolToken;
        pool = _pool;
    }

    function deposit(uint256 _wethToDeposit) public {
        _wethToDeposit = bound(
            _wethToDeposit,
            pool.getMinimumWethDepositAmount(),
            100 * 1e18
        );
        uint256 poolTokensToDepositBasedOnWeth = pool.getPoolTokensToDepositBasedOnWeth(_wethToDeposit);

        expectedWethDelta += int256(_wethToDeposit);
        expectedPoolTokenDelta += int256(poolTokensToDepositBasedOnWeth);

        vm.startPrank(liquidityProvider);

        weth.mint(liquidityProvider, _wethToDeposit);
        poolToken.mint(liquidityProvider, poolTokensToDepositBasedOnWeth);

        weth.approve(address(pool), _wethToDeposit);
        poolToken.approve(address(pool), poolTokensToDepositBasedOnWeth);

        pool.deposit(
            _wethToDeposit,
            0,
            poolTokensToDepositBasedOnWeth,
            uint64(block.timestamp + 30)
        );

        vm.stopPrank();
    }

    function withdraw(uint256 _liquidityTokensToBurn) public {
        uint256 lpBalance = pool.balanceOf(liquidityProvider);
        if (lpBalance <= 1) return;

        _liquidityTokensToBurn = bound(_liquidityTokensToBurn, 1, lpBalance - 1);

        uint256 totalSupply = pool.totalLiquidityTokenSupply();
        uint256 minWeth = (_liquidityTokensToBurn * weth.balanceOf(address(pool))) / totalSupply;
        uint256 minPoolTokens = (_liquidityTokensToBurn * poolToken.balanceOf(address(pool))) / totalSupply;

        expectedWethDelta -= int256(minWeth);
        expectedPoolTokenDelta -= int256(minPoolTokens);

        vm.startPrank(liquidityProvider);

        pool.withdraw(
            _liquidityTokensToBurn,
            minWeth,
            minPoolTokens,
            uint64(block.timestamp + 30)
        );

        vm.stopPrank();
    }

    function swapExactWethForPoolToken(uint256 _wethToSwap) public {
        _wethToSwap = bound(
            _wethToSwap,
            1,
            10 * 1e18
        );

        uint256 outputAmount = pool.getOutputAmountBasedOnInput(
            _wethToSwap,
            weth.balanceOf(address(pool)),
            poolToken.balanceOf(address(pool))
        );

        expectedWethDelta += int256(_wethToSwap);
        expectedPoolTokenDelta -= int256(outputAmount);

        vm.startPrank(user);

        weth.mint(user, _wethToSwap);
        weth.approve(address(pool), _wethToSwap);
        
        pool.swapExactInput(
            weth,
            _wethToSwap,
            poolToken,
            1,
            uint64(block.timestamp + 30)
        );

        vm.stopPrank();
    }

    function swapPoolTokenForExactWeth(uint256 _wethToGet) public {
        _wethToGet = bound(
            _wethToGet,
            1,
            weth.balanceOf(address(pool))
        );

        uint256 poolTokenInputAmount = pool.getInputAmountBasedOnOutput(
            _wethToGet,
            poolToken.balanceOf(address(pool)),
            weth.balanceOf(address(pool))
        );

        expectedWethDelta -= int256(_wethToGet);
        expectedPoolTokenDelta += int256(poolTokenInputAmount);

        vm.startPrank(user);

        poolToken.mint(user, poolTokenInputAmount);
        poolToken.approve(address(pool), poolTokenInputAmount);
        
        pool.swapExactOutput(
            poolToken,
            weth,
            _wethToGet,
            uint64(block.timestamp + 30)
        );

        vm.stopPrank();
    }
}
