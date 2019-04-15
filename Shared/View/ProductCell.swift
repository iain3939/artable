//
//  ProductCell.swift
//  Artable
//
//  Created by iain Allen on 03/03/2019.
//  Copyright © 2019 iain Allen. All rights reserved.
//

import UIKit
import Kingfisher

protocol ProductCellDelegate: class {
    func productFavorited(product: Product)
    func productAddedToCheckout(product: Product)
}

class ProductCell: UITableViewCell {
    
    
    @IBOutlet weak var productImg: RoundedImageView!
    @IBOutlet weak var productTitleLbl: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var favoriteBtn: UIButton!
    
    weak var delegate: ProductCellDelegate?
    
    private var product: Product!

    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(with product: Product, delegate: ProductCellDelegate) {
        self.product = product
        self.delegate = delegate
        productTitleLbl.text = product.name
        
        
        if let url = URL(string: product.imageUrl) {
            productImg.kf.setImage(with: url)
            let placeholder = UIImage(named: AppImages.placeHolder)
            productImg.kf.indicatorType = .activity
            let options: KingfisherOptionsInfo = [KingfisherOptionsInfoItem.transition(.fade(0.1))]
            productImg.kf.setImage(with: url, placeholder: placeholder, options: options)
        }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        if let price = formatter.string(from: product.price as NSNumber) {
            productPrice.text = price
        }
        
        if UserService.favorites.contains(product) {
            favoriteBtn.setImage(UIImage(named: AppImages.filledStar), for: .normal)
        } else {
            favoriteBtn.setImage(UIImage(named: AppImages.emptyStar), for: .normal)
        }
        
        
    }

    
    @IBAction func addToCartWasPressed(_ sender: RoundedButton) {
        delegate?.productAddedToCheckout(product: product)
    }
    
    @IBAction func favoriteWasPressed(_ sender: Any) {
        delegate?.productFavorited(product: product)
    }
}
