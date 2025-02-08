// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import {MockTokenA, MockTokenB} from "../test/mock/mockTest.sol";
import "@uniswap/v3-core/interfaces/IUniswapV3Factory.sol"; 
import "@uniswap/v3-core/interfaces/IUniswapV3Pool.sol";


contract SetupMockPool is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        // Deploy mock tokens
        MockTokenA tokenA = new MockTokenA();
        MockTokenB tokenB = new MockTokenB();

        // Create a Uniswap V3 pool (fee tier: 0.3%)
        IUniswapV3Factory factory = IUniswapV3Factory(0x1F98431c8aD98523631AE4a59f267346ea31F984);
        IUniswapV3Pool pool = IUniswapV3Pool(factory.createPool(address(tokenA), address(tokenB), 3000));

        // Initialize the pool with a price (e.g., 1 MTA = 100 MTB)
        pool.initialize(79228162514264337593543950336); // sqrtPriceX96 for 1:100 ratio

        vm.stopBroadcast();
    }
}