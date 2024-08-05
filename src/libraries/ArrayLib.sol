// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @author philogy <https://github.com/philogy>
library ArrayLib {
    function sum(uint256[] memory nums) internal pure returns (uint256 total) {
        for (uint256 i = 0; i < nums.length; i++) {
            total += nums[i];
        }
    }
}
