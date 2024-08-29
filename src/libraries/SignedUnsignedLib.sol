// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @author philogy <https://github.com/philogy>
library SignedUnsignedLib {
    error Overflow();
    error Underflow();

    function signed(uint256 x) internal pure returns (int256) {
        if (x > uint256(type(int256).max)) revert Overflow();
        return int256(x);
    }

    function unsigned(int256 x) internal pure returns (uint256) {
        if (x < 0) revert Underflow();
        return uint256(x);
    }

    function neg(int256 x) internal pure returns (uint256) {
        if (x > 0) revert Underflow();
        unchecked {
            return uint256(-x);
        }
    }
}
