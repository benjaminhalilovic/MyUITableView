//
//  ViewController.swift
//  MyUITableView
//
//  Created by mac on 13/02/2018.
//  Copyright © 2018 Benjamin Halilovic. All rights reserved.
//

import UIKit

class ViewController: UIViewController, MyTableViewDataSource {
    
    var tableView = MyTableView(withFrame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), style: .UITableViewStylePlain)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Log")
        // Do any additional setup after loading the view, typically from a nib.
        tableView.dataSource = self
        view.addSubview(tableView)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionInTableView(_ tableView: MyTableView) -> NSInteger {
        return 1
    }
    
    func tableView(_ tableView: MyTableView, numberOfRowsInSection section: NSInteger) -> NSInteger {
        return 2
    }
    
    func tableView(_ tableView: MyTableView) {
        
    }
    
    
}

