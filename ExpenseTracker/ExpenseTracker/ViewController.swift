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
    
    @IBOutlet weak var expenseTableView: UITableView!
    
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
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getExpense()
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
        cell.expenseAmountLabel.text = expense?.amount
        return cell
    }
}

