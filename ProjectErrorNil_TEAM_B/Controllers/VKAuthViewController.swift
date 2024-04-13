//
//  VKAuthViewController.swift
//  ProjectErrorNil_TEAM_B
//
//  Created by d0bsson on 29.03.2024.
//

import UIKit
import WebKit

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
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        guard let url = navigationResponse.response.url,
              let fragment = url.fragment
        else {
            decisionHandler(.allow)
            return
        }
        
        let
        params = fragment.components(separatedBy: "&")
            .map{$0.components(separatedBy: "=")}
            .reduce([String: String]()) { res, param in
                var dict = res
                let key = param[0]
                let value = param[1]
                dict[key] = value
                
                return dict
            }
        if let token = params["access_token"] {
            AuthManager.shared.userDef.setValue(token, forKey: "access_token")
            NotificationCenter.default.post(name: .loginNotification, object: nil, userInfo: ["isLogin" : true])
        }
        
        decisionHandler(.cancel)
    }
}

