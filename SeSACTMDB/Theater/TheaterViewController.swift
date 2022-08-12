//
//  TheaterViewController.swift
//  SeSACTMDB
//
//  Created by Brother Model on 2022/08/12.
//

import UIKit

class TheaterViewController: UIViewController {

    @IBOutlet weak var filterButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        filterButton.setTitle("Theater Filtering", for: .normal)
        filterButton.layer.cornerRadius = 10
    }
    
    @IBAction func filterActonSheet(_ sender: UIButton) {
        self.showAlertController()
        
    }
    
    func showAlertController() {
        let actionSheetController = UIAlertController()

        let allTheater = UIAlertAction(title: "전체보기", style: UIAlertAction.Style.default, handler: { (action: UIAlertAction) in print("OK all")
        })
        let cgv = UIAlertAction(title: "CGV", style: UIAlertAction.Style.default, handler: { (action: UIAlertAction) in print("OK cgv")
        })
        let megaBox = UIAlertAction(title: "메가박스", style: UIAlertAction.Style.default, handler: { (action: UIAlertAction) in print("OK mega")
        })
        let lotte = UIAlertAction(title: "롯데박스", style: UIAlertAction.Style.default, handler: { (action: UIAlertAction) in print("OK lotte")
        })

        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil)

        actionSheetController.addAction(allTheater)
        actionSheetController.addAction(cgv)
        actionSheetController.addAction(megaBox)
        actionSheetController.addAction(lotte)
        actionSheetController.addAction(cancelAction)

        self.present(actionSheetController, animated: true)
    }

}

