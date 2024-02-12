// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;
import {EbookStore} from "../src/Ebook.sol";
import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";
import {BucketStorage} from "@bnb-chain/greenfield-contracts/contracts/middle-layer/resource-mirror/storage/BucketStorage.sol";

contract CreateSeries is Script {
    address primaryAddress = 0x63d6fB13DeD20AEEf9e25cA264b5C1Bd2ca2bc22;
    address ebookAddress = 0x381B6BFd8e208F79d21C647Daf95247c669C55b9;
    string name = "ebookStore";
    uint64 chargedReadQuota = 0;
    address spAddress = primaryAddress;
    uint256 expireHeight = 	4959457;
    bytes sig = "0x";
    BucketStorage.BucketVisibilityType visibility = BucketStorage.BucketVisibilityType.PublicRead; // Use the local enum
    address public initOwner = vm.addr(vm.envUint("OP_PRIVATE_KEY"));
    function run() public {
        string memory messageToSign = "createSeries";
        uint256  _privateKey = vm.envUint("OP_PRIVATE_KEY");
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(_privateKey, keccak256(abi.encodePacked(messageToSign)));
        // Call the createSeries function with the signature
        vm.startBroadcast(initOwner);
        EbookStore(0x381B6BFd8e208F79d21C647Daf95247c669C55b9).createSeries{value: 0.01 ether}(name, visibility, chargedReadQuota, spAddress, expireHeight, bytes(abi.encodePacked(v, r, s)));
        vm.stopBroadcast();
    }


}
