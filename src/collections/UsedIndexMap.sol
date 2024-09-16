// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {UintVec, VecLib} from "./Vec.sol";

struct UsedIndex {
    uint256 fromIndex;
    uint256 toIndex;
}

struct UsedIndexMap {
    uint256 length;
    UintVec usedIndicesPtrs;
}

using UsedIndexMapLib for UsedIndexMap global;

/// @author philogy <https://github.com/philogy>
library UsedIndexMapLib {
    function init(UsedIndexMap memory self, uint256 length, uint256 startCapacity) internal pure {
        self.length = length;
        self.usedIndicesPtrs = VecLib.uint_with_cap(startCapacity);
    }

    function lookupIndex(UsedIndexMap memory self, uint256 index)
        internal
        pure
        returns (bool isUsed, uint256 usedIndex, uint256 realIndex)
    {
        require(index < self.length, "Index out-of-bounds");

        function(UintVec memory, uint256) pure returns (uint256) vecUintGet = VecLib.get;
        function(UintVec memory, uint256) pure returns (UsedIndex memory) vecUsedIndexGet;
        assembly {
            vecUsedIndexGet := vecUintGet
        }

        for (usedIndex = 0; usedIndex < self.usedIndicesPtrs.length; usedIndex++) {
            UsedIndex memory used = vecUsedIndexGet(self.usedIndicesPtrs, usedIndex);
            if (used.fromIndex == index) {
                isUsed = true;
                realIndex = used.toIndex;
                return (isUsed, usedIndex, realIndex);
            }
        }

        return (false, usedIndex, index);
    }

    function mapIndex(UsedIndexMap memory self, uint256 index) internal pure returns (uint256 realIndex) {
        (,, realIndex) = self.lookupIndex(index);
    }

    function useIndex(UsedIndexMap memory self, uint256 index) internal pure returns (uint256 realIndex) {
        require(self.length > 0, "Nothing to use");
        bool isUsed;
        uint256 usedIndex;
        (isUsed, usedIndex, realIndex) = self.lookupIndex(index);
        (,, uint256 lastIndex) = self.lookupIndex(self.length - 1);
        self.length -= 1;
        if (isUsed) {
            function(UsedIndex memory, uint256) pure setUsed = _set;
            function(uint256, uint256) pure setWithPtr;
            assembly {
                setWithPtr := setUsed
            }
            setWithPtr(self.usedIndicesPtrs.get(usedIndex), lastIndex);
        } else {
            UsedIndex memory newUsed = UsedIndex({fromIndex: index, toIndex: lastIndex});
            uint256 ptr;
            assembly {
                ptr := newUsed
            }
            self.usedIndicesPtrs.push(ptr);
        }
    }

    function _set(UsedIndex memory used, uint256 newToIndex) private pure {
        used.toIndex = newToIndex;
    }
}
