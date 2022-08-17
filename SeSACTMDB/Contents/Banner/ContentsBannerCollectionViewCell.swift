//
//  ContentsBannerCollectionViewCell.swift
//  SeSACTMDB
//
//  Created by Brother Model on 2022/08/09.
//

import UIKit

class ContentsBannerCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var posterView: PosterView!
    
    @IBOutlet weak var trendingRankLabel: UILabel!
    
    func configureBannerCell(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath, trendingMovieArray: [Movie]) {
        posterView.titleLabel.text = trendingMovieArray[indexPath.item].title
        let ImageURL = URL(string:EndPoint.TMDB_IMAGE_URL + trendingMovieArray[indexPath.item].imageURL)
        posterView.posterImageView.kf.setImage(with: ImageURL)
        posterView.titleLabel.text = ""
        trendingRankLabel.text = "Trending Ranking #\(indexPath.item + 1) \(trendingMovieArray[indexPath.item].title)"
        trendingRankLabel.textColor = .white
    }

}
