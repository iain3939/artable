//
//  Constants.swift
//  Artable
//
//  Created by iain Allen on 07/01/2019.
//  Copyright © 2019 iain Allen. All rights reserved.
//

import Foundation
import UIKit

struct Storyboard  {
    static let loginStoryboard = "LoginStoryboard"
    static let main = "Main"
}

struct StoryboardId {
    static let loginVC = "LoginVC"
    
}

struct AppImages {
    static let greenCheck = "green_check"
    static let redCheck = "red_check"
    static let filledStar = "filled_star"
    static let emptyStar = "empty_star"
    static let placeHolder = "placeholder"
}

struct AppColors {
    static let blue = #colorLiteral(red: 0.2266720831, green: 0.2677738667, blue: 0.3618181348, alpha: 1)
    static let red = #colorLiteral(red: 0.8352941176, green: 0.3921568627, blue: 0.3137254902, alpha: 1)
    static let offWhite = #colorLiteral(red: 0.9490196078, green: 0.9529411765, blue: 0.968627451, alpha: 1)
}

struct Identifiers {
    static let categoryCell = "CategoryCell"
    static let productCell = "ProductCell"
    static let CartItemCell = "CartItemCell"
}

struct Segues {
    static let ToProducts = "toProductsVC"
    static let toAddEditCategory = "toAddEditCategory"
    static let ToEditCategory = "ToEditCategory"
    static let ToAddEditProduct = "ToAddEditProduct"
    static let toFavorites = "toFavorites"
}


