//
//  AEShowToRGBController.swift
//  ARKit-Project
//
//  https://github.com/Allen0828/ARKit-Project
//

import UIKit
import ARKit

class AEShowToRGBController: UIViewController {

    var session: ARSession!
    
    private var testImg: UIImageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        session = ARSession()
        session.delegate = self
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
        
        if let ref = try? AECapturedTools(frame: frame), let rgb = ref.rgbPixel {
            let type = CVPixelBufferGetPixelFormatType(rgb)
            debugPrint(AECapturedTools.strType(from: type))
        } else {
            debugPrint("error")
        }
        
        
    }
    
}
