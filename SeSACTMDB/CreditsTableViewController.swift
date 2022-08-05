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
    
    var casts: [String] = []
    var crews: [String] = []
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
        if section == 0 {
            return casts.count
        } else if section == 1 {
            return crews.count
        } else {
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CreditsTableViewCell.reuseIdentifier, for: indexPath) as? CreditsTableViewCell else { return UITableViewCell() }
        
        if indexPath.section == 0 {
            cell.peopleName.text = casts[indexPath.row]
            cell.backgroundColor = .orange
        } else if indexPath.section == 1 {
            cell.peopleName.text = crews[indexPath.row]
            cell.backgroundColor = .brown
        }
        return cell
    }
 
    func creditRequestAPI(movieid: Int) {
        
        let url = EndPoint.TMDB_CREDITS_URL + String(selectedMovie.id) + "/credits?api_key=\(APIKey.TMDB_KEY)&language=en-US"
        
        AF.request(url, method: .get).validate().responseData { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
//                print("JSON: \(json)")
                
                let castArray = json["cast"].arrayValue
                let crewArray = json["crew"].arrayValue
                
                for cast in castArray {
                    let credit = cast["name"].stringValue
                    self.casts.append(credit)
                }
                for crew in crewArray {
                    let credit = crew["name"].stringValue
                    self.crews.append(credit)
                }
                
                self.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
            
        }
    }
}
