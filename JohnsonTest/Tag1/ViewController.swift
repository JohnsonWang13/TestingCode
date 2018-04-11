//
//  ViewController.swift
//  JohnsonTest
//
//  Created by Johnson on 2018/1/30.
//  Copyright © 2018年 Johnson. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var progressView: ProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        textField.text = fcmToken
    }
    
    @IBAction func didValueChange(_ sender: UISlider) {
        progressView.animateProgressViewToProgress(progress: sender.value)
        progressView.updateProgressViewLabelWithProgress(percent: sender.value)
    }
}
