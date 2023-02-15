
// contracts/OceanToken.sol
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

contract HoangToken is ERC20Capped, ERC20Burnable {
    address payable public owner;
    address payable public treasury;
    uint256 public blockReward;

    // create a mapping to keep track of who is blacklist
    mapping (address => bool) public _isBlacklisted;    

    constructor(uint256 cap, uint256 reward) ERC20("HoangToken", "HT") ERC20Capped(cap * (10 ** decimals())) {
        owner = payable(msg.sender);
        _mint(owner, 70000000 * (10 ** decimals()));
        blockReward = reward * (10 ** decimals());
    }

    function _mint(address account, uint256 amount) internal virtual override(ERC20Capped, ERC20) onlyOwner {
        // add the require statement into the transfer function   
        require(ERC20.totalSupply() + amount <= cap(), "ERC20Capped: cap exceeded");
        super._mint(account, amount);
    }

    function _burn(address account, uint256 amount) internal virtual override(ERC20) onlyOwner {
        require(ERC20.totalSupply() - amount <= cap(), "ERC20Burnable: Burn exceeded");
        super._burn(account, amount);
    }

        // adding multiple addresses to the blacklist - Used to manually block known bots and scammers
    function addToBlackList(address[] calldata addresses) external onlyOwner {
      for (uint256 i; i < addresses.length; ++i) {
        _isBlacklisted[addresses[i]] = true;
      }
    }

    // Remove from Blacklist 
    function removeFromBlackList(address account) external onlyOwner {
        _isBlacklisted[account] = false;
    }

    function _mintMinerReward() internal {
        super._mint(block.coinbase, blockReward);
    }

    function _beforeTokenTransfer(address from, address to, uint256 value) internal virtual override {
        require(!_isBlacklisted[owner] && !_isBlacklisted[to], "This address is blacklisted");
        if(from != address(0) && to != block.coinbase && block.coinbase != address(0)) {
            _mintMinerReward();
        }
        super._beforeTokenTransfer(from, to, value);
    }

    function setBlockReward(uint256 reward) public onlyOwner {
        blockReward = reward * (10 ** decimals());
    }

    function destroy() public onlyOwner {
        selfdestruct(owner);
    }

    modifier onlyOwner {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }
}