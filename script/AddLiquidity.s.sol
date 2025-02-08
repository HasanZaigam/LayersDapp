// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../lib/forge-std/src/Script.sol";
import "v3-periphery/interfaces/INonfungiblePositionManager.sol";

import {MockTokenA,MockTokenB} from "../test/mock/mockTest.sol";

contract AddLiquidity is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        INonfungiblePositionManager positionManager = INonfungiblePositionManager(0xC36442b4a4522E871399CD717aBDD847Ab11FE88);
        
        // Approve tokens
        MockTokenA tokenA = MockTokenA(0xff2598561c79Fd9248b341B1B3808b8A04d5668c); // Replace with your token address
        MockTokenB tokenB = MockTokenB(0xe8fCa2b97A1d0442D79f3C487288f2e34a781d96); // Replace with your token address
        tokenA.approve(address(positionManager), type(uint256).max);
        tokenB.approve(address(positionManager), type(uint256).max);

        // Define liquidity parameters
        INonfungiblePositionManager.MintParams memory params = INonfungiblePositionManager.MintParams({
            token0: address(tokenA),
            token1: address(tokenB),
            fee: 3000,
            tickLower: -887220,
            tickUpper: 887220,
            amount0Desired: 1000 * 1e18,
            amount1Desired: 100000 * 1e18,
            amount0Min: 0,
            amount1Min: 0,
            recipient: msg.sender,
            deadline: block.timestamp + 1000
        });

        // Add liquidity
        (uint256 tokenId, , , ) = positionManager.mint(params);
        
        vm.stopBroadcast();
    }
}