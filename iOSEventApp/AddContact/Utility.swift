//
//  Utility.swift
//  iOSEventApp
//
//  Created by sunil maharjan on 1/26/16.
//  Copyright © 2016 Swiss Magic. All rights reserved.
//

import UIKit

protocol ShowAlertViewDelegate {
    func alertViewDidTapped(didTappedYes:Bool)
}

protocol ShowAlertViewPopVCDelegate {
    func alertViewPopVCDidTapped()
}

class Utility: NSObject {
    
    static var alertViewDelegate:ShowAlertViewDelegate?
    static var alertViewPopVCDelegate:ShowAlertViewPopVCDelegate?
    
    // MARK: - Show Alert Method
    class  func showAlert(title:String, message:String,vc:UIViewController){
        
        let attributedString = NSAttributedString(string: title, attributes: [
            NSFontAttributeName : UIFont.systemFontOfSize(15),
            
            ])
        let alertController = UIAlertController(title: ""  , message: message
            , preferredStyle: UIAlertControllerStyle.Alert)
        alertController.setValue(attributedString, forKey: "attributedTitle")
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default){  (action) -> Void in
            
        }
        alertController.addAction(okAction)
        vc.presentViewController(alertController, animated: true, completion: nil)
    }
    
    class  func showAlertWithPopVC(title:String, message:String,vc:UIViewController){
        
        let attributedString = NSAttributedString(string: title, attributes: [
            NSFontAttributeName : UIFont.systemFontOfSize(15),
            
            ])
        let alertController = UIAlertController(title: ""  , message: message
            , preferredStyle: UIAlertControllerStyle.Alert)
        alertController.setValue(attributedString, forKey: "attributedTitle")
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default){  (action) -> Void in
           self.alertViewPopVCDelegate?.alertViewPopVCDidTapped()
        }
        alertController.addAction(okAction)
        vc.presentViewController(alertController, animated: true, completion: nil)
    }

    
    class  func showAlertWithDismissVC(title:String, message:String,vc:UIViewController){
        
        let attributedString = NSAttributedString(string: title, attributes: [
            NSFontAttributeName : UIFont.systemFontOfSize(15),
            
            ])
        let alertController = UIAlertController(title: ""  , message: message
            , preferredStyle: UIAlertControllerStyle.Alert)
        alertController.setValue(attributedString, forKey: "attributedTitle")
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default){  (action) -> Void in
            vc.dismissViewControllerAnimated(true, completion: nil)
        }
        alertController.addAction(okAction)
        vc.presentViewController(alertController, animated: true, completion: nil)
    }

    class  func showYesNoAlert(title:String, message:String,vc:UIViewController){
        
        let attributedString = NSAttributedString(string: title, attributes: [
            NSFontAttributeName : UIFont.systemFontOfSize(15),
            
            ])
        let alertController = UIAlertController(title: ""  , message: message
            , preferredStyle: UIAlertControllerStyle.Alert)
        alertController.setValue(attributedString, forKey: "attributedTitle")
        let okAction = UIAlertAction(title: "Ja", style: UIAlertActionStyle.Default){  (action) -> Void in
            self.alertViewDelegate?.alertViewDidTapped(true)
        }
        let noAction = UIAlertAction(title: "Nein", style: UIAlertActionStyle.Default){  (action) -> Void in
            self.alertViewDelegate?.alertViewDidTapped(false)
        }
        alertController.addAction(okAction)
        alertController.addAction(noAction)
       
        vc.presentViewController(alertController, animated: true, completion: nil)
    }

    
}
