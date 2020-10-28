//
//  ViewController.swift
//  Rover
//
//  Created by Anton Borisenko on 10/20/20.
//  Copyright © 2020 Anton Borisenko. All rights reserved.
//

import UIKit
import RealmSwift

class ViewWithMapController: UIViewController {

    var mapItemsCollectionView: UICollectionView! // Collection View, representing map
    var bottomPanelStackView: UIStackView!
    
    var itemsPerRow = 9
    var rowsCount = 16
    var minimumItemSpacing: CGFloat = MostOftenConstraintsConstants.minimumSpacing.cgfloatValue
    let sectionInsets = UIEdgeInsets(
                                    top: MostOftenConstraintsConstants.defaultSpacing.cgfloatValue,
                                    left: MostOftenConstraintsConstants.defaultSpacing.cgfloatValue,
                                    bottom: MostOftenConstraintsConstants.defaultSpacing.cgfloatValue,
                                    right: MostOftenConstraintsConstants.defaultSpacing.cgfloatValue
    )
    
    var map: DBMapModel!
    
    let mapPresenter = MapPresenter()
    
    override func loadView() {
        super.loadView()
        
        configureAndAddPanels()
        
        configureAndAddCollectionView()
        
        if self.map == nil {
            setClearMap()
        }
        
        mapPresenter.setViewDelegate(viewWithMapControllerDelegate: self)
        
        addGestureRecognizer()
    }

    
    //MARK: actions
    @objc func bottomPanelButtonPressed(sender: BottomPanelButton!) {
        
        mapPresenter.surfaceTypeSelected(selectedType: sender.mapItemType)
    }
    
    
    @objc func storageButtonPressed() {
        
        self.mapPresenter.mapWasChanged(map: self.map)
        self.mapPresenter.storageButtonPressed()
    }
    
    
    @objc func saveMap() {
        
        self.mapPresenter.saveMap(map: self.map)
    }
    
    
    @objc func randomMapGenerationButtonPressed() {
        
        mapPresenter.generateRandomMap(numberOfMapItems: self.map.mapItems.count)
    }
    
    
    @objc func detectPanGestureRecognizer(_ recognizer:UIPanGestureRecognizer) {
        
        let location = recognizer.location(in: self.mapItemsCollectionView)
        
        if let mapItemIndexPath = self.mapItemsCollectionView.indexPathForItem(at: location) {
            
            mapPresenter.mapItemSelected(selectedItemIndexPath: mapItemIndexPath)
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
            mapItemsCollectionView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            mapItemsCollectionView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: MostOftenConstraintsConstants.top.cgfloatValue),
            mapItemsCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: MostOftenConstraintsConstants.leading.cgfloatValue),
            mapItemsCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -MostOftenConstraintsConstants.trailing.cgfloatValue),
            mapItemsCollectionView.bottomAnchor.constraint(equalTo: bottomPanelStackView.topAnchor, constant: -MostOftenConstraintsConstants.bottom.cgfloatValue)
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
        
        let bottomPanelStackViewConstraints = ConstraintsConstantsSet(top: nil,
                                                                      trailing: -MostOftenConstraintsConstants.trailing.cgfloatValue,
                                                                      bottom: -MostOftenConstraintsConstants.bottom.cgfloatValue,
                                                                      leading: MostOftenConstraintsConstants.leading.cgfloatValue,
                                                                      height: 80.0,
                                                                      width: nil
        )
        
        activateConstraints(for: bottomPanelStackView, constraintsConstantsSet: bottomPanelStackViewConstraints)
        
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
        panel.spacing = MostOftenConstraintsConstants.defaultSpacing.cgfloatValue
        
        return panel
    }
    
    
    func addGestureRecognizer() {
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(detectPanGestureRecognizer(_:)))
        
        mapItemsCollectionView.addGestureRecognizer(panGestureRecognizer)
    }
    
    // Activating constraints for UIView element relative to self.view
    func activateConstraints(for viewElement: UIView, constraintsConstantsSet: ConstraintsConstantsSet) {
        
        var constraintsToActivate = [NSLayoutConstraint]()
        
        if constraintsConstantsSet.top != nil{
            constraintsToActivate.append(viewElement.topAnchor.constraint(equalTo: self.view.topAnchor, constant: constraintsConstantsSet.top!))
        }
        
        if constraintsConstantsSet.leading != nil {
            constraintsToActivate.append(viewElement.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: constraintsConstantsSet.leading!))
        }
        
        if constraintsConstantsSet.trailing != nil {
            constraintsToActivate.append(viewElement.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: constraintsConstantsSet.trailing!))
        }
        
        if constraintsConstantsSet.bottom != nil {
            constraintsToActivate.append(viewElement.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: constraintsConstantsSet.bottom!))
        }
        
        if constraintsConstantsSet.height != nil {
            constraintsToActivate.append(viewElement.heightAnchor.constraint(equalToConstant: constraintsConstantsSet.height!))
        }
        
        if constraintsConstantsSet.width != nil {
            constraintsToActivate.append(viewElement.widthAnchor.constraint(equalToConstant: constraintsConstantsSet.width!))
        }
        
        NSLayoutConstraint.activate(constraintsToActivate)
    }
}
