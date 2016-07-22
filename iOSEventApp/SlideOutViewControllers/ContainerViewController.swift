//  ContainerViewController.Swift
//  SlideOutNavigation
//
//  Created by sunil maharjan on 12/28/15.
//  Copyright © 2015 Sunil Maharjan. All rights reserved.
//

import UIKit
import QuartzCore

enum SlideOutState {
    case LeftCollapsed
    case LeftPanelExpanded
}

class ContainerViewController: UIViewController, EventListViewControllerDelegate, SidePanelViewControllerDelegate, UIGestureRecognizerDelegate {
    var centerNavigationController: UINavigationController!
    var centerViewController: EventListViewController!
    var xOffset :CGFloat=0
    var currentState: SlideOutState = .LeftCollapsed
        {
        didSet {
            let shouldShowShadow = currentState != .LeftCollapsed
            showShadowForCenterViewController(shouldShowShadow)
        }
    }
    
    var leftViewController: SidePanelViewController?
    
    let centerPanelExpandedOffset: CGFloat = 60
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpInitialViews()
    }
    
    func setUpInitialViews() {
        centerViewController = UIStoryboard.centerViewController()
        centerViewController.delegate = self
        
        centerNavigationController = UINavigationController(rootViewController: centerViewController)
        view.addSubview(centerNavigationController.view)
        addChildViewController(centerNavigationController)
        
        centerNavigationController.didMoveToParentViewController(self)
        
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: "respondToRightSwipeGesture:")
        swipeRight.direction = UISwipeGestureRecognizerDirection.Right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: "respondToLeftSwipeGesture:")
        swipeRight.direction = UISwipeGestureRecognizerDirection.Left
        self.view.addGestureRecognizer(swipeLeft)
        
        let tapGesture = UITapGestureRecognizer(target:self, action: "respondToTap:")
        self.view.addGestureRecognizer(tapGesture)
        tapGesture.delegate=self
    }
    
    func menuSelected(menu: Menu) {
        switch(menu.menuId){
        case "1":
            if let vc = UIStoryboard.centerViewController(){
                vc.title="EVENT ÜBERSICHT"
                self.centerNavigationController.viewControllers = [vc]
                vc.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "Hamburger"), style: UIBarButtonItemStyle.Plain, target: self, action: "toggleLeftPanel")
            }
            self.collapseSidePanel()
            break
        case "2":
            if let vc = UIStoryboard.redViewController(){
                vc.title="Red"
                self.centerNavigationController.viewControllers = [vc]
                vc.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "Hamburger"), style: UIBarButtonItemStyle.Plain, target: self, action: "toggleLeftPanel")
            }
            self.collapseSidePanel()
            break
        default:
            break
        }
    }
    
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        switch UIDevice.currentDevice().orientation{
        case .Portrait:
            switch (currentState) {
            case .LeftPanelExpanded:
                animateCenterPanelXPosition(targetPosition: CGRectGetWidth(centerNavigationController.view.frame) - centerPanelExpandedOffset)
            default:
                break
            }
        case .PortraitUpsideDown:
            switch (currentState) {
            case .LeftPanelExpanded:
                animateCenterPanelXPosition(targetPosition: CGRectGetWidth(centerNavigationController.view.frame) - centerPanelExpandedOffset)
            default:
                break
            }
        case .LandscapeLeft:
            switch (currentState) {
            case .LeftPanelExpanded:
                animateCenterPanelXPosition(targetPosition: CGRectGetWidth(centerNavigationController.view.frame) - centerPanelExpandedOffset)
            default:
                break
            }
        case .LandscapeRight:
            switch (currentState) {
            case .LeftPanelExpanded:
                animateCenterPanelXPosition(targetPosition: CGRectGetWidth(centerNavigationController.view.frame) - centerPanelExpandedOffset)
            default:
                break
            }
        default:
            break
        }    }
    
    
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        if currentState == .LeftPanelExpanded {
            return false
        }
        return  true
    }
    
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        let location = touch.locationInView(self.view)
        if xOffset == 0 {
            return false
        }
        if location.x >= xOffset{
            return true
        }
        return false
    }
    
    
    func respondToTap(sender:AnyObject){
        
        collapseSidePanel()
    }
    
    
    func respondToRightSwipeGesture(gesture:UIGestureRecognizer)
    {
        
        collapseSidePanel()
        
    }
    
    func respondToLeftSwipeGesture(gesture:UIGestureRecognizer)
    {
        if currentState == .LeftCollapsed{
            toggleLeftPanel()
        }
    }
    
    // MARK: CenterViewController delegate methods
    func toggleLeftPanel() {
        let notAlreadyExpanded = (currentState != .LeftPanelExpanded)
        
        if notAlreadyExpanded {
            addLeftPanelViewController()
        }
        
        animateLeftPanel(shouldExpand: notAlreadyExpanded)
    }
    
    
    func collapseSidePanel() {
        switch (currentState) {
            
        case .LeftPanelExpanded:
            toggleLeftPanel()
        default:
            break
        }
    }
    
    func addLeftPanelViewController() {
        if (leftViewController == nil) {
            leftViewController = UIStoryboard.leftViewController()
            leftViewController!.menus = Menu.allMenus()
            
            addChildSidePanelController(leftViewController!)
        }
    }
    
    func addChildSidePanelController(sidePanelController: SidePanelViewController) {
        sidePanelController.delegate = self
        
        view.insertSubview(sidePanelController.view, atIndex: 0)
        
        addChildViewController(sidePanelController)
        sidePanelController.didMoveToParentViewController(self)
    }
    
    func animateLeftPanel(shouldExpand shouldExpand: Bool) {
        if (shouldExpand) {
            currentState = .LeftPanelExpanded
            
            animateCenterPanelXPosition(targetPosition: CGRectGetWidth(centerNavigationController.view.frame) - centerPanelExpandedOffset)
        } else {
            animateCenterPanelXPosition(targetPosition: 0) { finished in
                self.currentState = .LeftCollapsed
                
                if self.leftViewController != nil {
                    self.leftViewController!.view.removeFromSuperview()
                    self.leftViewController = nil;
                }
            }
        }
    }
    
    
    func animateCenterPanelXPosition(targetPosition targetPosition: CGFloat, completion: ((Bool) -> Void)! = nil) {
        xOffset=targetPosition
        UIView.animateWithDuration(0.15, animations: {self.centerNavigationController!.view.frame = CGRect(x: targetPosition, y: self.view.frame.origin.y, width: self.view.frame.width, height: self.view.frame.height)}, completion: completion)
        
        
        
    }
    
    func showShadowForCenterViewController(shouldShowShadow: Bool) {
        if (shouldShowShadow) {
            centerNavigationController.view.layer.shadowOpacity = 0.1
        } else {
            centerNavigationController.view.layer.shadowOpacity = 0.0
        }
    }
    
}


private extension UIStoryboard {
    class func mainStoryboard() -> UIStoryboard { return UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()) }
    
    class func leftViewController() -> SidePanelViewController? {
        return mainStoryboard().instantiateViewControllerWithIdentifier("LeftViewController") as? SidePanelViewController
    }
    
    
    
    class func centerViewController() -> EventListViewController? {
        return mainStoryboard().instantiateViewControllerWithIdentifier("CenterViewController") as? EventListViewController
    }
    
    
    class func redViewController() -> RedViewController? {
        return mainStoryboard().instantiateViewControllerWithIdentifier("RedViewController") as? RedViewController
    }
    
}