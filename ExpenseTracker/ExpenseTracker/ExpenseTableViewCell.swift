//
//  ExpenseTableViewCell.swift
//  ExpenseTracker
//
//  Created by Tiparpron Sukanya on 12/12/23.
//

import Foundation
import UIKit
class  ExpenseTableViewCell: UITableViewCell{
    var expenseData: ExpenseEntity?
    
    @IBOutlet weak var expenseImageView: UIImageView!
    
    @IBOutlet weak var expenseDateLabel: UILabel!
    @IBOutlet weak var expenseTitle: UILabel!
    
    @IBOutlet weak var expenseAmountLabel: UILabel!
}
