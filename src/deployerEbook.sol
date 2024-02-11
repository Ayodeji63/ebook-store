// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/proxy/transparent/ProxyAdmin.sol";
import "@openzeppelin/contracts/proxy/transparent/TransparentUpgradeableProxy.sol";

import "./Ebook.sol";

contract DeployEbook {
    error DeployEbook__InvalidProxyEbookStore();

    address public proxyAdmin;
    address public proxyEbookStore;
    address public implEbookStore;
    address public ebookToken;
    bool public deployed;
    constructor() {
        /**
         * @dev deploy workflow
         * a. Generate contracts addresses in advance first while deploy `DeployerEbook`
         * c. Deploy the proxy contracts, checking if they are equal to the generated addresses before
         */

        proxyAdmin = calcCreateAddress(address(this), uint8(1));
        proxyEbookStore = calcCreateAddress(address(this), uint8(2));

        // 1. ProxyAdmin
        address deployedProxyAdmin = address(new ProxyAdmin());
        require(deployedProxyAdmin == proxyAdmin, "invalid proxyAdmin address");
        
    }

    function deploy(
        address _implEbookStore, 
        address _owner, 
        address _fundWallet, 
        uint256 _tax, 
        uint256 _callbackGasLimit, 
        uint8 _failureHandleStrategy, 
        address _ebookToken) public {
        require(!deployed, "only not deployed");
        deployed = true;

        require(_owner != address(0), "invalid owner");
        require(_fundWallet != address(0), "invalid fundWallet");
        require(_tax <= 1000, "invalid tax");
        require(_callbackGasLimit > 0, "invalid callbackGasLimit");

        require(_isContract(_implEbookStore), "invalid implEbookStroe");
        implEbookStore = _implEbookStore;

        require(_ebookToken != address(0), "invalid Ebook Token");
        ebookToken = _ebookToken;

        //1. deploy proxy contract
        address deployedProxyEbookStore = address(new TransparentUpgradeableProxy(implEbookStore, proxyAdmin, ""));
        if (deployedProxyEbookStore != proxyEbookStore) {
            revert DeployEbook__InvalidProxyEbookStore();
        }
        require(deployedProxyEbookStore == proxyEbookStore, "invalid proxyEbookstore address");

        // 2. Transfer admin ownership
        ProxyAdmin(proxyAdmin).transferOwnership(_owner);
        require(ProxyAdmin(proxyAdmin).owner() == _owner, "invalid proxyAdmin owner");

        // 3. Init marketplace
        EbookStore(payable(proxyEbookStore)).initialize(_owner, _fundWallet, _tax, _callbackGasLimit, _failureHandleStrategy,ebookToken);
    }

    function calcCreateAddress(address _deployer, uint8 _nonce) public pure returns(address) {
       return address(uint160(uint256(keccak256(abi.encodePacked(bytes1(0xd6), bytes1(0x94), _deployer, _nonce)))));
    }

    function _isContract(address account) internal view returns (bool) {
        return account.code.length > 0;
    }
}