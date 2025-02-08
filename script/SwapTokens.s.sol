// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../lib/forge-std/src/Script.sol";
import "../src/connectors/Uniswap/UniswapV3Connector.sol";
import "../test/mock/mockTest.sol";

contract SwapTokens is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        // Get contracts
        MockTokenA tokenA = MockTokenA(0xff2598561c79Fd9248b341B1B3808b8A04d5668c); // Replace with your token address
        MockTokenB tokenB = MockTokenB(0xe8fCa2b97A1d0442D79f3C487288f2e34a781d96); // Replace with your token address
        UniswapV3Connector connector = UniswapV3Connector(0x64ad6c28Dc4E325ec54392791D8b7e2f67Df6dD8); // Replace with your connector address

        // Approve the connector to spend tokens
        tokenA.approve(address(connector), 100 * 1e18);

        // Perform a swap: 100 MTA → MTB
        connector.swapExactInputSingle(
            1, // Version (adjust based on your setup)
            address(tokenA),
            address(tokenB),
            3000, // Fee tier
            100 * 1e18,
            0, // amountOutMinimum (set to 0 for testing)
            0 // sqrtPriceLimitX96 (set to 0 for testing)
        );

        vm.stopBroadcast();
    }
}