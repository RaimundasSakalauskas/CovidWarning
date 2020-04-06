//
//  BeaconRegionFactoryTests.swift
//  CovidWarningTests
//
//  Created by Raimundas Sakalauskas on 2020-04-06.
//  Copyright © 2020 Raimundas Sakalauskas. All rights reserved.
//

import XCTest
import CoreLocation
@testable import CovidWarning

class BeaconRegionFactoryTests: XCTestCase {

    private let customMajor: UInt16 = 50
    private let customMinor: UInt16 = 30
    private let customID = "custom.string.identifier"
    private let customUUID = UUID(uuidString: "949678AE-EE99-4798-97F1-D013F6612728")!
    
    func test_beaconInitDefaultValues_notNil() {
        let sut: CLBeaconRegion = BeaconRegionFactory.buildBeaconRegion()
        
        XCTAssertNotNil(sut)
    }

    func test_beaconInitDefaultValues_doesNotMatchCustomValues() {
        let sut: CLBeaconRegion = BeaconRegionFactory.buildBeaconRegion()
        
        XCTAssertNotEqual(sut.major, NSNumber(value: customMajor))
        XCTAssertNotEqual(sut.minor, NSNumber(value: customMinor))
        XCTAssertNotEqual(sut.identifier, customID)
        XCTAssertNotEqual(sut.uuid, customUUID)
    }
    
    func test_beaconInitCustomValues_doesNotMatchCustomValues() {
        //build using different default params
        var sut: CLBeaconRegion = BeaconRegionFactory.buildBeaconRegion(uuid: customUUID)
        XCTAssertNotEqual(sut.major, NSNumber(value: customMajor))
        XCTAssertNotEqual(sut.minor, NSNumber(value: customMinor))
        XCTAssertNotEqual(sut.identifier, customID)
        XCTAssertEqual(sut.uuid, customUUID)

        sut = BeaconRegionFactory.buildBeaconRegion(uuid: customUUID, major: customMajor)
        XCTAssertEqual(sut.major, NSNumber(value: customMajor))
        XCTAssertNotEqual(sut.minor, NSNumber(value: customMinor))
        XCTAssertNotEqual(sut.identifier, customID)
        XCTAssertEqual(sut.uuid, customUUID)

        sut = BeaconRegionFactory.buildBeaconRegion(uuid: customUUID, major: customMajor, minor: customMinor)
        
        XCTAssertEqual(sut.major, NSNumber(value: customMajor))
        XCTAssertEqual(sut.minor, NSNumber(value: customMinor))
        XCTAssertNotEqual(sut.identifier, customID)
        XCTAssertEqual(sut.uuid, customUUID)
        
        sut = BeaconRegionFactory.buildBeaconRegion(uuid: customUUID, major: customMajor, minor: customMinor, beaconId: customID)
        
        XCTAssertEqual(sut.major, NSNumber(value: customMajor))
        XCTAssertEqual(sut.minor, NSNumber(value: customMinor))
        XCTAssertEqual(sut.identifier, customID)
        XCTAssertEqual(sut.uuid, customUUID)
    }
    
    func test_sharedBeaconRegion_notNil() {
        let sut: CLBeaconRegion = BeaconRegionFactory.sharedBeaconRegion
        
        XCTAssertNotNil(sut)
    }
    

}
