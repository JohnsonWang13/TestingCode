//
//  RecordVC.swift
//  JohnsonTest
//
//  Created by Johnson on 2018/2/21.
//  Copyright © 2018年 Johnson. All rights reserved.
//

import UIKit
import MediaPlayer
import MobileCoreServices
import AVFoundation

class RecordVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "View A"
        view.backgroundColor = .white
//        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "NEXT", style: .plain, target: self, action: #selector(self.showController))
        setColors()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //        animate()
    }
    
    @objc func showController() {
        
        navigationController?.pushViewController(SecondVC(), animated: true)
    }
    
    private func animate() {
        guard let coordinator = self.transitionCoordinator else { return }
        
        coordinator.animate(alongsideTransition: {
            [weak self] context in
            self?.setColors()
            }, completion: nil)
    }
    
    private func setColors() {
        //
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.barTintColor = .red
    }
}
