// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

type CalldataReader is uint256;

using CalldataReaderLib for CalldataReader global;

/// @author philogy <https://github.com/philogy>
library CalldataReaderLib {
    function from(bytes calldata data) internal pure returns (CalldataReader reader) {
        assembly {
            reader := data.offset
        }
    }

    function shifted(CalldataReader reader, uint256 n) internal pure returns (CalldataReader newReader) {
        assembly {
            newReader := add(reader, n)
        }
    }

    function readBool(CalldataReader reader) internal pure returns (bool value) {
        assembly {
            value := byte(0, calldataload(reader))
        }
    }

    function readU16(CalldataReader reader) internal pure returns (uint16 value) {
        assembly {
            value := shr(240, calldataload(reader))
        }
    }

    function readU40(CalldataReader reader) internal pure returns (uint40 value) {
        assembly {
            value := shr(216, calldataload(reader))
        }
    }

    function readU64(CalldataReader reader) internal pure returns (uint64 value) {
        assembly {
            value := shr(192, calldataload(reader))
        }
    }

    function readU128(CalldataReader reader) internal pure returns (uint128 value) {
        assembly {
            value := shr(128, calldataload(reader))
        }
    }
}
