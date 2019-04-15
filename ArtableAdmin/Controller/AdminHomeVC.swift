//
//  AdminHomeVC.swift
//  ArtableAdmin
//
//  Created by iain Allen on 02/01/2019.
//  Copyright © 2019 iain Allen. All rights reserved.
//

import UIKit

class AdminHomeVC: HomeVC {
    
    @IBOutlet weak var addCategoryBtn: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem?.isEnabled = false
        
//        let addCategoryBtn = UIBarButtonItem(title: "+", style: .plain, target: self, action: #selector(addCategory))
//        navigationItem.rightBarButtonItem = addCategoryBtn
    }
    
    @IBAction func addCategory() {
        //segue to the add  category view
        performSegue(withIdentifier: Segues.toAddEditCategory, sender: self)
    }
    
//    @objc func  addCategory() {
//        //segue to the add  category view
//        performSegue(withIdentifier: Segues.toAddEditCategory, sender: self)
//    }


}

