// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../lib/forge-std/src/Script.sol";
import "../test/mock/mockTest.sol";

contract DeployMockToken is Script {
    event TokensDeployed(address tokenA, address tokenB);

    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        // Deploy mock tokens
        MockTokenA tokenA = new MockTokenA(msg.sender);
        MockTokenB tokenB = new MockTokenB(msg.sender);

        // Log addresses
        emit TokensDeployed(address(tokenA), address(tokenB));
        console.log("MockTokenA deployed at:", address(tokenA));
        console.log("MockTokenB deployed at:", address(tokenB));

        vm.stopBroadcast();
    }
}