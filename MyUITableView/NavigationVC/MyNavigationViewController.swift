//
//  MyNavigationViewController.swift
//  MyUITableView
//
//  Created by mac on 14/03/2019.
//  Copyright © 2019 Benjamin Halilovic. All rights reserved.
//

import UIKit

@objc protocol MyNavigationControllerDelegate {
    func navigationController(_ navigationController: MyNavigationViewController, didShowViewController viewController: UIViewController, animated:Bool)
    func navigationController(_ navigationController: MyNavigationViewController, willShowViewController viewController: UIViewController, animated:Bool)
}

class MyNavigationViewController: UIViewController {
    
    var viewControllers: [UIViewController]?
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

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
