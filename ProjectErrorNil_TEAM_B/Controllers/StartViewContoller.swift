//
//  ViewController.swift
//  ProjectErrorNil_TEAM_B
//
//  Created by d0bsson on 28.03.2024.
//

import UIKit

class StartViewController: UIViewController {
    
    var delegate: SceneDelegate? 
    
    lazy var backgroundImage = {
        $0.image = UIImage(named: "background")
        $0.contentMode = .scaleToFill
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIImageView())
    
    lazy var authButton = {
        $0.setTitle("Войти", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .black
        $0.layer.cornerRadius = 20
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIButton(primaryAction: authAction))
    
    lazy var errorNilLabel = {
        $0.text = "ErrorNil"
        $0.font = .systemFont(ofSize: 30, weight: .bold)
        $0.textColor = .white
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())
    
    lazy var nameTeamLabel = {
        $0.text = "Team B (Madina, Ruslan, David)"
        $0.font = .systemFont(ofSize: 16, weight: .semibold)
        $0.textColor = .white
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())
    
    lazy var authAction = UIAction { [weak self] _ in
        print("AUTH")
        let vc = VKAuthViewController()
        self?.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(backgroundImage)
        view.addSubview(authButton)
        view.addSubview(errorNilLabel)
        view.addSubview(nameTeamLabel)
        setConstraints()
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            backgroundImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            backgroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            backgroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            
            authButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            authButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            authButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            authButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -80),
            authButton.heightAnchor.constraint(equalToConstant: 58),
            
            errorNilLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 144),
            errorNilLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            nameTeamLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 180),
            nameTeamLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ])
    }
}

