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
        
        let mapCreationViewController = MapCreationViewController()
        
        let mapCreationNavigationController = UINavigationController.init(rootViewController: mapCreationViewController)
        
        let mapPresenter = MapPresenter()
        
        mapPresenter.setViewDelegate(viewWithMapControllerDelegate: mapCreationViewController)
        
        mapCreationViewController.setMapPresenterDelegate(delegate: mapPresenter)
        
        return mapCreationNavigationController
    }
    
    
    static func storageScene() -> UINavigationController {
        
        let storageViewController = StorageViewController()
        
        let storageNavigationController = UINavigationController.init(rootViewController: storageViewController)
        
        let storagePresenter = StoragePresenter()
        
        storagePresenter.setViewDelegate(storageViewControllerDelegate: storageViewController)
        
        storageViewController.setStoragePresenterDelegate(delegate: storagePresenter)
        
        return storageNavigationController
    }
    
    
    static func simulationScene(map: DBMapModel) -> UINavigationController {
        
        let stimulationViewController = SimulationViewController()
        
        let stimulationNavigationController = UINavigationController.init(rootViewController: stimulationViewController)
        
        let simulationPresenter = SimulationPresenter()
        
        simulationPresenter.setViewDelegate(simulationViewControllerDelegate: stimulationViewController)
        simulationPresenter.map = map
        
        stimulationViewController.setSimulationPresenterDelegate(delegate: simulationPresenter)
        
        return stimulationNavigationController
    }
}
