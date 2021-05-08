//
//  UserLocationData.swift
//  LocationTracking
//
//  Created by Mykola Tarasov on 5/8/21.
//

import Foundation

struct UserLocationData: Codable {
    var latitude: Float
    var longitude: Float
    var deviceId: String

    init(_ latitude: Float, _ longitude: Float, _ deviceId: String) {
        self.latitude = latitude
        self.longitude = longitude
        self.deviceId = deviceId
    }
}
