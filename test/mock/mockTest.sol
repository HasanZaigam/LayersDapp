//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MockTokenA is ERC20{
    constructor () ERC20("MockTokenA", "MTA"){
        _mint(msg.sender, 1000000 * 10 ** decimals());
    }
}

contract MockTokenB is ERC20{
    constructor () ERC20("MockTestB", "MTB"){
        _mint(msg.sender, 1000000 *10 ** decimals());
    }
}