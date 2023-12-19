//
//  Date+Extension.swift
//  ExpenseTracker
//
//  Created by Tiparpron Sukanya on 12/15/23.
//

import Foundation
extension Date{
    static func currentDate(dateFormatPattern: String) -> String {
            
            let date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = dateFormatPattern
    
            let result = formatter.string(from: date)
            return result
        }
}
