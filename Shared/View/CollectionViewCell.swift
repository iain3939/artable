//
//  CategoryCell.swift
//  Artable
//
//  Created by iain Allen on 03/03/2019.
//  Copyright © 2019 iain Allen. All rights reserved.
//

import UIKit
import Kingfisher

class CategoryCell: UICollectionViewCell {

    @IBOutlet weak var categoryImg: UIImageView!
    @IBOutlet weak var categoryNameLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        categoryImg.layer.cornerRadius = 5
    }
    
    func configureCell(with category: Category) {
        categoryNameLbl.text = category.name
        if let url = URL(string: category.imageUrl) {
            categoryImg.kf.setImage(with: url)
        }
        
    }

}
