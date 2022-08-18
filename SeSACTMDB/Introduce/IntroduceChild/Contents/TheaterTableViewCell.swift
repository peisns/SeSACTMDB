//
//  TheaterTableViewCell.swift
//  SeSACTMDB
//
//  Created by Brother Model on 2022/08/12.
//

import UIKit

class TheaterTableViewCell: UITableViewCell {

    @IBOutlet weak var theaterButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell() {
        backgroundColor  = .clear
        theaterButton.layer.cornerRadius = 10
        theaterButton.setTitle("영화관 찾기", for: .normal)
    }
}
