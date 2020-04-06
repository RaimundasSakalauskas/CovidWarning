//
// Created by Raimundas Sakalauskas on 2020-04-06.
// Copyright (c) 2020 Raimundas Sakalauskas. All rights reserved.
//

import Foundation
import CoreLocation

public class BeaconRegionFactory {
    public static let sharedUUID = UUID(uuidString:"D9882F69-32E7-41AC-B38D-E55699FC1905")!
    public static let sharedMajor: CLBeaconMajorValue = 100
    public static let sharedMinor: CLBeaconMinorValue = 1
    public static let sharedBeaconID = "com.pinstudios.covidWarning.sharedBeaconID"

    public static var sharedBeaconRegion: CLBeaconRegion = {
        return buildBeaconRegion()
    }()

    public static func buildBeaconRegion(uuid: UUID = BeaconRegionFactory.sharedUUID, major: CLBeaconMajorValue = BeaconRegionFactory.sharedMajor, minor: CLBeaconMinorValue = BeaconRegionFactory.sharedMinor, beaconId: String = BeaconRegionFactory.sharedBeaconID) -> CLBeaconRegion {

        if #available(iOS 13, *) {
            return CLBeaconRegion(uuid: uuid, major: major, minor: minor, identifier: beaconId)
        } else {
            return CLBeaconRegion(proximityUUID: uuid, major: major, minor: minor, identifier: beaconId)
        }
    }
}
