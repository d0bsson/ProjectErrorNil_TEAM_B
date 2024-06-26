//
//  SceneDelegate.swift
//  ProjectErrorNil_TEAM_B
//
//  Created by d0bsson on 28.03.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate, UITabBarControllerDelegate {


    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        NotificationCenter.default.addObserver(self, selector: #selector(switchVC(notification: )), name: .loginNotification, object: nil)
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        
        if AuthManager.shared.userDef.string(forKey: "access_token") != nil {
            window.rootViewController = TabControllers()
        } else {
            window.rootViewController = UINavigationController(rootViewController: StartViewController())
        }
                
        window.makeKeyAndVisible()
        
        self.window = window
    }
    
    @objc func switchVC(notification: Notification) {
        guard let isLogin = notification.userInfo?["isLogin"] as? Bool else { return }
        if isLogin {
            self.window?.rootViewController = TabControllers()
        } else {
            self.window?.rootViewController = StartViewController()
        }
    }
    
    //MARK: - Этот код не срабатывает, пробую через NotificationCenter
//        func createRootViewController(viewController: UIViewController){
//            self.window?.rootViewController = UINavigationController(rootViewController: viewController)
//        }
//
//        func setLoginStatus(isLogin: Bool){
//            if isLogin{
//                let startVC = TabControllers()
//                startVC.delegate = self
//                createRootViewController(viewController: startVC)
//            } else{
//                let loginVC = StartViewController()
//                createRootViewController(viewController: loginVC)
//            }
//        }

    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
        
    }



