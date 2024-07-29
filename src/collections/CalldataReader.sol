// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

type CalldataReader is uint256;

using CalldataReaderLib for CalldataReader global;

/// @author philogy <https://github.com/philogy>
library CalldataReaderLib {
    error ReaderOutOfBounds();

    function from(bytes calldata data) internal pure returns (CalldataReader reader) {
        assembly {
            reader := data.offset
        }
    }

    function notAtEnd(CalldataReader self, bytes calldata data) internal pure returns (bool notEnded) {
        assembly {
            let end := add(data.offset, data.length)
            notEnded := lt(self, end)
            if gt(self, end) {
                mstore(0x00, 0x353a325a /* ReaderOutOfBounds() */ )
                revert(0x1c, 0x04)
            }
        }
    }

    function shifted(CalldataReader reader, uint256 n) internal pure returns (CalldataReader newReader) {
        assembly {
            newReader := add(reader, n)
        }
    }

    function readBool(CalldataReader self) internal pure returns (bool value) {
        assembly {
            value := byte(0, calldataload(self))
        }
    }

    function readU8(CalldataReader self) internal pure returns (uint8 value) {
        assembly {
            value := shr(248, calldataload(self))
        }
    }

    function readU16(CalldataReader self) internal pure returns (uint16 value) {
        assembly {
            value := shr(240, calldataload(self))
        }
    }

    function readU40(CalldataReader self) internal pure returns (uint40 value) {
        assembly {
            value := shr(216, calldataload(self))
        }
    }

    function readU64(CalldataReader self) internal pure returns (uint64 value) {
        assembly {
            value := shr(192, calldataload(self))
        }
    }

    function readU128(CalldataReader self) internal pure returns (uint128 value) {
        assembly {
            value := shr(128, calldataload(self))
        }
    }
}
