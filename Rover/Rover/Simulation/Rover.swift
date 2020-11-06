//
//  RoverSprite.swift
//  Rover
//
//  Created by Anton Borisenko on 11/6/20.
//  Copyright © 2020 Anton Borisenko. All rights reserved.
//

import Foundation
import GLKit

// Structure, keeping track of the information we need at each corner of the sprite
struct TexturedVertex {
    var geometryVertex = GLKVector2()
    var textureVertex = GLKVector2()
}


struct TextureQuad {
    var bottomLeft = TexturedVertex()
    var bottomRight = TexturedVertex()
    var topLeft = TexturedVertex()
    var topRight = TexturedVertex()
    init() { }
}


class Rover {
    
    var effect: GLKBaseEffect
    var quad: TextureQuad!
    var textureInfo: GLKTextureInfo?
    
    
    init(withFile fileName: String, effect: GLKBaseEffect) {
        
        self.effect = effect
        
        let options = [GLKTextureLoaderOriginBottomLeft: NSNumber.init(value: true)]

        do {
            self.textureInfo = try GLKTextureLoader.texture(withContentsOfFile: fileName, options: options)
        } catch {
            print(error)
        }
        
        guard self.textureInfo != nil else { return }
        
        var newQuad = TextureQuad()
        newQuad.bottomLeft.geometryVertex = GLKVector2(v: (0.0, 0.0))
        newQuad.bottomRight.geometryVertex = GLKVector2(v: (Float(self.textureInfo!.width), 0.0))
        newQuad.topLeft.geometryVertex = GLKVector2(v: (0.0, Float(self.textureInfo!.width)))
        newQuad.topRight.geometryVertex = GLKVector2(v: (Float(self.textureInfo!.width), Float(self.textureInfo!.height)))

        newQuad.bottomLeft.textureVertex = GLKVector2(v: (0.0, 0.0))
        newQuad.bottomRight.textureVertex = GLKVector2(v: (1.0, 0.0))
        newQuad.topLeft.textureVertex = GLKVector2(v: (0.0, 1.0))
        newQuad.topRight.textureVertex = GLKVector2(v: (1.0, 1.0))
        
        self.quad = newQuad;
    }
    
    
    func render() {
        
        guard self.textureInfo != nil else {return }
        
        self.effect.texture2d0.name = self.textureInfo!.name
        self.effect.texture2d0.enabled = GLboolean(truncating: true)
        
        self.effect.prepareToDraw()
        
        // Passing the position and texture coordinate of each vertex
        glEnableVertexAttribArray(GLuint(GLKVertexAttrib.position.rawValue))
        glEnableVertexAttribArray(GLuint(GLKVertexAttrib.texCoord0.rawValue))
        
        // Sending each piece of data
        withUnsafePointer(to: &quad.bottomLeft.geometryVertex) { (pointer) -> Void in
            glVertexAttribPointer(GLuint(GLKVertexAttrib.position.rawValue),
                                  2,
                                  GLenum(GL_FLOAT),
                                  GLboolean(GL_FALSE),
                                  GLsizei(MemoryLayout.size(ofValue: TexturedVertex.self)),
                                  pointer)
        }
        
        withUnsafePointer(to: &quad.bottomLeft.textureVertex) { (pointer) -> Void in
            glVertexAttribPointer(GLuint(GLKVertexAttrib.texCoord0.rawValue),
                                  2,
                                  GLenum(GL_FLOAT),
                                  GLboolean(GL_FALSE),
                                  GLsizei(MemoryLayout.size(ofValue: TexturedVertex.self)),
                                  pointer)
        }
        
        glDrawArrays(GLenum(GL_TRIANGLE_STRIP), 0, 4);
    }
}
