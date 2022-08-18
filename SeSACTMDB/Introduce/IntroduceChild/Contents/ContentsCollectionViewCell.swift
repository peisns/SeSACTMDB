//
//  ContentsCollectionViewCell.swift
//  SeSACTMDB
//
//  Created by Brother Model on 2022/08/09.
//

import UIKit

import Kingfisher

class ContentsCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var posterView: PosterView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureCell(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath, data: [[Movie]]) {
        let ImageURL = URL(string:EndPoint.TMDB_IMAGE_URL + data[collectionView.tag][indexPath.item].imageURL)
        posterView.posterImageView.kf.setImage(with: ImageURL)
        posterView.titleLabel.text = data[collectionView.tag][indexPath.item].title
    }
}
