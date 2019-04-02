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
    
    private (set) var navigationController: UINavigationController?
    private (set) var splitViewController: UISplitViewController?
    private (set) var tabBarController: UITabBarController?
    private (set) var searchDisplayController: UISearchController?
    private (set) var modalViewController: MyViewController?
    
    private (set) var appearanceTransitionStack: NSInteger = 0
    private (set) var appearanceTransitionIsAnimated: Bool = false
    private (set) var viewIsAppearing: Bool = false
    private (set) var parentageTransition: UIViewControllerParentageTransition?
    
    var shouldAutomaticallyForwardRotationMethods: Bool {
        return true;
    }
    
    var shouldAutomaticallyForwardAppearanceMethods: Bool {
        return true;
    }
    
    
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
    
    func dismissModalViewControllerAnimated(_ animated: Bool) {
        if let modalViewController = modalViewController {
            if modalViewController.modalViewController != nil {
                modalViewController.dismissModalViewControllerAnimated(animated)
            }
            view.isHidden = false
            modalViewController.view.removeFromSuperview()
            modalViewController.parent = nil
            self.modalViewController = nil
            viewDidAppear(animated)
        } else {
            parent?.dismissModalViewControllerAnimated(animated)
        }
        
    }
    
    /*func nearestParentViewControllerThatIsKindOf(_ c: AnyClass) -> Any {
        if let parent = parent  {
            if parent.isKind(of: c) {
                
            }
        }
    }*/
    
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
    
    /*
     This method can be used to transition between sibling child view controllers. The receiver of this method is
     their common parent view controller. (Use [UIViewController addChildViewController:] to create the
     parent/child relationship.) This method will add the toViewController's view to the superview of the
     fromViewController's view and the fromViewController's view will be removed from its superview after the
     transition completes. It is important to allow this method to add and remove the views. The arguments to
     this method are the same as those defined by UIView's block animation API. This method will fail with an
     NSInvalidArgumentException if the parent view controllers are not the same as the receiver, or if the
     receiver explicitly forwards its appearance and rotation callbacks to its children. Finally, the receiver
     should not be a subclass of an iOS container view controller. Note also that it is possible to use the
     UIView APIs directly. If they are used it is important to ensure that the toViewController's view is added
     to the visible view hierarchy while the fromViewController's view is removed.
     */
    
    func transitionFromViewController(_ fromViewController: MyViewController, toViewController: MyViewController, duration: TimeInterval, options: UIViewAnimationOptions, animations: (() -> Void)?, _ complition: ((Bool) -> Void)? = nil) {
            var animated : Bool {
                if duration > 0 {
                    return true
                } else {
                    return false
                }
            }
    
        fromViewController.beginAppearanceTransition(false, animated: animated)
        toViewController.beginAppearanceTransition(true, animated: animated)
        
        UIView.transition(with: view, duration: duration, options: options, animations: {
            if let animations = animations {
                animations()
            }
            self.view.addSubview(toViewController.view)
            
        }) { (finished) in
            if finished {
                complition!(finished)
            }
            fromViewController.view.removeFromSuperview()
            //fromViewController.endAppearanceTransition
            //toViewController.endAppearanceTransition
        }
        
        
    }
    
    
    //If you are implementing a custom container controller, use this method to tell the child that its views are about to appear or disappear. Do not invoke viewWillAppear:, viewWillDisappear:, viewDidAppear:, or viewDidDisappear: directly.
    func beginAppearanceTransition(_ isAppearing: Bool, animated: Bool) {
        if appearanceTransitionStack == 0 || (appearanceTransitionStack > 0 && viewIsAppearing != isAppearing) {
            appearanceTransitionStack = 1
            appearanceTransitionIsAnimated = animated
            viewIsAppearing = isAppearing
            
            if shouldAutomaticallyForwardAppearanceMethods {
                for child in children {
                    if child.isViewLoaded() && child.view.isDescendant(of: view) {
                        child.beginAppearanceTransition(isAppearing, animated: animated)
                    }
                }
            }
            
            if viewIsAppearing {
                _ = self.view
                viewWillAppear(appearanceTransitionIsAnimated)
            } else {
                viewWillDisappear(appearanceTransitionIsAnimated)
            }
        }
    }
    
    /*
 - (void)endAppearanceTransition
 {
 if (_appearanceTransitionStack > 0) {
 _appearanceTransitionStack--;
 
 if (_appearanceTransitionStack == 0) {
 if ([self shouldAutomaticallyForwardAppearanceMethods]) {
 for (UIViewController *child in self.childViewControllers) {
 [child endAppearanceTransition];
 }
 }
 
 if (_viewIsAppearing) {
 [self viewDidAppear:_appearanceTransitionIsAnimated];
 } else {
 [self viewDidDisappear:_appearanceTransitionIsAnimated];
 }
 }
 }
 }
 */
    
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
