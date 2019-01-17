//
//  Alert.swift
//  Artable
//
//  Created by iain Allen on 07/01/2019.
//  Copyright © 2019 iain Allen. All rights reserved.
//

import Foundation
import UIKit

struct Alert {
    // MARK:  Alerts
    
    private static func  showBasicAlert(on vc: UIViewController, with title: String, message: String) {
        let alert = UIAlertController(title: title , message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        vc.present(alert, animated: true)
    }
    
    static func showIncompleteFormAlert(on vc: UIViewController) {
        showBasicAlert(on: vc, with: "Invomplete Form" , message: "Please fill out all fields in the form")
    }
    
}
