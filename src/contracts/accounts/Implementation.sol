// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Implementation {
    mapping(address => bool) public authorities;
    address public immutable implementation;
    uint public constant version = 1;

    constructor() {
        implementation = address(this);
    }

    event LogEnableUser(address indexed authority);
    event LogDisableUser(address indexed authority);
    event LogCast(
        address indexed origin,
        address indexed sender,
        uint value
    );

    modifier auth {
        require(authorities[msg.sender] || msg.sender == address(this), "not-authorized");
        _;
    }

    function enable(address authority) external {
        require(authorities[authority] == false, "already-enabled");
        authorities[authority] = true;
        emit LogEnableUser(authority);
    }

    function disable(address authority) external auth {
        require(authorities[authority], "already-disabled");
        authorities[authority] = false;
        emit LogDisableUser(authority);
    }

    function isAuth(address authority) public view returns (bool) {
        return authorities[authority];
    }

    function cast(
        address[] calldata _targets,
        bytes[] calldata _datas,
        address _origin
    ) external payable auth returns (bytes32[] memory responses) {
        require(_targets.length == _datas.length, "invalid-targets-data-length");
        responses = new bytes32[](_targets.length);
        
        for(uint i = 0; i < _targets.length; i++) {
            require(_targets[i] != address(0), "invalid-target");
            
            (bool success, bytes memory response) = _targets[i].delegatecall(_datas[i]);
            require(success, "delegatecall-failed");
            
            responses[i] = bytes32(response);
        }

        emit LogCast(_origin, msg.sender, msg.value);
    }

    receive() external payable {}
}