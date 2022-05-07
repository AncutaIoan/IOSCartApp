//
//  ProductScreenTableViewController.swift
//  CartOS
//
//  Created by AncutaIoan on 5/7/22.
//

import UIKit

class ProductScreenTableViewController: UITableViewController {


    private var viewModel = ProductScreenViewModel()

      override func viewDidLoad() {
          super.viewDidLoad()

          title = "Products"
          
          // Connect to database.
          viewModel.connectToDatabase()
      }
      
      override func viewWillAppear(_ animated: Bool) {
          super.viewWillAppear(true)
          loadData()
          tableView.reloadData()
      }
      
      // MARK: - Load data from SQLite database
      private func loadData() {
          viewModel.loadDataFromSQLiteDatabase()
      }

      // MARK: - Table view data source
      override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          viewModel.numberOfRowsInSection(section: section)
      }

      override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

          // Configure the cell...
          let object = viewModel.cellForRowAt(indexPath: indexPath)
          
          if let productCell = cell as? ProductTableViewCell {
              productCell.setCellWithValuesOf(object)
          }
          return cell
      }
      
      // Delete cell from table
      override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
          if editingStyle == .delete {
              let product = viewModel.cellForRowAt(indexPath: indexPath)
              
              // Delete product from database table
              SQLiteCommands.deleteRow(productId: product.id)
              
              // Updates the UI after delete changes
              self.loadData()
              self.tableView.reloadData()
          }
      }
      
      // MARK: - Navigation

      override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

          if segue.identifier == "editProduct" {
              guard let newProductVC = segue.destination as? NewProductViewController else {return}
              guard let selectedProductCell = sender as? ProductTableViewCell else {return}
              if let indexPath = tableView.indexPath(for: selectedProductCell) {
                  let selectedProduct = viewModel.cellForRowAt(indexPath: indexPath)
                  newProductVC.viewModel = NewProductViewModel(productValues: selectedProduct)
              }
          }
      }
  }
