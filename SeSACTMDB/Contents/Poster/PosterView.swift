//
//  PosterView.swift
//  SeSACTMDB
//
//  Created by Brother Model on 2022/08/09.
//

import UIKit

class PosterView: UIView {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        loadView()
    }
    
    private func loadView() {
        guard let view = UINib(nibName: "PosterView", bundle: nil).instantiate(withOwner: self, options: nil).first as? UIView else { return }
        view.frame = bounds
        view.layer.cornerRadius = 10
        self.addSubview(view)
    }
    
    
}
