//
// Created by Raimundas Sakalauskas on 2020-04-07.
// Copyright (c) 2020 Raimundas Sakalauskas. All rights reserved.
//

import Foundation

public enum AuthorizationStatus : CustomStringConvertible {
    case notDetermined
    case restricted
    case denied
    case authorized

    public var description: String {
        switch self {
            case .notDetermined:
                return "notDetermined"
            case .restricted:
                return "restricted"
            case .denied:
                return "denied"
            case .authorized:
                return "authorized"
        }
    }
}