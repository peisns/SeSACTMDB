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
        
        // design cell layout
        let cellLayout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 0
        let screenWidth = UIScreen.main.bounds.width
        cellLayout.itemSize = CGSize(width: screenWidth , height: screenWidth)
        cellLayout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        cellLayout.minimumLineSpacing = spacing
        cellLayout.minimumInteritemSpacing = spacing

        mainCollectionView.collectionViewLayout = cellLayout
        
        genreRequestAPI()
        requestAPI()
    
    }
    

    func genreRequestAPI() {
        let genreURL = EndPoint.TMDB_GENRE_URL
        
        AF.request(genreURL, method: .get).validate().responseData { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
//                print("JSON: \(json)")
                
                let genreArray = json["genres"].arrayValue
                
                for genre in genreArray {
                    let genreID: Int = genre["id"].intValue
                    let genreName: String = genre["name"].stringValue
                    self.genreDictionary[genreID] = genreName
                }
//                print(self.genreDictionary)
                
            case .failure(let error):
                print(error)
            }
        }
    }

    

    func requestAPI() {
        
        let url = EndPoint.TMDB_URL + APIKey.TMDB_KEY + "&page=" + String(startPage)
        
        AF.request(url, method: .get).validate().responseData { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
//                print("JSON: \(json)")
                
                let resultArray = json["results"].arrayValue
                self.totalCount = json["total_pages"].intValue
                
                for result in resultArray {
                    let id = result["id"].intValue
                    let release_date = result["release_date"].stringValue
                    
                    let genre_idsArray = result["genre_ids"].arrayValue
                    var genre_ids: [Int] = []
                    for id in genre_idsArray {
                        genre_ids.append(id.intValue)
                    }
                    
                    let title = result["title"].stringValue
                    let imageURL = result["poster_path"].stringValue
                    let vote_average = result["vote_average"].doubleValue
                    
                
                    self.movieInfo.append(Movie(id: id, release_date: release_date, genre_ids: genre_ids, title: title, imageURL: imageURL, vote_average: vote_average))
                    self.mainCollectionView.reloadData()
                }
                
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    func creditRequestAPI(movieid: Int) -> [String] {
        
        let url = EndPoint.TMDB_CREDITS_URL + String(movieid) + "/credits?api_key=\(APIKey.TMDB_KEY)&language=en-US"
        var credits: [String] = []
        
        AF.request(url, method: .get).validate().responseData { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
//                print("JSON: \(json)")
                
                let resultArray = json["cast"].arrayValue
                
                
                for result in resultArray {
                    
                    let credit = result["name"].stringValue
                    credits.append(credit)
                }
//                print(credits)
            case .failure(let error):
                print(error)
            }
            
        }
        return credits
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



extension ViewController:UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieInfo.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainCollectionViewCell.reuseIdentifier, for: indexPath) as? MainCollectionViewCell else { return UICollectionViewCell() }
        cell.backgroundColor = .orange
        
        cell.releaseDateLabel.text = movieInfo[indexPath.item].release_date
        cell.genreLabel.text = "#" + String(genreDictionary[movieInfo[indexPath.item].genre_ids[0]]!)
        let ImageURL = URL(string:EndPoint.TMDB_IMAGE_URL + movieInfo[indexPath.item].imageURL)
        cell.mediaImageView.kf.setImage(with: ImageURL)
        cell.titleLabel.text = movieInfo[indexPath.item].title
        
        let credits = creditRequestAPI(movieid: movieInfo[indexPath.item].id)
        
        var castLabel = ""
        for credit in credits {
            castLabel += credit + ", "
        }
        
//        cell.castLabel.text = castLabel
        
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        // movie id 유저디폴트에 저장
        //save temporary character index
//            UserDefaults.standard.set(indexPath.row, forKey:"moi")
            
            //present select check scene
//            let sb = UIStoryboard(name: "SelectCheck", bundle: nil)
//            guard let vc = sb.instantiateViewController(withIdentifier: SelectCheckViewController.identifier) as? SelectCheckViewController else {
//                showAlert(message: "잘못된 스토리보드입니다.")
//                return }
//            vc.modalPresentationStyle = .overCurrentContext
//            present(vc, animated: true)
    }
}
