//
//  ViewController.swift
//  ExpenseTracker
//
//  Created by Tiparpron Sukanya on 12/7/23.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    @IBOutlet weak var expenseBaseView: UIView!
    @IBOutlet weak var totalExpenseLabel: UILabel!
    
    @IBOutlet weak var expenseTableView: UITableView!
    var categoryArray = ["Gas","Transport","Home","Grocery","Phone","Other"]
    var expenseList: [ExpenseEntity]?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //below make corner raduis

        //add border to black box
        expenseBaseView.layer.borderWidth = 5.0
        expenseBaseView.layer.borderColor = UIColor.red.cgColor
        
        expenseTableView.delegate = self
        expenseTableView.dataSource = self
        
        saveCategory()
    }
//    move screen one to two and come back to one again use ViewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getExpense()
        if let expenseList{
            var totalExpense = 0
            for expense in expenseList{
                totalExpense += Int(expense.amount ?? "0") ?? 0 // convert number which is string to int so we can make total
            }
            totalExpenseLabel.text = "$\(totalExpense)"
        }
       
    }
    //save array line 16 catergoryArray one by one so we use for loop
    func saveCategory(){
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate){
            //first check if they have catergories on databae or not if database there so no need to save but if not found se we need to save line 38 to 41 check save or not
            let fetchRequest = Category.fetchRequest()
            if let categories = try? appDelegate.persistentContainer.viewContext.fetch(fetchRequest), categories.count > 0{
                return
            }
            //43 to 50 crate from the array line 16 and save
            let context = appDelegate.persistentContainer.viewContext
            //for loop create catergory and save one by one
            for categoryName in categoryArray{
                let description = NSEntityDescription.entity(forEntityName:"Category", in: context)
                let entity = NSManagedObject(entity: description!, insertInto: context) as? Category
                entity?.categoryName = categoryName
            }
            appDelegate.saveContext()//just save
        }
    }
    func getExpense(){
        //inable to get data we need to make a request from data base
        let fetchRequest = ExpenseEntity.fetchRequest()
        expenseList = try? (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext.fetch(fetchRequest)
        expenseTableView.reloadData()
    }
// how to put hex color also ex size of border 2px
}
extension ViewController{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  expenseList?.count ?? 0 // if expense list not there so row is 0
        //expenseList from database var line 18
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return 100
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "expenseCell", for:indexPath) as? ExpenseTableViewCell else {
            return UITableViewCell()
        }
        //to get the data for respective row --which row which data or which expense
        let expense = expenseList?[indexPath.row]//indexpath is opsition row postion
        cell.expenseTitle.text = expense?.category
        cell.expenseAmountLabel.text = "$ \(expense?.amount ?? "")"
        return cell
    }
}

