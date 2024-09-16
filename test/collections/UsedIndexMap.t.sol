// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test} from "forge-std/Test.sol";
import {UsedIndexMap} from "src/collections/UsedIndexMap.sol";
import {PRNG} from "src/collections/PRNG.sol";

import {console} from "forge-std/console.sol";
import {FormatLib} from "src/libraries/FormatLib.sol";

/// @author philogy <https://github.com/philogy>
contract UsedIndexMapTest is Test {
    using FormatLib for *;

    function setUp() public {}

    uint256[] ogNums;
    uint256[] nums;

    function test_fuzzing_randomUse(uint256 length, PRNG memory rng) public {
        length = bound(length, 1, 1000);
        for (uint256 i = 0; i < length; i++) {
            ogNums.push(i);
            nums.push(i);
        }
        UsedIndexMap memory map;
        map.init(length, length / 2);

        uint256 iters = rng.randuint(1, length + 1);
        for (uint256 i = 0; i < iters; i++) {
            uint256 index = rng.randuint(nums.length);

            uint256 num = nums[index];
            uint256 ui = map.useIndex(index);
            uint256 mappedNum = ogNums[ui];

            assertEq(num, mappedNum);

            uint256 lastIndex = nums.length - 1;
            uint256 lastNum = nums[lastIndex];
            nums.pop();

            if (index != lastIndex) {
                nums[index] = lastNum;
            }
        }
    }
}
