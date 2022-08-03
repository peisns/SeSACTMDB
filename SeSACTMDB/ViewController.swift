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

class ViewController: UIViewController {

    @IBOutlet weak var mainCollectionView: UICollectionView!
    
    var genreDictionary: [Int: String] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        mainCollectionView.delegate = self
        mainCollectionView.dataSource = self
        
        // design cell layout
        let cellLayout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 0
        let screenWidth = UIScreen.main.bounds.width
        cellLayout.itemSize = CGSize(width: screenWidth , height: screenWidth)
        cellLayout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        cellLayout.minimumLineSpacing = spacing
        cellLayout.minimumInteritemSpacing = spacing

        mainCollectionView.collectionViewLayout = cellLayout
        
        requestGenreAPI()
        requestAPI()
    
    }
    
    func requestGenreAPI() {
        let url = EndPoint.TMDB_GENRE_URL
        
        AF.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                
                let genreArray = json["genres"].arrayValue
                
                for genre in genreArray {
                    let genreID: Int = genre["id"].intValue
                    let genreName: String = genre["name"].stringValue
                    self.genreDictionary[genreID] = genreName
                }
                print(self.genreDictionary)
                
            case .failure(let error):
                print(error)
            }
        }
    }
    


    func requestAPI() {
        
        let url = EndPoint.TMDB_URL + APIKey.TMDB_KEY
        
        AF.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                
                let resultArray = json["results"].arrayValue
                
                for result in resultArray {
                    let release_date = result["release_date"].stringValue
                    let genre_ids = result["genre_ids"].arrayValue
                    let title = result["title"].stringValue
                }
                
                
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
}


extension ViewController:UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainCollectionViewCell.reuseIdentifier, for: indexPath) as? MainCollectionViewCell else { return UICollectionViewCell() }
        cell.backgroundColor = .orange
        
        return cell
    }
    
    
}
