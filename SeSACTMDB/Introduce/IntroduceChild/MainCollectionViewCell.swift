//
//  MainCollectionViewCell.swift
//  SeSACTMDB
//
//  Created by Brother Model on 2022/08/03.
//

import UIKit

class MainCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    
    @IBOutlet weak var mediaImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var castLabel: UILabel!
    
    @IBOutlet weak var videoLinkButton: UIButton!
    
    @IBOutlet weak var voteAverageLabel: UILabel!
    
    func designCell(movieInfo:[Movie],indexPath: IndexPath, genreDictionary: [Int:String]) {
        backgroundColor = .orange
        releaseDateLabel.text = movieInfo[indexPath.item].release_date
        genreLabel.text = "#" + String(genreDictionary[movieInfo[indexPath.item].genre_ids[0]] ?? "")
        let ImageURL = URL(string:EndPoint.TMDB_IMAGE_URL + movieInfo[indexPath.item].imageURL)
        mediaImageView.kf.setImage(with: ImageURL)
        titleLabel.text = movieInfo[indexPath.item].title
        videoLinkButton.tag = indexPath.item
        voteAverageLabel.text = String(movieInfo[indexPath.item].vote_average)
    }
}
