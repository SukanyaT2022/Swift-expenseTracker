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
    
    var amountString = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        amountTextField.delegate = self
        //difference delegate get data--datasource set data
    }
    @IBAction func submitButtonAction(_ sender: Any) {
        amountTextField.resignFirstResponder()
    saveExpense()
    }
    func saveExpense(){
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate){
           let context = appDelegate.persistentContainer.viewContext
            let description = NSEntityDescription.entity(forEntityName:"ExpenseEntity", in: context)
            let entity = NSManagedObject(entity: description!, insertInto: context) as? ExpenseEntity
            entity?.amount = amountString
            //hh hour -mm munite
            entity?.timeStamp = Date.currentDate(dateFormatPattern:"dd-MM-yy HH:mm:ss")
            entity?.category = "other"
            appDelegate.saveContext()//save data to database
        }
    }
}
extension AddExpenseViewController: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        amountString = textField.text ?? ""  + string
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        amountString = textField.text ?? ""
    }
}
