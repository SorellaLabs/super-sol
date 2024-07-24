// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {FixedPointMathLib} from "solady/src/utils/FixedPointMathLib.sol";
import {SafeCastLib} from "solady/src/utils/SafeCastLib.sol";
import {safeconsole as console} from "forge-std/safeconsole.sol";

type DiffMeter is uint256;

type AverageMeter is uint256;

using GasMeteringLib for DiffMeter global;
using GasMeteringLib for AverageMeter global;

/// @author philogy <https://github.com/philogy>
library GasMeteringLib {
    using SafeCastLib for *;

    function start(DiffMeter) internal view returns (DiffMeter) {
        return DiffMeter.wrap(gasleft());
    }

    function diff(DiffMeter self) internal view returns (uint256) {
        return DiffMeter.unwrap(self) - gasleft();
    }

    function diffAndLog(DiffMeter self, bytes32 message) internal view returns (DiffMeter) {
        uint256 newUsed = gasleft();
        console.log(message, DiffMeter.unwrap(self) - newUsed);
        return DiffMeter.wrap(newUsed);
    }

    function startNext(AverageMeter self) internal view returns (AverageMeter meter) {
        uint32 newLeft = gasleft().toUint32();
        assembly {
            meter := or(shl(32, shr(32, self)), newLeft)
        }
    }

    function end(AverageMeter self) internal view returns (AverageMeter) {
        uint32 newLeft = gasleft().toUint32();
        return self._updateAverage(self.lastLeft() - newLeft, newLeft);
    }

    function lastLeft(AverageMeter self) internal pure returns (uint32 last) {
        assembly {
            last := and(self, 0xffffffff)
        }
    }

    function total(AverageMeter self) internal pure returns (uint256 t) {
        assembly {
            t := and(shr(32, self), 0xffffffff)
        }
    }

    function average(AverageMeter self) internal pure returns (uint256 avgWad) {
        avgWad = uint128(AverageMeter.unwrap(self) >> 64);
    }

    function _updateAverage(AverageMeter self, uint32 newValue, uint32 newLeft) internal pure returns (AverageMeter) {
        uint256 value = newValue * FixedPointMathLib.WAD;
        uint256 packed = AverageMeter.unwrap(self);
        uint256 n = uint32(packed >> 32);
        uint256 avg = uint128(packed >> 64);
        if (n == 0) {
            n = 1;
            avg = value;
        } else {
            avg = avg * n + value;
            avg /= ++n;
        }
        return AverageMeter.wrap(uint256(newLeft) | (uint256(n.toUint32()) << 32) | (uint256(avg.toUint128()) << 64));
    }
}
