//
//  AlertService.swift
//  Artable
//
//  Created by iain Allen on 07/01/2019.
//  Copyright © 2019 iain Allen. All rights reserved.
//

import Foundation
import UIKit
import Firebase

struct AlertService {
    // MARK:  Alerts
    
    private static func  showBasicAlert(on vc: UIViewController, with title: String, message: String) {
        let alert = UIAlertController(title: title , message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        vc.present(alert, animated: true)
    }
    
    static func showFirebaseError(on vc: UIViewController, error: Error) {
        if let errorCode = AuthErrorCode(rawValue: error._code) {
            showBasicAlert(on: vc, with: "Error" , message: errorCode.errorMessage)
        }
        
    }
    
    static func fillOutAllFieldsAlert(on vc: UIViewController) {
        showBasicAlert(on: vc, with: "Error", message:  "Please fill out all fields")
    }
    
    static func passConfirm(on vc: UIViewController) {
        showBasicAlert(on: vc, with: "Error", message: "Password do not match.")
    }
    
}

extension AuthErrorCode {
    var errorMessage: String {
        switch self {
        case .emailAlreadyInUse:
            return "The email is already in use with another account. Pick another email"
        case .userNotFound:
            return "Account not found for the specified user. Please check and try again"
        case .userDisabled:
            return "Your account has been disabled. Please contact support"
        case .invalidEmail, .invalidSender, .invalidRecipientEmail:
            return "Please enter a valid email"
        case .networkError:
            return "Network error. Please try again"
        case .weakPassword:
            return "Your password is too weak. The password must be 6 characters long or more."
        case.wrongPassword:
            return "Your password or email is incorrect"
        default:
            return "Sorry, something went wrong."
        }
        
    }
}
