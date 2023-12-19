//
//  ExpenseEntity+CoreDataProperties.swift
//  ExpenseTracker
//
//  Created by Tiparpron Sukanya on 12/14/23.
//
//

import Foundation
import CoreData


extension ExpenseEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ExpenseEntity> {
        return NSFetchRequest<ExpenseEntity>(entityName: "ExpenseEntity")
    }

    @NSManaged public var amount: String?
    @NSManaged public var category: String?
    @NSManaged public var timeStamp: String?

}

extension ExpenseEntity : Identifiable {

}
