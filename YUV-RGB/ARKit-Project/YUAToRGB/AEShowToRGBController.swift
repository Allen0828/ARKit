//
//  AEShowToRGBController.swift
//  ARKit-Project
//  swift
//
//  https://github.com/Allen0828/ARKit-Project
//

import UIKit
import ARKit

class AEShowToRGBController: UIViewController {

    var arView: ARSCNView!
    var session: ARSession!
    
    private var testImg: UIImageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        session = ARSession()
        session.delegate = self
        
        arView = ARSCNView(frame: UIScreen.main.bounds)
        arView.session = session
        view.addSubview(arView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let config = ARImageTrackingConfiguration()
        session.run(config, options: .resetTracking)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        session.pause()
    }

}

extension AEShowToRGBController: ARSessionDelegate {
    
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        let originalType = CVPixelBufferGetPixelFormatType(frame.capturedImage)
        debugPrint(AECapturedTools.strType(from: originalType))
        
        // Swift
        if let tools = try? AECapturedTools(frame: frame), let ref = tools.rgbPixel {
            let type = CVPixelBufferGetPixelFormatType(ref)
            debugPrint(AECapturedTools.strType(from: type))
        } else {
            debugPrint("error")
        }
        // Swift end
        
        
        // OC
//        let tools = AECapturedTools_OC(frame: frame)
//        if let ref = tools?.rgbPixel {
//            let type = CVPixelBufferGetPixelFormatType(ref)
//            debugPrint(AECapturedTools.strType(from: type))
//        } else {
//            debugPrint("error")
//        }
        // if use code in the .mm file,  you need call deinit function
        // tools?.deinit()
        // OC end
        
    }
    
}
