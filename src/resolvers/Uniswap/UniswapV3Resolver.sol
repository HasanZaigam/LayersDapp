// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "v3-core/contracts/interfaces/IUniswapV3Pool.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract UniswapV3Resolver {
    // Struct to return pool information
    struct PoolInfo {
        address token0;
        address token1;
        uint24 fee;
        int24 tick;
        uint160 sqrtPriceX96;
        uint128 liquidity;
        uint256 reserve0;
        uint256 reserve1;
    }

    // Struct to return swap quote information
    struct SwapQuote {
        uint256 amountIn;
        uint256 amountOut;
        uint160 sqrtPriceX96After;
    }

    // Get pool information
    function getPoolInfo(address poolAddress) external view returns (PoolInfo memory) {
        IUniswapV3Pool pool = IUniswapV3Pool(poolAddress);

        // Fetch pool state
        (uint160 sqrtPriceX96, int24 tick, , , , , ) = pool.slot0();
        uint128 liquidity = pool.liquidity();

        // Fetch token addresses and fees
        address token0 = pool.token0();
        address token1 = pool.token1();
        uint24 fee = pool.fee();

        // Fetch reserves (balances of tokens in the pool)
        uint256 reserve0 = IERC20(token0).balanceOf(poolAddress);
        uint256 reserve1 = IERC20(token1).balanceOf(poolAddress);

        return PoolInfo({
            token0: token0,
            token1: token1,
            fee: fee,
            tick: tick,
            sqrtPriceX96: sqrtPriceX96,
            liquidity: liquidity,
            reserve0: reserve0,
            reserve1: reserve1
        });
    }

    // Get a swap quote for exact input
    function getSwapQuoteExactInput(
        address poolAddress,
        address tokenIn,
        uint256 amountIn
    ) external view returns (SwapQuote memory) {
        IUniswapV3Pool pool = IUniswapV3Pool(poolAddress);
        (uint160 sqrtPriceX96, , , , , , ) = pool.slot0();

        bool zeroForOne = tokenIn == pool.token0();

        // Calculate the amount out using the current sqrtPriceX96
        uint256 amountOut = zeroForOne
            ? _getAmountOut(sqrtPriceX96, amountIn, true)
            : _getAmountOut(sqrtPriceX96, amountIn, false);

        // Simulate the new sqrtPriceX96 after the swap
        uint160 sqrtPriceX96After = zeroForOne
            ? _getSqrtPriceX96AfterExactInput(sqrtPriceX96, amountIn, true)
            : _getSqrtPriceX96AfterExactInput(sqrtPriceX96, amountIn, false);

        return SwapQuote({
            amountIn: amountIn,
            amountOut: amountOut,
            sqrtPriceX96After: sqrtPriceX96After
        });
    }

    // Helper function to calculate the amount out given sqrtPriceX96
    function _getAmountOut(
        uint160 sqrtPriceX96,
        uint256 amountIn,
        bool zeroForOne
    ) internal pure returns (uint256 amountOut) {
        if (zeroForOne) {
            amountOut = (amountIn * 1e18) / ((uint256(sqrtPriceX96) * uint256(sqrtPriceX96)) / (1 << 96));
        } else {
            amountOut = (amountIn * (uint256(sqrtPriceX96) * uint256(sqrtPriceX96)) / (1 << 96)) / 1e18;
        }
    }

    // Helper function to calculate the new sqrtPriceX96 after an exact input swap
    function _getSqrtPriceX96AfterExactInput(
        uint160 sqrtPriceX96,
        uint256 amountIn,
        bool zeroForOne
    ) internal pure returns (uint160 sqrtPriceX96After) {
        if (zeroForOne) {
            sqrtPriceX96After = uint160((sqrtPriceX96 * 1e18) / (1e18 + (amountIn * 1e18) / (1 << 96)));
        } else {
            sqrtPriceX96After = uint160((sqrtPriceX96 * (1e18 + (amountIn * 1e18) / (1 << 96))) / 1e18);
        }
    }

    // Get the current price of token0 in terms of token1
    function getPrice(address poolAddress) external view returns (uint256 price) {
        IUniswapV3Pool pool = IUniswapV3Pool(poolAddress);
        (uint160 sqrtPriceX96, , , , , , ) = pool.slot0();

        // Calculate the price using the sqrtPriceX96
        price = (uint256(sqrtPriceX96) * uint256(sqrtPriceX96)) / (1 << 96);
    }
}