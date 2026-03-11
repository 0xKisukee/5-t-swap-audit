// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import { Test, StdInvariant, console2 } from "forge-std/Test.sol";
import { PoolFactory } from "../src/PoolFactory.sol";
import { TSwapPool } from "../src/TSwapPool.sol";
import { ERC20Mock } from "@openzeppelin/contracts/mocks/token/ERC20Mock.sol";
import { Handler } from "./Handler.t.sol";

contract Invariant is StdInvariant, Test {
    PoolFactory factory;
    TSwapPool pool;
    ERC20Mock weth;
    ERC20Mock poolToken;

    address liquidityProvider = makeAddr("liquidityProvider");

    uint256 startingWeth = 100 * 1e18;
    uint256 startingPoolToken = 10_000 * 1e18;

    Handler handler;

    function setUp() public {
        weth = new ERC20Mock();
        poolToken = new ERC20Mock();

        factory = new PoolFactory(address(weth));
        pool = TSwapPool(factory.createPool(address(poolToken)));

        vm.startPrank(liquidityProvider);

        weth.mint(liquidityProvider, startingWeth);
        poolToken.mint(liquidityProvider, startingPoolToken);

        weth.approve(address(pool), startingWeth);
        poolToken.approve(address(pool), startingPoolToken);

        pool.deposit(
            startingWeth,
            0,
            startingPoolToken,
            uint64(block.timestamp + 30)
        );

        vm.stopPrank();

        handler = new Handler(weth, poolToken, pool);
        targetContract(address(handler));
        bytes4[] memory selectors = new bytes4[](4);
        selectors[0] = Handler.deposit.selector;
        selectors[1] = Handler.withdraw.selector;
        selectors[2] = Handler.swapExactWethForPoolToken.selector;
        selectors[3] = Handler.swapPoolTokenForExactWeth.selector;
        targetSelector(FuzzSelector(address(handler), selectors));
    }

    function statefulFuzz_ConstantProduct() public {
        uint256 finalWethBalance = weth.balanceOf(address(pool));
        uint256 finalPoolTokenBalance = poolToken.balanceOf(address(pool));

        int256 actualWethDelta = int256(finalWethBalance) - int256(startingWeth);
        int256 actualPoolTokenDelta = int256(finalPoolTokenBalance) - int256(startingPoolToken);
        
        assertEq(actualWethDelta, handler.expectedWethDelta());
        assertEq(actualPoolTokenDelta, handler.expectedPoolTokenDelta());
    }
}
