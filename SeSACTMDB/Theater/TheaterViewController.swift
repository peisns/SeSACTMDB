//
//  TheaterViewController.swift
//  SeSACTMDB
//
//  Created by Brother Model on 2022/08/12.
//

import UIKit
import MapKit

//Location1. import
import CoreLocation



class TheaterViewController: UIViewController {

    @IBOutlet weak var filterButton: UIButton!

    //location2. create Location Manager Instance
    //when locationManager declared, call a locationManagerDidChangeAuthorization method
    let locationManager = CLLocationManager()

    //import MapKit before declare MKmapView
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        filterButton.setTitle("Theater Filtering", for: .normal)
        filterButton.layer.cornerRadius = 10
        
        //Location4. use Protocol
        locationManager.delegate = self
        
        let campus = CLLocationCoordinate2D(latitude: 37.517829, longitude: 126.886270)
        setCenterRegion(center: campus)
    }
    
    @IBAction func filterActonSheet(_ sender: UIButton) {
        showAlertController()
    }
    
    func setCenterRegion(center: CLLocationCoordinate2D) {
        let region = MKCoordinateRegion(center: center, latitudinalMeters: 3000, longitudinalMeters: 3000)
        mapView.setRegion(region, animated: true)
    }
    
    func showAlertController() {
        let actionSheetController = UIAlertController()

        let allTheater = UIAlertAction(title: "전체보기", style: UIAlertAction.Style.default, handler: { (action: UIAlertAction) in print("OK all")
        })
        let cgv = UIAlertAction(title: "CGV", style: UIAlertAction.Style.default, handler: { (action: UIAlertAction) in print("OK cgv")
        })
        let megaBox = UIAlertAction(title: "메가박스", style: UIAlertAction.Style.default, handler: { (action: UIAlertAction) in print("OK mega")
        })
        let lotte = UIAlertAction(title: "롯데박스", style: UIAlertAction.Style.default, handler: { (action: UIAlertAction) in print("OK lotte")
        })

        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil)

        actionSheetController.addAction(allTheater)
        actionSheetController.addAction(cgv)
        actionSheetController.addAction(megaBox)
        actionSheetController.addAction(lotte)
        actionSheetController.addAction(cancelAction)

        self.present(actionSheetController, animated: true)
    }
    
    

}

//Location7 check User Location Info
extension TheaterViewController {
    
    //check Device Location Authorization
    func checkUserDeviceLocationServiceAuthorization() {
        print(#function)
        
        //get authorizationStatus
        let authorizationStatus: CLAuthorizationStatus
        if #available(iOS 14.0, *) {
            authorizationStatus = locationManager.authorizationStatus
        } else {
            authorizationStatus = CLLocationManager.authorizationStatus()
        }
        
        //check iOS location active
        //It isn't a app's authorization value but device's
        if CLLocationManager.locationServicesEnabled() {
            print("\(#function), locationServiceEnable == true")
            checkUserCurrentLocationAuthorization(authorizationStatus: authorizationStatus)
        } else {
            print("위치 서비스가 꺼져 있습니다.")
        }
        
        
        
    }
    
    // Location8. check app's location authorization
    func checkUserCurrentLocationAuthorization(authorizationStatus: CLAuthorizationStatus) {
        print(#function)
        switch authorizationStatus {
        case .notDetermined: // not determined yet
            print("notDetermined")
            
            // locationManager.desiredAccuracy = kCLLocationAccuracyBest // set location Accuracy, default value is best on iOS
            //request authorization to user
            locationManager.requestWhenInUseAuthorization()
            
        case .restricted: // don't have authroziation
            print("restricted")
        case .denied:
            print("denied")
            presentAlertToGetAuthorization()
        case .authorizedWhenInUse:
            print("authorizedWhenInUse")
            //call a startUpdatingLocation method to call a didUpdateLocations method
            locationManager.startUpdatingLocation()
        default:
            print("default")
        }
    }

    func presentAlertToGetAuthorization() {
        let alert = UIAlertController(title: "위치 정보 이용 알림", message: "위치서비스를 이용할 수 없습니다. 주변 영화관의 검색을 위해서 위치 정보가 필요합니다. 기기의 '설정 > 개인정보 보호'에서 위치 서비스를 켜주세요.", preferredStyle: .alert)
        
        let move = UIAlertAction(title: "설정으로 이동", style: .destructive) { _ in
            if let appSetting = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSetting)
            }
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        
        alert.addAction(move)
        alert.addAction(cancel)
        
        self.present(alert, animated: true)
    }
}



//Location3. declare Protocol
extension TheaterViewController: CLLocationManagerDelegate {
    
    //Location5. Get User Location Info
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(#function)
        if let center = locations.last?.coordinate {
            setCenterRegion(center: center)
        }
        locationManager.stopUpdatingLocation()
    }
    
    
    //Location6. can't get User Location Info
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(#function)
    }
    
    //location9. when changing user authorization
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print(#function)
        checkUserDeviceLocationServiceAuthorization()
    }
    //under iOS 14
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    }
}
