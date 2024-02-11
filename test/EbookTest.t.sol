// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test} from "forge-std/Test.sol";
import {console} from "forge-std/console.sol";
import {DeployScript} from "../script/1-deploy.s.sol";

contract EbookTest is Test {
    DeployScript deployScript;

    function setUp() public {
        deployScript = new DeployScript();
        deployScript.run();
    }

    function testDeploy() public view {
        console.log("This is just a test");
        assert(1==1);
    }
}