//
//  UIViewController.swift
//  CatGenerator
//
//  Created by WhyQ on 08/10/24.
//

import UIKit

extension UIViewController {
     func bounceAlert(alert: UIAlertController) {
        guard let view = alert.view.superview else { return }
        
        view.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        view.alpha = 0.0
        
        UIView.animate(withDuration: 0.2) {
            view.alpha = 1.0
            view.transform = .identity
        }
    }
}
