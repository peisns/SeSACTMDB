//
//  ContentsViewController.swift
//  SeSACTMDB
//
//  Created by Brother Model on 2022/08/09.
//

import UIKit

import Kingfisher

class ContentsViewController: UIViewController {

    @IBOutlet weak var bannerCollectionView: UICollectionView!
    @IBOutlet weak var contentsTableView: UITableView!
    
    var trendingMovieArray: [Movie] = []
    var recommendMovieArray: [Movie] = []
    var similarMovieArray: [Movie] = []
    var nowPlayingMovieArray: [Movie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black

        bannerCollectionView.delegate = self
        bannerCollectionView.dataSource = self
        bannerCollectionView.collectionViewLayout = bannerCollectionViewLayout()
        bannerCollectionView.isPagingEnabled = true
        bannerCollectionView.backgroundColor = .clear
        
        contentsTableView.delegate = self
        contentsTableView.dataSource = self

        requestAPIData()
        
    }
    
    func requestAPIData() {
        trendingRequestAPI.shared.getTrendingData(startPage: 1) { int, trendingMovieArray in
            self.trendingMovieArray = trendingMovieArray
            self.bannerCollectionView.reloadData()
            
            recommendMovieRequestAPI.shared.getVideoData(movieID: self.trendingMovieArray[0].id) { movieArray in
                self.recommendMovieArray = movieArray
                
                
                let similarURL = EndPoint.TMDB_BASE_URL + String(trendingMovieArray[0].id) + EndPoint.TMDB_SIMILAR_URL
                requestMovieArrayAPI.shared.getVideoData(url: similarURL) { movieArray in
                    self.similarMovieArray = movieArray
                    
                    let nowPlayingURL = EndPoint.TMDB_BASE_URL + EndPoint.TMDB_NOWPLAYING_URL
                    requestMovieArrayAPI.shared.getVideoData(url: nowPlayingURL) { movieArray in
                        self.nowPlayingMovieArray = movieArray
                        self.contentsTableView.reloadData()
                    }
                }
            }
        }
    }
}

extension ContentsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == bannerCollectionView {
            return trendingMovieArray.count
        } else {
            return recommendMovieArray.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == bannerCollectionView {
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContentsBannerCollectionViewCell.reuseIdentifier, for: indexPath) as? ContentsBannerCollectionViewCell else { return UICollectionViewCell() }
            cell.posterView.titleLabel.text = trendingMovieArray[indexPath.item].title
            let ImageURL = URL(string:EndPoint.TMDB_IMAGE_URL + trendingMovieArray[indexPath.item].imageURL)
            cell.posterView.posterImageView.kf.setImage(with: ImageURL)
            cell.posterView.titleLabel.text = ""
            cell.trendingRankLabel.text = "Trending Ranking #\(indexPath.item + 1) \(trendingMovieArray[indexPath.item].title)"
            cell.trendingRankLabel.textColor = .white
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContentsCollectionViewCell.reuseIdentifier, for: indexPath) as? ContentsCollectionViewCell else { return UICollectionViewCell() }
            if collectionView.tag == 0 {
                let ImageURL = URL(string:EndPoint.TMDB_IMAGE_URL + recommendMovieArray[indexPath.item].imageURL)
                cell.posterView.posterImageView.kf.setImage(with: ImageURL)
                cell.posterView.titleLabel.text = recommendMovieArray[indexPath.item].title
            } else if collectionView.tag == 1 {
                let ImageURL = URL(string:EndPoint.TMDB_IMAGE_URL + similarMovieArray[indexPath.item].imageURL)
                cell.posterView.posterImageView.kf.setImage(with: ImageURL)
                cell.posterView.titleLabel.text = similarMovieArray[indexPath.item].title
            } else if collectionView.tag == 2 {
                let ImageURL = URL(string:EndPoint.TMDB_IMAGE_URL + nowPlayingMovieArray[indexPath.item].imageURL)
                cell.posterView.posterImageView.kf.setImage(with: ImageURL)
                cell.posterView.titleLabel.text = nowPlayingMovieArray[indexPath.item].title
            }
            return cell
        }
        
    }
    
    func bannerCollectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: 141)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        return layout
    }
}

extension ContentsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trendingMovieArray.count > 0 ? 5 : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ContentsTableViewCell.reuseIdentifier, for: indexPath) as? ContentsTableViewCell else { return UITableViewCell() }
        
        cell.backgroundColor = .black
        cell.contentsCollectionView.backgroundColor = .black
        cell.contentsCollectionView.delegate = self
        cell.contentsCollectionView.dataSource = self
        cell.contentsCollectionView.register(UINib(nibName: ContentsCollectionViewCell.reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: ContentsCollectionViewCell.reuseIdentifier)
        cell.contentsCollectionView.tag = indexPath.row
        cell.contentsCollectionView.reloadData()
        cell.headerLabel.text = "가장 핫한 \(trendingMovieArray[0].title)을 좋아하신다면?"
        switch indexPath.row {
        case 0:
            cell.headerLabel.text = "가장 핫한 \(trendingMovieArray[0].title)을 좋아하신다면?"
        case 1:
            cell.headerLabel.text = "가장 핫한 \(trendingMovieArray[0].title)과 비슷한 영화"
        case 2:
            cell.headerLabel.text = "지금 상영중인 영화"
        default:
            cell.headerLabel.text = "Test"
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 190
    }
}
