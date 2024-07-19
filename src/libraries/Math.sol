// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @author philogy <https://github.com/philogy>
library Math {
    function max(uint256 x, uint256 y) internal pure returns (uint256) {
        return x > y ? x : y;
    }

    function min(uint256 x, uint256 y) internal pure returns (uint256) {
        return x < y ? x : y;
    }

    function abs(int256 x) internal pure returns (uint256) {
        unchecked {
            return x < 0 ? uint256(-x) : uint256(x);
        }
    }

    function sabs(int256 x) internal pure returns (int256) {
        return x < 0 ? -x : x;
    }
}
