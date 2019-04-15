//
//  StripeCart.swift
//  Artable
//
//  Created by iain Allen on 04/04/2019.
//  Copyright © 2019 iain Allen. All rights reserved.
//

import Foundation

let StripeCart = _StripeCart()

final class _StripeCart {
    
    var cartItems = [Product]()
    private let stripCreditCardCut = 0.029
    private let flatFeeCents = 30
    var shippingFees = 0
    
    var subTotal: Int {
        var amount = 0
        for item in cartItems {
            let pricePennies = Int(item.price * 100)
            amount += pricePennies
        }
        return amount
    }
    
    var processingFees: Int {
        if subTotal == 0 {
            return 0
        }
        let sub = Double(subTotal)
        let feesAndSub = Int(sub * stripCreditCardCut) + flatFeeCents
        return feesAndSub
    }
    
    var total: Int {
        return subTotal + processingFees + shippingFees
    }
    
    func addItemToCart(item: Product) {
        cartItems.append(item)
    }
    
    func removeItemFromCart(item: Product) {
        if let index = cartItems.firstIndex(of: item) {
            cartItems.remove(at: index)
        }
    }
    
    func clearCart() {
        cartItems.removeAll()
    }
    
    
}
