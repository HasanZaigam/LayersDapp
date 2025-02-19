// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface AccountInterface {
    function isAuth(address _user) external view returns (bool);
}

contract Variables {
    address public immutable instaIndex;

    constructor(address _instaIndex) {
        instaIndex = _instaIndex;
    }

    uint64 public accounts;
    mapping(address => uint64) public accountID;
    mapping(uint64 => address) public accountAddr;
    mapping(address => UserLink) public userLink;
    mapping(address => mapping(uint64 => UserList)) public userList;

    struct UserLink {
        uint64 first;
        uint64 last;
        uint64 count;
    }
    struct UserList {
        uint64 prev;
        uint64 next;
    }

    mapping(uint64 => AccountLink) public accountLink;
    mapping(uint64 => mapping(address => AccountList)) public accountList;

    struct AccountLink {
        address first;
        address last;
        uint64 count;
    }
    struct AccountList {
        address prev;
        address next;
    }
}

contract Configure is Variables {
    constructor(address _instaIndex) Variables(_instaIndex) {}

    function addAccount(address _owner, uint64 _account) internal {
        if (userLink[_owner].last != 0) {
            userList[_owner][_account].prev = userLink[_owner].last;
            userList[_owner][userLink[_owner].last].next = _account;
        }
        if (userLink[_owner].first == 0) userLink[_owner].first = _account;
        userLink[_owner].last = _account;
        userLink[_owner].count++;
    }

    function removeAccount(address _owner, uint64 _account) internal {
        uint64 _prev = userList[_owner][_account].prev;
        uint64 _next = userList[_owner][_account].next;
        if (_prev != 0) userList[_owner][_prev].next = _next;
        if (_next != 0) userList[_owner][_next].prev = _prev;
        if (_prev == 0) userLink[_owner].first = _next;
        if (_next == 0) userLink[_owner].last = _prev;
        userLink[_owner].count--;
        delete userList[_owner][_account];
    }

    function addUser(address _owner, uint64 _account) internal {
        if (accountLink[_account].last != address(0)) {
            accountList[_account][_owner].prev = accountLink[_account].last;
            accountList[_account][accountLink[_account].last].next = _owner;
        }
        if (accountLink[_account].first == address(0)) accountLink[_account].first = _owner;
        accountLink[_account].last = _owner;
        accountLink[_account].count++;
    }

    function removeUser(address _owner, uint64 _account) internal {
        address _prev = accountList[_account][_owner].prev;
        address _next = accountList[_account][_owner].next;
        if (_prev != address(0)) accountList[_account][_prev].next = _next;
        if (_next != address(0)) accountList[_account][_next].prev = _prev;
        if (_prev == address(0)) accountLink[_account].first = _next;
        if (_next == address(0)) accountLink[_account].last = _prev;
        accountLink[_account].count--;
        delete accountList[_account][_owner];
    }
}

contract InstaList is Configure {
    constructor(address _instaIndex) Configure(_instaIndex) {}

    function addAuth(address _owner) external {
        require(accountID[msg.sender] != 0, "not-account");
        require(AccountInterface(msg.sender).isAuth(_owner), "not-owner");
        addAccount(_owner, accountID[msg.sender]);
        addUser(_owner, accountID[msg.sender]);
    }

    function removeAuth(address _owner) external {
        require(accountID[msg.sender] != 0, "not-account");
        require(!AccountInterface(msg.sender).isAuth(_owner), "already-owner");
        removeAccount(_owner, accountID[msg.sender]);
        removeUser(_owner, accountID[msg.sender]);
    }

    function init(address _account) external {
        require(msg.sender == instaIndex, "not-index");
        require(accountID[_account] == 0, "Account already initialized");
        accounts++;
        accountID[_account] = accounts;
        accountAddr[accounts] = _account;
    }
}