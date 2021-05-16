//
//  SettingsViewController.swift
//  LocationTracking
//
//  Created by Mykola Tarasov on 5/7/21.
//

import UIKit
import CoreLocation

class SettingsViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var configureAppText: UILabel!
    @IBOutlet weak var trackingSwitch: UISwitch!
    @IBOutlet weak var trackingLabel: UILabel!
    @IBOutlet weak var endpointTextField: UITextField!
    @IBOutlet weak var deviceIdTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // set delegates
        endpointTextField.delegate = self
        deviceIdTextField.delegate = self

        let userDefaults = UserDefaults.standard
        endpointTextField.text = userDefaults.string(forKey: Keys.endpointId)
        deviceIdTextField.text = userDefaults.string(forKey: Keys.deviceId)

        updateLocationTrackingStatus()

        NotificationCenter.default.addObserver(self, selector: #selector(appDidBecomeActive),
                                               name: UIApplication.didBecomeActiveNotification,
                                               object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

        checkConfigurationIsMissing()
    }

    @objc func appDidBecomeActive() {
        updateLocationTrackingStatus()
    }

    func updateLocationTrackingStatus() {
        let locStatus = CLLocationManager.authorizationStatus()
        trackingSwitch.isOn = locStatus == .authorizedAlways || locStatus == .authorizedWhenInUse
        if trackingSwitch.isOn {
            trackingLabel.text = "Location tracking is active"
            LocationManager.shared.startUpdatingLocation()
        } else {
            trackingLabel.text = "Activate tracking"
            LocationManager.shared.stopUpdatingLocation()
        }
    }

    func checkConfigurationIsMissing() {
        if let text1 = endpointTextField.text,
           let text2 = deviceIdTextField.text,
           text1 != "" || text2 != "" {
            configureAppText.isHidden = true
            trackingSwitch.isEnabled = true
            trackingLabel.isEnabled = true
        } else {
            configureAppText.isHidden = false
            trackingSwitch.isEnabled = false
            trackingSwitch.isOn = false
            trackingLabel.isEnabled = false
        }
    }

    @IBAction func trackingSwitchPressed(_ sender: Any) {
        // check Location Services disabled
        let locStatus = CLLocationManager.authorizationStatus()
        if trackingSwitch.isOn
            && (locStatus == .denied || locStatus == .restricted) {
            trackingSwitch.isOn = false
            displayOkAlert(title: "Location Services are disabled",
                           message: "Please enable Location Services in Settings")
            return
        }
        // update text label
        if trackingSwitch.isOn {
            if locStatus == .notDetermined {
                // request location authorization
                let sharedLocactionManager = LocationManager.shared
                sharedLocactionManager.locationAuthorizationUpdatedToAlwaysCallback = {
                    self.showLocationTrackingAnimation()
                }
                sharedLocactionManager.requestLocationAuthorization()
            } else {
                LocationManager.shared.startUpdatingLocation()
                showLocationTrackingAnimation()
            }
            trackingLabel.text = "Location tracking is active"
        } else {
            LocationManager.shared.stopUpdatingLocation()
            trackingLabel.text = "Activate tracking"
        }
    }

    @IBAction func savePressed(_ sender: Any) {
        // quit test fields when editing
        endpointTextField.resignFirstResponder()
        deviceIdTextField.resignFirstResponder()
        // save text fields inputs
        let userDefaults = UserDefaults.standard
        userDefaults.set(endpointTextField.text, forKey: Keys.endpointId)
        userDefaults.set(deviceIdTextField.text, forKey: Keys.deviceId)

        if let button = sender as? UIButton {
            springSaveButton(button: button)
        }
    }
    
    // Private functions

    func showLocationTrackingAnimation() {
        let origin = trackingLabel.frame.origin
        let frame = CGRect(x: origin.x+55, y: origin.y-55, width: 45, height: 45)
        guard let locationImageView = UIImageView.fromGif(frame: frame, resourceName: "location-update") else { return }
        view.addSubview(locationImageView)
        locationImageView.startAnimating()
        UIView.animate(withDuration: 1.1, delay: 0.0, options: .curveEaseIn, animations: {
            locationImageView.alpha = 0.0
        }, completion: { _ in
            locationImageView.animationImages = nil
            locationImageView.removeFromSuperview()
        })
    }

    private func showToast(message: String) {
        let origin = saveButton.frame.origin
        let toastLabel = UILabel(frame: CGRect(x: origin.x+5, y: origin.y-50, width: 140, height: 30))
        toastLabel.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        //toastLabel.textColor = UIColor.white
        toastLabel.font = .systemFont(ofSize: 16)
        toastLabel.textAlignment = .center
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 1.5, delay: 0.1, options: .curveEaseIn, animations: {
             toastLabel.alpha = 0.0
        }, completion: { success in
            if success {
                toastLabel.removeFromSuperview()
            }
        })
    }

    private func springSaveButton(button: UIButton) {
        let bounds = button.bounds
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 10, options: .curveEaseOut) {
            button.bounds = CGRect(x: bounds.origin.x - 20, y: bounds.origin.y, width: bounds.size.width + 50, height: bounds.size.height)
        } completion: { success in
            if success {
                //UIView.animate(withDuration: 0.2) {
                    button.bounds = bounds
                //}
            }
        }

    }

    private func displayOkAlert(title: String? = nil, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
}
