// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

struct UintVec {
    uint256 _length;
    uint256[] _mem;
}

using VecLib for UintVec global;

type void is uint256;

/// @author philogy <https://github.com/philogy>
library VecLib {
    error OutOfBoundsVecGet();

    uint256 constant MIN_NEW_CAPACITY = 1;

    function uint_with_cap(uint256 capacity) internal pure returns (UintVec memory obj) {
        obj._length = 0;
        obj._mem = new uint256[](capacity);
    }

    function length(UintVec memory self) internal pure returns (uint256) {
        return self._length;
    }

    function length(UintVec storage self) internal view returns (uint256) {
        return self._mem.length;
    }

    function get(UintVec memory self, uint256 index) internal pure returns (uint256) {
        if (index >= self._length) revert OutOfBoundsVecGet();
        return self._mem[index];
    }

    function get(UintVec storage self, uint256 index) internal view returns (uint256) {
        if (index >= self._mem.length) revert OutOfBoundsVecGet();
        return self._mem[index];
    }

    function push(UintVec memory self, uint256 value) internal pure {
        uint256 index = self._length;
        self._length++;
        uint256 oldCap = self._mem.length;
        if (self._length > oldCap) {
            uint256 newCap = oldCap * 2;
            uint256[] memory newMem = new uint256[](newCap < MIN_NEW_CAPACITY ? MIN_NEW_CAPACITY : newCap);
            for (uint256 i = 0; i < oldCap; i++) {
                newMem[i] = self._mem[i];
            }
            self._mem = newMem;
        }
        self._mem[index] = value;
    }

    function push(UintVec storage self, uint256 value) internal {
        self._mem.push(value);
    }
}
