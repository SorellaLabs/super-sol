// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

struct PRNG {
    uint256 __state;
}

using PRNGLib for PRNG global;

/// @author philogy <https://github.com/philogy>
library PRNGLib {
    error InvalidBounds();

    function randbool(PRNG memory self) internal pure returns (bool) {
        return self.next() % 2 == 0;
    }

    function randchoice(PRNG memory self, uint256 p, uint256 x, uint256 y) internal pure returns (uint256) {
        return self.randuint(1e18) <= p ? x : y;
    }

    function randaddr(PRNG memory self) internal pure returns (address) {
        return address(uint160(self.randuint(1 << 160)));
    }

    function randuint16(PRNG memory self) internal pure returns (uint16) {
        return uint16(self.randuint(1 << 16));
    }

    function randuint64(PRNG memory self) internal pure returns (uint64) {
        return uint64(self.randuint(1 << 64));
    }

    function randuint8(PRNG memory self) internal pure returns (uint8) {
        return uint8(self.randuint(1 << 8));
    }

    function randuint8(PRNG memory self, uint256 max) internal pure returns (uint8) {
        require(max <= 256, "Invalid max");
        return uint8(self.randuint(max));
    }

    function randBytes(PRNG memory rng, uint256 minLen, uint256 maxLen) internal pure returns (bytes memory b) {
        b = new bytes(rng.randuint(minLen, maxLen));
        for (uint256 i = 0; i < b.length; i++) {
            b[i] = bytes1(uint8(rng.randuint(256)));
        }
    }

    function randint(PRNG memory self, int256 lowerBound, int256 upperBound) internal pure returns (int256 num) {
        if (lowerBound >= upperBound) revert InvalidBounds();
        uint256 rangeSize;
        unchecked {
            rangeSize = uint256(upperBound) - uint256(lowerBound);
            num = int256(self.randuint(rangeSize) + uint256(lowerBound));
        }
    }

    function randuint(PRNG memory self, uint256 lowerBound, uint256 upperBound) internal pure returns (uint256 num) {
        if (lowerBound >= upperBound) revert InvalidBounds();
        num = self.randuint(upperBound - lowerBound) + lowerBound;
    }

    function wad(PRNG memory self) internal pure returns (uint256) {
        return self.randuint(1e18);
    }

    function randuint(PRNG memory self, uint256 upperBound) internal pure returns (uint256 num) {
        if (upperBound == 1) return 0;
        uint256 maxValue = (type(uint256).max / upperBound) * upperBound;
        assembly ("memory-safe") {
            let preState := mload(self)
            let value
            mstore(0x20, preState)
            for { let i := 0 } 1 { i := add(i, 1) } {
                mstore(0x00, i)
                value := keccak256(0x00, 0x40)
                if lt(value, maxValue) { break }
            }
            num := mod(value, upperBound)

            mstore8(0x1f, 3)
            mstore(self, keccak256(31, 33))
        }
    }

    function next(PRNG memory self) internal pure returns (uint256 value) {
        assembly ("memory-safe") {
            mstore(1, mload(self))

            mstore8(0, 1)
            value := keccak256(0, 33)

            mstore8(0, 2)
            mstore(self, keccak256(0, 33))
        }
    }
}
