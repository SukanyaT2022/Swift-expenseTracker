//
//  AddExpenseViewController.swift
//  ExpenseTracker
//
//  Created by Tiparpron Sukanya on 12/15/23.
//

import Foundation
import UIKit
import CoreData
class AddExpenseViewController: UIViewController{
    @IBOutlet weak var amountTextField: UITextField!
    
    @IBOutlet weak var submitButton: UIButton!
    
    @IBOutlet weak var pickerOverlayView: UIView!
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    @IBOutlet weak var doneButton: UIButton!
    
    @IBOutlet weak var categoryButton: UIButton!
    
    
    @IBOutlet weak var catergoryTextField: UITextField!
    
    var categoryList : [Category]?//Category come from DataBase
    
    var selectedCategoryName = "other" // if user not select anything
    var amountString = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        amountTextField.delegate = self
        catergoryTextField.delegate = self
        //difference delegate get data--datasource set data
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerOverlayView.isHidden = true
        catergoryTextField.isHidden = true
        getCatergory()
    }
    func getCatergory(){
        let fetchRequest = Category.fetchRequest()//Category is enitity from dataBase
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate){
            if let categories = try? appDelegate.persistentContainer.viewContext.fetch(fetchRequest), categories.count > 0{
                categoryList = categories
            }
        }
    }
    @IBAction func submitButtonAction(_ sender: Any) {
        amountTextField.resignFirstResponder()
    saveExpense()
    }
    //continue button action
    @IBAction func categoryButtonAction(_ sender: Any) {
        pickerOverlayView.isHidden = false
        pickerView.reloadAllComponents()
    }
    
    @IBAction func doneButtonAction(_ sender: Any) {
        categoryButton.setTitle(selectedCategoryName, for:.normal)
        pickerOverlayView.isHidden = true
        if selectedCategoryName == "Other" {
            catergoryTextField.isHidden = false
            catergoryTextField.becomeFirstResponder()
        }
    }
    
    func saveExpense(){
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate){
           let context = appDelegate.persistentContainer.viewContext
            let description = NSEntityDescription.entity(forEntityName:"ExpenseEntity", in: context)
            let entity = NSManagedObject(entity: description!, insertInto: context) as? ExpenseEntity
            entity?.amount = amountString
            //hh hour -mm munite
            entity?.timeStamp = Date.currentDate(dateFormatPattern:"dd-MM-yy HH:mm:ss")
            entity?.category = selectedCategoryName
            appDelegate.saveContext()//save data to database
            //line below after fill catergory and $ amount and submit it direct to previous page
            self.navigationController?.popViewController(animated: true)
        }
    }
}
extension AddExpenseViewController: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == catergoryTextField{
           selectedCategoryName = textField.text ?? ""  + string
        }else{
            amountString = textField.text ?? ""  + string
        }
       
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == catergoryTextField{
            selectedCategoryName = textField.text ?? ""
        }else{
            amountString = textField.text ?? ""
        }
      
    }
}
extension AddExpenseViewController: UIPickerViewDelegate,UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        we have only one colum from the list
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        //how many catergory
        return categoryList?.count ?? 0
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categoryList?[row].categoryName
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selecledCategory = categoryList?[row]
        selectedCategoryName = selecledCategory?.categoryName ?? ""
        //if user not select anything - it go to catergory ther var line 25
    }
}
