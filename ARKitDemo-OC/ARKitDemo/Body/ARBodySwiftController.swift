//
//  ARBodySwiftController.swift
//  ARKitDemo
//
//  Created by gw_pro on 2022/3/9.
//

import UIKit
import ARKit

@available(iOS 13.0, *)
class ARBodySwiftController: UIViewController, ARSessionDelegate {

    var arView: ARSCNView!
    var session: ARSession!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        session = ARSession()
        session.delegate = self
        
        arView = ARSCNView(frame: UIScreen.main.bounds)
        arView.session = session
        view.addSubview(arView)
        
        loadRobot()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let config = ARBodyTrackingConfiguration()
        config.environmentTexturing = .none
        config.isAutoFocusEnabled = true
        
        session.run(config, options: .resetTracking)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        session.pause()
    }

    
    var characterNode : SCNNode!
    var characterRoot : SCNNode!
    
    func loadRobot() {
        
        guard let url = Bundle.main.url(forResource: "robot", withExtension: "usdz") else { fatalError() }
        
        let scene = try! SCNScene(url: url, options: [.checkConsistency: true])

        characterNode = scene.rootNode
        
        let shapeParent = characterNode.childNode(withName: "biped_robot_ace_skeleton", recursively: true)!
        
        // Hierarchy is a bit odd, two 'root' names. Taking the second one
        characterRoot = shapeParent.childNode(withName: "root", recursively: false)?.childNode(withName: "root", recursively: false)
        
        self.arView.scene.rootNode.addChildNode(characterNode)
        
        
    }
    
    func session(_ session: ARSession, didUpdate frame: ARFrame) {

        if let detectedBody = frame.detectedBody {

            guard let interfaceOrientation = arView.window?.windowScene?.interfaceOrientation else { return }
            let transform = frame.displayTransform(for: interfaceOrientation, viewportSize: arView.frame.size)

           //This array contains only the lower body joints
            var arrayOfJoints = [detectedBody.skeleton.jointLandmarks[8],detectedBody.skeleton.jointLandmarks[9],detectedBody.skeleton.jointLandmarks[10],detectedBody.skeleton.jointLandmarks[11],detectedBody.skeleton.jointLandmarks[12],detectedBody.skeleton.jointLandmarks[13],detectedBody.skeleton.jointLandmarks[16]]


            //Todo lo de este for estaba en el .forEach
            for i in 0...arrayOfJoints.count - 1 {

                let normalizedCenter = CGPoint(x: CGFloat(arrayOfJoints[i][0]), y: CGFloat(arrayOfJoints[i][1])).applying(transform)
                let center = normalizedCenter.applying(CGAffineTransform.identity.scaledBy(x: arView.frame.width, y: arView.frame.height))

                let circleWidth: CGFloat = 10
                let circleHeight: CGFloat = 10
                let rect = CGRect(origin: CGPoint(x: center.x - circleWidth/2, y: center.y - circleHeight/2), size: CGSize(width: circleWidth, height: circleHeight))
                let circleLayer = CAShapeLayer()


                circleLayer.fillColor = .init(srgbRed: 255, green: 255, blue: 255, alpha: 1.0)


                circleLayer.path = UIBezierPath(ovalIn: rect).cgPath

                arView.layer.addSublayer(circleLayer)
            }
        }
    }
    
    
    
    let parentNode = SCNNode()
    var sphereNodes:[SCNNode] = []
    
    func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {

        for anchor in anchors {
            
            guard let bodyAnchor = anchor as? ARBodyAnchor else { continue }
             
            //let bodyPosition = simd_make_float3(bodyAnchor.transform.columns.3)
            
            // Update Robot Character
            characterRoot.transform = SCNMatrix4.init(bodyAnchor.transform)
            
            for joint in ARBodyUtils.allJoints {
                if let childNode = characterRoot.childNode(withName: joint.rawValue, recursively: true) {
                    if let transform = bodyAnchor.skeleton.localTransform(for: joint) {
                        childNode.transform = SCNMatrix4.init(transform)
                    }
                }
            }
            
            
            // -
            parentNode.transform = SCNMatrix4.init(bodyAnchor.transform)
            
            let joints = ARBodyUtils.selectedJointNames
            //let joints = ARBodyUtils.allJoints
            
            if sphereNodes.count == 0 {
                
                // create joints
                 self.arView.scene.rootNode.addChildNode(parentNode)
                 
                 for  i in 0..<joints.count {
                     
                    let boxSize : CGFloat = 0.06
                    let sphereNode = SCNNode(geometry:
                        SCNBox(width: boxSize*1.9, height: boxSize, length: boxSize, chamferRadius: 0) )

                    sphereNode.geometry?.firstMaterial?.diffuse.contents =
                        ARBodyUtils.colorForJointName(joints[i].rawValue)
                    
                    //let sphereNode = SCNNode()
                    sphereNode.showAxes(radius: 0.0085, height: 0.15)
                    
                     parentNode.addChildNode(sphereNode)
                     sphereNodes.append(sphereNode)
                     
                 }
                
            }
            
            for  i in 0..<joints.count {
                
                if let transform = bodyAnchor.skeleton.modelTransform(for: joints[i]) {
                    
                    //let position = bodyPosition + simd_make_float3(transform.columns.3)
                    //sphereNodes[i].position = SCNVector3(position.x, position.y, position.z)
                    
                    sphereNodes[i].transform = SCNMatrix4.init(transform)
                    
                }
            }
            
        }
        
    }


}



