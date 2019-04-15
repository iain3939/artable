//
//  ProductsVC.swift
//  Artable
//
//  Created by iain Allen on 03/03/2019.
//  Copyright © 2019 iain Allen. All rights reserved.
//

import UIKit

import FirebaseFirestore

class ProductsVC: UIViewController, ProductCellDelegate {
    
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var products = [Product]()
    var category: Category!
    var db: Firestore!
    var listener: ListenerRegistration!
    var showFavorites = false
    

    override func viewDidLoad() {
        
        super.viewDidLoad()
        db = Firestore.firestore()
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: Identifiers.productCell, bundle: nil), forCellReuseIdentifier: Identifiers.productCell)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupProductsListener()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        listener.remove()
    }
    
    
    
    func setupProductsListener() {
        var ref: Query!
        if showFavorites {
            ref  = db.collection("users").document(UserService.user.id).collection("favorites")
        } else {
            ref = db.products(category: category.id)
        }
        
        listener = ref.addSnapshotListener({ (snap, error) in
            if let error = error {
                debugPrint(error.localizedDescription)
                return
            }
            
            snap?.documentChanges.forEach({ (change) in
                let data = change.document.data()
                let product = Product.init(data: data)
                
                switch change.type {
                case.added:
                    self.onDocumentAdded(change: change, product: product)
                case.modified:
                    self.onDocumentModified(change: change, product: product)
                case.removed:
                    self.onDocumentRemoved(change: change)
                }
            })
        })
    
    }
    
    func productFavorited(product: Product) {
        UserService.favoriteSelected(product: product)
        guard let index = products.firstIndex(of: product) else { return }
        tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }
    
    func productAddedToCheckout(product: Product) {
       StripeCart.addItemToCart(item: product)
        
    }
}

extension ProductsVC: UITableViewDelegate, UITableViewDataSource {
    
    func onDocumentAdded(change: DocumentChange, product: Product) {
        let newIndex = Int(change.newIndex)
        products.insert(product, at: newIndex)
        tableView.insertRows(at: [IndexPath(item: newIndex, section: 0)], with: .automatic)
    }
    
    func onDocumentModified(change: DocumentChange, product: Product) {
        if change.newIndex == change.oldIndex {
            //Item changed, but remained in the same position
            let index = Int(change.newIndex)
            products[index] = product
            tableView.reloadRows(at: [IndexPath(item: index, section: 0)], with: .automatic)
        } else {
            // Item changed and changed position
            let oldIndex = Int(change.oldIndex)
            let newIndex = Int(change.newIndex)
            products.remove(at: oldIndex)
            products.insert(product, at: newIndex)
            tableView.moveRow(at: IndexPath(item: oldIndex, section: 0), to: IndexPath(item: newIndex, section: 0))
        }
    }
    
    func onDocumentRemoved(change: DocumentChange) {
        let oldIndex = Int(change.oldIndex)
        products.remove(at: oldIndex)
        tableView.deleteRows(at: [IndexPath(item: oldIndex, section: 0)], with: .automatic)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.productCell, for: indexPath) as? ProductCell {
            cell.configureCell(with: products[indexPath.row], delegate: self)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ProductDetailVC()
        let selectedProduct = products[indexPath.row]
        vc.product = selectedProduct
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    
    
    
}
