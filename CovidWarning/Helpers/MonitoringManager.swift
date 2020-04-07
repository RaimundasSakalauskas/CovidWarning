//
// Created by Raimundas Sakalauskas on 2020-04-07.
// Copyright (c) 2020 Raimundas Sakalauskas. All rights reserved.
//

import Foundation
import CoreLocation

protocol MonitoringManagerDelegate {
    func didChangeAuthorizationStatus(manager: MonitoringManager, status: AuthorizationStatus)
    func didMonitorBeacon(manager: MonitoringManager, beacons: [CLBeacon], nearestBeacon: CLBeacon?)
}

class MonitoringManager: NSObject, CLLocationManagerDelegate {
    var locationManager: CLLocationManager

    public var delegate: MonitoringManagerDelegate?

    override init() {
        locationManager = CLLocationManager()
        super.init()
        locationManager.delegate = self
    }

    func getAuthorizationStatus() -> AuthorizationStatus {
        switch CLLocationManager.authorizationStatus() {
            case .notDetermined:
                return .notDetermined
            case .restricted:
                return .restricted
            case .denied:
                return .denied
            case .authorizedAlways, .authorizedWhenInUse, .authorized:
                return .authorized
            @unknown default:
                return .denied
        }
    }

    @discardableResult func startMonitoring(region: CLBeaconRegion) -> Bool {
        if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
            if CLLocationManager.isRangingAvailable() {
                locationManager.startMonitoring(for: region)
                if #available(iOS 13, *) {
                    locationManager.startRangingBeacons(satisfying: CLBeaconIdentityConstraint(uuid: region.uuid))
                } else {
                    locationManager.startRangingBeacons(in: region)
                }

                return true
            }
        }

        return false
    }

    func prepare() {
        locationManager.requestWhenInUseAuthorization()
    }

    func isMonitoring(region: CLBeaconRegion) -> Bool {
        return locationManager.monitoredRegions.contains(region)
    }

    @discardableResult func stopMonitoring(region: CLBeaconRegion) -> Bool {
        if #available(iOS 13, *) {
            locationManager.stopRangingBeacons(satisfying: CLBeaconIdentityConstraint(uuid: region.uuid))
        } else {
            locationManager.stopRangingBeacons(in: region)
        }

        locationManager.stopMonitoring(for: region)

        return true
    }

    //MARK: CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        delegate?.didChangeAuthorizationStatus(manager: self, status: getAuthorizationStatus())
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

        delegate?.didMonitorBeacon(manager: self, beacons: beacons, nearestBeacon: nearestBeacon)
    }
}
