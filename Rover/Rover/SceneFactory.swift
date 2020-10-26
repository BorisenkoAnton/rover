//
//  SceneFactory.swift
//  Rover
//
//  Created by Anton Borisenko on 10/23/20.
//  Copyright © 2020 Anton Borisenko. All rights reserved.
//

import UIKit

class SceneFactory {
    
    static func mapCreationScene() -> UINavigationController {
        
        return createViewController(viewController: ViewWithMapController.self, navigationController: UINavigationController.self)
    }
    
    
    static func storageScene() -> UINavigationController {
        
        return createViewController(viewController: StorageViewController.self, navigationController: UINavigationController.self)
    }
    
    
    static private func createViewController(viewController: UIViewController.Type, navigationController: UINavigationController.Type) -> UINavigationController {
        
        let createdViewController = viewController.init()
        
        let createdNavigationController = navigationController.init(rootViewController: createdViewController)
        
        return createdNavigationController
    }
}
