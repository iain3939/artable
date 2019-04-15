//
//  RegisterVC.swift
//  Artable
//
//  Created by iain Allen on 02/01/2019.
//  Copyright © 2019 iain Allen. All rights reserved.
//

import UIKit
import Firebase

class RegisterVC: UIViewController {
    // MARK: IBOutlets
    
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var confirmPassTxt: UITextField!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var passCheckImg: UIImageView!
    @IBOutlet weak var confirmPassImg: UIImageView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        passwordTxt.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        confirmPassTxt.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        
        
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        guard let passTxt = passwordTxt.text else { return }
        
        if textField == confirmPassTxt {
            passCheckImg.isHidden = false
            confirmPassImg.isHidden = false
        } else {
            if passTxt.isEmpty {
                passCheckImg.isHidden = true
                confirmPassImg.isHidden = true
                confirmPassTxt.text = ""
            }
        }
        
        // Make it so that the passowrds match
        if passwordTxt.text == confirmPassTxt.text {
            passCheckImg.image = UIImage(named: AppImages.greenCheck)
            confirmPassImg.image = UIImage(named: AppImages.greenCheck)
        } else {
            passCheckImg.image = UIImage(named: AppImages.redCheck)
            confirmPassImg.image = UIImage(named: AppImages.redCheck)
            
        }
    }
    
    // MARK: IBActions
    
    @IBAction func registerClicked(_ sender: Any) {
        
        guard let email = emailTxt.text , email.isNotEmpty,
            let username = usernameTxt.text, username.isNotEmpty,
            let password = passwordTxt.text, password.isNotEmpty else {
                AlertService.fillOutAllFieldsAlert(on: self)
                return }
        
        guard let confirmPass = confirmPassTxt.text, confirmPass == password else { AlertService.passConfirm(on: self)
            return
            
        }
        
        spinner.startAnimating()
        
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if let error = error {
                debugPrint(error)
                AlertService.showFirebaseError(on: self, error: error)
                return
            }
            guard let fireUser = result?.user else { return }
            let artUser = User.init(id: fireUser.uid, email: email, username: username, stripeId: "")
            self.createFirestoreUser(user: artUser)
            
        }
        
//        guard let authUser = Auth.auth().currentUser else { return }
//        let credential = EmailAuthProvider.credential(withEmail: email, password: password)
//        authUser.linkAndRetrieveData(with: credential) { (authUser, error) in
//
//
//            self.spinner.stopAnimating()
//            print("Successfully register new user!!")
//            self.dismiss(animated: true, completion: nil)
//        }
    }
    
    func createFirestoreUser(user: User) {
        let newUserRef = Firestore.firestore().collection("users").document(user.id)
        let data = User.modelToData(user: user)
        newUserRef.setData(data) { (error) in
            if let error = error {
                AlertService.showFirebaseError(on: self, error: error)
                debugPrint("Error Unalble to upload new user document\(error.localizedDescription)")
                
            } else {
                self.dismiss(animated: true, completion:    nil)
                self.spinner.stopAnimating()
            }
        }
    }
}




