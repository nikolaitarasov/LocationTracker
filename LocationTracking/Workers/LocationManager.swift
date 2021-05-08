//
//  LocationManager.swift
//  LocationManager
//
//  Created by Mykola Tarasov on 5/7/21.
//

import Foundation
import UIKit
import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {

    static let shared = LocationManager()
    private var locationManager: CLLocationManager = CLLocationManager()
    private var requestLocationAuthorizationCallback: ((CLAuthorizationStatus) -> Void)?
    var locationAuthorizationUpdatedToAlwaysCallback: (() -> Void)?
    let locationDataSender = LocationDataSender()

    override init() {
        super.init()

        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.distanceFilter = kCLDistanceFilterNone
    }

    func requestLocationAuthorization() {
        if #available(iOS 13.4, *) {
            self.requestLocationAuthorizationCallback = { status in
                if status == .authorizedWhenInUse {
                    self.locationManager.requestAlwaysAuthorization()
                }
            }
            self.locationManager.requestWhenInUseAuthorization()
        } else {
            self.locationManager.requestAlwaysAuthorization()
        }
    }

    func startUpdatingLocation() {
        self.locationManager.startMonitoringSignificantLocationChanges()
        self.locationManager.startUpdatingLocation()
    }

    func stopUpdatingLocation() {
        self.locationManager.stopMonitoringSignificantLocationChanges()
        self.locationManager.stopUpdatingLocation()
    }

    // MARK: - CLLocationManagerDelegate

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.requestLocationAuthorizationCallback?(status)
        if status == .authorizedWhenInUse {
            manager.startMonitoringSignificantLocationChanges()
            manager.startUpdatingLocation()
        } else if status == .denied || status == .restricted {
            manager.stopMonitoringSignificantLocationChanges()
            manager.stopUpdatingLocation()
        } else if status == .authorizedAlways {
            self.locationAuthorizationUpdatedToAlwaysCallback?()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let latitude = Float(location.coordinate.latitude)
            let longitude = Float(location.coordinate.longitude)
            print("lat: \(latitude)\nlon: \(longitude)")
            let userDefaults = UserDefaults.standard
            let endpoint = userDefaults.string(forKey: Keys.endpointId) ?? "unknown"
            let deviceIdStr = userDefaults.string(forKey: Keys.deviceId) ?? "unknown"
            let userLocation = UserLocationData(latitude, longitude, deviceIdStr)
            locationDataSender.send(to: endpoint, userLocation: userLocation)
        }
    }
}
