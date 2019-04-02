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
    var uiTableView = UITableView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let myViewController = MyViewController(nibName: nil, bundle: nil)
        
        let myNavController = MyNavigationController(withRootViewController: myViewController)
        
        myNavController.view.addSubview(self.view)
        
        
        //l
        //myViewController.view = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
       
        //print(myViewController)
        
        //let myViewController1 = UIViewController(nibName: nil, bundle: nil)
        //myViewController1.view = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        //print(myViewController1)
        
        // Do any additional setup after loading the view, typically from a nib.
        //tableView.dataSource = self
        //let tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 80))
        //tableHeaderView.backgroundColor = UIColor.blue
        //tableView.tableHeaderView = tableHeaderView
        //tableView.frame = CGRect(x: 10, y: 10, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        //
        //view.addSubview(tableView)
        //tableView.selectRowAtIndexPath(NSIndexPath(row: 1, section: 0), animated: false, scrollPosition: .UITableViewScrollPositionNone)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func numberOfSectionInTableView(_ tableView: MyTableView) -> NSInteger {
        return 1
    }
    
    func tableView(_ tableView: MyTableView, numberOfRowsInSection section: NSInteger) -> NSInteger {
        return 3
    }
    
    func tableView(_ tableView: MyTableView, cellForRowAtIndexPath _index: NSIndexPath) -> UITableViewCell {
        print("Call cellForRowAtIndex \(_index)")
        if let cell = tableView.dequeueReusableCellWithIdentifier("Cell") {
            cell.detailTextLabel?.text = "Moja kolona \(_index.row)"
            cell.backgroundColor = UIColor.orange
            return cell
        }
        
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        cell.detailTextLabel?.text = "Moja kolona \(_index.row)"
        cell.backgroundColor = UIColor.orange
        return cell
    }


}

