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
    
    private var itemsPerRow = 9
    private var rowsCount = 16
    private var minimumItemSpacing: CGFloat = MostOftenConstraintsConstants.minimumSpacing.cgfloatValue
    private let sectionInsets = UIEdgeInsets(
                                    top: MostOftenConstraintsConstants.defaultSpacing.cgfloatValue,
                                    left: MostOftenConstraintsConstants.defaultSpacing.cgfloatValue,
                                    bottom: MostOftenConstraintsConstants.defaultSpacing.cgfloatValue,
                                    right: MostOftenConstraintsConstants.defaultSpacing.cgfloatValue
    )
    
    var mapItems = [MapItem]()
    
    private let mapPresenter = MapPresenter()
    
    
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
        
        let randomGenerationButton = UIButton()

        randomGenerationButton.setTitle("Generate", for: .normal)
        randomGenerationButton.translatesAutoresizingMaskIntoConstraints = false
        randomGenerationButton.addTarget(self, action: #selector(randomMapGenerationButtonPressed(sender:)), for: .touchUpInside)
        
        topPanelStackView.addArrangedSubview(randomGenerationButton)
        
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

// MARK:- ViewWithMapControllerDelegate

extension ViewWithMapController: ViewWithMapControllerDelegate {
    
    func highlightBottomPanelButton(selectedSurfaceType: SurfaceType) {
        
        for bottomButton in bottomPanelStackView.arrangedSubviews {
            let buttonSurfaceType = (bottomButton as! BottomPanelButton).mapItemType
            
            var imageName: String
            
            if buttonSurfaceType == selectedSurfaceType {
                imageName = buttonSurfaceType!.returnStringValue(surfaceType:buttonSurfaceType!) + "_highlighted"
            } else {
                imageName = buttonSurfaceType!.returnStringValue(surfaceType:buttonSurfaceType!)
            }
            
            if let image = UIImage(named: "\(imageName)") {
                (bottomButton as! BottomPanelButton).setImage(image, for: .normal)
            }
        }
    }
    
    // Set surface type for one map item (one content view cell)
    func setMapItemSurface(indexPath: IndexPath, surfaceType: SurfaceType) {
        
        self.mapItems[indexPath.row].mapItemType = surfaceType
        
        self.mapItemsCollectionView.reloadData()
    }
    
    // Set surface types for all map
    func setAllMapItemsSurfaceTypes(mapItemSurfaceTypes: [SurfaceType]) {
        
        for (index, mapItemType) in mapItemSurfaceTypes.enumerated() {
            self.mapItems[index].mapItemType = mapItemType
        }
        
        self.mapItemsCollectionView.reloadData()
    }
}

// MARK:- UICollectionViewDataSource & UICollectionViewDelegate

extension ViewWithMapController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return mapItems.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MapItemCollectionViewCell.reuseID, for: indexPath) as? MapItemCollectionViewCell else {
                fatalError("Wrong cell")
        }
        
        cell.mapItemImage.image = nil
        
        let mapItem = mapItems[indexPath.item]
        
        if let mapItemType = mapItem.mapItemType {
            
            cell.update(mapItemType: mapItemType)
        }
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        mapPresenter.mapItemSelected(selectedItemIndexPath: indexPath)
    }
}

// MARK:  UICollectionViewDelegateFlowLayout
extension ViewWithMapController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
     
        let paddingSpace = sectionInsets.left + sectionInsets.right + minimumItemSpacing * (CGFloat(integerLiteral: itemsPerRow) - 1)
        let availableWidth = collectionView.bounds.width - paddingSpace
        let widthPerItem = availableWidth / CGFloat(integerLiteral: itemsPerRow)
     
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return sectionInsets
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
     
     return 1.0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
     
        return minimumItemSpacing
    }
}
