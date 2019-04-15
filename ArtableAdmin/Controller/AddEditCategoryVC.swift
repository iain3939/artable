//
//  AddEditCategoryVC.swift
//  ArtableAdmin
//
//  Created by iain Allen on 25/03/2019.
//  Copyright © 2019 iain Allen. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore


class AddEditCategoryVC: UIViewController {

    @IBOutlet weak var nameTxt: UITextField!
    @IBOutlet weak var categoryImg: RoundedImageView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var addBtn: RoundedButton!
    
    var categoryToEdit: Category?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(imgTaped(_:)))
        tap.numberOfTapsRequired = 1
        categoryImg.isUserInteractionEnabled = true
        categoryImg.addGestureRecognizer(tap)
        
        // If we are editing, categoryToEdit will != nil
        if let category = categoryToEdit {
            nameTxt.text = category.name
            if let url = URL(string: category.imgUrl) {
                categoryImg.contentMode = .scaleAspectFill
                categoryImg.kf.setImage(with: url)
                addBtn.setTitle("Save Changes", for: .normal)
            }
        }

        
    }
    
    @objc func imgTaped(_ tap: UITapGestureRecognizer) {
        launchImgPicker()
    }
    

    
    @IBAction func addCategoryWasPressed(_ sender: Any) {
        
        uploadImageThenDocument()
    }
    
    func uploadImageThenDocument() {
        guard let image = categoryImg.image,
            let categoryName = nameTxt.text, categoryName.isNotEmpty else { AlertService.addCategoryErrorMessage(on: self)
            return }
        spinner.startAnimating()
        guard let imageData = image.jpegData(compressionQuality: 0.2) else { return }
        
        let imageRef = Storage.storage().reference().child("/categoryImages/\(categoryName).jpg")
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        
        imageRef.putData(imageData, metadata: metaData) { (metaData, error) in
            if let error = error {
                self.handleError(error: error, msg: "unable to upload  new image")
                return
            }
            imageRef.downloadURL(completion: { (url, error) in
                if let error = error {
                     self.handleError(error: error, msg: "unable to retrive url")
                    return
                }
                guard let url = url else { return }
                print("Iain:\(url)")
                self.uploadDocument(url: url.absoluteString)
            })
        }
        
    }
    
    func uploadDocument(url: String) {
        var docRef: DocumentReference!
        var category = Category.init(name: nameTxt.text!,
                                     id: "",
                                     imgUrl: url,
                                     timeStamp: Timestamp())
        
        if let categoryToEdit = categoryToEdit {
            // we are editing
            docRef = Firestore.firestore().collection("categories").document(categoryToEdit.id)
            category.id = categoryToEdit.id
        } else {
            // new category
            docRef = Firestore.firestore().collection("categories").document()
            category.id = docRef.documentID
        }
        
        let data = Category.modelToData(category: category)
        docRef.setData(data, merge: true) { (error) in
            if let error = error {
                self.handleError(error: error, msg: "unable to upload new category to firestore")
                return
            }
            
             self.navigationController?.popViewController(animated: true)
        }
            
            
        
    }
        
        
    
    
    func handleError(error: Error, msg: String) {
        debugPrint(error.localizedDescription)
        self.spinner.stopAnimating()
        
    }
    
}

extension AddEditCategoryVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func launchImgPicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else { return }
        categoryImg.contentMode = .scaleToFill
        categoryImg.image = image
        dismiss(animated: true, completion: nil)
        
       
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
