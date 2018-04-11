//
//  PopoverVC.swift
//  JohnsonTest
//
//  Created by Johnson on 2018/3/6.
//  Copyright © 2018年 Johnson. All rights reserved.
//

import UIKit

class PopoverVC: UIViewController {
    
    @IBOutlet weak var contentLabel: UILabel!
    
    var content: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentLabel.text = content
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.preferredContentSize = CGSize(width: contentLabel.frame.width + 20, height: contentLabel.frame.height + 20)
    }
}

extension UIView {
    func popover(_ viewController: UIViewController, content: String, arrowDirections: UIPopoverArrowDirection, delegate: UIPopoverPresentationControllerDelegate) {
        let popController = UIStoryboard(name: "Popover", bundle: nil).instantiateViewController(withIdentifier: "PopoverVC") as! PopoverVC
        popController.content = content
        popController.modalPresentationStyle = .popover
        
        if let presentation = popController.popoverPresentationController {
            presentation.permittedArrowDirections = arrowDirections
            presentation.delegate = delegate
            presentation.backgroundColor = .white
            
            presentation.sourceView = self
            presentation.sourceRect = self.bounds
        }
        viewController.present(popController, animated: true, completion: nil)
    }
}

extension UIBarButtonItem {
    func popover(_ viewController: UIViewController, content: String, arrowDirections: UIPopoverArrowDirection, delegate: UIPopoverPresentationControllerDelegate) {
        let popController = UIStoryboard(name: "Popover", bundle: nil).instantiateViewController(withIdentifier: "PopoverVC") as! PopoverVC
        popController.content = content
        popController.modalPresentationStyle = .popover
        
        if let presentation = popController.popoverPresentationController {
            presentation.permittedArrowDirections = arrowDirections
            presentation.delegate = delegate
            presentation.backgroundColor = .white
            
            presentation.barButtonItem = self
        }
        viewController.present(popController, animated: true, completion: nil)
    }
}
