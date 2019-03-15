//
//  MyViewController.swift
//  MyUITableView
//
//  Created by mac on 14/03/2019.
//  Copyright © 2019 Benjamin Halilovic. All rights reserved.
//

import UIKit

public enum UIModalTransitionStyle : Int {
    
    
    case coverVertical
    
    case flipHorizontal
    
    case crossDissolve
    
    @available(iOS 3.2, *)
    case partialCurl
}

public enum UIModalPresentationStyle : Int {
    
    
    case fullScreen
    
    @available(iOS 3.2, *)
    case pageSheet
    
    @available(iOS 3.2, *)
    case formSheet
    
    @available(iOS 3.2, *)
    case currentContext
    
    @available(iOS 7.0, *)
    case custom
    
    @available(iOS 8.0, *)
    case overFullScreen
    
    @available(iOS 8.0, *)
    case overCurrentContext
    
    @available(iOS 8.0, *)
    case popover
    
    
    @available(iOS 7.0, *)
    case none
}

class MyViewController: UIResponder {

    open var nibName: String? {
       return nil
    }
    open var nibBundle: Bundle? {
        return nil
    }
    
    private (set) var _view: UIView!
    
    open var view: UIView! {
        get{
            if isViewLoaded() {
                return _view
            } else {
                let wereEnabled = UIView.areAnimationsEnabled
                UIView.setAnimationsEnabled(false)
                loadView()
                viewDidLoad()
                UIView.setAnimationsEnabled(wereEnabled)
                return _view
            }
        }
        set {
            if newValue != _view {
                _view = newValue
            }
        }
    }
    
    func isViewLoaded() -> Bool {
        return _view != nil
    }
    
    func loadView() {
        self._view = UIView.init(frame: CGRect(x: 0, y: 0, width: 320, height: 480))
    }
    
    func viewDidLoad() {
        
    }
    
    func viewDidUnload() {
        
    }
    
    func didReceiveMemoryWarning() {
        
    }
    
    func viewWillAppear(_ animated: Bool) {
        
    }
    
    func viewDidAppear(_ animated: Bool) {
        
    }
    
    func viewWillDisappear(_ animated: Bool) {
        
    }
    
    func viewDidDisappear(_ animated: Bool) {
        
    }
    
    func viewWillLayoutSubviews() {
        
    }
    
    func viewDidLayoutSubviews() {
        
    }
    
    
    
    
    open var title: String?
    //open var interfaceOrientation: UIInterfaceOrientation { get }
    open var navigationItem: UINavigationItem?
    open var toolbarItems: NSArray?
    open var isEditing: Bool
    var hidesBottomBarWhenPushed: Bool
    
    open var contentSizeForViewInPopover: CGSize?
    
   
    open var modalTransitionStyle: UIModalTransitionStyle?
    open var modalPresentationStyle: UIModalPresentationStyle?
    open var definesPresentationContext: Bool?
    open var providesPresentationContextTransitionStyle: Bool?
    
    weak open var parent: UIViewController?
    
    open var children: [UIViewController] = []
    
    //open var presentedViewController: UIViewController? { get }
    //open var presentingViewController: UIViewController? { get }
    
    
    public override convenience init() {
        self.init(nibName: nil, bundle: nil)
    }
    
    public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        contentSizeForViewInPopover = CGSize(width: 320, height: 1100)
        hidesBottomBarWhenPushed = false
        isEditing = true
        super.init()
        
    }
    
    
}
