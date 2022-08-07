//
//  VideoViewController.swift
//  SeSACTMDB
//
//  Created by Brother Model on 2022/08/05.
//

import UIKit
import WebKit

import Alamofire
import SwiftyJSON


class VideoViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    
    var selectedMovieID = 0
    
    var destinationURL: String = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()

        videoRequestAPI()
    }
    

    
    func openWebPage(to url:String) {
        guard let url = URL(string: url) else {
            print("Invalid URL")
            return
        }
        let request = URLRequest(url: url)
        webView.load(request)
    }

    func videoRequestAPI() {
        
        let url = EndPoint.TMDB_VIDEO_URL + "\(self.selectedMovieID)/videos?api_key=\(APIKey.TMDB_KEY)&language=en-US"
        
        AF.request(url, method: .get).validate().responseData { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
//                print("JSON: \(json)")
                
                var url = ""
                
                let key = json["results"][0]["key"].stringValue
                let site = json["results"][0]["site"].stringValue
                
                if site == "YouTube" {
                    url = "https://www.youtube.com/watch?v="
                } else {
                    url = "https://vimeo.com/"
                }
                
                self.destinationURL = url + key
                

                self.openWebPage(to: self.destinationURL)

            case .failure(let error):
                print(error)
            }
            
        }
    }
    
}
