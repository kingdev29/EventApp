//
//  CreateEventViewController.swift
//  iOSEventApp
//
//  Created by sunil maharjan on 1/4/16.
//  Copyright © 2016 Swiss Magic. All rights reserved.
//

import UIKit
import QuartzCore
import SwiftValidator


struct fromtoprice {
    var from: Int
    var to: Int
    var price: Int
}

class CreateEventViewController: UIViewController, ValidationDelegate {
    
    // MARK: - Properties
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var textStadt: UITextFieldWithBottomBorder!
    @IBOutlet weak var textKanton: UITextFieldWithBottomBorder!
    @IBOutlet weak var textLand: UITextFieldWithBottomBorder!
    @IBOutlet weak var textClub: UITextFieldWithBottomBorder!
    @IBOutlet weak var textEventName: UITextFieldWithBottomBorder!
    
    var selectedTextField:UITextField!
    var validationFailed:Bool = true
    let validator = Validator()
    
    @IBAction func dismissCreateView(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - View Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CreateEventViewController.dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        navigationController!.navigationBar.barTintColor = Constants.navigationBarTintColor
        navigationController!.navigationBar.tintColor = UIColor.whiteColor()
        
        let attributes = [
            NSForegroundColorAttributeName: UIColor.whiteColor(),
            NSFontAttributeName: UIFont.systemFontOfSize(15)
        ]
        self.navigationController?.navigationBar.titleTextAttributes = attributes
        
        CreateEventHelper.removeBackFromNavigationButton(self)
        GlobalVariables.createEventData.removeAll()
        initializeViews()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        registerKeyboardObserver()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        deRegisterKeyboardObserver()
    }
    
    
    @IBAction func btnNext(sender: AnyObject) {
    
        self.validator.validate(self)
    }
    
    // MARK: - Form Validation Delegate Methods
    
    func validationFailed(errors: [UITextField : ValidationError]) {
        validationFailed = true
        Utility.showAlert("Fehler", message: "Alle Felder müssen ausgefüllt werden.", vc: self)
    }
    
    func validationSuccessful() {
        var address = [String: String]()
        let eventName = textEventName.text
        let clubName = textClub.text
        let stadt = textStadt.text
        let kanton = textKanton.text
        let land = textLand.text
        address["state"] = stadt
        address["area"] = kanton
        address["country"] = land
        
        GlobalVariables.createEventData["name"] = eventName
        GlobalVariables.createEventData["club"] = clubName
        GlobalVariables.createEventData["address"] = address
        validationFailed = false
        
    }
    
    
    // MARK: - Keyboard Methods
    
    func registerKeyboardObserver(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CreateEventViewController.keyboardShow(_:)), name:UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CreateEventViewController.keyboardHide(_:)), name:UIKeyboardWillHideNotification, object: nil)
    }
    
    func deRegisterKeyboardObserver(){
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardShow(notification: NSNotification)
    {
        self.scrollView.scrollEnabled = true
        let info : NSDictionary = notification.userInfo!
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue().size
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize!.height - 60, 0.0)
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
        var aRect : CGRect = self.view.frame
        aRect.size.height -= keyboardSize!.height
        if selectedTextField !== nil {
            if (!CGRectContainsPoint(aRect, selectedTextField!.frame.origin))
            {
                self.scrollView.scrollRectToVisible(selectedTextField!.frame, animated: true)
            }
        }
    }
    
    func keyboardHide(notification: NSNotification)
    {
        let info : NSDictionary = notification.userInfo!
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue().size
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, -keyboardSize!.height, 0.0)
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
        self.view.endEditing(true)
        self.scrollView.scrollEnabled = false
    }
    
    func dismissKeyboard(){
        self.view.endEditing(true)
    }
    
    func textFieldDidBeginEditing(textField: UITextField!)
    {
        selectedTextField = textField
    }
    
    func textFieldDidEndEditing(textField: UITextField!)
    {
        selectedTextField = nil
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        switch selectedTextField {
        case textEventName:
            textClub.becomeFirstResponder()
            break
        case textClub:
            textStadt.becomeFirstResponder()
            break
        case textStadt:
            textKanton.becomeFirstResponder()
            break
        case textKanton:
            textLand.becomeFirstResponder()
            break
        case textLand:
            self.view.endEditing(true)
            break
        default:
            break
        }
        
        return false
    }
    
    // MARK: -Custom Methods
    
    func initializeViews(){
        
        if let editEvent = GlobalVariables.editEventData {
            textEventName.text = editEvent.name
            textClub.text = editEvent.club
            textStadt.text = editEvent.state
            textKanton.text = editEvent.area
            textLand.text = editEvent.country
        }else{
        textEventName.text = ""
        textClub.text = ""
        textStadt.text = ""
        textLand.text = ""
        textKanton.text = ""
        }
        self.validator.registerField(textEventName, rules: [RequiredRule()])
        self.validator.registerField(textClub, rules: [RequiredRule()])
        self.validator.registerField(textStadt, rules: [RequiredRule()])
        self.validator.registerField(textKanton, rules: [RequiredRule()])
        self.validator.registerField(textLand, rules: [RequiredRule()])
        
    }
    
    // MARK: - Segue Methods
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        return (validationFailed ? false:true)
    }
    
}
