//
//  ViewController.swift
//  ARMeasuring
//
//  Created by octagon studio on 25/07/18.
//  Copyright © 2018 Cordova. All rights reserved.
//

import UIKit
import ARKit 

class ViewController: UIViewController, ARSCNViewDelegate {
    @IBOutlet weak var sceneView: ARSCNView!
    let configuration = ARWorldTrackingConfiguration()
    
    
    var distanceLabel = UILabel()
    var distance_x = UILabel()
    var distance_y = UILabel()
    var distance_z = UILabel()
    var target = UIButton()
    var startingPosition:SCNNode?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sceneView.session.run(configuration)
//        self.sceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin, ARSCNDebugOptions.showFeaturePoints]
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        
        self.sceneView.delegate = self
        self.sceneView.addGestureRecognizer(tapGestureRecognizer)
        targetButton()
        distanceLabels()
        
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer){
        guard let sceneView = sender.view as? ARSCNView else {return}
        guard let currentFrame = sceneView.session.currentFrame else {return}
        let camera = currentFrame.camera
        let transform = camera.transform
        
        if self.startingPosition != nil {
            self.startingPosition?.removeFromParentNode()
            self.startingPosition = nil
            return
        }
        
        var translationMatrix = matrix_identity_float4x4
        translationMatrix.columns.3.z = -0.1
        let modifiedMatrix = simd_mul(transform, translationMatrix)
        
        let sphere = SCNNode(geometry: SCNSphere(radius: 0.005))
        sphere.geometry?.firstMaterial?.diffuse.contents = UIColor.yellow
        
        sphere.simdTransform = modifiedMatrix
        self.sceneView.scene.rootNode.addChildNode(sphere)
        self.startingPosition = sphere
    }
    
    func targetButton(){
        target = UIButton(frame: CGRect(x: 167, y: 313, width: 40, height: 40))
        target.backgroundColor = .clear
        target.setImage(UIImage(named: "add"), for: .normal)
        
        self.view.addSubview(target)
    }
    
    
    //LABEL PROPERTIES
    func distanceLabels(){
       // Distance Label
        distanceLabel = UILabel(frame: CGRect(x: 150, y: 50, width: 67, height: 20.5))
        distanceLabel.backgroundColor = .clear
        distanceLabel.text = "Distance"
        distanceLabel.textColor = UIColor.white

        //Distance X
        distance_x = UILabel(frame: CGRect(x: 100, y: 100, width: 80, height: 20.5))
        distance_x.backgroundColor = .clear
        distance_x.text = "X"
        distance_x.textColor = UIColor.white
        
        //Distance Y
        distance_y = UILabel(frame: CGRect(x: 180, y: 100, width: 80, height: 20.5))
        distance_y.backgroundColor = .clear
        distance_y.text = "Y"
        distance_y.textColor = UIColor.white
    
        //Distance Z
        distance_z = UILabel(frame: CGRect(x:280, y: 100, width: 80, height: 20.5))
        distance_z.backgroundColor = .clear
        distance_z.text = "Z"
        distance_z.textColor = UIColor.white
        
        
        
        self.view.addSubview(distanceLabel)
        self.view.addSubview(distance_x)
        self.view.addSubview(distance_y)
        self.view.addSubview(distance_z)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        guard let startingPosition = self.startingPosition else {return}
        guard let pointOfView = self.sceneView.pointOfView else {return}
        
        let transform = pointOfView.transform
        let location = SCNVector3(transform.m41, transform.m42, transform.m43)
        let xDistance = location.x - startingPosition.position.x
        let yDistance = location.y - startingPosition.position.y
        let zDistance = location.z - startingPosition.position.z
        
        DispatchQueue.main.async {
            
            self.distance_x.text = String(format: "%.2f", xDistance) + "m"
            self.distance_y.text = String(format: "%.2f", yDistance) + "m"
            self.distance_z.text = String(format: "%.2f", zDistance) + "m"
            self.distanceLabel.text = String(format: "%.2f", self.distanceTravelled(x: xDistance, y: yDistance, z: zDistance)) + "m"
        }
        
    }
    
    
    
    func distanceTravelled(x: Float, y:Float, z:Float) -> Float {
        return (sqrt(x*x + y*y + z*z))
    }
    

  
}






