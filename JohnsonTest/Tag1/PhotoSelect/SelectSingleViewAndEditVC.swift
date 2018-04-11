//
//  SelectSingleViewAndEditVC.swift
//  JohnsonTest
//
//  Created by Johnson on 2018/3/21.
//  Copyright © 2018年 Johnson. All rights reserved.
//

import UIKit
import TLPhotoPicker

class SelectSingleViewAndEditVC: TLPhotosPickerViewController {
    
    var photoEditDelegate: EditPhotoDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        doneButton.action = #selector(done)
    }
    
    @objc func done() {
        if selectedAssets.isEmpty { return }
        let editImageVC = PhotoEditVC()
        editImageVC.delegate = photoEditDelegate
        editImageVC.selectedAssets = selectedAssets[0]
        self.navigationController?.pushViewController(editImageVC, animated: true)
    }
    
//    override func doneButtonTap() {
//
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.navigationController?.topViewController is PhotoEditVC {
            self.navigationController?.setNavigationBarHidden(false, animated: true)
        } else {
            self.navigationController?.setNavigationBarHidden(true, animated: true)
        }
    }
}

extension TLPhotosPickerViewController {
//    class func custom(withTLPHAssets: (([TLPHAsset]) -> Void)? = nil, didCancel: ((Void) -> Void)? = nil) -> CustomPhotoPickerViewController {
//        let picker = CustomPhotoPickerViewController(withTLPHAssets: withTLPHAssets, didCancel:didCancel)
//        return picker
//    }
    
    func wrapNavigationControllerWithoutBar() -> UINavigationController {
        let navController = UINavigationController(rootViewController: self)
//        navController.navigationBar.isHidden = true
        return navController
    }
}
