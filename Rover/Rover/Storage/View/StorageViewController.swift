//
//  StorageViewController.swift
//  Rover
//
//  Created by Anton Borisenko on 10/22/20.
//  Copyright © 2020 Anton Borisenko. All rights reserved.
//

import UIKit
import RealmSwift

class StorageViewController: UIViewController {
    
    let tableWithStoredMapsView = UITableView()
    
    var storedMaps = Array<DBMapModel>()
    
    let storagePresenter = StoragePresenter()
    
    
    override func loadView() {
        
        super.loadView()
        
        addTableView()
        
        configureNavigationBar()
        
        self.storagePresenter.setViewDelegate(storageViewControllerDelegate: self)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        self.storagePresenter.getStoredMaps()
    }
    
    
    func addTableView() {
        
        view.addSubview(tableWithStoredMapsView)
        
        tableWithStoredMapsView.translatesAutoresizingMaskIntoConstraints = false
        tableWithStoredMapsView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableWithStoredMapsView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableWithStoredMapsView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableWithStoredMapsView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        tableWithStoredMapsView.delegate = self
        tableWithStoredMapsView.dataSource = self
        
        tableWithStoredMapsView.register(CellWithStoredMap.self, forCellReuseIdentifier: CellWithStoredMap.reuseID)
    }
    
    
    func configureNavigationBar() {
        
        let synchronizationButton = UIBarButtonItem(title: "Synchronize", style: .plain, target: self, action: nil)
        
        self.navigationItem.rightBarButtonItem  = synchronizationButton
        
        let createButton = UIBarButtonItem(title: "Create", style: .plain, target: self, action: #selector(createButtonPressed))
        
        self.navigationItem.rightBarButtonItems = [synchronizationButton, createButton]
        
        let returnButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(returnButtonPressed))
        
        self.navigationItem.leftBarButtonItem  = returnButton
    }
    
    
    @objc func createButtonPressed() {
        
        self.storagePresenter.createMap(navigationController: self.navigationController!)
    }
    
    
    @objc func returnButtonPressed() {
        
        self.storagePresenter.returnToCurrentMap()
    }
}
