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

        videoRequestAPI.shared.getVideoData(selectedMovieID: selectedMovieID) { url, key in
            self.destinationURL = url + key
            self.openWebPage(to: self.destinationURL)
        }
    }
    
    func openWebPage(to url:String) {
        guard let url = URL(string: url) else {
            print("Invalid URL")
            return
        }
        let request = URLRequest(url: url)
        webView.load(request)
    }
}
