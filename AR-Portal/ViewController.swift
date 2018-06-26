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
        let portalNode = scene!.rootNode.childNode(withName: "Portal", recursively: false)!
        let transform = hitTestResult.worldTransform
        let planePosition = transform.columns.3
        portalNode.position = SCNVector3(planePosition.x,planePosition.y,planePosition.z)
        self.sceneView.scene.rootNode.addChildNode(portalNode)
        self.addPlane(nodeName: "roof", portalNode: portalNode, imageName: "top")
        self.addPlane(nodeName: "floor", portalNode: portalNode, imageName: "bottom")
        self.addWalls(nodeName: "backWall", portalNode: portalNode, imageName: "back")
        self.addWalls(nodeName: "sideWallA", portalNode: portalNode, imageName: "sideA")
        self.addWalls(nodeName: "sideWallB", portalNode: portalNode, imageName: "sideB")
        self.addWalls(nodeName: "sideDoorA", portalNode: portalNode, imageName: "sideDoorA")
        self.addWalls(nodeName: "sideDoorB", portalNode: portalNode, imageName: "sideDoorB")

        
    }
    func addWalls(nodeName: String, portalNode: SCNNode, imageName: String){
        let child = portalNode.childNode(withName: nodeName, recursively: true)
        child?.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "Portal.scnassets/\(imageName).png")
        child?.renderingOrder = 200
        if let mask = child?.childNode(withName: "mask", recursively: false) {
            mask.geometry?.firstMaterial?.transparency = 0.000001
        }
    }
    
    func addPlane(nodeName: String, portalNode: SCNNode, imageName: String){
        let child = portalNode.childNode(withName: nodeName, recursively: true)
        child?.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "Portal.scnassets/\(imageName).png")
        child?.renderingOrder = 200
    }
}

