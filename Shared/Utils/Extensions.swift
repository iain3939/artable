//
//  Extensions.swift
//  Artable
//
//  Created by iain Allen on 03/01/2019.
//  Copyright © 2019 iain Allen. All rights reserved.
//

import UIKit
import Firebase

extension String {
    var isNotEmpty: Bool {
        return !isEmpty
    }
}


extension Firestore{
    var categories: Query {
        return collection("categories").order(by: "timeStamp", descending: true)
        
        
        
    }
}

extension Firestore {
    func products(category: String) -> Query {
        return collection("products").whereField("category", isEqualTo: category).order(by: "timeStamp", descending: true)
}

}

extension Int {
    
    func penniesToFormattedCurrency() -> String {
        let pounds = Double(self) / 100
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        
        if let poundString  = formatter.string(from: pounds as NSNumber) {
            return poundString
        }
        
        return "£0.00"
    }
}




