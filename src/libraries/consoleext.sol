// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {console} from "forge-std/console.sol";
import {LibString} from "solady/src/utils/LibString.sol";

/// @author philogy <https://github.com/philogy>
library consoleext {
    using LibString for uint256;

    function logWords(bytes memory data) public pure {
        for (uint256 i = 0; i < data.length; i += 32) {
            uint256 word;
            assembly ("memory-safe") {
                word := mload(add(add(data, 0x20), i))
            }
            uint256 len = data.length - i;
            if (len > 32) len = 32;
            console.log("%s", word.toHexString(len));
        }
    }
}
