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
    var mapRect: CGRect?
    var mapImage: UIImage?
    var rover: Rover?
    var roverPathSectors = [CGRect]()
    
    private var simulationView: GLKView!
    private var context: EAGLContext?
    private var ciContext: CIContext?
    
    // Array of vertices for drawing
    var vertices = [Vertex]()

    // Array specifies the order in which to draw each vertex
    var indices = [GLubyte]()
    
    // Index of sector with pit
    var emergencySectorIndex: Int? = nil
    
    // Keeps track of the indices
    private var elementBufferObject = GLuint()
    
    // Keeps track of the per-vertex data itself (data in vertices array)
    private var vertexBufferObject = GLuint()
    
    //This object can be bound like the vertex buffer object. Any future vertex attribute calls you make will be stored inside it
    private var vertexArrayObject = GLuint()
    
    var effect = GLKBaseEffect()
    
    
    override func loadView() {

        super.loadView()
        
        simulationView = self.view as? GLKView
        
        configureNavigationBar()
    
        self.rover = Rover(frame:.zero, imageName: "rover")
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        setupGL()
        
        self.simulationPresenterDelegate?.setMapToView()
        
        self.rover?.render(coordinates: self.roverPathSectors, emergencySectorIndex: self.emergencySectorIndex)

        self.view.addSubview(rover!)
    }
    
    
    override func glkView(_ view: GLKView, drawIn rect: CGRect) {
        
        // Specifying RGB and alpha values to use when clearing the screen
        glClearColor(0.0, 0.0, 0.0, 1.0)

        // Performing clearing
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT))

        if self.map != nil {
            if self.mapRect == nil {
                let screenHeight = UIScreen.main.bounds.height
                let screenWidth = UIScreen.main.bounds.width
                
                let mapWidth = screenWidth * 0.9
                let mapHeight = screenHeight * 0.8
                
                self.mapRect = CGRect(x: screenWidth * 0.05, y: screenHeight * 0.05, width: mapWidth, height: mapHeight)
            }
            
            if self.mapImage == nil {
                self.mapImage = collageMapSectors()
            }
            
            let image = CIImage(cgImage: self.mapImage!.cgImage!)

            let scale = CGAffineTransform(scaleX: self.simulationView.contentScaleFactor, y: self.simulationView.contentScaleFactor)
            
            let drawingRect = self.mapRect!.applying(scale) //image.extent.applying(scale)
            
            self.ciContext?.draw(image, in: drawingRect, from: image.extent)
        }

        effect.prepareToDraw()

        glBindVertexArrayOES(vertexArrayObject);

        glDrawElements(GLenum(GL_LINES),            // This tells OpenGL what we want to draw
                       GLsizei(indices.count),      // Tells OpenGL how many vertices we want to draw
                       GLenum(GL_UNSIGNED_BYTE),    // Specifying the type of values contained in each index
                       nil)                         // Specifies an offset within a buffer

        glBindVertexArrayOES(0)
    }
    
    
    func collageMapSectors() -> UIImage {

        let mapSectorSideWidth = self.map?.first?.coordinates.width
        let mapSectorSideHeight = self.map?.first?.coordinates.height
        
        var mapImage: CIImage?
        
        for mapSector in self.map!{
            let mapSectorImage =  UIImage(named: mapSector.surfaceImageName)!
            
            var ci = CIImage(image: mapSectorImage)!
            
            ci = ci.transformed(by: CGAffineTransform(scaleX: (mapSectorSideWidth! / mapSectorImage.size.width) / CGFloat(2.0), y: (mapSectorSideHeight! / mapSectorImage.size.height) / CGFloat(2.0)))
            ci = ci.transformed(by: CGAffineTransform(translationX: mapSector.coordinates.origin.x, y: mapSector.coordinates.origin.y))
            
            if mapImage == nil {
                mapImage = ci
            } else {
                mapImage = ci.composited(over: mapImage!)
            }
        }
        
        let cgIntermediate = CIContext(options: nil).createCGImage(mapImage!, from: mapImage!.extent)!
        let finalRenderedMapImage = UIImage(cgImage: cgIntermediate)
     
        return finalRenderedMapImage
    }
    
    
// MARK: - Configuring View
    
    func configureNavigationBar() {
        
        let returnButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(returnButtonPressed))
        
        self.navigationItem.leftBarButtonItem  = returnButton
    }
    
    
    // MARK: actions
    
    @objc func returnButtonPressed() {
        
        self.navigationController?.popViewController(animated: true)
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
                     indices.size(),
                     indices,
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
