// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;
import {EbookStore} from "../src/Ebook.sol";
import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";
import {BucketStorage} from "@bnb-chain/greenfield-contracts/contracts/middle-layer/resource-mirror/storage/BucketStorage.sol";
import {DevOpsTools} from "foundry-devops/src/DevOpsTools.sol";


//   Ebook Store contract 0x6BCFc34457D7c99bE6cAF1aECF3E0b9ac64d957E
//   Ebook Store Token contract 0xBB57fF52AA39F1b43288Fd7c2FBea3b27a837Ad8
contract CreateSeries is Script {
    address primaryAddress = 0x63d6fB13DeD20AEEf9e25cA264b5C1Bd2ca2bc22;
    string name = "111heath";
    uint64 chargedReadQuota = 0;
    address spAddress = primaryAddress;
    uint256 expireHeight = block.number + block.number * 2;
    bytes sig = "";
    BucketStorage.BucketVisibilityType visibility = BucketStorage.BucketVisibilityType.PublicRead; // Use the local enum
    address public initOwner = vm.addr(vm.envUint("OP_PRIVATE_KEY"));

     function run() external {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment(
            "EbookStore",
            block.chainid
        );
        console.log(mostRecentlyDeployed);
        console.log("Block Number: %d", block.number);
        console.log("Expire Height: %d", expireHeight);
        console.log("Visibility: %d", uint(visibility));
        createSeries(mostRecentlyDeployed);
    }
    function createSeries(address contractAddress) public {
        string memory messageToSign = "createSeries";
        uint256  _privateKey = vm.envUint("OP_PRIVATE_KEY");
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(_privateKey, keccak256(abi.encodePacked(messageToSign)));
        // Call the createSeries function with the signature
        vm.startBroadcast(initOwner);
        EbookStore(contractAddress).createSeries{value: 0.015 ether}(name, visibility, chargedReadQuota, spAddress, expireHeight, sig);
        vm.stopBroadcast();
    }


}
