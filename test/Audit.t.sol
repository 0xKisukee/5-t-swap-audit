// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import { Test, console2 } from "forge-std/Test.sol";
import { PoolFactory } from "../../src/PoolFactory.sol";
import { TSwapPool } from "../src/TSwapPool.sol";
import { ERC20Mock } from "@openzeppelin/contracts/mocks/token/ERC20Mock.sol";

contract PoolFactoryTest is Test {
    PoolFactory factory;
    TSwapPool pool;
    ERC20Mock weth;
    ERC20Mock poolToken;

    address liquidityProvider = makeAddr("liquidityProvider");

    uint256 startingWeth = 100 * 1e18;
    uint256 startingPoolToken = 10_000 * 1e18;

    function setUp() public {
        weth = new ERC20Mock();
        poolToken = new ERC20Mock();

        factory = new PoolFactory(address(weth));
        pool = TSwapPool(factory.createPool(address(poolToken)));
    }

    // Upgrade tests coverage 
    function test_wethSetup() public {
        assertEq(address(weth), factory.getWethToken());
    }

    // Audit tests
    function test_depositZeroPoolTokensDos() public {
        vm.startPrank(liquidityProvider);

        uint256 minWethDeposit = pool.getMinimumWethDepositAmount();

        weth.mint(liquidityProvider, minWethDeposit);
        weth.approve(address(pool), minWethDeposit);

        // Depositing with 0 poolTokens
        pool.deposit(
            minWethDeposit,
            0,
            0,
            uint64(block.timestamp + 30)
        );

        // Now we can't withdraw our weth
        uint256 liqToWithdraw = pool.balanceOf(liquidityProvider);
        vm.expectRevert();
        pool.withdraw(
            liqToWithdraw,
            1,
            1,
            uint64(block.timestamp + 30)
        );

        vm.stopPrank();

        assertGt(weth.balanceOf(address(pool)), 0);
    }

    function test_hugePriceDos() public {
        vm.startPrank(liquidityProvider);

        uint256 minWethDeposit = pool.getMinimumWethDepositAmount();

        weth.mint(liquidityProvider, minWethDeposit);
        poolToken.mint(liquidityProvider, 1);

        weth.approve(address(pool), minWethDeposit);
        poolToken.approve(address(pool), 1);

        pool.deposit(
            minWethDeposit,
            1,
            1,
            uint64(block.timestamp + 30)
        );

        vm.stopPrank();
    }
}