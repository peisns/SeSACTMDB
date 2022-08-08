//
//  TMDBAPIManager.swift
//  SeSACTMDB
//
//  Created by Brother Model on 2022/08/07.
//

import Foundation

import Alamofire
import Kingfisher
import SwiftyJSON

class genreRequestAPI {
    static let shared = genreRequestAPI()
    private init() { }
    
    typealias completionHandler = ([Int : String]) -> Void
    
    func getGenreData(completionHandler:@escaping completionHandler) {
        let genreURL = EndPoint.TMDB_GENRE_URL
        
        AF.request(genreURL, method: .get).validate().responseData { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                
                let genreArray = json["genres"].arrayValue
                var genreDictionary: [Int: String] = [:]
                
                for genre in genreArray {
                    let genreID: Int = genre["id"].intValue
                    let genreName: String = genre["name"].stringValue
                    genreDictionary[genreID] = genreName
                }
                completionHandler(genreDictionary)
                
            case .failure(let error):
                print(error)
            }
        }
    }
}

class trendingRequestAPI {
    static let shared = trendingRequestAPI()
    private init() { }
    
    typealias completionHandler = (Int, [Movie]) -> Void
    
    func getTrendingData(startPage: Int, completionHandler:@escaping completionHandler) {
        
        let url = EndPoint.TMDB_URL + APIKey.TMDB_KEY + "&page=" + String(startPage)
        
        AF.request(url, method: .get).validate().responseData { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                var movieInfo: [Movie] = []
                
                let resultArray = json["results"].arrayValue
                
                let totalCount = json["total_pages"].intValue
                
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
                movieInfo.append(Movie(id: id, release_date: release_date, genre_ids: genre_ids, title: title, imageURL: imageURL, vote_average: vote_average))
                }
                
                completionHandler(totalCount, movieInfo)
                
            case .failure(let error):
                print(error)
            }
        }
    }
}

class creditRequestAPI {
    static let shared = creditRequestAPI()
    private init() { }
    
    func getCreditData(movieId: Int, completionHandler:@escaping ([String], [String])-> Void) {
        
        let url = EndPoint.TMDB_CREDITS_URL + String(movieId) + "/credits?api_key=\(APIKey.TMDB_KEY)&language=en-US"
        
        AF.request(url, method: .get).validate().responseData { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                
                let castArray = json["cast"].arrayValue
                let crewArray = json["crew"].arrayValue
                let casts = castArray.map { $0["name"].stringValue }
                let crews = crewArray.map { $0["name"].stringValue }
                
                completionHandler(casts, crews)
                
            case .failure(let error):
                print(error)
            }
        }
    }
}

class videoRequestAPI {
    static let shared = videoRequestAPI()
    private init() { }
    
    typealias completionHandler = (String, String) -> Void
    func getVideoData(selectedMovieID:Int, completionHandler: @escaping completionHandler) {
            let url = EndPoint.TMDB_VIDEO_URL + "\(selectedMovieID)/videos?api_key=\(APIKey.TMDB_KEY)&language=en-US"
            
            AF.request(url, method: .get).validate().responseData { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    let key = json["results"][0]["key"].stringValue
                    let site = json["results"][0]["site"].stringValue
                    
                    let url = site == "YouTube" ? "https://www.youtube.com/watch?v=" : "https://vimeo.com/"
                    
                    completionHandler(url, key)
                    
                case .failure(let error):
                    print(error)
            }
        }
    }
}
