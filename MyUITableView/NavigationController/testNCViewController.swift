//
//  testNCViewController.swift
//  MyUITableView
//
//  Created by mac on 01/04/2019.
//  Copyright © 2019 Benjamin Halilovic. All rights reserved.
//

import UIKit

class testNCViewController: UINavigationController {

    override func addChildViewController(_ childController: UIViewController) {
        print("addChild")
        super.addChildViewController(childController)
    }
    
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
