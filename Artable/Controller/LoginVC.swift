//
//  LoginVC.swift
//  Artable
//
//  Created by iain Allen on 02/01/2019.
//  Copyright © 2019 iain Allen. All rights reserved.
//

import UIKit
import Firebase


class LoginVC: UIViewController {
    
    // MARK: IBOutlets

    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    
    

    @IBAction func loginWasPressed(_ sender: Any) {
        
        guard let email = emailTxt.text, email.isNotEmpty,
            let password = passwordTxt.text, password.isNotEmpty else {
                AlertService.fillOutAllFieldsAlert(on: self)
                return }
        spinner.startAnimating()
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if let error = error {
                debugPrint(error.localizedDescription)
                AlertService.showFirebaseError(on: self, error: error)
                self.spinner.stopAnimating()
                return
            }
            self.spinner.stopAnimating()
            
            print("*** Successfully login...")
        self.dismiss(animated: true, completion: nil)
        }    }
    
    @IBAction func forgotPassWasPressed(_ sender: Any) {
        let vc = ForgotPasswordVC()
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: true, completion: nil)
        
    
    }
    
    @IBAction func guessedWasPressed(_ sender: Any) {
    }
    
    
}
