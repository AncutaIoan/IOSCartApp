//
//  ProductTableViewCell.swift
//  CartOS
//
//  Created by AncutaIoan on 5/7/22.
//

import UIKit

class ProductTableViewCell: UITableViewCell {

    @IBOutlet weak var ProductPhotoImageView: UIImageView!
    @IBOutlet weak var ShopNameLabel: UILabel!
    @IBOutlet weak var ProductNameLabel: UILabel!
    func setCellWithValuesOf(_ product: Product) {
           ProductNameLabel.text = product.productName
           ShopNameLabel.text = product.shopName
           
           let image = UIImage(data: product.photo)
           ProductPhotoImageView.image = image
       }

}
