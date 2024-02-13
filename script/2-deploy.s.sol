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
        EbookStore ebookStore = new EbookStore();
        EbookChainToken ebookStoreToken = new EbookChainToken();
        ebookStore.initialize(initOwner, fundWallet, tax, callbackGasLimit, failureHandleStrategy,address(ebookStoreToken));
        console.log("Ebook Store contract", address(ebookStore));
        console.log("Ebook Store Token contract", address(ebookStoreToken));
        vm.stopBroadcast();
    }
}