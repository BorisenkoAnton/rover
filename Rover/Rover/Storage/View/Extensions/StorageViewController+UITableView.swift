//
//  StorageViewController+.swift
//  Rover
//
//  Created by Anton Borisenko on 10/23/20.
//  Copyright © 2020 Anton Borisenko. All rights reserved.
//

import UIKit
import RealmSwift

extension StorageViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.storedMaps.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CellWithStoredMap.reuseID, for: indexPath) as? CellWithStoredMap else {
            return UITableViewCell()
        }
        
        // Tag for text fild is set to track index of Map, which name will be changed
        cell.update(mapName: self.storedMaps[indexPath.row].name, textfieldTag: indexPath.row)
        
        cell.mapNameTextField.delegate = self
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, actionPerformed) in
            
            self.storagePresenterDelegate?.removeMapFromStorage(map: self.storedMaps[indexPath.row])
            
            self.storedMaps.remove(at: indexPath.row)
            
            self.tableWithStoredMapsView.deleteRows(at: [indexPath], with: .automatic)
        }
        
        let editAction = UIContextualAction(style: .normal, title: "Edit") { (action, view, actionPerformed) in
            
            self.storagePresenterDelegate?.editMap(map: self.storedMaps[indexPath.row], navigationController: self.navigationController!)
        }
        
        let simulateAction = UIContextualAction(style: .normal, title: "Simulate") { (action, view, actionPerformed) in
            
            self.storagePresenterDelegate?.simulateMap(map: self.storedMaps[indexPath.row], navigationController: self.navigationController!)
        }
        
        let swipeActions = UISwipeActionsConfiguration(actions: [deleteAction, editAction, simulateAction])

        return swipeActions
    }
}
