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
        label.text = "asdfasdjkasdf;a"
        label.numberOfLines = 0
        label.textColor = .white
        return label
    }()
    
    let mainChild03: UIView = {
        let view = UIView()
        view.backgroundColor = .blue
        return view
    }()
    
    let mainChild04: UIView = {
        let view = UIView()
        view.backgroundColor = .systemPink
        return view
    }()
    
    let mainChild05: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        return view
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
        view.backgroundColor = .black
        return view
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
        sendMainSceneButton.addTarget(self, action: #selector(presentToMainScene), for: .touchUpInside)
    }
    
    @objc func presentToMainScene() {
        presentScene(name: "Main", vc: ViewController(), style: .fullScreen)

    }
    

    func configureUI() {
        let topAndFooterViewHeight = view.bounds.height * 0.2
        [topView, mainView , footerView].forEach { view.addSubview($0)}
        
        [titleLabel].forEach {topView.addSubview($0)}
        
        [mainChild01, mainChild02, mainChild03, mainChild04, mainChild05].forEach{mainView.addArrangedSubview($0)}
        
        mainChild01.addSubview(descriptionLabel)
        [cameraImageView, cameraLabel].forEach {mainChild02.addSubview($0)}
        
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
            make.width.equalTo(view)
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
            make.leading.equalTo(cameraImageView.snp.trailing)
            make.trailing.equalTo(view).inset(44)
            make.top.bottom.equalTo(mainChild02)
        }
        
        footerView.snp.makeConstraints { make in
            make.height.equalTo(topAndFooterViewHeight)
            make.leading.trailing.bottom.equalTo(view)
        }
        
        sendMainSceneButton.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(footerView)
            make.width.equalTo(view).inset(44)
            make.height.equalTo(44)
        }
    }

}
