//
//  ViewController.swift
//  AR-Portal
//
//  Created by Julian Lechuga Lopez on 25/6/18.
//  Copyright © 2018 Julian Lechuga Lopez. All rights reserved.
//

import UIKit
import ARKit
class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet weak var planeDetected: UILabel!
    @IBOutlet weak var sceneView: ARSCNView!
    let configuration = ARWorldTrackingConfiguration()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
        self.configuration.planeDetection = .horizontal
        self.sceneView.delegate = self
        self.sceneView.session.run(configuration)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.sceneView.addGestureRecognizer(tapGestureRecognizer)
                // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    @objc func handleTap(sender: UITapGestureRecognizer){
        guard let sceneView = sender.view as? ARSCNView else {return}
        let tapLocation = sender.location(in: sceneView)
        let hitTest = sceneView.hitTest(tapLocation, types: .existingPlaneUsingExtent)
        if !hitTest.isEmpty{
            self.addItem(hitTestResult: hitTest.first!)
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard anchor is ARPlaneAnchor else {return}
        DispatchQueue.main.async{
            self.planeDetected.isHidden = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 3){
                self.planeDetected.isHidden = true
            }
        }
        
    }
    
    func addItem(hitTestResult: ARHitTestResult){
        let scene = SCNScene(named: "Portal.scnassets/Portal.scn")
        let node = scene?.rootNode.childNode(withName: "Portal", recursively: false)
        let transform = hitTestResult.worldTransform
        let thirdColumn = transform.columns.3
        node?.position = SCNVector3(thirdColumn.x,thirdColumn.y,thirdColumn.z)
        self.sceneView.scene.rootNode.addChildNode(node!)
        
    }

}

