
// contracts/OceanToken.sol
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract HoangToken is ERC20, Ownable {
     mapping (address => bool) private _blacklist;
    address private _treasury;

    constructor(string memory name, string memory symbol, address treasuryAddress) ERC20(name, symbol) {
        _treasury = treasuryAddress;
        _mint(msg.sender, 70000000 * (10 ** decimals()));
    }

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    function burn(uint256 amount) public onlyOwner {
        _burn(msg.sender, amount);
    }

    function addToBlacklist(address account) public onlyOwner {
        _blacklist[account] = true;
    }

    function removeFromBlacklist(address account) public onlyOwner {
        _blacklist[account] = false;
    }

    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
        require(!_blacklist[msg.sender], "Sender account is blacklisted");
        require(!_blacklist[recipient], "Recipient account is blacklisted");

        uint256 fee = amount / 20;
        uint256 transferAmount = amount - fee;

        _transfer(msg.sender, _treasury, fee);
        _transfer(msg.sender, recipient, transferAmount);

        return true;
    }

    function treasury() public view returns (address) {
        return _treasury;
    }
}