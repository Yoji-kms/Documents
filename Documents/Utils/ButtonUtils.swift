//
//  ButtonUtils.swift
//  Documents
//
//  Created by Yoji on 09.05.2023.
//

import UIKit

extension UIButton {
    func validateViaTxtFields(_ txtFields: [UITextField]) {
        var isValid = true
        txtFields.forEach { txtField in
            let txtFieldIsEmpty = (txtField.text?.isEmpty ?? true) && txtField.text == ""
            isValid = isValid && !txtFieldIsEmpty
        }
        
        self.isEnabled = isValid
        let alpha = isValid ? 1 : 0.7
        self.backgroundColor = self.backgroundColor?.withAlphaComponent(alpha)
    }
}
