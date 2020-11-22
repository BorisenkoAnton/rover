//
//  SceneFactory.swift
//  Rover
//
//  Created by Anton Borisenko on 10/23/20.
//  Copyright © 2020 Anton Borisenko. All rights reserved.
//

import UIKit

class SceneFactory {
    
    static func mapCreationScene() -> UIViewController {
        
        let mapCreationViewController = MapCreationViewController()
        
        let mapPresenter = MapPresenter()
        
        mapPresenter.setViewDelegate(viewWithMapControllerDelegate: mapCreationViewController)
        
        mapCreationViewController.setMapPresenterDelegate(delegate: mapPresenter)
        
        return mapCreationViewController
    }
    
    
    static func storageScene() -> UIViewController {
        
        let storageViewController = StorageViewController()
        
        let storagePresenter = StoragePresenter()
        
        storagePresenter.setViewDelegate(storageViewControllerDelegate: storageViewController)
        
        storageViewController.setStoragePresenterDelegate(delegate: storagePresenter)
        
        return storageViewController
    }
    
    
    static func simulationScene(map: DBMapModel) -> UIViewController {
        
        let simulationViewController = SimulationViewController()
        
        let simulationPresenter = SimulationPresenter()
        
        simulationPresenter.setViewDelegate(simulationViewControllerDelegate: simulationViewController)
        simulationPresenter.map = map
        
        simulationViewController.setSimulationPresenterDelegate(delegate: simulationPresenter)
        
        return simulationViewController
    }
}
