//
//  BannerVC.swift
//  JohnsonTest
//
//  Created by Johnson on 2018/2/23.
//  Copyright © 2018年 Johnson. All rights reserved.
//

import UIKit

class BannerVC: UIViewController {
    
    @IBOutlet weak var scrollCollectionView: UICollectionView!
    
    var banner: [UIColor] = [.black, .blue, .red, .yellow]
    var bannerCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        settingCollectionView()
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.scrollAutomatically), userInfo: nil, repeats: true)
    }
    
    private func settingCollectionView() {
        scrollCollectionView.delegate = self
        scrollCollectionView.dataSource = self
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = scrollCollectionView.frame.size
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        scrollCollectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        scrollCollectionView.setCollectionViewLayout(layout, animated: false)
        
        scrollCollectionView.showsVerticalScrollIndicator = false
        scrollCollectionView.showsHorizontalScrollIndicator = false
        scrollCollectionView.isPagingEnabled = true
        scrollCollectionView.alwaysBounceHorizontal = false
    }
    
    @objc func scrollAutomatically(_ timer: Timer) {
        
        bannerCount += 1
        guard bannerCount >= 5 else { return }
        bannerCount = 0
        
        if let collectionView  = scrollCollectionView {
            for cell in collectionView.visibleCells {
                let indexPath: IndexPath? = collectionView.indexPath(for: cell)
                if ((indexPath?.row)!  < banner.count - 1) {
                    let indexPath1: IndexPath?
                    indexPath1 = IndexPath.init(row: (indexPath?.row)! + 1, section: (indexPath?.section)!)
                    
                    collectionView.scrollToItem(at: indexPath1!, at: .right, animated: true)
                } else {
                    let indexPath1: IndexPath?
                    indexPath1 = IndexPath.init(row: 0, section: (indexPath?.section)!)
                    collectionView.scrollToItem(at: indexPath1!, at: .left, animated: true)
                }
            }
        }
    }
}


// MARK: - Collection View Delegate
extension BannerVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        bannerCount = 0
        print(indexPath)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        bannerCount = 0
    }
}

// MARK: - Collection View Flow Layout
extension BannerVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
}

// MARK: - Collection View Data Source
extension BannerVC: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return banner.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        cell.backgroundColor = banner[indexPath.row]
        
        return cell
    }
}

