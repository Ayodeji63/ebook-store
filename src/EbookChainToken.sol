pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract EbookChainToken is ERC20, Ownable {
    uint256 private constant _initialSupply =  1_000_000_000 *  10**18; //  1 billion tokens with  18 decimals
    uint256 private constant _mintPrice =  0.1 *  10**18; //  0.1 ETH
    uint256 private _totalSupply =  0;

    constructor() ERC20("SciChain", "SCI") {
        _mint(msg.sender, _initialSupply);
        _totalSupply = _initialSupply;
    }

    function mint(uint256 amount) public payable onlyOwner {
        require(amount >  0, "Amount must be greater than  0");
        require(msg.value >= _mintPrice * amount, "Not enough ETH sent");
        
        _totalSupply += amount;
        _mint(msg.sender, amount);
        emit Mint(msg.sender, amount);
    }

    event Mint(address indexed minter, uint256 amount);
}
