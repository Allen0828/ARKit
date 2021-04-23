//
//  ViewController.swift
//  ARKit-Project
//
//  Created by GW-Mac-Pro on 2021/4/23.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        btn.backgroundColor = .red
        btn.setTitle("YUA To RGB", for: .normal)
        btn.addTarget(self, action: #selector(toRGB), for: .touchUpInside)
        view.addSubview(btn)
        
    }


}
 
extension ViewController {
    @objc private func toRGB() {
        let vc = AEShowToRGBController()
        navigationController?.pushViewController(vc, animated: true)
    }
}
