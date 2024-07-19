// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Math} from "./Math.sol";

library FormatLib {
    using Math for *;
    using FormatLib for *;

    function toStr(uint256 x) internal pure returns (string memory) {
        if (x == 0) return "0";
        bytes memory b;
        while (x > 0) {
            uint8 c = uint8(48 + x % 10);
            b = abi.encodePacked(c, b);
            x /= 10;
        }
        return string(b);
    }

    function toStr(int256 x) internal pure returns (string memory) {
        string memory str = x.abs().toStr();
        if (x >= 0) return str;
        return string.concat("-", str);
    }

    function toStr(bool b) internal pure returns (string memory) {
        return b ? "true" : "false";
    }

    function toStr(uint256[] memory values) internal pure returns (string memory) {
        if (values.length == 0) return "[]";
        string memory str = string.concat("[", values[0].toStr());
        for (uint256 i = 1; i < values.length; i++) {
            str = string.concat(str, ", ", values[i].toStr());
        }
        return string.concat(str, "]");
    }

    function toStr(bool[] memory values) internal pure returns (string memory) {
        if (values.length == 0) return "[]";
        string memory str = string.concat("[", values[0].toStr());
        for (uint256 i = 1; i < values.length; i++) {
            str = string.concat(str, ", ", values[i].toStr());
        }
        return string.concat(str, "]");
    }

    function fmtD(int256 value) internal pure returns (string memory) {
        return fmtD(value, 6, 18);
    }

    function fmtD(int256 value, uint8 roundTo) internal pure returns (string memory) {
        return fmtD(value, roundTo, 18);
    }

    function fmtD(int256 value, uint8 roundTo, uint8 decimals) internal pure returns (string memory) {
        roundTo = roundTo > decimals ? decimals : roundTo;
        int256 roundedUnit = int256(10 ** uint256(decimals - roundTo));
        int256 decimalValue = (value + roundedUnit / 2) / roundedUnit;
        assert(roundedUnit > 0);

        uint256 one = 10 ** roundTo;

        uint256 aboveDecimal = decimalValue.abs() / one;
        uint256 belowDecimal = decimalValue.abs() % one;

        string memory decimalRepr = belowDecimal.toStr();
        while (bytes(decimalRepr).length < roundTo) {
            decimalRepr = string.concat("0", decimalRepr);
        }

        return string.concat(value < 0 ? "-" : "", aboveDecimal.toStr(), ".", decimalRepr);
    }

    function fmtD(uint256 value) internal pure returns (string memory) {
        return fmtD(value, 6, 18);
    }

    function fmtD(uint256 value, uint8 roundTo) internal pure returns (string memory) {
        return fmtD(value, roundTo, 18);
    }

    function fmtD(uint256 value, uint8 roundTo, uint8 decimals) internal pure returns (string memory) {
        roundTo = roundTo > decimals ? decimals : roundTo;
        uint256 roundedUnit = 10 ** uint256(decimals - roundTo);
        uint256 decimalValue = (value + roundedUnit / 2) / roundedUnit;

        uint256 one = 10 ** roundTo;
        uint256 aboveDecimal = decimalValue / one;
        uint256 belowDecimal = decimalValue % one;

        string memory decimalRepr = belowDecimal.toStr();
        while (bytes(decimalRepr).length < roundTo) {
            decimalRepr = string.concat("0", decimalRepr);
        }

        return string.concat(aboveDecimal.toStr(), ".", decimalRepr);
    }
}
