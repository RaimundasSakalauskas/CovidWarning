//
// Created by Raimundas Sakalauskas on 2020-04-03.
// Copyright (c) 2020 Raimundas Sakalauskas. All rights reserved.
//

import Foundation
import CoreBluetooth

extension CBManagerState: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch self {
            case .poweredOn:
                return "poweredOn"
            case .poweredOff:
                return "poweredOff"
            case .unsupported:
                return "unsupported"
            case .resetting:
                return "resetting"
            case .unauthorized:
                return "unauthorized"
            case .unknown:
                fallthrough
            @unknown default:
                NSLog("New value was introduced here.")
                return "unknown"
            }
    }
}
