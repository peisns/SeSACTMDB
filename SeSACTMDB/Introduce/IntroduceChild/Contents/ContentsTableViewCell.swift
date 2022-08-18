//
//  ContentsTableViewCell.swift
//  SeSACTMDB
//
//  Created by Brother Model on 2022/08/09.
//

import UIKit

class ContentsTableViewCell: UITableViewCell {

    @IBOutlet weak var headerLabel: UILabel!
    
    @IBOutlet weak var contentsCollectionView: UICollectionView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        
    }

    private func setupUI() {

        headerLabel.textColor = .white
        headerLabel.text = "추천 콘텐츠"
        
        contentsCollectionView.backgroundColor = .clear
        contentsCollectionView.collectionViewLayout = collectionViewLayout()
    }
    
    private func collectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 100, height: 141)
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
        
        return layout
    }
    
    func configureCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, trendingMovieArray: [Movie]) {
        backgroundColor = .black
        contentsCollectionView.tag = indexPath.row
        contentsCollectionView.backgroundColor = .black
        switch indexPath.row {
        case 0:
            headerLabel.text = "가장 핫한 \(trendingMovieArray[0].title)을 좋아하신다면?"
        case 1:
            headerLabel.text = "가장 핫한 \(trendingMovieArray[0].title)과 비슷한 영화"
        case 2:
            headerLabel.text = "지금 상영중인 영화"
        case 3:
            headerLabel.text = "인기 영화"
        case 4:
            headerLabel.text = "역대급 TOP RANK!"
        default:
            headerLabel.text = "Test"
        }
        selectionStyle = .none

    }
}
