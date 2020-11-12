//
//  ViewController.swift
//  Rover
//
//  Created by Anton Borisenko on 10/20/20.
//  Copyright © 2020 Anton Borisenko. All rights reserved.
//

import UIKit
import RealmSwift

class MapCreationViewController: UIViewController {

    private var screenSize: CGRect {
        return UIScreen.main.bounds
    }
    
    var mapItemsCollectionView: UICollectionView! // Collection View, representing map
    var bottomPanelStackView: UIStackView!
    
    let itemsPerRow = 9
    let rowsCount = 16
    let minimumItemSpacing: CGFloat = 1.0
    let sectionInsets = UIEdgeInsets(top: 2.0, left: 2.0, bottom: 2.0, right: 2.0)
    
    var map: DBMapModel!
    
    var mapPresenterDelegate: MapPresenterDelegate?
    
    override func loadView() {
        super.loadView()
        
        configureAndAddPanels()
        
        configureAndAddCollectionView()
        
        if self.map == nil {
            setClearMap()
        }
        
        mapPresenterDelegate?.setViewDelegate(viewWithMapControllerDelegate: self)
        
        addGestureRecognizer()
    }

    
    //MARK: actions
    
    @objc func bottomPanelButtonPressed(sender: BottomPanelButton!) {
        
        mapPresenterDelegate?.surfaceTypeSelected(selectedType: sender.mapItemType)
    }
    
    
    @objc func storageButtonPressed() {
        
        self.mapPresenterDelegate?.mapWasChanged(map: self.map)
        self.mapPresenterDelegate?.storageButtonPressed()
    }
    
    
    @objc func saveMap() {
        
        self.mapPresenterDelegate?.saveMap(map: self.map)
    }
    
    
    @objc func randomMapGenerationButtonPressed() {
        
        mapPresenterDelegate?.generateRandomMap(neededNumberOfMapItems: self.map.mapItems.count, map: self.map, itemsPerRow: self.itemsPerRow)
    }
    
    
    @objc func detectPanGestureRecognizer(_ recognizer:UIPanGestureRecognizer) {
        
        let location = recognizer.location(in: self.mapItemsCollectionView)
        
        if let mapItemIndexPath = self.mapItemsCollectionView.indexPathForItem(at: location) {
            
            mapPresenterDelegate?.mapItemSelected(map: self.map, indexPath: mapItemIndexPath)
        }
    }
    
    // MARK: configuring view elements
    func configureAndAddCollectionView() {
        
        mapItemsCollectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: UICollectionViewFlowLayout())
        mapItemsCollectionView.backgroundColor = .white
        mapItemsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        mapItemsCollectionView.delegate = self
        mapItemsCollectionView.dataSource = self
        
        view.addSubview(mapItemsCollectionView)
        
        NSLayoutConstraint.activate([
            mapItemsCollectionView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: screenSize.height * 0.10),
            mapItemsCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: screenSize.width * 0.05),
            mapItemsCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -(screenSize.width * 0.05)),
            mapItemsCollectionView.bottomAnchor.constraint(equalTo: bottomPanelStackView.topAnchor, constant: -(screenSize.height * 0.05))
        ])
        
        mapItemsCollectionView.register(MapItemCollectionViewCell.self, forCellWithReuseIdentifier: MapItemCollectionViewCell.reuseID)
    }
    
    // Configuring and adding top (with random generating button) and bottom (with surface types) panels to view
    func configureAndAddPanels() {
        
        // Top panel
        let randomMapGenerationButton = UIBarButtonItem(title: "Generate", style: .plain, target: self, action: #selector(randomMapGenerationButtonPressed))
        
        let saveButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveMap))
        
        let storageButton = UIBarButtonItem(title: "Storage", style: .plain, target: self, action: #selector(storageButtonPressed))
        
        self.navigationItem.leftBarButtonItem = randomMapGenerationButton
        
        self.navigationItem.rightBarButtonItems = [storageButton, saveButton]
        
        // Bottom panel
        bottomPanelStackView = createStackView()
        
        view.addSubview(bottomPanelStackView)
        
        NSLayoutConstraint.activate([
            bottomPanelStackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: screenSize.width * 0.05),
            bottomPanelStackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -(screenSize.width * 0.05)),
            bottomPanelStackView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -(screenSize.height * 0.05)),
            bottomPanelStackView.heightAnchor.constraint(equalToConstant: screenSize.height * 0.1)
        ])
        
        for surfaceType in SurfaceType.allCases {
            let bottomPanelButton = BottomPanelButton()
            
            bottomPanelButton.mapItemType = surfaceType
            bottomPanelButton.translatesAutoresizingMaskIntoConstraints = false
            bottomPanelButton.addTarget(self, action: #selector(bottomPanelButtonPressed(sender:)), for: .touchUpInside)
            
            let imageName = SurfaceType.returnStringValue(surfaceType:surfaceType)
            
            if let image = UIImage(named: "\(imageName)") {
                bottomPanelButton.setImage(image, for: .normal)
            }
            
            bottomPanelStackView.addArrangedSubview(bottomPanelButton)
        }
    }
    
    
    func createStackView() -> UIStackView {
        
        let panel = UIStackView()
        
        panel.translatesAutoresizingMaskIntoConstraints = false
        panel.alignment = .fill
        panel.distribution = .fillEqually
        panel.spacing = 8.0
        
        return panel
    }
    
    
    func addGestureRecognizer() {
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(detectPanGestureRecognizer(_:)))
        
        mapItemsCollectionView.addGestureRecognizer(panGestureRecognizer)
    }
}
