//
//  SettingsTextFieldsHelper.swift
//  LocationTracking
//
//  Created by Mykola Tarasov on 5/7/21.
//

import UIKit

extension SettingsViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {

    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        checkConfigurationIsMissing()
    }

//    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//        return true;
//    }
//    func textFieldShouldClear(_ textField: UITextField) -> Bool {
//        return true;
//    }
//    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
//        return true;
//    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        checkConfigurationIsMissing()
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
