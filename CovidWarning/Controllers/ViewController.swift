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

class ViewController : UIViewController, BroadcastingManagerDelegate, MonitoringManagerDelegate {
    @IBOutlet weak var proximityLabel: UILabel!
    @IBOutlet weak var broadcastingLabel: UILabel!
    @IBOutlet weak var monitoringLabel: UILabel!
        
    private var broadcastingManager: BroadcastingManager!
    private var monitoringManager: MonitoringManager!  
    
    override func viewDidLoad() {
        super.viewDidLoad()

        broadcastingManager = BroadcastingManager()
        broadcastingManager.delegate = self

        monitoringManager = MonitoringManager()
        monitoringManager.delegate = self

        proximityLabel.text = "Unknown"
        monitoringLabel.text = "Monitoring disabled"
        broadcastingLabel.text = "Not broadcasting position"
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        evalBroadcastingManagerAuthorization()
        evalLocationManagerAuthorization()
    }





    private func evalLocationManagerAuthorization() {
        let authorizationState = monitoringManager.getAuthorizationStatus()

        NSLog("evalLocationManagerAuthorization = \(authorizationState)")
        var statusText: String?

        switch authorizationState {
            case .authorized:
                statusText = "Monitoring enabled"
                monitoringManager.startMonitoring(region: BeaconRegionFactory.sharedBeaconRegion)
            case .notDetermined:
                statusText = "Monitoring disabled"
                //trigger authorization request
                monitoringManager.prepare()
            case .restricted:
                statusText = "Location Services are restricted. Ask your manager to enable it."
            case .denied:
                statusText = "Please enable Location Services permission for this app. You can do this in settings"
        }

        DispatchQueue.main.async { [weak self, statusText] in
            self?.monitoringLabel.text = statusText
        }
    }

    private func evalBroadcastingManagerAuthorization() {
        let managerState = broadcastingManager.getManagerStatus()
        let authorizationState = broadcastingManager.getAuthorizationStatus()

        NSLog("evalBroadcastingManagerAuthorization = \(authorizationState) managerState = \(managerState)")

        var statusText = "Not broadcasting position"

        //we shouldn't advertise if at least one of these conditions is false
        if (managerState != .ready && broadcastingManager.isAdvertising()) {
            broadcastingManager.stopAdvertising()
        }

        switch authorizationState {
            case .authorized:
                broadcastingManager.prepare()

                if (managerState == .ready) {
                    statusText = "Broadcasting position"

                    //start advertising
                    if (!broadcastingManager.isAdvertising()) {
                        broadcastingManager.startAdvertising(region: BeaconRegionFactory.sharedBeaconRegion)
                    }
                } else if (managerState == .poweredOff) {
                    statusText = "Bluetooth is turned off. Please power it on."
                }
            case .notDetermined:
                //trigger authorization request
                broadcastingManager.prepare()
            case .restricted:
                statusText = "Bluetooth is restricted. Ask your manager to enable it."
            case .denied:
                statusText = "Please enable bluetooth permission for this app. You can do this in settings"
        }

        DispatchQueue.main.async { [weak self, statusText] in
            self?.broadcastingLabel.text = statusText
        }
    }

    //MARK: MonitoringManagerDelegate
    func didChangeAuthorizationStatus(manager: MonitoringManager, status: AuthorizationStatus) {
        DispatchQueue.main.async { [weak self] in
            self?.evalLocationManagerAuthorization()
        }
    }

    func didMonitorBeacon(manager: MonitoringManager, beacons: [CLBeacon], nearestBeacon: CLBeacon?) {
        DispatchQueue.main.async { [weak self, nearestBeacon] in
            if let nearestBeacon = nearestBeacon {
                let distance = nearestBeacon.getDistance(txPower: -60)
                self?.proximityLabel.text = String(format: "distance: %.2fm", distance)
            } else {
                self?.proximityLabel.text = "Unknown"
            }
        }
    }

    //MARK: BroadcastingManagerDelegate
    func didChangeAuthorizationStatus(manager: BroadcastingManager, status: AuthorizationStatus) {
        DispatchQueue.main.async { [weak self] in
            self?.evalBroadcastingManagerAuthorization()
        }
    }

    func didChangeManagerStatus(manager: BroadcastingManager, status: ManagerStatus) {
        DispatchQueue.main.async { [weak self] in
            self?.evalBroadcastingManagerAuthorization()
        }
    }
}




