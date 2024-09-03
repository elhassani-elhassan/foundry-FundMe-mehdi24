//SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/mocks/MockV3Aggregator.sol";

contract HelperConfig {
    NetworkCnfig public activeNetworkConfig;

    struct NetworkCnfig {
        address priceFeed;
    }

    constructor() {
        if (block.chainid == 11155111) {
            activeNetworkConfig = getSepoliaEthConfig();
        } else {
            activeNetworkConfig = getOrCreateAnvilEtheConfig();
        }
    }

    function getSepoliaEthConfig() public pure returns (NetworkCnfig memory) {
        NetworkCnfig memory sepoliaConfig = NetworkCnfig({
            priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306
        });
        return sepoliaConfig;
    }

    function getOrCreateAnvilEtheConfig() public returns (NetworkCnfig memory) {
        if (activeNetworkConfig.priceFeed != address(0)) {
            return activeNetworkConfig;
        }

        MockV3Aggregator mockpriceFeed = new MockV3Aggregator(8, 2000e8);

        NetworkCnfig memory anvilConfig = NetworkCnfig({
            priceFeed: address(mockpriceFeed)
        });
        return anvilConfig;
    }
}
