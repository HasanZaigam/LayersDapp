// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../lib/forge-std/src/Script.sol";
import {MockTokenA, MockTokenB} from "../test/mock/mockTest.sol";
import "@uniswap/v3-core/interfaces/IUniswapV3Factory.sol"; 
import "@uniswap/v3-core/interfaces/IUniswapV3Pool.sol";


contract SetupMockPool is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        // Deploy mock tokens (mint to `msg.sender`)
        MockTokenA tokenA = new MockTokenA(msg.sender); // ✅ Correct!
        MockTokenB tokenB = new MockTokenB(msg.sender); // ✅ Correct!

        // Create a Uniswap V3 pool
        IUniswapV3Factory factory = IUniswapV3Factory(0x0227628f3F023bb0B980b67D528571c95c6DaC1c);
        IUniswapV3Pool pool = IUniswapV3Pool(factory.createPool(address(tokenA), address(tokenB), 3000));

        // Initialize the pool
        pool.initialize(79228162514264337593543950336);

        vm.stopBroadcast();
    }
}