extension SCNNode {
    
    func setHighlighted(_ highlighted : Bool = true) {
        var node = self
        node.categoryBitMask = highlighted ? 2 : 1
        for child in node.childNodes {
            child.setHighlighted(highlighted)
        }
    }
    
    func showAxes(radius : CGFloat = 0.002, height : CGFloat = 0.3) {
        self.addChildNode(AxisGrid(radius:radius, height:height))
    }
    
    func setAxesTransform( newX : SCNVector3 ,
                           newY : SCNVector3 ,
                           newZ : SCNVector3 ,
                           position : SCNVector3 ) {
        
        let transform = SCNMatrix4.init(m11: newX.x, m12: newX.y, m13: newX.z, m14: 0,
                                        m21: newY.x, m22: newY.y, m23: newY.z, m24: 0,
                                        m31: newZ.x, m32: newZ.y, m33: newZ.z, m34: 0,
                                        m41: position.x, m42: position.y, m43: position.z, m44: 1.0)
        self.transform = transform
        
    }
    
}


class AxisGrid : SCNNode {
    
    
    init(radius : CGFloat = 0.002, height : CGFloat = 0.3) {
        super.init()
        
        let x = SCNCapsule(capRadius: radius, height: height)
        x.firstMaterial?.lightingModel = .constant
        x.firstMaterial?.diffuse.contents = UIColor.red
        let xn = SCNNode(geometry:x)
        xn.position = SCNVector3(height/2.0, 0.0, 0.0)
        xn.eulerAngles.z = 90.0 * Float.pi / 180.0
        self.addChildNode(xn)
        
        let y = SCNCapsule(capRadius: radius, height: height)
        y.firstMaterial?.lightingModel = .constant
        y.firstMaterial?.diffuse.contents = UIColor.green
        let yn = SCNNode(geometry:y)
        yn.position = SCNVector3(0.0, height/2.0, 0.0)
        self.addChildNode(yn)
        
        
        let z = SCNCapsule(capRadius: radius, height: height)
        z.firstMaterial?.lightingModel = .constant
        z.firstMaterial?.diffuse.contents = UIColor.blue
        let zn = SCNNode(geometry:z)
        zn.position = SCNVector3(0.0, 0.0, height/2.0)
        zn.eulerAngles.x = 90.0 * Float.pi / 180.0
        self.addChildNode(zn)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
