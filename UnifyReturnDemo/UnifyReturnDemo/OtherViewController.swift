//
//  OtherViewController.swift
//  UnifyReturnDemo
//
//  Created by 杨志远 on 2017/7/11.
//  Copyright © 2017年 BaQiWL. All rights reserved.
//

import UIKit

class OtherViewController: UIViewController,UIGestureRecognizerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "attention"), style: .plain, target: self, action: #selector(custom))
        //setUpSelf()
        //enableGestureReturn()
    }
    
    func custom() {
        print("仍旧可以自定义leftBarButtonItem")
    }
    
    func enableGestureReturn() {
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        //self.childViewControllers.count > 1
        return true
    }
    
    func setUpSelf() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "return").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(popToPreviousController))
        
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
    
    func popToPreviousController() {
        _ = navigationController?.popViewController(animated: true)
    }
}
