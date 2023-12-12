//
//  ViewController.swift
//  ExpenseTracker
//
//  Created by Tiparpron Sukanya on 12/7/23.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var expenseBaseView: UIView!
    
    @IBOutlet weak var expenseTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //below make corner raduis

        //add border to black box
        expenseBaseView.layer.borderWidth = 5.0
        expenseBaseView.layer.borderColor = UIColor.red.cgColor
    }

// how to put hex color also ex size of border 2px
}

