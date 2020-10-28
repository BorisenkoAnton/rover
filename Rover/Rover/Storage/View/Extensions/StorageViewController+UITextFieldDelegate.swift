//
//  StorageViewController+UITextFieldDelegate.swift
//  Rover
//
//  Created by Anton Borisenko on 10/27/20.
//  Copyright © 2020 Anton Borisenko. All rights reserved.
//

import UIKit

extension StorageViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if (textField.text != nil) && (textField.text != "") {
            self.storagePresenter.changeMapName(map: self.storedMaps[textField.tag], newName: textField.text!)
        }
    }
}
