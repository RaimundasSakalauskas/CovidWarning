//
//  ViewController.swift
//  CovidWarning
//
//  Created by Raimundas Sakalauskas on 2020-04-03.
//  Copyright © 2020 Raimundas Sakalauskas. All rights reserved.
//

import UIKit
import CoreLocation
import CoreBluetooth
import CoreLocation

class ViewController: UIViewController, CBPeripheralManagerDelegate, CLLocationManagerDelegate {
    @IBOutlet weak var proximityLabel: UILabel!
    
    let proximityUUID = UUID(uuidString:"D9882F69-32E7-41AC-B38D-E55699FC1905")
    let major: CLBeaconMajorValue = 100
    let minor: CLBeaconMinorValue = 1
    let beaconID = "com.example.myDeviceRegion"

    var peripheral: CBPeripheralManager!
    var locationManager: CLLocationManager!
    var beaconRegion: CLBeaconRegion!

    override func viewDidLoad() {
        super.viewDidLoad()

        peripheral = CBPeripheralManager(delegate: self, queue: nil)

        locationManager = CLLocationManager()
        locationManager.delegate = self

        if #available(iOS 13, *) {
            beaconRegion = CLBeaconRegion(uuid: proximityUUID!, major: major, minor: minor, identifier: beaconID)
        } else {
            beaconRegion = CLBeaconRegion(proximityUUID: proximityUUID!, major: major, minor: minor, identifier: beaconID)
        }

        proximityLabel.text = "Unknown"
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        evalLocationManagerAuthorization()
    }

    private func evalLocationManagerAuthorization() {
        switch CLLocationManager.authorizationStatus() {
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
            case .restricted:
                //do nothing
                break
            case .denied:
                //do nothing
                break
            case .authorizedAlways, .authorizedWhenInUse:
                print("CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) = \(CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self))")
                if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                    print("CLLocationManager.isRangingAvailable() = \(CLLocationManager.isRangingAvailable())")
                    if CLLocationManager.isRangingAvailable() {
                        startMonitoring()
                    }
                }
        }
    }

    private func startMonitoring() {
        print("locationManager.monitoredRegions.contains(beaconRegion) = \(locationManager.monitoredRegions.contains(beaconRegion))")
        //if !locationManager.monitoredRegions.contains(beaconRegion) {
            locationManager.startMonitoring(for: beaconRegion)
            locationManager.startRangingBeacons(in: beaconRegion)
        //}
    }


    //MARK: CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.evalLocationManagerAuthorization()
    }

    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        print("didStartMonitoringFor: \(region)")
    }

    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        print("didRangeBeacons \(beacons), region: \(region)")

        var nearestBeacon: CLBeacon?
        for beacon in beacons {
            if nearestBeacon == nil {
                nearestBeacon = beacon
            } else if beacon.accuracy > 0 && beacon.accuracy < nearestBeacon!.accuracy {
                nearestBeacon = beacon
            }
        }

        DispatchQueue.main.async { [weak self] in
           if let nearestBeacon = nearestBeacon {
               let distance = self?.getDistance(rssi: nearestBeacon.rssi, txPower: -60)
               self?.proximityLabel.text = String(format: "proximity: %@\r\ndistance: %.2fm +-%.2fm\r\nrssi: %idb", nearestBeacon.proximity.debugDescription, distance!, nearestBeacon.accuracy, nearestBeacon.rssi)
           } else {
               self?.proximityLabel.text = "Unknown"

           }
        }
    }

    func getDistance(rssi: Int, txPower: Double) -> Double {
        /*
         * RSSI = TxPower - 10 * n * lg(d)
         * n = 2 (in free space)
         *
         * d = 10 ^ ((TxPower - RSSI) / (10 * n))
         */

        return pow(10.0, (txPower - Double(rssi)) / (10 * 2))
    }

    @available(iOS 13, *)
    func locationManager(_ manager: CLLocationManager, didRange beacons: [CLBeacon], satisfying beaconConstraint: CLBeaconIdentityConstraint) {
        print("didRange \(beacons), beaconConstraint: \(beaconConstraint)")
        print("beaconConstraint = \(beaconConstraint)")
    }

    //MARK: CBPeripheralManagerDelegate
    func advertiseDevice(region : CLBeaconRegion) {
        let peripheralData = region.peripheralData(withMeasuredPower: nil)
        peripheral.startAdvertising(((peripheralData as NSDictionary) as! [String : Any]))
    }

    func peripheralManagerDidStartAdvertising(_ peripheral: CBPeripheralManager, error: Error?) {
        print("peripheralManagerDidStartAdvertising: \(peripheral)")
    }

    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        print("peripheral.state = \(peripheral.state)")
        switch peripheral.state {
            case .poweredOn:
                advertiseDevice(region: beaconRegion)
            default:
                //do nothing
                break
        }
    }


}




