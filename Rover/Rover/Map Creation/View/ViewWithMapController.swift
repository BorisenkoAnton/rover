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
    var mapItemsCollectionView: UICollectionView!
    var bottomPanelStackView: UIStackView!
    
    var mapItems = [MapItem](repeating: MapItem(), count: 144)
    
    private var itemsPerRow: CGFloat = 9
    private var minimumItemSpacing: CGFloat = 1
    private let sectionInsets = UIEdgeInsets(top: 8.0, left: 8.0, bottom: 8.0, right: 8.0)
    private let mapPresenter = MapPresenter()
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        configureAndAddPanels()
        
        configureAndAddCollectionView()
        
        mapPresenter.setViewDelegate(viewWithMapControllerDelegate: self)
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(detectPan(_:)))
        
        mapItemsCollectionView.addGestureRecognizer(panGestureRecognizer)
    }

    
    //MARK: actions
    @objc func bottomPanelButtonPressed(sender: BottomPanelButton!) {
        
        mapPresenter.surfaceTypeSelected(selectedType: sender.mapItemType)
    }
    
    
    @objc func randomMapGenerationButtonPressed(sender: UIButton!) {
        
        mapPresenter.generateRandomMap(numberOfMapItems: self.mapItems.count)
    }
    
    
    @objc func detectPan(_ recognizer:UIPanGestureRecognizer) {
        
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
            mapItemsCollectionView.topAnchor.constraint(equalTo: topPanelStackView.bottomAnchor, constant: 20),
            mapItemsCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            mapItemsCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            mapItemsCollectionView.bottomAnchor.constraint(equalTo: bottomPanelStackView.topAnchor, constant: -20)
        ])
        
        mapItemsCollectionView.register(MapItemCollectionViewCell.self, forCellWithReuseIdentifier: MapItemCollectionViewCell.reuseID)
    }
    
    
    func configureAndAddPanels() {
        
        topPanelStackView = UIStackView(frame: .zero)
        
        topPanelStackView.translatesAutoresizingMaskIntoConstraints = false
        topPanelStackView.alignment = .fill
        topPanelStackView.distribution = .fillEqually
        topPanelStackView.spacing = 8.0
        
        view.addSubview(topPanelStackView)
        
        NSLayoutConstraint.activate([
            topPanelStackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            topPanelStackView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 8),
            topPanelStackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 8),
            topPanelStackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -8)
        ])
        
        NSLayoutConstraint(item: topPanelStackView!, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 80).isActive = true
        
        let randomGenerationButton = UIButton()

        randomGenerationButton.setTitle("Generate", for: .normal)
        //randomGenerationButton.backgroundColor = .white
        randomGenerationButton.translatesAutoresizingMaskIntoConstraints = false
        randomGenerationButton.addTarget(self, action: #selector(randomMapGenerationButtonPressed(sender:)), for: .touchUpInside)
        
        topPanelStackView.addArrangedSubview(randomGenerationButton)
        
        bottomPanelStackView = UIStackView(frame: .zero)
        
        bottomPanelStackView.translatesAutoresizingMaskIntoConstraints = false
        bottomPanelStackView.alignment = .fill
        bottomPanelStackView.distribution = .fillEqually
        bottomPanelStackView.spacing = 8.0
        
        view.addSubview(bottomPanelStackView)
        
        NSLayoutConstraint.activate([
            bottomPanelStackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            bottomPanelStackView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -20),
            bottomPanelStackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            bottomPanelStackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20)
        ])
        
        NSLayoutConstraint(item: bottomPanelStackView!, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 80).isActive = true
        
        for itemType in MapItemType.allCases {
            let bottomPanelButton = BottomPanelButton()
            
            bottomPanelButton.mapItemType = itemType
            bottomPanelButton.translatesAutoresizingMaskIntoConstraints = false
            bottomPanelButton.addTarget(self, action: #selector(bottomPanelButtonPressed(sender:)), for: .touchUpInside)
            
            let imageName = itemType.returnStringValue(itemType:itemType)
            
            if let image = UIImage(named: "\(imageName)") {
                bottomPanelButton.setImage(image, for: .normal)
            }
            
            bottomPanelStackView.addArrangedSubview(bottomPanelButton)
        }
    }
}

// MARK:- ViewWithMapControllerDelegate

extension ViewWithMapController: ViewWithMapControllerDelegate {
    
    func highlightBottomPanelButton(selectedSurfaceType: MapItemType) {
        
        for bottomButton in bottomPanelStackView.arrangedSubviews {
            let buttonSurfaceType = (bottomButton as! BottomPanelButton).mapItemType
            
            var imageName: String
            
            if buttonSurfaceType == selectedSurfaceType {
                imageName = buttonSurfaceType!.returnStringValue(itemType:buttonSurfaceType!) + "_highlighted"
            } else {
                imageName = buttonSurfaceType!.returnStringValue(itemType:buttonSurfaceType!)
            }
            
            if let image = UIImage(named: "\(imageName)") {
                (bottomButton as! BottomPanelButton).setImage(image, for: .normal)
            }
        }
    }
    
    
    func setMapItemSurface(indexPath: IndexPath, surfaceType: MapItemType) {
        
        self.mapItems[indexPath.row].mapItemType = surfaceType
        self.mapItemsCollectionView.reloadData()
    }
    
    
    func setMapItems(mapItemTypes: [MapItemType]) {
        
        for (index, mapItemType) in mapItemTypes.enumerated() {
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
        self.mapItemsCollectionView.deselectItem(at: indexPath, animated: true)
    }
}

// MARK:  UICollectionViewDelegateFlowLayout
extension ViewWithMapController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
     
        let paddingSpace = sectionInsets.left + sectionInsets.right + minimumItemSpacing * (itemsPerRow - 1)
        let availableWidth = collectionView.bounds.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
     
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
