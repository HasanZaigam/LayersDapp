// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "v3-periphery/interfaces/INonfungiblePositionManager.sol";
import "../test/mock/mockTest.sol";
import {Script} from "forge-std/Script.sol";

contract AddLiquidity is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        INonfungiblePositionManager positionManager = INonfungiblePositionManager(0xC36442b4a4522E871399CD717aBDD847Ab11FE88);
        
        // Replace with your token addresses
        MockTokenA tokenA = MockTokenA(0xff2598561c79Fd9248b341B1B3808b8A04d5668c);
        MockTokenB tokenB = MockTokenB(0xe8fCa2b97A1d0442D79f3C487288f2e34a781d96);
        
        tokenA.approve(address(positionManager), type(uint256).max);
        tokenB.approve(address(positionManager), type(uint256).max);

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

        (uint256 tokenId, , , ) = positionManager.mint(params);
        
        vm.stopBroadcast();
    }
}