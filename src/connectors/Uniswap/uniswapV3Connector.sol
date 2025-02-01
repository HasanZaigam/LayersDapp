// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "v3-core/contracts/interfaces/IUniswapV3Pool.sol";
import "v3-periphery/interfaces/ISwapRouter.sol";
import "v3-periphery/libraries/TransferHelper.sol";

interface IInstaIndex {
    function connectors(uint version) external view returns (address);
    function account(uint version) external view returns (address);
}

interface IInstaList {
    function accountID(address account) external view returns (uint64);
}

contract UniswapV3Connector {
    ISwapRouter public immutable swapRouter;
    IInstaIndex public immutable instaIndex;
    IInstaList public immutable instaList;

    constructor(address _swapRouter, address _instaIndex, address _instaList) {
        swapRouter = ISwapRouter(_swapRouter);
        instaIndex = IInstaIndex(_instaIndex);
        instaList = IInstaList(_instaList);
    }

    modifier onlyAccount(uint version) {
        require(msg.sender == instaIndex.account(version), "not-account");
        _;
    }

    function swapExactInputSingle(
        uint version,
        address tokenIn,
        address tokenOut,
        uint24 fee,
        uint256 amountIn,
        uint256 amountOutMinimum,
        uint160 sqrtPriceLimitX96
    ) external onlyAccount(version) returns (uint256 amountOut) {
        TransferHelper.safeTransferFrom(tokenIn, msg.sender, address(this), amountIn);
        TransferHelper.safeApprove(tokenIn, address(swapRouter), amountIn);

        ISwapRouter.ExactInputSingleParams memory params =
            ISwapRouter.ExactInputSingleParams({
                tokenIn: tokenIn,
                tokenOut: tokenOut,
                fee: fee,
                recipient: msg.sender,
                deadline: block.timestamp,
                amountIn: amountIn,
                amountOutMinimum: amountOutMinimum,
                sqrtPriceLimitX96: sqrtPriceLimitX96
            });

        amountOut = swapRouter.exactInputSingle(params);
    }

    function swapExactOutputSingle(
        uint version,
        address tokenIn,
        address tokenOut,
        uint24 fee,
        uint256 amountOut,
        uint256 amountInMaximum,
        uint160 sqrtPriceLimitX96
    ) external onlyAccount(version) returns (uint256 amountIn) {
        TransferHelper.safeTransferFrom(tokenIn, msg.sender, address(this), amountInMaximum);
        TransferHelper.safeApprove(tokenIn, address(swapRouter), amountInMaximum);

        ISwapRouter.ExactOutputSingleParams memory params =
            ISwapRouter.ExactOutputSingleParams({
                tokenIn: tokenIn,
                tokenOut: tokenOut,
                fee: fee,
                recipient: msg.sender,
                deadline: block.timestamp,
                amountOut: amountOut,
                amountInMaximum: amountInMaximum,
                sqrtPriceLimitX96: sqrtPriceLimitX96
            });

        amountIn = swapRouter.exactOutputSingle(params);

        if (amountIn < amountInMaximum) {
            TransferHelper.safeApprove(tokenIn, address(swapRouter), 0);
            TransferHelper.safeTransfer(tokenIn, msg.sender, amountInMaximum - amountIn);
        }
    }
}