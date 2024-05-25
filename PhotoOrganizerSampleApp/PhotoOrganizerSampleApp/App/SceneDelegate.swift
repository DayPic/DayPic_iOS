//
//  SceneDelegate.swift
//  PhotoOrganizerSampleApp
//
//  Created by 박준홍 on 5/21/24.
//

import UIKit
import PhotoOrganizer

final class SceneDelegate: UIResponder,
                           UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        
        let categories = ["food", "scene", "human", "animal", "nature", "city", "product", "exercise", "meal", "dessert", "pet", "night", "daytime", "people", "dynamic", "static", "indoor", "outdoor"]
        
        guard let windowScene = (scene as? UIWindowScene)
        else { return }
        self.window = UIWindow(windowScene: windowScene)
        let photoOrganizer = OpenAIClipPhotoOrganizer()
        let viewModel = SampleViewModel(
            photoOrganizer: photoOrganizer,
            categories: categories
        )
        self.window?.rootViewController = SampleViewController(
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

