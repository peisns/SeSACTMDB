//
//  ProfileViewController.swift
//  SeSACTMDB
//
//  Created by Brother Model on 2022/08/13.
//

import UIKit

import YPImagePicker
import Photos

class ProfileViewController: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()


        profileImageView.layer.cornerRadius = 20
    }
    override func viewWillAppear(_ animated: Bool) {
        if let savedImage = UserDefaults.standard.data(forKey: "Profile") {
            profileImageView.image = UIImage(data: savedImage)
        }
    }
    
    @IBAction func backButtonClicked(_ sender: UIButton) {
        dismiss(animated: false)
        
    }
    
    @IBAction func profileChangeButtonClicked(_ sender: UIButton) {
        let picker = YPImagePicker()
        picker.didFinishPicking { [unowned picker] items, _ in
            if let photo = items.singlePhoto {
                print(photo.fromCamera) // Image source (camera or library)
                print(photo.image) // Final image selected by the user
                print(photo.originalImage) // original image selected by the user, unfiltered
                print(photo.modifiedImage) // Transformed image, can be nil
                print(photo.exifMeta) // Print exif meta data of original image.
                
                self.profileImageView.image = photo.image
                
                UserDefaults.standard.set(photo.image.jpegData(compressionQuality:1.0), forKey: "Profile")
            }
            picker.dismiss(animated: true, completion: nil)
        }
        present(picker, animated: true, completion: nil)
    }
    

}
