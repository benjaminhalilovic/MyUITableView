//
//  MyNavigationController.swift
//  MyUITableView
//
//  Created by mac on 01/04/2019.
//  Copyright © 2019 Benjamin Halilovic. All rights reserved.
//

import UIKit

@objc protocol MyNavigationControllerDelegate {
    func navigationController(_ navigationController: MyNavigationController, didShowViewController: MyViewController, animated: Bool)
    func navigationController(_ navigationController: MyNavigationController, willShowViewController: MyViewController, animated: Bool)
    
}

class MyNavigationController: MyViewController {
    
    open var viewControllers: [MyViewController] = []
    private (set) var visibleViewController: MyViewController?
    private (set) var navigationBar: UINavigationBar
    private (set) var toolbar: UIToolbar
    open weak var delegate: MyNavigationControllerDelegate?
    
    private (set) var topViewController:MyViewController?
    
    var navigationBarHidden: Bool = false
    var toolBarHidden: Bool = false
    
    func isNavigationBarHidden() -> Bool {
        return navigationBarHidden
    }
    
    func isToolbarHidden() -> Bool {
        return toolBarHidden
    }
    
    public init(withRootViewController rootViewController: MyViewController) {
        navigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: 70, height: 60))
        toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 70, height: 60))
        super.init(nibName: nil, bundle: nil)
        
        viewControllers.append(rootViewController)
        
        //navigationBar.delegate = self
        
        
    }
    
    override func loadView() {
        self.view = UIView.init(frame: CGRect(x: 0, y: 0, width: 320, height: 480))
        
        var navBarRect: CGRect = CGRect()
        var contentRect: CGRect = CGRect()
        var toolBarRect: CGRect = CGRect()
        
        getNavBarRect(&navBarRect, contentRect: &contentRect, toolBarRect: &toolBarRect, bounds: view.bounds)
        
        navigationBar.frame = navBarRect
        visibleViewController?.view.frame = contentRect
        toolbar.frame = toolBarRect
        
        navigationBar.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]
        visibleViewController?.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        toolbar.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        
        view.addSubview((visibleViewController?.view)!)
        view.addSubview(navigationBar)
        view.addSubview(toolbar)
        
       
        //print("navBarRect \(navBarRect)")
    }
    
    private func getNavBarRect(_ navBarRect: inout CGRect, contentRect: inout CGRect, toolBarRect: inout CGRect, bounds: CGRect  ) {
        
        let navBar = CGRect(x: bounds.minX, y: bounds.minY, width: bounds.width, height: 70)
        let toolbar = CGRect(x: bounds.minX, y: bounds.maxY - self.toolbar.frame.size.height , width: bounds.width, height: self.toolbar.frame.size.height)
       
        var content = bounds
        
        if !self.navigationBarHidden {
            content.origin.y += navBar.height
            content.size.height -= navBar.height
        }
        
        if !self.toolBarHidden {
            content.size.height -= toolbar.height
        }
        
        navBarRect = navBar
        contentRect = content
        toolBarRect = toolbar
        
    }
    
    
    
    

}
