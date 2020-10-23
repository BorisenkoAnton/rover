//
//  StorageViewController.swift
//  Rover
//
//  Created by Anton Borisenko on 10/22/20.
//  Copyright © 2020 Anton Borisenko. All rights reserved.
//

import UIKit

class StorageViewController: UIViewController {
    
    let tableWithStoredMapsView = UITableView()
    
    override func loadView() {
        
        super.loadView()
        
        addTableView()
        
        configureNavigationBar()
    }

    
    func addTableView() {
        
        view.addSubview(tableWithStoredMapsView)
        
        tableWithStoredMapsView.translatesAutoresizingMaskIntoConstraints = false
        tableWithStoredMapsView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableWithStoredMapsView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableWithStoredMapsView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableWithStoredMapsView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
    
    
    func configureNavigationBar() {
        
        let synchronizationButton = UIBarButtonItem(title: "Synchronize", style: .plain, target: self, action: nil)
        
        self.navigationItem.rightBarButtonItem  = synchronizationButton
        
        let mapCreationButton = UIBarButtonItem(title: "Create", style: .plain, target: self, action: nil)
        
        self.navigationItem.leftBarButtonItem  = mapCreationButton
    }
}
