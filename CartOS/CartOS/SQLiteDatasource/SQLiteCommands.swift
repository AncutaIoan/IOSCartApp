//
//  SQLiteCommands.swift
//  CartOS
//
//  Created by AncutaIoan on 5/7/22.
//


import Foundation
import SQLite

class SQLiteCommands {
    
    static var table = Table("contact")
    
    // Expressions
    static let id = Expression<Int>("id")
    static let productName = Expression<String>("productName")
    static let shopName = Expression<String>("shopName")
    static let price = Expression<String>("price")
    static let photo = Expression<Data>("photo")
    
    // Creating Table
    static func createTable() {
        guard let database = SQLiteDatabase.sharedInstance.database else {
            print("Datastore connection error")
            return
        }
        
        do {
            // ifNotExists: true - Will NOT create a table if it already exists
            try database.run(table.create(ifNotExists: true) { table in
                table.column(id, primaryKey: true)
                table.column(productName)
                table.column(shopName)
                table.column(price)
                table.column(photo)
            })
        } catch {
            print("Table already exists: \(error)")
        }
    }
    
    // Inserting Row
    static func insertRow(_ productValues:Product) -> Bool? {
        guard let database = SQLiteDatabase.sharedInstance.database else {
            print("Datastore connection error")
            return nil
        }
        
        do {
            try database.run(table.insert(productName <- productValues.productName, shopName <- productValues.shopName, price <- productValues.price, photo <- productValues.photo))
            return true
        } catch let Result.error(message, code, statement) where code == SQLITE_CONSTRAINT {
            print("Insert row failed: \(message), in \(String(describing: statement))")
            return false
        } catch let error {
            print("Insertion failed: \(error)")
            return false
        }
    }
    
    // Updating Row
    static func updateRow(_ productValues: Product) -> Bool? {
        guard let database = SQLiteDatabase.sharedInstance.database else {
            print("Datastore connection error")
            return nil
        }
        
        // Extracts the appropriate product from the table according to the id
        let contact = table.filter(id == productValues.id).limit(1)
        
        do {
            // Update the product's values
            if try database.run(contact.update(productName <- productValues.productName, shopName <- productValues.shopName, price <- productValues.price, photo <- productValues.photo)) > 0 {
                print("Updated contact")
                return true
            } else {
                print("Could not update contact: contact not found")
                return false
            }
        } catch let Result.error(message, code, statement) where code == SQLITE_CONSTRAINT {
            print("Update row faild: \(message), in \(String(describing: statement))")
            return false
        } catch let error {
            print("Updation failed: \(error)")
            return false
        }
    }
    
    // Present Rows
    static func presentRows() -> [Product]? {
        guard let database = SQLiteDatabase.sharedInstance.database else {
            print("Datastore connection error")
            return nil
        }
        
        // product Array
        var productArray = [Product]()
        
        // Sorting data in descending order by ID
        table = table.order(id.desc)
        
        do {
            for product in try database.prepare(table) {
                
                let idValue = product[id]
                let productNameValue = product[productName]
                let shopNameValue = product[shopName]
                let priceValue = product[price]
                let photoValue = product[photo]
                
                // Create object
                let productObject = Product(id: idValue, productName: productNameValue, shopName: shopNameValue, price: priceValue, photo: photoValue)
                
                // Add object to an array
                productArray.append(productObject)
                
                print("id \(product[id]), productName: \(product[productName]), shopName: \(product[shopName]), price: \(product[price]), photo: \(product[photo])")
            }
        } catch {
            print("Present row error: \(error)")
        }
        return productArray
    }
    
    // Delete Row
    static func deleteRow(productId: Int) {
        guard let database = SQLiteDatabase.sharedInstance.database else {
            print("Datastore connection error")
            return
        }
        
        do {
            let product = table.filter(id == productId).limit(1)
            try database.run(product.delete())
        } catch {
            print("Delete row error: \(error)")
        }
    }
}
