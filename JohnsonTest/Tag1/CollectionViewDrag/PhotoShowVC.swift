//
//  PhotoShowVC.swift
//  JohnsonTest
//
//  Created by Johnson on 2018/3/15.
//  Copyright © 2018年 Johnson. All rights reserved.
//

import UIKit

class PhotoShowVC: UIViewController {

    var imageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingView()
    }
    
    private func settingView() {
        self.view.backgroundColor = .clear
        imageView.frame = self.view.frame
        imageView.contentMode = .scaleAspectFit
        self.view.addSubview(imageView)
    }
}
