//
//  ViewController.swift
//  MultipleVIrtualObjects
//
//  Created by Manoj kumar on 13/02/23.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene()
        
        // Set the scene to the view
        sceneView.scene = scene
        
        let box = SCNBox(width: 0.2, height: 0.2, length: 0.2, chamferRadius: 0)
        let material = SCNMaterial()
        material.name = "Color"
        material.diffuse.contents = UIImage(named: "wood")
        
        let boxNode = SCNNode(geometry: box)
        boxNode.position = SCNVector3(x: 0, y: 0, z: -0.5)
        boxNode.geometry?.materials = [material]
        
        let sphere = SCNSphere(radius: 0.3)
        sphere.firstMaterial?.diffuse.contents = UIImage(named: "earth")
        
        let sphereNode = SCNNode(geometry: sphere)
        sphereNode.position = SCNVector3(x: 0.5, y: 0, z: -0.5)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(taped))
        self.sceneView.addGestureRecognizer(tapGesture)
        
        self.sceneView.scene.rootNode.addChildNode(sphereNode)
        self.sceneView.scene.rootNode.addChildNode(boxNode)
    }
    
    @objc func taped(recognizer: UITapGestureRecognizer) {
        let sceneView = recognizer.view as! SCNView
        let touchLocation = recognizer.location(in: sceneView)
        let hitResults = sceneView.hitTest(touchLocation, options: [:])
        
        if !hitResults.isEmpty {
            let node = hitResults[0].node
            let material = node.geometry?.material(named: "Color")
            
            material?.diffuse.contents = UIColor.red
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
}
