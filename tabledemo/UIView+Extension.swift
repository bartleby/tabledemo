//
//  UIView+Extension.swift
//  tabledemo
//
//  Created by Андрей М on 04.10.2020.
//

import UIKit

@IBDesignable extension UIView {
    static var className: String {
        return String(describing: type(of: self.init()))
    }
}
