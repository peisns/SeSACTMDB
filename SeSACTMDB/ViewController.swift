//
//  ViewController.swift
//  SeSACTMDB
//
//  Created by Brother Model on 2022/08/03.
//

import UIKit

import Alamofire
import Kingfisher
import SwiftyJSON

struct Movie {
    let id: Int
    let release_date: String
    let genre_ids: [Int]
    let title: String
    let imageURL: String
    let vote_average: Double
}

class ViewController: UIViewController {

    @IBOutlet weak var mainCollectionView: UICollectionView!
    
    var genreDictionary: [Int: String] = [:]
    var movieInfo: [Movie] = []
    
    var startPage = 1
    var totalCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        mainCollectionView.delegate = self
        mainCollectionView.dataSource = self
        mainCollectionView.prefetchDataSource = self
        
        mainCollectionView.collectionViewLayout = designCellLayout()
        
        genreRequest()
        requestAPI()
    }
    
    func genreRequest() {
        getTMDBJson.shared.genreJSON { dictionary in
            self.genreDictionary = dictionary
        }
    }

    func requestAPI() {
        getTMDBJson.shared.getTrendingData(startPage: startPage) { totalCount, movieInfo in
            self.movieInfo.append(contentsOf: movieInfo)
            self.totalCount = totalCount
            self.mainCollectionView.reloadData()
        }
        
//        trendingRequestAPI.shared.getTrendingData(startPage: startPage) { totalCount, movieInfo in
//            self.movieInfo.append(contentsOf: movieInfo)
//            self.totalCount = totalCount
//            self.mainCollectionView.reloadData()
//        }
    }
}

extension ViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if movieInfo.count - 1 == indexPath.item && movieInfo.count < totalCount {
                startPage += 1
                requestAPI()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        //
    }
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieInfo.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainCollectionViewCell.reuseIdentifier, for: indexPath) as? MainCollectionViewCell else { return UICollectionViewCell() }
        
        cell.designCell(movieInfo: movieInfo, indexPath: indexPath, genreDictionary: genreDictionary)
        cell.videoLinkButton.addTarget(self, action: #selector(videoLinkbuttonClicked(sender:)), for: .touchUpInside)
        
        return cell
    }
                                       
    @objc func videoLinkbuttonClicked(sender: UIButton){
        //push Video Scene
        let sb = UIStoryboard(name: "Video", bundle: nil)
        guard let vc = sb.instantiateViewController(withIdentifier: VideoViewController.reuseIdentifier) as? VideoViewController else { return }
        vc.selectedMovieID = movieInfo[sender.tag].id
        navigationController?.pushViewController(vc, animated: true)
    }
                                   
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //push Credits Scene
        let sb = UIStoryboard(name: "Credits", bundle: nil)
        guard let vc = sb.instantiateViewController(withIdentifier: CreditsTableViewController.reuseIdentifier) as? CreditsTableViewController else { return }
        vc.selectedMovie = self.movieInfo[indexPath.item]
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension ViewController {
    func designCellLayout() -> UICollectionViewFlowLayout {
        let cellLayout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 0
        let screenWidth = UIScreen.main.bounds.width
        cellLayout.itemSize = CGSize(width: screenWidth , height: screenWidth)
        cellLayout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        cellLayout.minimumLineSpacing = spacing
        cellLayout.minimumInteritemSpacing = spacing
        
        return cellLayout
    }
}
