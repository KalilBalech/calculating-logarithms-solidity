// SPDX-License-Identifier: UNLICENSED
pragma solidity >0.8.0;

contract logarithmCalculator {
    function log_2(uint256 x) internal pure returns (int256) {
        require(x > 0);

        uint8 msb = mostSignificantBit(x);

        if (msb > 128) x >>= msb - 128;
        else if (msb < 128) x <<= 128 - msb;

        x &= TWO128_1;

        int256 result = (int256(msb) - 128) << 128; // Integer part of log_2

        int256 bit = TWO127;
        for (uint8 i = 0; i < 128 && x > 0; i++) {
            x = (x << 1) + ((x * x + TWO127) >> 128);
            if (x > TWO128_1) {
                result |= bit;
                x = (x >> 1) - TWO127;
            }
            bit >>= 1;
        }

        return result;
    }

    /**
     * Calculate ln (x / 2^128) * 2^128.
     *
     * @param x parameter value
     * @return ln (x / 2^128) * 2^128
     */
    function ln(uint256 x) internal pure returns (int256) {
        require(x > 0);

        int256 l2 = log_2(x);
        if (l2 == 0) return 0;
        else {
            uint256 al2 = uint256(l2 > 0 ? l2 : -l2);
            uint8 msb = mostSignificantBit(al2);
            if (msb > 127) al2 >>= msb - 127;
            al2 = (al2 * LN2 + TWO127) >> 128;
            if (msb > 127) al2 <<= msb - 127;

            return int256(l2 >= 0 ? al2 : -al2);
        }
    }
}
