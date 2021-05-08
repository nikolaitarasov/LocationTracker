//
//  LocationDataSender.swift
//  LocationTracking
//
//  Created by Mykola Tarasov on 5/8/21.
//

import Foundation

struct LocationDataSender {

    func send(to endpoint: String?, userLocation: UserLocationData) {
        guard let endpoint = endpoint else {
            print("Error: Invalid or missing endpoint")
            return
        }
        guard let requestUrl = URL(string: endpoint) else { return }
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "POST"
        do {
            let json = try JSONEncoder().encode(userLocation)
            request.httpBody = json
        } catch let error {
            print("Can't encode JSON: \(error.localizedDescription)")
        }
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            //TODO: Need valid endpoint
            /*if let error = error {
                print("Error took place \(error)")
                return
            }

            if let data = data, let dataString = String(data: data, encoding: .utf8) {
                print("Response data string:\n \(dataString)")
            }*/
        }
        task.resume()
    }
}
