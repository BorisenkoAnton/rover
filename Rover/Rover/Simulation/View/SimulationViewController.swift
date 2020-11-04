//
//  SimulationViewController.swift
//  Rover
//
//  Created by Anton Borisenko on 10/30/20.
//  Copyright © 2020 Anton Borisenko. All rights reserved.
//

import UIKit
import GLKit
import OpenGLES


class SimulationViewController: GLKViewController {
    
    var simulationPresenterDelegate: SimulationPresenterDelegate?
    var map: [MapSector]?
    
    // Array of vertices for drawing
    private var vertices = [Vertex]()

    // Array specifies the order in which to draw each vertex
    private var Indices = [GLubyte]()
    
    var effect = GLKBaseEffect()
    private var ciContext: CIContext?

    private var simulationView: GLKView!
    private var context: EAGLContext?
    
    // Keeps track of the indices
    private var elementBufferObject = GLuint()
    
    // Keeps track of the per-vertex data itself (data in vertices array)
    private var vertexBufferObject = GLuint()
    
    //This object can be bound like the vertex buffer object. Any future vertex attribute calls you make will be stored inside it
    private var vertexArrayObject = GLuint()
    
    
    override func loadView() {
        
        super.loadView()
        
        simulationView = self.view as? GLKView
        
        setupGL()
        
        setupVertexBuffer()
        
        self.simulationPresenterDelegate?.setMapToView()
    }
    
    
    override func glkView(_ view: GLKView, drawIn rect: CGRect) {

        // Specifying RGB and alpha values to use when clearing the screen
        glClearColor(0.0, 0.0, 0.0, 1.0)
        
        // Performing clearing
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT))
        
        effect.prepareToDraw()
        
        if self.map != nil {
            for mapSector in self.map! {
                let image = CIImage(cgImage: UIImage(named: mapSector.surfaceImageName)!.cgImage!)

                let scale = CGAffineTransform(scaleX: self.simulationView.contentScaleFactor, y: self.simulationView.contentScaleFactor)

                let drawingRect = mapSector.coordinates.applying(scale)

                self.ciContext?.draw(image, in: drawingRect, from: image.extent)
            }
        }
        
        glBindVertexArrayOES(vertexArrayObject);
        
        glDrawElements(GLenum(GL_LINES),            // This tells OpenGL what we want to draw
                       GLsizei(Indices.count),      // Tells OpenGL how many vertices we want to draw
                       GLenum(GL_UNSIGNED_BYTE),    // Specifying the type of values contained in each index
                       nil)                         // Specifies an offset within a buffer
        
        glBindVertexArrayOES(0)
    }
    
// MARK: - Setting up GL
    
    private func setupGL() {

        // EAGLContext manages all of the information that iOS needs to draw with OpenGL
        if let eaglContext = EAGLContext(api: .openGLES3) {
            
            context = eaglContext
            
            // Specifying that the rendering created context is the one to use in the current thread
            EAGLContext.setCurrent(context)
            
            self.simulationView.context = context!
            
            self.ciContext = CIContext(eaglContext: eaglContext)
            
            delegate = self
        }
        
        glLineWidth(20.0)
    }
    
    
    func setupVertexBuffer() {
        
        // Specifying information about how to read colors and positions from data structures
        let vertexAttribColor = GLuint(GLKVertexAttrib.color.rawValue)
        
        let vertexAttribPosition = GLuint(GLKVertexAttrib.position.rawValue)
        
        // Size in bytes of an item of type Vertex
        let vertexSize = MemoryLayout<Vertex>.stride
        
        // Specify that we want the stride of a GLfloat multiplied by three. This corresponds to the x, y and z variables in the Vertex structure
        let colorOffset = MemoryLayout<GLfloat>.stride * 3
        
        // Converting the offset into the required type
        let colorOffsetPointer = UnsafeRawPointer(bitPattern: colorOffset)
        
        // MARK: Creating Vertex Array Object buffers
        
        // Creating new VAO. Parameters: number of VAO's to generate, pointer to a GLuint wherein it will store the ID of the generated object
        glGenVertexArraysOES(1, &vertexArrayObject)
        
        // Binding created VAO and stored in the vertexArrayObject variable
        glBindVertexArrayOES(vertexArrayObject)
        
        // MARK: Creating Vertex Buffer Object Buffers
        
        glGenBuffers(1, &vertexBufferObject)
        
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), vertexBufferObject)
        
        glBufferData(GLenum(GL_ARRAY_BUFFER), // Indicates to what buffer you are passing data
                     vertices.size(),         // Specifies the size in bytes of the data
                     vertices,                // The actual data we are going to use
                     GLenum(GL_STATIC_DRAW)   // Tells OpenGL how we want the GPU to manage the data
        )
        
        glEnableVertexAttribArray(vertexAttribPosition)
        
        glVertexAttribPointer(vertexAttribPosition,         // Specifies the attribute name to set
                              3,                            // Specifies how many values are present for each vertex
                              GLenum(GL_FLOAT),             // Specifies the type of each value, which is float for both position and color
                              GLboolean(UInt8(GL_FALSE)),   // Specifies if we want the data to be normalized
                              GLsizei(vertexSize),          // The size of the stride
                              nil)                          // The offset of the position data (at the very start of the vertices array)
            
        glEnableVertexAttribArray(vertexAttribColor)
        
        glVertexAttribPointer(vertexAttribColor,
                              4,
                              GLenum(GL_FLOAT),
                              GLboolean(UInt8(GL_FALSE)),
                              GLsizei(vertexSize),
                              colorOffsetPointer)
        
        // MARK: Creating Element Buffer Object buffers
        
        glGenBuffers(1, &elementBufferObject)
        
        glBindBuffer(GLenum(GL_ELEMENT_ARRAY_BUFFER), elementBufferObject)
        
        glBufferData(GLenum(GL_ELEMENT_ARRAY_BUFFER),
                     Indices.size(),
                     Indices,
                     GLenum(GL_STATIC_DRAW))
        
        glBindVertexArrayOES(0)
        
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), 0)
        
        glBindBuffer(GLenum(GL_ELEMENT_ARRAY_BUFFER), 0)
    }
    
    // MARK:- Tidying Up
    
    private func tearDownGL() {
        
        EAGLContext.setCurrent(context)

        glDeleteBuffers(1, &vertexArrayObject)
        glDeleteBuffers(1, &vertexBufferObject)
        glDeleteBuffers(1, &elementBufferObject)
            
        EAGLContext.setCurrent(nil)
            
        context = nil
    }
    
    
    deinit {
        tearDownGL()
    }
}
