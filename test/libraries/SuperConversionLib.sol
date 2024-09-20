// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test} from "forge-std/Test.sol";
import {SuperConversionLib} from "src/libraries/SuperConversionLib.sol";

/// @author philogy <https://github.com/philogy>
contract SuperConversionLibTest is Test {
    using SuperConversionLib for *;

    function setUp() public {}

    function test_convert_uint128() public pure {
        uint128[] memory arr = [uint128(1), uint128(2), uint128(3)].into();
        assertEq(arr[0], 1);
        assertEq(arr[1], 2);
        assertEq(arr[2], 3);
    }
}
