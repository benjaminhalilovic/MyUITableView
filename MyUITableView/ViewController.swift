//
//  ViewController.swift
//  MyUITableView
//
//  Created by mac on 03/04/2019.
//  Copyright © 2019 Benjamin Halilovic. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let myVC = MyViewController(nibName: nil, bundle: nil)
        let pushVC = MyViewController(nibName: nil, bundle: nil)
         let pushVC1 = MyViewController(nibName: nil, bundle: nil)
        
        let navVC = MyNavigationController(withRootViewController: myVC)
        
        navVC.pushViewController(pushVC, animated: false)
        navVC.addChildViewController(pushVC1)
        
        
        print("navVC childens \(navVC.children)")
        print("navVC viewControllers \(navVC.viewControllers)")
        
        print("myVC parent \(String(describing: myVC.parent))")
        print("pushVC parent \(String(describing: pushVC.parent))")

        self.view.addSubview(navVC.view)
        
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
