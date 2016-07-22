//
//  CreateEventHelper.swift
//  iOSEventApp
//
//  Created by sunil maharjan on 1/21/16.
//  Copyright © 2016 Swiss Magic. All rights reserved.
//
import Foundation
import UIKit

class CreateEventHelper: NSObject {
    
    // MARK: - Remove Back Title
    
    class func removeBackFromNavigationButton(sender:UIViewController){
         sender.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.Plain, target:nil, action:nil)
    }

}
