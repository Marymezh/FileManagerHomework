//
//  UIViewExtension.swift
//  FileManagerHomework
//
//  Created by Мария Межова on 21.03.2022.
//

import Foundation
import UIKit

extension UIView {
    func toAutoLayout() {
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func addSubviews(_ subviews: UIView...) {
        subviews.forEach { addSubview($0) }
    }
}
