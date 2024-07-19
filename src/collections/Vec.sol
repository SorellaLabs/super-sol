// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

struct UintVec {
    uint256 length;
    uint256[] _mem;
}

using VecLib for UintVec global;

type void is uint256;

/// @author philogy <https://github.com/philogy>
library VecLib {
    error OutOfBoundsVecGet();

    uint256 constant MIN_NEW_CAPACITY = 1;

    function uint_with_cap(uint256 capacity) internal pure returns (UintVec memory obj) {
        obj.length = 0;
        obj._mem = new uint256[](capacity);
    }

    function get(UintVec memory self, uint256 index) internal pure returns (uint256) {
        if (index >= self.length) revert OutOfBoundsVecGet();
        return self._mem[index];
    }

    function push(UintVec memory self, uint256 value) internal pure {
        uint256 index = self.length;
        self.length++;
        uint256 oldCap = self._mem.length;
        if (self.length > oldCap) {
            uint256 newCap = oldCap * 2;
            uint256[] memory newMem = new uint256[](newCap < MIN_NEW_CAPACITY ? MIN_NEW_CAPACITY : newCap);
            for (uint256 i = 0; i < oldCap; i++) {
                newMem[i] = self._mem[i];
            }
            self._mem = newMem;
        }
        self._mem[index] = value;
    }
}
