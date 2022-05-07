//
//  NewProductViewController.swift
//  CartOS
//
//  Created by AncutaIoan on 5/7/22.
//

import UIKit

class NewProductViewController: UIViewController {

    @IBOutlet weak var photoImageView: UIImageView!
    
    @IBOutlet weak var productNameTextField: UITextField!
    @IBOutlet weak var shopNameTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    
    var viewModel: NewProductViewModel!
    	
    override func viewDidLoad() {
        super.viewDidLoad()
               // Do any additional setup after loading the view.
               
               createTable()
               setUpViews()
               productNameTextField.becomeFirstResponder()
               priceTextField.delegate = self
    }


    // MARK: - Connect to database and create table.
        private func createTable() {
            let database = SQLiteDatabase.sharedInstance
            database.createTable()
        }
        
        // MARK: - Setup the views with the values of the selected product
        private func setUpViews() {
            if let viewModel = viewModel {
                productNameTextField.text = viewModel.productName
                shopNameTextField.text = viewModel.shopName
                priceTextField.text = viewModel.price
                photoImageView.image = viewModel.photo
            }
        }

    @IBAction func saveButton(_ sender: Any) {
    
            let id: Int = viewModel == nil ? 0 : viewModel.id!
            let productName = productNameTextField.text ?? ""
            let shopName = shopNameTextField.text ?? ""
            let price = priceTextField.text ?? ""
            let uiImage = photoImageView.image ?? #imageLiteral(resourceName: "defualtContactIPhoto")
            guard let photo = uiImage.pngData() else {return}
            
            let productValues = Product(id: id, productName: productName, shopName: shopName, price: price, photo: photo)

            if viewModel == nil {
                createNewProduct(productValues)
            } else {
                updateProduct(productValues)
            }
        SQLiteCommands.presentRows()
    }
        
        private func createNewProduct(_ productValues:Product) {
            let productAddedToTable = SQLiteCommands.insertRow(productValues)
            
            if productAddedToTable == true {
                dismiss(animated: true, completion: nil)
            } else {
                showError("Error", message: "This product cannot be created because already exist in your rpdouct list.")
            }
        }
        
        // MARK: - Update product
        private func updateProduct(_ productValues: Product) {
            let productUpdatedInTable = SQLiteCommands.updateRow(productValues)
            
            if productUpdatedInTable == true {
                if let cellClicked = navigationController {
                    cellClicked.popViewController(animated: true)
                }
            } else {
                showError("Error", message: "This product cannot be updated because this already exist in your product list")
            }
        }
        

        @IBAction func cancelButton(_ sender: Any) {
            let addButtonClicked = presentingViewController is UINavigationController
            // If the user clicked add button on the previous screen
            if addButtonClicked {
                // Dismisses back to the previous screen with animation
                dismiss(animated: true, completion: nil)
            }
            // If the user clicked on a cell on the previous screen
            else if let cellClicked = navigationController {
                cellClicked.popViewController(animated: true)
            } else {
                print("The ProductScreenTableViewController is not inside a navigation controller")
            }
        }

    
}
    extension NewProductViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        // MARK: - Image tap gesture
        @IBAction func addImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
            // let the user pick media from his photo library.
            let imagePickerController = UIImagePickerController()
            
            // Allows to picked photos.
            imagePickerController.sourceType = .photoLibrary
            
            imagePickerController.delegate = self
            present(imagePickerController, animated: true, completion: nil)
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            dismiss(animated: true, completion: nil)
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
                fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
            }
            
            photoImageView.image = selectedImage
            
            dismiss(animated: true, completion: nil)
        }
    }

extension NewProductViewController: UITextFieldDelegate {

    private func format(with mask: String, price: String) -> String {
        let numbers = price.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        var result = ""
        var index = numbers.startIndex
        
        for ch in mask where index < numbers.endIndex {
            if ch == "X" {
                result.append(numbers[index])
                index = numbers.index(after: index)
            } else {
                result.append(ch)
            }
        }
        return result
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else {return false}
        let newString = (text as NSString).replacingCharacters(in: range, with: string)
        textField.text = format(with: "XXXXX $", price: newString)
        return false
    }
}
