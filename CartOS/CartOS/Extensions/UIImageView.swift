//
//  UIImageView.swift
//  CartOS
//
//  Created by IoanAncuta on 5/7/22.
//

import UIKit

extension UIImageView {
    // Round shaped image
    func makeRounded() {
        self.layer.masksToBounds = false
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
    }
}
