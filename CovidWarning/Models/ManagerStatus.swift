//
// Created by Raimundas Sakalauskas on 2020-04-07.
// Copyright (c) 2020 Raimundas Sakalauskas. All rights reserved.
//

import Foundation

public enum ManagerStatus : CustomStringConvertible {
    case unauthorized
    case poweredOff
    case notReady
    case ready

    public var description: String {
        switch self {
            case .poweredOff:
                return "poweredOff"
            case .unauthorized:
                return "notAuthorized"
            case .notReady:
                return "notReady"
            case .ready:
                return "ready"
        }
    }
}