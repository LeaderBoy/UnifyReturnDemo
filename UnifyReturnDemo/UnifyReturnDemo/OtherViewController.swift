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
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)

//        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "attention"), style: .plain, target: self, action: #selector(custom))
//        setUpSelf()
        //enableGestureReturn()
    }
    
    func custom() {
        print("仍旧可以自定义leftBarButtonItem")
    }
    
    
    //MARK: 当不使用UnifyReturn.swift的时候需要使用以下内容来支持侧滑返回
    //MARK: 支持侧滑返回
    func enableGestureReturn() {
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        //self.childViewControllers.count > 1
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    
    
    
    //MARK:设置返回按钮的样式
    func setUpSelf() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "return").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(popToPreviousController))
        
    }
    
    func popToPreviousController() {
        _ = navigationController?.popViewController(animated: true)
    }
}
