//
//  CategoryListViewController.swift
//  ExpenseTracker
//
//  Created by Tiparpron Sukanya on 1/18/24.
//

import Foundation
import UIKit
class CategoryListViewController: UIViewController{
    
    @IBOutlet weak var categoryTableView: UITableView!
    var categoryList : [Category]?//Category is entity from database
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryTableView.delegate = self
        categoryTableView.dataSource = self
        fetchCategory()
    }
    func fetchCategory(){
        let fetchRequest = Category.fetchRequest()//Category is enitity from dataBase
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate){
            if let categories = try? appDelegate.persistentContainer.viewContext.fetch(fetchRequest), categories.count > 0{
                categoryList = categories
                categoryTableView.reloadData()
            }
        }
    }
}
extension CategoryListViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath) as? CatergoryTableViewCell else{
            return UITableViewCell()
        }
        let category = categoryList? [indexPath.row]// catergoryList is array line 13
        cell.titleLabel.text = category?.categoryName
        cell.categoryData = category
        return cell
    }
    
    //44 to end expalin function next week. 3 function do what
    
    //line 48 to 63 slide to delete catergory
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
       return true
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            let cell = tableView.cellForRow(at: indexPath) as? CatergoryTableViewCell
            if let categoryData = cell?.categoryData,let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
                appDelegate.persistentContainer.viewContext.delete(categoryData)
                appDelegate.saveContext()
                fetchCategory()
            }
        }
    }
}
