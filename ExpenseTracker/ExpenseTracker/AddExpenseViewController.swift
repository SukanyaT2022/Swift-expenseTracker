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
    
    //switch
    @IBOutlet weak var saveCatergoryLabel: UILabel!
    
    @IBOutlet weak var catergorySwitch: UISwitch!
    
    var categoryList : [Category]?//Category come from DataBase
    
    var selectedCategoryName = "" // if user not select anything
    var amountString = ""
    //switch below make switch not save -unlesss user switch to save
    var shouldSaveCategory = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        amountTextField.delegate = self
        catergoryTextField.delegate = self
        //difference delegate get data--datasource set data
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerOverlayView.isHidden = true // if donot click select catergory --hide it
        catergoryTextField.isHidden = true //if user select other catergory --if not hide it
//        submitButton.isUserInteractionEnabled = false
        
        //switch- when show it hide so true - when user choose it do somt=ething
        saveCatergoryLabel.isHidden = true
        catergorySwitch.isHidden = true
        
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
  
        //if user forget to put amount so it can not submit
        if amountTextField.text?.isEmpty ?? true{
            showAlert(message: "Please enter amount", title: "warning")
            return
        }
        //if user not completed choosing category and click done-- so it can not submit
        if pickerOverlayView.isHidden == false{
            showAlert(message: "Please select category", title: "warning")
            return
        }
        ///if user selecht other option but does not fill the type so -submit not work
        // continue explain tomorrow
        if  selectedCategoryName.isEmpty || ( selectedCategoryName == "Other" && catergoryTextField.text?.isEmpty ?? true){
            showAlert(message: selectedCategoryName.isEmpty ? "Please select category" : "Please enter catergory details", title: "warning")
            return
        }
        amountTextField.resignFirstResponder()
        catergoryTextField.resignFirstResponder()
        saveCategory()
    saveExpense()
    }
    func showAlert(message:String,title:String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle:.alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(okAction)
        self.present(alertController, animated: true)
    }
    //switch action
    @IBAction func categorySwitchAction(_ sender: UISwitch) {
        shouldSaveCategory = sender.isOn //switch on is true - not green it 's off
    }
    
    //continue button action
    @IBAction func categoryButtonAction(_ sender: Any) {
        pickerOverlayView.isHidden = false // when select catergory button-- unhide overlayview and load picker view
        selectedCategoryName = selectedCategoryName.isEmpty ? categoryList![0].categoryName! : selectedCategoryName
        pickerView.reloadAllComponents()
    }
    
    @IBAction func doneButtonAction(_ sender: Any) {
        categoryButton.setTitle(selectedCategoryName, for:.normal)
        pickerOverlayView.isHidden = true //after select catergory and click done --hide pickerview
        if selectedCategoryName == "Other" {
            catergoryTextField.isHidden = false //if select other catergory then - show textview pop up for user to fill
            catergoryTextField.becomeFirstResponder()
            //switch
            saveCatergoryLabel.isHidden = false
            catergorySwitch.isHidden = false
        }else{
            catergoryTextField.isHidden = true // if not click other then hise textfield
            catergoryTextField.text = ""
            //switch
            saveCatergoryLabel.isHidden = true
            catergorySwitch.isHidden = true
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
    
    func saveCategory(){
       // if text fill is empty donot save--just return
        if catergoryTextField.text?.isEmpty ?? true {
            return
        }
        //donot save if the switch not on so we put false
        if shouldSaveCategory == false{
            return
        }
        //save database
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate){
           let context = appDelegate.persistentContainer.viewContext
            let description = NSEntityDescription.entity(forEntityName:"Category", in: context)
            let entity = NSManagedObject(entity: description!, insertInto: context) as? Category
            entity?.categoryName = catergoryTextField.text
            appDelegate.saveContext()//save data to database
    
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
