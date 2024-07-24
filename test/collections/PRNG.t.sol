// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test} from "forge-std/Test.sol";
import {PRNG} from "src/collections/PRNG.sol";

import {console2 as console} from "forge-std/console2.sol";
import {FormatLib} from "src/libraries/FormatLib.sol";

/// @author philogy <https://github.com/philogy>
contract PRNGTest is Test {
    using FormatLib for *;

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

    function test_fuzzing_randmag(uint256 seed) public pure {
        PRNG memory rng = PRNG(seed);
        uint256 value = rng.randmag(0.01e27, 20.0e27);
        assertGe(value, 0.01e27);
        assertLt(value, 20.0e27);
    }

    function test_randmag() public pure {
        PRNG memory rng = PRNG(420_69_1);
        for (uint256 i = 0; i < 10; i++) {
            uint256 value = rng.randmag(0.1e27, 10.0e27);
            console.log("value: %s", value.fmtD(6, 27));
        }
    }
}
