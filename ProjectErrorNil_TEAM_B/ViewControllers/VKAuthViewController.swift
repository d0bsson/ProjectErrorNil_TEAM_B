//
//  VKAuthViewController.swift
//  ProjectErrorNil_TEAM_B
//
//  Created by d0bsson on 29.03.2024.
//

import UIKit
import WebKit
//https://oauth.vk.com/authorize?client_id=51891179&redirect_uri=/blank.html&display=mobile&scope=offline&response_type=token&v=5.199


class VKAuthViewController: UIViewController {
    
    private let vkManager = VKManager()
    
    lazy var webView = {
        $0.navigationDelegate = self
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(WKWebView(frame: view.frame))

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(webView)
        if let req = vkManager.getAuthRequest() {
            webView.load(req)
        }
    }
}

extension VKAuthViewController: WKNavigationDelegate {
    
}
