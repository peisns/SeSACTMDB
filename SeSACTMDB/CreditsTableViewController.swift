//
//  CreditsTableViewController.swift
//  SeSACTMDB
//
//  Created by Brother Model on 2022/08/05.
//

import UIKit

import Alamofire
import SwiftyJSON

class CreditsTableViewController: UITableViewController {
    
    var credits: [String] = []
    var selectedMovie: Movie = Movie(id: 0, release_date: "", genre_ids: [], title: "", imageURL: "", vote_average: 0)
    
    @IBOutlet weak var movieTitleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        movieTitleLabel.text = selectedMovie.title
        
        creditRequestAPI(movieid: selectedMovie.id)
        tableView.rowHeight = 200
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return credits.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CreditsTableViewCell.reuseIdentifier, for: indexPath) as? CreditsTableViewCell else { return UITableViewCell() }
        
        cell.peopleName.text = credits[indexPath.row]
        
        return cell
    }
 
    func creditRequestAPI(movieid: Int) {
        
        let url = EndPoint.TMDB_CREDITS_URL + String(selectedMovie.id) + "/credits?api_key=\(APIKey.TMDB_KEY)&language=en-US"
        
        AF.request(url, method: .get).validate().responseData { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
//                print("JSON: \(json)")
                
                let resultArray = json["cast"].arrayValue
                
                for result in resultArray {
                    let credit = result["name"].stringValue
                    self.credits.append(credit)
                }
                self.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
            
        }
    }
}
