//
//  UIViewController+Extension.swift
//  SeSACTMDB
//
//  Created by Brother Model on 2022/08/18.
//

import UIKit

extension UIViewController {
    
    func presentScene<T: UIViewController>(name: String, vc: T, style: UIModalPresentationStyle) {
        let sb = UIStoryboard(name: name, bundle: nil)
        let viewController = sb.instantiateViewController(withIdentifier: T.reuseIdentifier) as! T
        viewController.modalPresentationStyle = style
        self.present(viewController, animated: false)
    }
}
