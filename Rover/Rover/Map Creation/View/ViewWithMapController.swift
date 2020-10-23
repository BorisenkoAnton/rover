//
//  ViewController.swift
//  Rover
//
//  Created by Anton Borisenko on 10/20/20.
//  Copyright © 2020 Anton Borisenko. All rights reserved.
//

import UIKit

class ViewWithMapController: UIViewController {

    var topPanelStackView: UIStackView!
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
    
    var mapItems = [MapItem]()
    
    let mapPresenter = MapPresenter()
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        mapItems = [MapItem](repeating: MapItem(), count: itemsPerRow * rowsCount)
        
        configureAndAddPanels()
        
        configureAndAddCollectionView()
        
        mapPresenter.setViewDelegate(viewWithMapControllerDelegate: self)
        
        addGestureRecognizer()
    }

    
    //MARK: actions
    @objc func bottomPanelButtonPressed(sender: BottomPanelButton!) {
        
        mapPresenter.surfaceTypeSelected(selectedType: sender.mapItemType)
    }
    
    
    @objc func storageButtonPressed(sender: UIButton!) {
        
        
    }
    
    
    @objc func randomMapGenerationButtonPressed(sender: UIButton!) {
        
        mapPresenter.generateRandomMap(numberOfMapItems: self.mapItems.count)
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
            mapItemsCollectionView.topAnchor.constraint(equalTo: topPanelStackView.bottomAnchor, constant: MostOftenConstraintsConstants.bottom.cgfloatValue),
            mapItemsCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: MostOftenConstraintsConstants.leading.cgfloatValue),
            mapItemsCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -MostOftenConstraintsConstants.trailing.cgfloatValue),
            mapItemsCollectionView.bottomAnchor.constraint(equalTo: bottomPanelStackView.topAnchor, constant: -MostOftenConstraintsConstants.bottom.cgfloatValue)
        ])
        
        mapItemsCollectionView.register(MapItemCollectionViewCell.self, forCellWithReuseIdentifier: MapItemCollectionViewCell.reuseID)
    }
    
    
    func createButton(withTitle title:String, andTargetAction action: Selector, forEvent event:UIControl.Event) -> UIButton{
        
        let button = UIButton()
        
        button.setTitle(title, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: action, for: event)
        
        return button
    }
    
    // Configuring and adding top (with random generating button) and bottom (with surface types) panels to view
    func configureAndAddPanels() {
        // Top panel
        topPanelStackView = createStackView()
        
        view.addSubview(topPanelStackView)
        
        let topPanelStackViewConstraints = ConstraintsConstantsSet(top: MostOftenConstraintsConstants.top.cgfloatValue,
                                                                   trailing: -MostOftenConstraintsConstants.trailing.cgfloatValue,
                                                                   bottom: nil,
                                                                   leading: MostOftenConstraintsConstants.leading.cgfloatValue,
                                                                   height: 60.0, width: nil
        )
        
        activateConstraints(for: topPanelStackView, constraintsConstantsSet: topPanelStackViewConstraints)
        
        let randomGenerationButton = createButton(withTitle: "Generate", andTargetAction: #selector(randomMapGenerationButtonPressed(sender:)), forEvent: .touchUpInside)

        topPanelStackView.addArrangedSubview(randomGenerationButton)
        
        let storageButton = createButton(withTitle: "Storage", andTargetAction: #selector(storageButtonPressed(sender:)), forEvent: .touchUpInside)
        
        topPanelStackView.addArrangedSubview(storageButton)
        
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
            
            let imageName = surfaceType.returnStringValue(surfaceType:surfaceType)
            
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
