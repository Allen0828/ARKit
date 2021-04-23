//
//  AEShowToRGBController.swift
//  ARKit-Project
//
//  Created by GW-Mac-Pro on 2021/4/23.
//

import UIKit
import ARKit

class AEShowToRGBController: UIViewController {

    var session: ARSession!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        session = ARSession()
        session.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        
    }

}

extension AEShowToRGBController: ARSessionDelegate {
    
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        
    }
    
}
