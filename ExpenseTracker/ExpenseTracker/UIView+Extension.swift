//
//  UIView+Extension.swift
//  ExpenseTracker
//
//  Created by Tiparpron Sukanya on 12/12/23.
//

import Foundation
import UIKit
@IBDesignable
extension UIView{
  @IBInspectable
    var cornerRadius: CGFloat{
        get{
            return layer.cornerRadius
        }
        set{
            layer.cornerRadius = newValue
        }
    }
}
