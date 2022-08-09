//
//  ContentsViewController.swift
//  SeSACTMDB
//
//  Created by Brother Model on 2022/08/09.
//

import UIKit

class ContentsViewController: UIViewController {

    @IBOutlet weak var bannerCollectionView: UICollectionView!
    @IBOutlet weak var contentsTableView: UITableView!
    
    let numberList: [[Int]] = [
        [Int](1...20),
        [Int](21...40),
        [Int](41...60),
        [Int](61...80),
        [Int](81...100),
        [Int](101...120),
        [Int](121...140),
        [Int](141...160)
    ]
    
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

    }
}

extension ContentsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == bannerCollectionView {
            return 5
        } else {
            return numberList[section].count
        }    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == bannerCollectionView {
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContentsBannerCollectionViewCell.reuseIdentifier, for: indexPath) as? ContentsBannerCollectionViewCell else { return UICollectionViewCell() }
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContentsCollectionViewCell.reuseIdentifier, for: indexPath) as? ContentsCollectionViewCell else { return UICollectionViewCell() }
            cell.posterView.titleLabel.text = "\(numberList[collectionView.tag][indexPath.item])"
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
        return numberList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ContentsTableViewCell.reuseIdentifier, for: indexPath) as? ContentsTableViewCell else { return UITableViewCell() }
        
        cell.backgroundColor = .black
        cell.contentsCollectionView.backgroundColor = .black
        cell.contentsCollectionView.delegate = self
        cell.contentsCollectionView.dataSource = self
        cell.contentsCollectionView.register(UINib(nibName: ContentsCollectionViewCell.reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: ContentsCollectionViewCell.reuseIdentifier)
        cell.contentsCollectionView.tag = indexPath.row


        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 190
    }
}
