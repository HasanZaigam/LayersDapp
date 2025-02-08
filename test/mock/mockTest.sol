//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MockTokenA is ERC20{
    constructor (address initialHolder) ERC20("MockTokenA", "MTA"){
        _mint(initialHolder, 1000000 * 10 ** decimals());
    }
}

contract MockTokenB is ERC20{
    constructor (address initialHolder) ERC20("MockTestB", "MTB"){
        _mint(initialHolder, 1000000 *10 ** decimals());
    }
}