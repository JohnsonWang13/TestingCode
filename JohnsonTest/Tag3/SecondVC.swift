//
//  SecondVC.swift
//  JohnsonTest
//
//  Created by Johnson on 2018/2/23.
//  Copyright © 2018年 Johnson. All rights reserved.
//

import UIKit

class SecondVC: UIViewController {
    
    fileprivate var naviBackgroundImage: UIImage?
    fileprivate var naviShadowImage: UIImage?
    
    @IBOutlet weak var popover: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "B"
        view.backgroundColor = .white
        setColors()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //        animate()
    }
    
    override func willMove(toParentViewController parent: UIViewController?) { // tricky part in iOS 10
        //        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        //        navigationController?.navigationBar.shadowImage = UIImage()
        //        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.barTintColor = .red //previous color
        super.willMove(toParentViewController: parent)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.navigationBar.barTintColor = .blue
    }
    
    private func animate() {
        guard let coordinator = self.transitionCoordinator else { return }
        coordinator.animate(alongsideTransition: {
            [weak self] context in
            self?.setColors()
            }, completion: nil)
    }
    
    private func setColors(){
        //                navigationController?.navigationBar.isTranslucent = false
        
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.barTintColor = .blue
    }
    
    @IBAction func buttonPop(_ sender: UIButton) {
//        popover(sender, content: "絕對是這做沒錯", arrowDirections: .down)
        sender.popover(self,content: "絕對是這做沒錯", arrowDirections: .down, delegate: self)
    }
    
    @IBAction func popAction(_ sender: UIBarButtonItem) {
        popover(sender, content: "是這樣做吧？", arrowDirections: .up)
    }
    
    func popover(_ sender: Any,content: String, arrowDirections: UIPopoverArrowDirection) {
        let popController = UIStoryboard(name: "Popover", bundle: nil).instantiateViewController(withIdentifier: "PopoverVC") as! PopoverVC
        popController.content = content
        popController.modalPresentationStyle = .popover
        
        if let presentation = popController.popoverPresentationController {
            presentation.permittedArrowDirections = arrowDirections
            presentation.delegate = self
            presentation.backgroundColor = .white
            if let sender = sender as? UIBarButtonItem {
                presentation.barButtonItem = sender
            }

            if let sender = sender as? UIView {
                presentation.sourceView = sender
                presentation.sourceRect = sender.bounds
            }
        }
        present(popController, animated: true, completion: nil)
    }
}

extension SecondVC: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}
