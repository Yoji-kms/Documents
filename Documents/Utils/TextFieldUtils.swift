//
//  TextFieldUtils.swift
//  Documents
//
//  Created by Yoji on 02.05.2023.
//

import UIKit

extension UITextField {
    func leadingPadding(_ padding: CGFloat) {
        self.leftView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: 0))
        self.leftViewMode = .always
    }
    
    func setBorder(color: CGColor, width: CGFloat, cornerRadius: CGFloat?) {
        self.layer.cornerRadius = cornerRadius ?? 0
        self.layer.borderColor = color
        self.layer.borderWidth = width
    }
}
