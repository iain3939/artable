//
//  ForgotPassword.swift
//  Artable
//
//  Created by iain Allen on 07/02/2019.
//  Copyright © 2019 iain Allen. All rights reserved.
//

import UIKit
import Firebase

class ForgotPasswordVC: UIViewController {
    @IBOutlet weak var emailTxt: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func canceledWasPressed(_ sender: RoundedButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func resetWasPressed(_ sender: RoundedButton) {
        guard let email = emailTxt.text, email.isNotEmpty else { AlertService.resetEmail(on: self)
            return }
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            if let error = error {
                debugPrint(error)
                AlertService.showFirebaseError(on: self, error: error)
                return
            }
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    
    

}
