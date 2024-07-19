// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test} from "forge-std/Test.sol";
import {UintVec, VecLib} from "src/collections/Vec.sol";

import {PRNG} from "src/collections/PRNG.sol";

/// @author philogy <https://github.com/philogy>
contract VecTest is Test {
    function test_fuzzing_initializeWithCapacity(uint256 cap) public pure {
        cap = bound(cap, 0, 200);
        UintVec memory values = VecLib.uint_with_cap(cap);
        assertEq(values._mem.length, cap);
        assertEq(values.length(), 0);
    }

    function test_fuzzing_push(uint256 startCap, uint256 totalPushes, uint256 seed) public pure {
        startCap = bound(startCap, 0, 150);
        totalPushes = bound(totalPushes, startCap / 2, startCap * 2 + 1);

        PRNG memory rng = PRNG(seed);

        UintVec memory vec = VecLib.uint_with_cap(startCap);

        uint256[] memory stored = new uint256[](totalPushes);
        for (uint256 i = 0; i < totalPushes; i++) {
            stored[i] = rng.next();
            vec.push(stored[i]);
            for (uint256 j = 0; j < i + 1; j++) {
                assertEq(stored[j], vec.get(j));
            }
            assertEq(vec.length(), i + 1);
            assertLe(vec.length(), vec._mem.length);
        }
    }
}
