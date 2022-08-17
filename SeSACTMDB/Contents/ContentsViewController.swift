//
//  ContentsViewController.swift
//  SeSACTMDB
//
//  Created by Brother Model on 2022/08/09.
//

import UIKit

import Kingfisher
import Alamofire

class ContentsViewController: UIViewController {

    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var bannerCollectionView: UICollectionView!
    @IBOutlet weak var contentsTableView: UITableView!
    
    
    private var trendingMovieArray: [Movie] = []
    private var recommendMovieArray: [Movie] = []
    private var similarMovieArray: [Movie] = []
    private var nowPlayingMovieArray: [Movie] = []
    private var popularMovieArray: [Movie] = []
    private var topRankMovieArray: [Movie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        profileButton.layer.cornerRadius = 10
        
        bannerCollectionView.delegate = self
        bannerCollectionView.dataSource = self
        bannerCollectionView.collectionViewLayout = bannerCollectionViewLayout()
        bannerCollectionView.isPagingEnabled = true
        bannerCollectionView.backgroundColor = .clear
        
        contentsTableView.delegate = self
        contentsTableView.dataSource = self
        let nibName = UINib(nibName: TheaterTableViewCell.reuseIdentifier, bundle: nil)
        contentsTableView.register(nibName, forCellReuseIdentifier: TheaterTableViewCell.reuseIdentifier)

        requestAPIData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let savedImage = UserDefaults.standard.data(forKey: "Profile") {
            profileButton.setImage(UIImage(data: savedImage), for: .normal)
        }
    }
    
    @IBAction func rightBarButtonClicked(_ sender: UIButton) {
        let sb = UIStoryboard(name: "Contents", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: ProfileViewController.reuseIdentifier) as! ProfileViewController
        
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: false)
    }
    
    private func requestAPIData() {
        getTMDBJson.shared.getMovieInfoData(url: EndPoint.TMDB_TRENDING_URL + APIKey.TMDB_KEY + "&page=1") { totalCount, movieInfo in
            self.trendingMovieArray = movieInfo
            
            getTMDBJson.shared.getMovieInfoData(url: EndPoint.TMDB_BASE_URL + "\(String(self.trendingMovieArray[0].id))/recommendations?api_key=\(APIKey.TMDB_KEY)&language=en-US&page=1") { _, movieInfo in
                self.recommendMovieArray = movieInfo
                
                let similarURL = EndPoint.TMDB_BASE_URL + String(self.trendingMovieArray[0].id) + EndPoint.TMDB_SIMILAR_URL
                getTMDBJson.shared.getMovieInfoData(url: similarURL) { _, movieInfo in
                    self.similarMovieArray = movieInfo
                    
                    let nowPlayingURL = EndPoint.TMDB_BASE_URL + EndPoint.TMDB_NOWPLAYING_URL
                    getTMDBJson.shared.getMovieInfoData(url: nowPlayingURL) { _, movieInfo in
                        self.nowPlayingMovieArray = movieInfo
                        
                        getTMDBJson.shared.getMovieInfoData(url: EndPoint.TMDB_BASE_URL + EndPoint.TMDB_POPULAR_URL) { _, movieInfo in
                            self.popularMovieArray = movieInfo
                                           
                            getTMDBJson.shared.getMovieInfoData(url: EndPoint.TMDB_BASE_URL + EndPoint.TMDB_TOPRANK_URL) { _, movieInfo in
                                self.topRankMovieArray = movieInfo
                                self.contentsTableView.reloadData()
                                self.bannerCollectionView.reloadData()
                            }
                        }
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
            cell.configureBannerCell(collectionView, cellForItemAt: indexPath, trendingMovieArray: trendingMovieArray)
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContentsCollectionViewCell.reuseIdentifier, for: indexPath) as? ContentsCollectionViewCell else { return UICollectionViewCell() }
            let data: [[Movie]] = [recommendMovieArray, similarMovieArray, nowPlayingMovieArray, popularMovieArray, topRankMovieArray]
            cell.configureCell(collectionView, cellForItemAt: indexPath, data: data)
            return cell
        }
    }
    
    private func bannerCollectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.2 - 8)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        return layout
    }
}

extension ContentsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return trendingMovieArray.count > 0 ? 5 : 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TheaterTableViewCell.reuseIdentifier, for: indexPath) as? TheaterTableViewCell else { return UITableViewCell() }
            cell.configureCell()
            cell.theaterButton.addTarget(self, action: #selector(presentTheaterScene), for:.touchUpInside)
            
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ContentsTableViewCell.reuseIdentifier, for: indexPath) as? ContentsTableViewCell else { return UITableViewCell() }
            cell.contentsCollectionView.delegate = self
            cell.contentsCollectionView.dataSource = self
            cell.contentsCollectionView.register(UINib(nibName: ContentsCollectionViewCell.reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: ContentsCollectionViewCell.reuseIdentifier)
            cell.contentsCollectionView.reloadData()
            cell.configureCell(tableView, cellForRowAt: indexPath, trendingMovieArray: trendingMovieArray)
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? 80 : 190
    }
    
    @objc private func presentTheaterScene() {
        let sb = UIStoryboard(name: "Theater", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: TheaterViewController.reuseIdentifier) as! TheaterViewController

        self.present(vc, animated: true)
    }
}
