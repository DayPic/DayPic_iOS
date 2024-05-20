//
//  SceneDelegate.swift
//  DayPic
//
//  Created by 박준홍 on 5/20/24.
//

import UIKit
import TodayList
import PhotoOrganizer

final class SceneDelegate: UIResponder,
                           UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene)
        else { return }
        self.window = UIWindow(windowScene: windowScene)
        let photoOrganizer = OpenAIClipPhotoOrganizer()
        let viewModel = TodayListViewModel(photoOrganizer: photoOrganizer)
        self.window?.rootViewController = TodayListViewController(
            viewModel: viewModel
        )
        self.window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        
    }

    func sceneWillResignActive(_ scene: UIScene) {
        
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        
    }


}

