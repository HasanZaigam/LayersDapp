

// // pragma solidity ^0.8.0;

// // import "forge-std/Script.sol";
// // import "../test/mock/mockTest.sol";
// // import "v3-core/contracts/interfaces/IUniswapV3Factory.sol";
// // import "v3-periphery/interfaces/INonfungiblePositionManager.sol";
// // import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

// // contract SetupPoolScript is Script {
// //     IUniswapV3Factory constant FACTORY = IUniswapV3Factory(0x1F98431c8aD98523631AE4a59f267346ea31F984);
// //     INonfungiblePositionManager constant NPM = INonfungiblePositionManager(0xC36442b4a4522E871399CD717aBDD847Ab11FE88);
    
// //     function run() external {
// //         uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
// //         vm.startBroadcast(deployerPrivateKey);

// //         // Deploy mock tokens
// //         MockTokenA tokenA = new MockTokenA();
// //         MockTokenB tokenB = new MockTokenB();
        
// //         // Ensure tokens are sorted
// //         address token0 = address(tokenA) < address(tokenB) ? address(tokenA) : address(tokenB);
// //         address token1 = address(tokenA) < address(tokenB) ? address(tokenB) : address(tokenA);

// //         // Create pool
// //         FACTORY.createPool(token0, token1, 3000); // 0.3% fee tier
// //         address poolAddress = FACTORY.getPool(token0, token1, 3000);
        
// //         // Approve tokens for position manager
// //         IERC20(token0).approve(address(NPM), type(uint256).max);
// //         IERC20(token1).approve(address(NPM), type(uint256).max);

// //         // Initialize pool with price of 1:1
// //         uint160 sqrtPriceX96 = 79228162514264337593543950336; // 1:1 price

// //         // Create initial liquidity
// //         NPM.mint(
// //             INonfungiblePositionManager.MintParams({
// //                 token0: token0,
// //                 token1: token1,
// //                 fee: 3000,
// //                 tickLower: -887220,  // Price range: 0.01 - 100
// //                 tickUpper: 887220,
// //                 amount0Desired: 1000 * 10**18,
// //                 amount1Desired: 1000 * 10**18,
// //                 amount0Min: 0,
// //                 amount1Min: 0,
// //                 recipient: msg.sender,
// //                 deadline: block.timestamp + 3600
// //             })
// //         );

// //         console.log("Token A deployed at:", address(tokenA));
// //         console.log("Token B deployed at:", address(tokenB));
// //         console.log("Pool created at:", poolAddress);

// //         vm.stopBroadcast();
// //     }
// // }

// pragma solidity ^0.8.20;

// import {Script} from "forge-std/Script.sol";
// import {MockTokenA, MockTokenB} from "../test/mock/mockTest.sol";
//  import "v3-core/contracts/interfaces/IUniswapV3Factory.sol";
// import "v3-periphery/interfaces/INonfungiblePositionManager.sol";
// contract SetupPoolScript is Script {
//     address constant FACTORY = 0x1F98431c8aD98523631AE4a59f267346ea31F984;
    
//     function run() external {
//         uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
//         vm.startBroadcast(deployerPrivateKey);

//         // Deploy mock tokens
//         MockToken tokenA = new MockToken("Mock Token A", "MTKA", 18);
//         MockToken tokenB = new MockToken("Mock Token B", "MTKB", 18);

//         // Ensure tokens are in correct order (lower address first)
//         (address token0, address token1) = tokenA < tokenB 
//             ? (address(tokenA), address(tokenB))
//             : (address(tokenB), address(tokenA));

//         // Create pool using factory
//         IUniswapV3Factory factory = IUniswapV3Factory(FACTORY);
//         address poolAddress = factory.createPool(token0, token1, 3000);
//         require(poolAddress != address(0), "Pool creation failed");

//         // Initialize pool with price
//         IUniswapV3Pool pool = IUniswapV3Pool(poolAddress);
//         uint160 sqrtPriceX96 = 79228162514264337593543950336; // 1:1 price
//         pool.initialize(sqrtPriceX96);

//         // Mint initial liquidity
//         // Note: You'll need to approve tokens and add liquidity in a separate step

//         vm.stopBroadcast();

//         // Log deployed addresses
//         console.log("Token A deployed to:", address(tokenA));
//         console.log("Token B deployed to:", address(tokenB));
//         console.log("Pool deployed to:", poolAddress);
//     }
// }


// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";
import {MockTokenA, MockTokenB} from "../test/mock/mockTest.sol";
import {IUniswapV3Factory} from "v3-core/contracts/interfaces/IUniswapV3Factory.sol";
import {IUniswapV3Pool} from "v3-core/contracts/interfaces/IUniswapV3Pool.sol";
import {INonfungiblePositionManager} from "v3-periphery/interfaces/INonfungiblePositionManager.sol";
import {console} from "forge-std/console.sol";

contract SetupPoolScript is Script {
    address constant FACTORY = 0x1F98431c8aD98523631AE4a59f267346ea31F984;
    
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        // Deploy mock tokens
        MockTokenA tokenA = new MockTokenA();  // Changed from MockToken to MockTokenA
        MockTokenB tokenB = new MockTokenB();  // Changed from MockToken to MockTokenB

        // Ensure tokens are in correct order (lower address first)
        (address token0, address token1) = address(tokenA) < address(tokenB) 
            ? (address(tokenA), address(tokenB))
            : (address(tokenB), address(tokenA));

        // Create pool using factory
        IUniswapV3Factory factory = IUniswapV3Factory(FACTORY);
        address poolAddress = factory.createPool(token0, token1, 3000);
        require(poolAddress != address(0), "Pool creation failed");

        // Initialize pool with price
        IUniswapV3Pool pool = IUniswapV3Pool(poolAddress);
        uint160 sqrtPriceX96 = 79228162514264337593543950336; // 1:1 price
        pool.initialize(sqrtPriceX96);

        vm.stopBroadcast();

        // Log deployed addresses
        console.log("Token A deployed to:", address(tokenA));
        console.log("Token B deployed to:", address(tokenB));
        console.log("Pool deployed to:", poolAddress);
    }
}