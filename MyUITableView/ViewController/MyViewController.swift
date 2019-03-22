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

public enum UIViewControllerParentageTransition  {
    case UIViewControllerParentageTransitionNone
    case UIViewControllerParentageTransitionToParent
    case vUIViewControllerParentageTransitionFromParent
}

class MyViewController: UIResponder {

    open var nibName: String? {
       return nil
    }
    open var nibBundle: Bundle? {
        return nil
    }
    
    open var wantsFullScreenLayout: Bool = false
    
    private (set) var _view: UIView!
    private (set) var _navigationItem: UINavigationItem?

    
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
    
    //??
    open var navigationItem: UINavigationItem? {
        if _navigationItem != nil {
            _navigationItem = UINavigationItem(title: title)
        }
        return _navigationItem
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
    
    
    
    
    open var title: String!  {
        willSet {
            if newValue == title {
                _navigationItem?.title = title
            }
        }
    }
    //open var interfaceOrientation: UIInterfaceOrientation { get }
    
    open var toolbarItems: NSArray?
    open var editing: Bool = false
 
    
    var hidesBottomBarWhenPushed: Bool
    
    open var contentSizeForViewInPopover: CGSize?
    
   
    open var modalTransitionStyle: UIModalTransitionStyle?
    open var modalPresentationStyle: UIModalPresentationStyle?
    open var definesPresentationContext: Bool?
    open var providesPresentationContextTransitionStyle: Bool?
    
    weak open var parent: MyViewController?
    
    private (set) var children: [MyViewController] = NSMutableArray() as! [MyViewController]
    
    //open var presentedViewController: UIViewController? { get }
    //open var presentingViewController: UIViewController? { get }
    
    private (set) var  navigationController: UINavigationController?
    private (set) var splitViewController: UISplitViewController?
    private (set) var tabBarController: UITabBarController?
    private (set) var searchDisplayController: UISearchController?
    private (set) var modalViewController: MyViewController?
    
    private (set) var parentageTransition: UIViewControllerParentageTransition?
    
    
    public override convenience init() {
        self.init(nibName: nil, bundle: nil)
    }
    
    public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        contentSizeForViewInPopover = CGSize(width: 320, height: 1100)
        hidesBottomBarWhenPushed = false
        super.init()
        
    }
    
    func presentViewController(_ viewControllerToPresent: MyViewController,_ animated: Bool, complition: () -> Void) {
        if viewControllerToPresent != self {
            
            modalViewController = viewControllerToPresent
            modalViewController?.parent = self
            
            let windows = (self.view.window)!
            let newView = (modalViewController?.view)!
            
            newView.autoresizingMask = view.autoresizingMask
            
            newView.frame = wantsFullScreenLayout ? windows.screen.bounds : windows.screen.applicationFrame
            
            windows.addSubview(newView)
            modalViewController?.viewWillAppear(animated)
            
            viewWillDisappear(animated)
            view.isHidden = true
            viewDidDisappear(animated)
        }
    
    }
    
    //addChildViewController
    //This method creates a parent-child relationship between the current view controller and the object in the childController parameter. This relationship is necessary when embedding the child view controller’s view into the current view controller’s content. If the new child view controller is already the child of a container view controller, it is removed from that container before being added.
    //This method is only intended to be called by an implementation of a custom container view controller. If you override this method, you must call super in your implementation.
    
    func addChildViewController(_ childController: MyViewController?) {
     
        childController?.willMoveToParentViewController(self)
        if let childController = childController  {
            children.append(childController)
            childController.parent = self
        }
    }
    
    func removeFromParentViewController() {
        if let parent = parent {
            if let index = parent.children.index(of: self) {
                parent.children.remove(at: index)
            }
        }
    }
    
    func willMoveToParentViewController(_ parent: MyViewController?) {
        if parent != nil {
            parentageTransition = UIViewControllerParentageTransition.UIViewControllerParentageTransitionToParent
        } else {
            parentageTransition = UIViewControllerParentageTransition.UIViewControllerParentageTransitionNone
        }
    }
    
    func didMoveToParentViewController(_ paretnt: MyViewController) {
        parentageTransition = UIViewControllerParentageTransition.UIViewControllerParentageTransitionNone
    }
    
    
}
