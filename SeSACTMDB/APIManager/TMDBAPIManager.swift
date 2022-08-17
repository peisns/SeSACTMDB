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

class getTMDBJson {
    static let shared = getTMDBJson()
    private init() { }
    
    typealias getJsonCompletionHandler = (JSON) -> Void
    func getJson(url: String, completionHandler: @escaping getJsonCompletionHandler) {
        AF.request(url, method: .get).validate().responseData { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                completionHandler(json)
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    typealias genreCompletionHandler = ([Int : String]) -> Void
    func genreJSON(completionHandler: @escaping genreCompletionHandler) {
        getJson(url: EndPoint.TMDB_GENRE_URL) { json in
            let genreArray = json["genres"].arrayValue
            var genreDictionary: [Int: String] = [:]
            
            for genre in genreArray {
                let genreID: Int = genre["id"].intValue
                let genreName: String = genre["name"].stringValue
                genreDictionary[genreID] = genreName
            }
            completionHandler(genreDictionary)
        }
    }
        
    typealias getMovieInfoCompletionHandler = (Int?, [Movie]) -> Void
    func getMovieInfoData(url:String, completionHandler:@escaping getMovieInfoCompletionHandler) {
        getJson(url: url) { json in
            var movieInfo: [Movie] = []

            let resultArray = json["results"].arrayValue
            let totalCount = json["total_pages"].int
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
        }
    }
    
    func getCreditData(movieId: Int, completionHandler:@escaping ([String], [String])-> Void) {
        let url = EndPoint.TMDB_BASE_URL + String(movieId) + "/credits?api_key=\(APIKey.TMDB_KEY)&language=en-US"
        getJson(url: url) { json in
            let castArray = json["cast"].arrayValue
            let crewArray = json["crew"].arrayValue
            let casts = castArray.map { $0["name"].stringValue }
            let crews = crewArray.map { $0["name"].stringValue }
            
            completionHandler(casts, crews)
        }
    }
    
    typealias getVideoCompletionHandler = (String, String) -> Void
    func getVideoData(selectedMovieID:Int, completionHandler: @escaping getVideoCompletionHandler) {
        let url = EndPoint.TMDB_BASE_URL + "\(selectedMovieID)/videos?api_key=\(APIKey.TMDB_KEY)&language=en-US"
        getJson(url: url) { json in
            let key = json["results"][0]["key"].stringValue
            let site = json["results"][0]["site"].stringValue
            
            let url = site == "YouTube" ? "https://www.youtube.com/watch?v=" : "https://vimeo.com/"
            
            completionHandler(url, key)
        }
    }
}

