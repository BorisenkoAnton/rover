//
//  RoverSprite.swift
//  Rover
//
//  Created by Anton Borisenko on 11/6/20.
//  Copyright © 2020 Anton Borisenko. All rights reserved.
//

import UIKit

class Rover: UIImageView {

    var pathAnimationGroup = CAAnimationGroup()
    
    
    init(frame: CGRect, imageName: String) {
        
        super.init(frame: frame)
        
        guard let roverImage = UIImage(named: imageName) else { return }
        
        self.image = roverImage
    }
    
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func render(coordinates: [CGRect]) {
        
        UIView.animateKeyframes(withDuration: 10.0, delay: 0, options: [.calculationModeLinear, .repeat], animations: {
            
            var relativeStartTime = 0.0
            let duration = Double(coordinates.count)
            
            for coordinate in coordinates {
                
                UIView.addKeyframe(withRelativeStartTime: relativeStartTime / duration, relativeDuration: 1.0 / duration) {
                    self.frame = coordinate
                }
                
                relativeStartTime += 1.0
            }
            
        }) { (_) in
            
        }
    }
}
