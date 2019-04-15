//
//  AddEditProductsVC.swift
//  ArtableAdmin
//
//  Created by iain Allen on 28/03/2019.
//  Copyright © 2019 iain Allen. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore

class AddEditProductsVC: UIViewController {
    
    
    
    @IBOutlet weak var productNameTxt: UITextField!
    @IBOutlet weak var productPriceTxt: UITextField!
    @IBOutlet weak var productDescTxt: UITextView!
    @IBOutlet weak var productImgView: RoundedImageView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var addBtn: RoundedButton!
    
    var productToEdit: Product?
    var selectedCategory:  Category!
    
    var name = ""
    var price = 0.0
    var productDescription = ""
    
   

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(imgTaped(_:)))
        tap.numberOfTapsRequired = 1
        productImgView.isUserInteractionEnabled = true
        productImgView.addGestureRecognizer(tap)
        
        // if we are editing, productToEdit will != nil
        if let product = productToEdit {
            productNameTxt.text = product.name
            productPriceTxt.text = "\(product.price)"
            productDescTxt.text = product.productDescription
            if let url = URL(string: product.imageUrl) {
                productImgView.contentMode = .scaleAspectFill
                productImgView.kf.setImage(with: url)
                addBtn.setTitle("Save Changes", for: .normal)
            }
            
        }
        

        
    }
    
    
    @objc func imgTaped(_ tap: UITapGestureRecognizer) {
        launchImgPicker()
    }
    
    @IBAction func addWasPressed(_ sender: Any) {
        uploadImageThenDocument()
        
    }
    
    func uploadImageThenDocument() {
        guard let image = productImgView.image,
        let name = productNameTxt.text , name.isNotEmpty,
        let descriptionTxt = productDescTxt.text, descriptionTxt.isNotEmpty,
        let priceString = productPriceTxt.text,
            let price = Double(priceString)  else {
                AlertService.fillOutAllFieldsAlert(on: self)
                return }
        self.name = name
        self.productDescription = descriptionTxt
        self.price = price
        
        spinner.startAnimating()
        
        guard let imageData = image.jpegData(compressionQuality: 0.2) else { return }
        let imageRef = Storage.storage().reference().child("/productImages/\(name).jpg")
        
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        
        imageRef.putData(imageData, metadata: metaData) { (metaData, error) in
            if let error = error {
                self.handleError(error: error, msg: "Unable to upload image")
                return
                
            }
            imageRef.downloadURL(completion: { (url, error) in
                if let error = error {
                    self.handleError(error: error, msg: "Unable to download url")
                    return
                }
                guard let url = url else { return }
                print(url)
                self.uploadDocumnet(url: url.absoluteString)
            })
        }
        
        }
    
    func handleError(error: Error, msg: String) {
        debugPrint(error.localizedDescription)
        self.spinner.stopAnimating()
    
    }
    
    
    func uploadDocumnet(url: String) {
        var docRef: DocumentReference!
        var product = Product.init(name: name,
                                   id: "",
                                   category: selectedCategory.id,
                                   price: price,
                                   productDescription: productDescription,
                                   imgUrl: url)
        if let productToEdit = productToEdit {
            // we are  editing a product
            docRef = Firestore.firestore().collection("products").document(productToEdit.id)
            product.id = productToEdit.id
        } else {
            // we are adding a new product
            docRef = Firestore.firestore().collection("products").document()
            product.id = docRef.documentID
        }
        
        let data = Product.modelToData(product: product)
        docRef.setData(data, merge: true) { (error) in
            if let error = error {
                self.handleError(error: error, msg: "Unable to upload firestore Document")
                return
                
            }
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    

}

extension AddEditProductsVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func launchImgPicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else { return }
        productImgView.contentMode = .scaleToFill
        productImgView.image = image
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
}
