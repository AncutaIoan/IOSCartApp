//
//  ProductScreenViewModel.swift
//  CartOS
//
//  Created by AncutaIoan on 5/7/22.
//

import Foundation
class ProductScreenViewModel {
    
    private var productArray = [Product]()
    
    func connectToDatabase() {
        _ = SQLiteDatabase.sharedInstance
    }
    
    func loadDataFromSQLiteDatabase() {
        productArray = SQLiteCommands.presentRows() ?? []
    }
    
    func numberOfRowsInSection (section: Int) -> Int {
        if productArray.count != 0 {
            return productArray.count
        }
        return 0
    }
    
    func cellForRowAt (indexPath: IndexPath) -> Product {
        return productArray[indexPath.row]
    }
}
