//
//  Category+CoreDataProperties.swift
//  ExpenseTracker
//
//  Created by Tiparpron Sukanya on 12/14/23.
//
//

import Foundation
import CoreData


extension Category {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Category> {
        return NSFetchRequest<Category>(entityName: "Category")
    }

    @NSManaged public var categoryName: String?

}

extension Category : Identifiable {

}
