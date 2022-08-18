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
        let vc = sb.instantiateViewController(withIdentifier: T.reuseIdentifier) as! T
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = style
        self.present(nav, animated: false)
    }
}
