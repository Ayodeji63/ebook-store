// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import {console} from "forge-std/console.sol";

import "../src/deployerEbook.sol";
import "../src/Ebook.sol";
import "../src/EbookChainToken.sol";

contract DeployScript is Script {
    uint256 public constant callbackGasLimit = 1_000_000;
    uint8 public constant failureHandleStrategy = 0; // BlockOnFail
    uint256 public constant tax = 100; // 1%

    address public operator;

    address public crossChain;
    address public groupHub;
    address public initOwner = vm.addr(vm.envUint("OP_PRIVATE_KEY"));
    address public fundWallet = initOwner;
    uint256 public _privateKey = vm.envUint("OP_PRIVATE_KEY");

    function setUp() public {
           uint256 privateKey = vm.envUint("OP_PRIVATE_KEY");
        operator = vm.addr(privateKey);
        console.log("operator balance: %s", operator.balance / 1e18);

        privateKey = uint256(vm.envBytes32("OWNER_PRIVATE_KEY"));
        initOwner = vm.addr(privateKey);
        fundWallet = initOwner;
        console.log("init owner: %s", initOwner);
    }

    function run() public {
        vm.startBroadcast(vm.addr(_privateKey));
        console.log("operator address: %s", operator);
        console.log("Private key address: ", vm.addr(_privateKey));

        DeployEbook deployer = new DeployEbook();
        console.log("Deployer address: %s", address(deployer));
        EbookStore ebookStore = new EbookStore();
        EbookChainToken ebookStoreToken = new EbookChainToken();
        

        console.log("implEbookStore address: %s", address(ebookStore));

        address proxyAdmin = deployer.calcCreateAddress(address(deployer), uint8(1));
        require(proxyAdmin == deployer.proxyAdmin(), "wrong proxyAdmin address");
        console.log("proxyAdmin address: %s", proxyAdmin);
        address proxyEbookStore = deployer.calcCreateAddress(address(deployer), uint8(2));
        require(proxyEbookStore == deployer.proxyEbookStore(), "wrong proxyEbookStroe address");
        console.log("proxyEbookStore address: %s", proxyEbookStore);

        deployer.deploy(address(ebookStore), initOwner, fundWallet, tax, callbackGasLimit, failureHandleStrategy, address(ebookStoreToken));
        vm.stopBroadcast();
    }
}