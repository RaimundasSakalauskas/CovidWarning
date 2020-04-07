//
// Created by Raimundas Sakalauskas on 2020-04-07.
// Copyright (c) 2020 Raimundas Sakalauskas. All rights reserved.
//

import Foundation
import CoreBluetooth
import CoreLocation

protocol BroadcastingManagerDelegate {
    func didChangeAuthorizationStatus(manager: BroadcastingManager, status: AuthorizationStatus)
    func didChangeManagerStatus(manager: BroadcastingManager, status: ManagerStatus)
}

class BroadcastingManager: NSObject, CBPeripheralManagerDelegate, CBPeripheralDelegate {

    public var delegate: BroadcastingManagerDelegate?

    private var peripheralManager: CBPeripheralManager!

    func getAuthorizationStatus() -> AuthorizationStatus {
        if #available(iOS 13.1, *) {
            switch CBCentralManager.authorization {
                case .notDetermined:
                    return .notDetermined
                case .restricted:
                    return .restricted
                case .denied:
                    return .denied
                case .allowedAlways:
                    return .authorized
                @unknown default:
                    return .denied
            }
        } else {
            //even though this is deprecated for 13.0 - it works
            switch CBPeripheralManager.authorizationStatus() {
                case .notDetermined:
                    return .notDetermined
                case .restricted:
                    return .restricted
                case .denied:
                    return .denied
                case .authorized:
                    return .authorized
                @unknown default:
                    return .denied
            }
        }
    }

    func getManagerStatus() -> ManagerStatus {
        guard peripheralManager != nil else {
            return .notReady
        }

        switch peripheralManager.state {
            case .unsupported:
                //this should never because its prevented by hardware requirement in info.plist
                fatalError("peripheral manager state unsupported is unexpected")
            case .unauthorized:
                return .unauthorized
            case .poweredOff:
                return .poweredOff
            case .unknown, .resetting:
                return .notReady
            case .poweredOn:
                return .ready
        }
    }


    func prepare() {
        if (peripheralManager == nil) {
            //this will trigger request for BLE if current status is undetermined
            peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
        }
    }

    @discardableResult func startAdvertising(region: CLBeaconRegion) -> Bool {
        guard peripheralManager != nil else {
            return false
        }

        let peripheralData = region.peripheralData(withMeasuredPower: nil)
        peripheralManager.startAdvertising(((peripheralData as NSDictionary) as! [String : Any]))
        return true
    }

    func isAdvertising() -> Bool {
        guard peripheralManager != nil else {
            return false
        }

        return peripheralManager.isAdvertising
    }

    @discardableResult func stopAdvertising() -> Bool {
        guard peripheralManager != nil else {
            return false
        }

        peripheralManager.stopAdvertising()
        return true
    }

    //MARK: CBPeripheralManagerDelegate
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        delegate?.didChangeAuthorizationStatus(manager: self, status: getAuthorizationStatus())
        delegate?.didChangeManagerStatus(manager: self, status: getManagerStatus())
    }

    func peripheralManagerDidStartAdvertising(_ peripheral: CBPeripheralManager, error: Error?) {
        print("peripheralManagerDidStartAdvertising: \(peripheral)")
    }
}

