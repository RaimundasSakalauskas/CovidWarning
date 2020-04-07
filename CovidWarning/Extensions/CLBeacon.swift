//
// Created by Raimundas Sakalauskas on 2020-04-07.
// Copyright (c) 2020 Raimundas Sakalauskas. All rights reserved.
//

import Foundation
import CoreLocation

extension CLBeacon {
    //Apple discourages use of `accuracy` property therefore adding our own method to get distance
    func getDistance(txPower: Double) -> Double {
        /*
         * RSSI = TxPower - 10 * n * lg(d)
         * n = 2 (in free space)
         *
         * d = 10 ^ ((TxPower - RSSI) / (10 * n))
         */

        pow(10.0, (txPower - Double(self.rssi)) / (10 * 2))
    }
}
