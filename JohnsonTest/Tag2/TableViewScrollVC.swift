//
//  TableViewScrollVC.swift
//  JohnsonTest
//
//  Created by Johnson on 2018/2/7.
//  Copyright © 2018年 Johnson. All rights reserved.
//

import UIKit

class TableViewScrollVC: UIViewController {
    
    @IBOutlet weak var myTableView: UITableView!
    
    //    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var testViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var testView: UIView!
    @IBOutlet weak var testLabel: UILabel!
    
    fileprivate let screenHeight = UIScreen.main.bounds.height
    var defaultOffSet: CGPoint?
    
    var isHide = false
    
    var dataArray = ["1", "2", "3"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewSetting()
        
        testLabel.alpha = 1
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(open))
        testView.addGestureRecognizer(tap)
    }
    
    @objc func open() {
        UIView.animate(withDuration: 0.3) {
            self.testViewHeight.constant = self.screenHeight * 300 / 667
            //            self.tableViewHeight.constant = UIScreen.main.bounds.height * 250 / 667
            self.testLabel.alpha = 1
            
            self.view.layoutIfNeeded()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        defaultOffSet = myTableView.contentOffset
    }
    
    private func tableViewSetting() {
        myTableView.delegate = self
        myTableView.dataSource = self
        
        //        tableView.contentInset = UIEdgeInsetsMake(collectionView.size.height, 0, 0, 0)
    }
}

// MARK: - TableView Delegate
extension TableViewScrollVC: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = myTableView.contentOffset
        let minHeight = screenHeight * 50 / 667
        let maxHeight = screenHeight * 300 / 667
        
        if let startOffset = self.defaultOffSet {
            if offset.y < startOffset.y {
                // Scrolling down
                // check if your collection view height is less than normal height, do your logic.
                
                let deltaY = fabs((startOffset.y - offset.y))
                testViewHeight.constant = min(testViewHeight.constant + deltaY, maxHeight)
                //                tableViewHeight.constant = max(minHeight, tableViewHeight.constant - deltaY)
            } else {
                
                let deltaY = fabs((startOffset.y - offset.y))
                
                if deltaY == 0 {
                    return
                }
                testViewHeight.constant = max(testViewHeight.constant - deltaY, minHeight)
                //                tableViewHeight.constant = min(maxHeight, tableViewHeight.constant + deltaY)
            }
            
            testLabel.alpha = 1 - (maxHeight - testViewHeight.constant) / (maxHeight - minHeight)
            
            self.view.layoutIfNeeded()
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        UIView.animate(withDuration: 0.2) {
            
            if self.isHide {
                if self.testViewHeight.constant > self.screenHeight * 80 / 667 {
                    self.testViewHeight.constant = self.screenHeight * 300 / 667
                    self.testLabel.alpha = 1
                    self.isHide = false
                } else {
                    self.testViewHeight.constant = self.screenHeight * 50 / 667
                    self.testLabel.alpha = 0
                }
            } else {
                if self.testViewHeight.constant < self.screenHeight * 270 / 667 {
                    self.testViewHeight.constant = self.screenHeight * 50 / 667
                    self.testLabel.alpha = 0
                    self.isHide = true
                } else {
                    self.testViewHeight.constant = self.screenHeight * 300 / 667
                    self.testLabel.alpha = 1
                }
            }
            
            //            if self.isHide {
            //                if self.tableViewHeight.constant < UIScreen.main.bounds.height * 480 / 667 {
            //                    self.tableViewHeight.constant = UIScreen.main.bounds.height * 250 / 667
            //                    self.testLabel.alpha = 1
            //                    self.isHide = false
            //                } else {
            //                    self.tableViewHeight.constant = UIScreen.main.bounds.height * 530 / 667
            //                    self.testLabel.alpha = 0
            //                }
            //            } else {
            //                if self.tableViewHeight.constant > UIScreen.main.bounds.height * 300 / 667 {
            //                    self.tableViewHeight.constant = UIScreen.main.bounds.height * 530 / 667
            //                    self.testLabel.alpha = 0
            //                    self.isHide = true
            //                } else {
            //                    self.tableViewHeight.constant = UIScreen.main.bounds.height * 250 / 667
            //                    self.testLabel.alpha = 1
            //                }
            //            }
            self.view.layoutIfNeeded()
        }
    }
}

// MARK: - TableView DataSource
extension TableViewScrollVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        
        cell?.textLabel?.text = dataArray[indexPath.row]
        
        return cell!
    }
}
