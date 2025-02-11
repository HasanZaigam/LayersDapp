// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "forge-std/console.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "v3-periphery/interfaces/ISwapRouter.sol";
import "v3-core/contracts/interfaces/IUniswapV3Factory.sol";
import "v3-core/contracts/interfaces/IUniswapV3Pool.sol";
import "v3-periphery/interfaces/INonfungiblePositionManager.sol";

// Import InstaIndex and other necessary contracts
import {InstaIndex} from "../../src/contracts/registry/index.sol";
import {InstaList} from "../../src/contracts/registry/list.sol";
import {UniswapV3Connector} from "../../src/connectors/Uniswap/UniswapV3Connector.sol";
import {UniswapV3Resolver} from "../../src/resolvers/Uniswap/UniswapV3Resolver.sol";

contract InteractionScript is Script {
    IUniswapV3Factory public constant FACTORY = IUniswapV3Factory(0x4752ba5DBc23f44D87826276BF6Fd6b1C372aD24);
    INonfungiblePositionManager public constant POSITION_MANAGER = INonfungiblePositionManager(0xC36442b4a4522E871399CD717aBDD847Ab11FE88);
    ISwapRouter public constant SWAP_ROUTER = ISwapRouter(0xE592427A0AEce92De3Edee1F18E0157C05861564);
    
    InstaIndex public instaIndex;
    UniswapV3Connector public connector;
    uint24 public constant FEE = 3000;

    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address deployer = vm.addr(deployerPrivateKey);
        
        vm.startBroadcast(deployerPrivateKey);

        // Deploy InstaIndex
        instaIndex = new InstaIndex();
        console.log("InstaIndex deployed at:", address(instaIndex));

        // Deploy InstaList
        InstaList instaList = new InstaList(address(instaIndex));
        console.log("InstaList deployed at:", address(instaList));

        // Deploy Uniswap Connector
        connector = new UniswapV3Connector(
            address(SWAP_ROUTER),
            address(instaIndex),
            address(instaList)
        );
        console.log("UniswapV3Connector deployed at:", address(connector));

        // Deploy Uniswap Resolver
        UniswapV3Resolver resolver = new UniswapV3Resolver();
        console.log("UniswapV3Resolver deployed at:", address(resolver));

        // Set up InstaIndex basics
        instaIndex.setBasics(
            deployer,            // Master
            address(instaList),   // List
            address(connector),   // Connector
            address(resolver)     // Resolver
        );
        console.log("Registry setup completed");

        // Create a new account through InstaIndex
        instaIndex.build(deployer, 1, address(0));
        console.log("New account created for:", deployer);

        vm.stopBroadcast();
    }
}
