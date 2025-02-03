// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "../src/contracts/registry/index.sol";
import {InstaList} from "../src/contracts/registry/list.sol";
import "../src/connectors/Uniswap/UniswapV3Connector.sol";
import "../src/resolvers/Uniswap/UniswapV3Resolver.sol";

contract DeployScript is Script {
    function run() external {
        uint256 deployerPrivateKey = 0x89cbb5edb3b5a1a94d880f71c687c2e98f5706a8751119cb0136dc28edab8c52; // Hardcoded Private Key

        vm.startBroadcast(deployerPrivateKey);

        // Deploy InstaIndex
        InstaIndex instaIndex = new InstaIndex();

        // Deploy InstaList
        InstaList instaList = new InstaList(address(instaIndex));

        // Deploy UniswapV3Connector
        address swapRouter = 0xE592427A0AEce92De3Edee1F18E0157C05861564; // Uniswap V3 SwapRouter address
        UniswapV3Connector connector = new UniswapV3Connector(swapRouter, address(instaIndex), address(instaList));

        // Deploy UniswapV3Resolver
        UniswapV3Resolver resolver = new UniswapV3Resolver();

        // Set up InstaIndex with the deployed contracts
        instaIndex.setBasics(address(this), address(instaList), address(connector), address(resolver));

        vm.stopBroadcast();
    }
}
