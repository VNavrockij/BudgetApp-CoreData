//
//  SceneDelegate.swift
//  BudgetApp
//
//  Created by Vitalii Navrotskyi on 22.04.2024.
//

import UIKit
import CoreData

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    private enum Constant: String {
        case model = "BudgetModel"
    }

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: Constant.model.rawValue)
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
        return container
    }()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }

        let window = UIWindow(windowScene: scene)
        window.makeKeyAndVisible()
        let navController = UINavigationController(
            rootViewController: BudgetCategoriesTableViewController(
                persistentContainer: persistentContainer
            )
        )
        window.rootViewController = navController
        self.window = window
    }

    func sceneDidDisconnect(_ scene: UIScene) {}

    func sceneDidBecomeActive(_ scene: UIScene) {}

    func sceneWillResignActive(_ scene: UIScene) {}

    func sceneWillEnterForeground(_ scene: UIScene) {}

    func sceneDidEnterBackground(_ scene: UIScene) {}
}
