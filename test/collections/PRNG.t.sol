// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test} from "forge-std/Test.sol";
import {PRNG} from "src/collections/PRNG.sol";

/// @author philogy <https://github.com/philogy>
contract PRNGTest is Test {
    function test_fuzzing_randintBoundValidity(int256 bound1, int256 bound2, uint256 seed) public pure {
        vm.assume(bound1 != bound2);
        (int256 lo, int256 hi) = bound1 < bound2 ? (bound1, bound2) : (bound2, bound1);
        PRNG memory rng = PRNG(seed);
        int256 value = rng.randint(lo, hi);
        assertGe(value, lo);
        assertLt(value, hi);
    }

    function test_fuzzing_randuintBoundValidity(uint256 bound1, uint256 bound2, uint256 seed) public pure {
        vm.assume(bound1 != bound2);
        (uint256 lo, uint256 hi) = bound1 < bound2 ? (bound1, bound2) : (bound2, bound1);
        PRNG memory rng = PRNG(seed);
        uint256 value = rng.randuint(lo, hi);
        assertGe(value, lo);
        assertLt(value, hi);
    }
}
