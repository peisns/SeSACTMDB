//
//  ProfileViewController.swift
//  SeSACTMDB
//
//  Created by Brother Model on 2022/08/13.
//

import UIKit

import YPImagePicker

class ProfileViewController: UIViewController {

    // 1. UIImagePickerController 인스턴스 생성
    let picker = UIImagePickerController()
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        profileImageView.layer.cornerRadius = 20
        picker.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let savedImage = UserDefaults.standard.data(forKey: "Profile") {
            profileImageView.image = UIImage(data: savedImage)
        }
    }
    
    @IBAction func backButtonClicked(_ sender: UIButton) {
        dismiss(animated: false)
    }
    
    //UIImagePickerController
    @IBAction func profileChangeButtonClicked2(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
            picker.allowsEditing = true
            
            present(picker, animated: true)
        } else {
            // 사용불가, 사용자에게 alert
        }
    }
    
    @IBAction func profileChangeButtonClicked3(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            picker.sourceType = .photoLibrary
            picker.allowsEditing = true
            
            present(picker, animated: true)
        } else {
            // 사용불가, 사용자에게 alert
        }
    }
    
    
    //Open Source
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

//3. add Delegate
extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //4. after user selects a photo
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.profileImageView.image = image
            UserDefaults.standard.set(image.jpegData(compressionQuality:1.0), forKey: "Profile")
            dismiss(animated: true)
        }
    }
    
    //5. after user clicks a cancel
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    }
    
    
}
