//
//  IntroduceChild03ViewController.swift
//  SeSACTMDB
//
//  Created by Brother Model on 2022/08/18.
//

import UIKit

import SnapKit

class IntroduceChild03ViewController: UIViewController {
    
    let topView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Allow Tracking on the next screen for:"
        label.numberOfLines = 0
        label.textAlignment = .left
        label.font = .boldSystemFont(ofSize: 28)
        return label
    }()
    
    let mainView: UIStackView = {
        let view = UIStackView()
        view.distribution = .fillEqually
        view.backgroundColor = .black
        view.axis = .vertical
        return view
    }()
    
    let mainChild01: UIView = {
        let view = UIView()
        return view
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Turning on location services allows us to provide featrues like:"
        label.textColor = .white
        label.numberOfLines = 0
        label.font = .boldSystemFont(ofSize: 16)
        return label
    }()
    
    let mainChild02: UIView = {
        let view = UIView()
        return view
    }()
    
    let cameraImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "camera.circle.fill")
        view.tintColor = .white
        return view
    }()
    
    let cameraLabel: UILabel = {
        let label = UILabel()
        label.text = "Camera usage is needed when you set a profile"
        label.numberOfLines = 0
        label.textColor = .white
        return label
    }()
    
    let mainChild03: UIView = {
        let view = UIView()
        return view
    }()
    
    let photoImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "photo.on.rectangle.angled")
        view.tintColor = .white
        return view
    }()
    
    let photoLabel: UILabel = {
        let label = UILabel()
        label.text = "You can set a profile image of your photo library"
        label.numberOfLines = 0
        label.textColor = .white
        return label
    }()
    
    let mainChild04: UIView = {
        let view = UIView()
        return view
    }()
    
    let locationImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "map.fill")
        view.tintColor = .white
        return view
    }()
    
    let locationLabel: UILabel = {
        let label = UILabel()
        label.text = "Near theaters is found with map"
        label.numberOfLines = 0
        label.textColor = .white
        return label
    }()
    
    let mainChild05: UIView = {
        let view = UIView()
        return view
    }()
    
    let descriptionLabel2: UILabel = {
        let label = UILabel()
        label.text = "You can change this later in the Setting app"
        label.textColor = .white
        label.numberOfLines = 0
        label.font = .boldSystemFont(ofSize: 16)
        return label
    }()
    
    let sendMainSceneButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitleColor(UIColor.black, for: .normal)
        button.setTitle("시작하기", for: .normal)
        button.layer.cornerRadius = 15
        return button
    }()
    
    let footerView: UIView = {
        let view = UIView()
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
        sendMainSceneButton.addTarget(self, action: #selector(presentToMainScene), for: .touchUpInside)
    }
    
    @objc func presentToMainScene() {
        self.dismiss(animated: true)
        presentScene(name: "Main", vc: ViewController(), style: .fullScreen)
    }

    func configureUI() {
        let topAndFooterViewHeight = view.bounds.height * 0.2
        [topView, mainView , footerView].forEach { view.addSubview($0)}
        
        [titleLabel].forEach {topView.addSubview($0)}
        
        [mainChild01, mainChild02, mainChild03, mainChild04, mainChild05].forEach{mainView.addArrangedSubview($0)}
        
        mainChild01.addSubview(descriptionLabel)
        [cameraImageView, cameraLabel].forEach {mainChild02.addSubview($0)}
        [photoImageView, photoLabel].forEach {mainChild03.addSubview($0)}
        [locationImageView, locationLabel].forEach {mainChild04.addSubview($0)}
        mainChild05.addSubview(descriptionLabel2)

        [sendMainSceneButton].forEach {footerView.addSubview($0)}
        
        topView.snp.makeConstraints { make in
            make.top.equalTo(view)
            make.leading.equalTo(view)
            make.trailing.equalTo(view)
            make.height.equalTo(topAndFooterViewHeight)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view).inset(44)
            make.centerY.equalTo(topView).offset(topAndFooterViewHeight * 0.2)
        }
        
        mainView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view)
            make.top.equalTo(topView.snp.bottom)
            make.bottom.equalTo(footerView.snp.top)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.centerY.equalTo(mainChild01)
            make.trailing.leading.equalTo(view).inset(44)
        }
        
        cameraImageView.snp.makeConstraints { make in
            make.leading.equalTo(mainChild02).inset(44)
            make.width.equalTo(mainChild02.snp.height).inset(20)
            make.centerY.equalTo(mainChild02)
            make.height.equalTo(cameraImageView.snp.width)
        }
        
        cameraLabel.snp.makeConstraints { make in
            make.leading.equalTo(cameraImageView.snp.trailing).offset(16)
            make.trailing.equalTo(view).inset(44)
            make.top.bottom.equalTo(mainChild02)
        }
        
        photoImageView.snp.makeConstraints { make in
            make.leading.equalTo(mainChild03).inset(44)
            make.width.equalTo(mainChild03.snp.height).inset(20)
            make.centerY.equalTo(mainChild03)
            make.height.equalTo(cameraImageView.snp.width)
        }
        
        photoLabel.snp.makeConstraints { make in
            make.leading.equalTo(photoImageView.snp.trailing).offset(16)
            make.trailing.equalTo(view).inset(44)
            make.top.bottom.equalTo(mainChild03)
        }
        
        locationImageView.snp.makeConstraints { make in
            make.leading.equalTo(mainChild04).inset(44)
            make.width.equalTo(mainChild04.snp.height).inset(20)
            make.centerY.equalTo(mainChild04)
            make.height.equalTo(locationImageView.snp.width)
        }
        
        locationLabel.snp.makeConstraints { make in
            make.leading.equalTo(locationImageView.snp.trailing).offset(16)
            make.trailing.equalTo(view).inset(44)
            make.top.bottom.equalTo(mainChild04)
        }
        
        descriptionLabel2.snp.makeConstraints { make in
            make.centerY.equalTo(mainChild05)
            make.trailing.leading.equalTo(view).inset(44)
        }
        
        footerView.snp.makeConstraints { make in
            make.height.equalTo(topAndFooterViewHeight)
            make.leading.trailing.bottom.equalTo(view)
        }
        
        sendMainSceneButton.snp.makeConstraints { make in
            make.centerX.equalTo(footerView)
            make.centerY.equalTo(footerView).offset(-44)
            make.width.equalTo(view).inset(44)
            make.height.equalTo(44)
        }
    }
}
