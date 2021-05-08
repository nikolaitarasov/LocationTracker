//
//  SettingsTextFieldsHelper.swift
//  LocationTracking
//
//  Created by Mykola Tarasov on 5/7/21.
//

import UIKit

extension SettingsViewController {

    func textFieldDidEndEditing(_ textField: UITextField) {
        checkConfigurationIsMissing()
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        checkConfigurationIsMissing()

        // limit deviceIdTextField to 20 characters
        let text = textField.text ?? ""
        if textField == deviceIdTextField && text.count >= 20 {
            return false
        }
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
