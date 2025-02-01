// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/connectors/Uniswap/UniswapV3Connector.sol";
import "../src/contracts/registry/index.sol";
import {InstaList} from "../src/contracts/registry/list.sol";

contract UniswapV3ConnectorTest is Test {
    UniswapV3Connector connector;
    InstaIndex instaIndex;
    InstaList instaList;

    function setUp() public {
        // Deploy contracts
        instaIndex = new InstaIndex();
        instaList = new InstaList(address(instaIndex));
        connector = new UniswapV3Connector(0xE592427A0AEce92De3Edee1F18E0157C05861564, address(instaIndex), address(instaList));
    }

    function testSwapExactInputSingle() public {
        // Add your test logic here
        // Example: Test a swap using the connector
    }
}