// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import {InstaIndex} from "../src/contracts/registry/index.sol";
import {InstaList} from "../src/contracts/registry/list.sol";
import {UniswapV3Connector} from "../src/connectors/Uniswap/UniswapV3Connector.sol";
import {UniswapV3Resolver} from "../src/resolvers/Uniswap/UniswapV3Resolver.sol";
import {Implementation} from "../src/contracts/accounts/Implementation.sol";

contract DeployScript is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address deployer = vm.addr(deployerPrivateKey);

        vm.startBroadcast(deployerPrivateKey);

        // Deploy InstaIndex
        InstaIndex instaIndex = new InstaIndex();
        console.log("InstaIndex deployed at:", address(instaIndex));

        // Deploy InstaList
        InstaList instaList = new InstaList(address(instaIndex));
        console.log("InstaList deployed at:", address(instaList));

        // Deploy Account Implementation
        Implementation accountImplementation = new Implementation();
        console.log("Account Implementation deployed at:", address(accountImplementation));

        // Deploy UniswapV3Connector
        address swapRouter = 0xE592427A0AEce92De3Edee1F18E0157C05861564;
        UniswapV3Connector connector = new UniswapV3Connector(
            swapRouter,
            address(instaIndex),
            address(instaList)
        );
        console.log("UniswapV3Connector deployed at:", address(connector));

        // Deploy UniswapV3Resolver
        UniswapV3Resolver resolver = new UniswapV3Resolver();
        console.log("UniswapV3Resolver deployed at:", address(resolver));

        // Set up InstaIndex with the deployed contracts
        instaIndex.setBasics(
            deployer,
            address(instaList),
            address(accountImplementation),
            address(connector)
        );
        console.log("Registry setup completed");

        vm.stopBroadcast();
    }
}