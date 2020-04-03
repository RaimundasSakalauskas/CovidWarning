//
// Created by Raimundas Sakalauskas on 2020-04-03.
// Copyright (c) 2020 Raimundas Sakalauskas. All rights reserved.
//

import Foundation
import CoreLocation

extension CLProximity: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch self {
            case .unknown:
                return "unknown"
            case .immediate:
                return "immediate"
            case .near:
                return "near"
            case .far:
                return "far"
        }
    }
}