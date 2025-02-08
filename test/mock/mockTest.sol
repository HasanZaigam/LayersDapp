//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MockTestA is ERC20{
    constructor () ERC20("MockTokenA", "MTA"){
        _mint(msg.sender, 1000000 * 10 ** decimals());
    }
}

contract MockTestB is ERC20{
    constructor () ERC20("MockTestB", "MTB"){
        _mint(msg.sender, 1000000 *10 ** decimals());
    }
}