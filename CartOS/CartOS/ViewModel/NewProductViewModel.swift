//
//  NewProductViewModel.swift
//  CartOS
//
//  Created by IoanAncuta on 5/7/22.
//

import UIKit

class NewProductViewModel {
    
    private var productValues: Product?
    
    let id: Int?
    let productName: String?
    let shopName: String?
    let price: String?
    let photo: UIImage?
    
    init(productValues: Product?) {
        self.productValues = productValues
        
        self.id = productValues?.id
        self.productName = productValues?.productName
        self.shopName = productValues?.shopName
        self.price = productValues?.price
        self.photo = UIImage(data: productValues!.photo)
        
    }
}
