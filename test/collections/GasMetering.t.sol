// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test} from "forge-std/Test.sol";
import {DiffMeter, AverageMeter} from "src/collections/GasMetering.sol";
import {FormatLib} from "src/libraries/FormatLib.sol";
import {console2 as console} from "forge-std/console2.sol";

/// @author philogy <https://github.com/philogy>
contract GasMeteringTest is Test {
    using FormatLib for *;

    uint256 private __var;

    function test_diffMeter() public {
        DiffMeter meter = DiffMeter.wrap(gasleft());
        _useGas(10);
        meter = meter.diffAndLog("use x10: %s");
        _useGas(21);
        meter = meter.diffAndLog("use x21: %s");
    }

    function test_averageMeter() public {
        AverageMeter meter;

        __var = 0;

        for (uint256 i = 0; i < 20; i++) {
            meter = meter.startNext();
            _useGas(21 + i);
            meter = meter.end();
            console.log("average: %s", meter.average().fmtD());
        }
    }

    function _useGas(uint256 n) internal {
        for (uint256 i = 0; i < n; i++) {
            __var = 0;
        }
    }
}
