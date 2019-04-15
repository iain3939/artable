//
//  AdminProductsVC.swift
//  ArtableAdmin
//
//  Created by iain Allen on 28/03/2019.
//  Copyright © 2019 iain Allen. All rights reserved.
//

import UIKit

class AdminProductsVC: ProductsVC {
    
    @IBOutlet weak var editCategoryButton: UIBarButtonItem!
    @IBOutlet weak var newProductButton: UIBarButtonItem!
    
    var selectedProduct: Product?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        

//        let editCategoryButton = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editCategory))
//        let newProductButton = UIBarButtonItem(title: "+", style: .plain, target: self, action: #selector(newProduct))
//        navigationItem.setRightBarButtonItems([editCategoryButton, newProductButton], animated: true)
    }
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        products.removeAll()
        tableView.reloadData()
    }
    
    
    @IBAction func editCategoryWasPressed() {
         performSegue(withIdentifier: Segues.ToEditCategory, sender: self)
    }
    
    @IBAction func newProductWasPRessed() {
        performSegue(withIdentifier: Segues.ToAddEditProduct, sender: self)
    }
    
//    @objc func editCategory() {
//        performSegue(withIdentifier: Segues.ToEditCategory, sender: self)
//    }
//
//    @objc func newProduct() {
//        performSegue(withIdentifier: Segues.ToAddEditProduct, sender: self)
//    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedProduct = products[indexPath.row]
        performSegue(withIdentifier: Segues.ToAddEditProduct, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.ToAddEditProduct {
            if let destination = segue.destination as? AddEditProductsVC {
                destination.selectedCategory = category
                destination.productToEdit = selectedProduct
            }
            
        } else if segue.identifier == Segues.ToEditCategory {
            if let destination = segue.destination as? AddEditCategoryVC {
                destination.categoryToEdit = category
            }
        }
    }
    

   

}
