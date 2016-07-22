//
//  LoginViewController.swift
//  iOSEventApp
//
//  Created by Kiran Thapa on 1/19/16.
//  Copyright © 2016 Swiss Magic. All rights reserved.
//

import UIKit
import PKHUD
import SwiftValidator

class LoginViewController: UIViewController, ValidationDelegate, LoginDelegate  {
    
    // MARK: Properties
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var lblEmailError: UILabel!
    @IBOutlet weak var lblPasswordError: UILabel!
    @IBOutlet weak var btnLogin: UIButton!
    
    let validator = Validator()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        Networking.loginDelegate = self
        self.initializeFields()
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
        self.view.addGestureRecognizer(tap)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(false)
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if let stringOne = defaults.stringForKey(Constants.authToken) {
            print("token")
            print(stringOne) // Some String Value
            self.performSegueWithIdentifier(Constants.showEventList, sender: self)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: Custom Methods
    
    func initializeFields() {
        self.txtEmail.text = ""
        self.txtPassword.text = ""
        self.lblEmailError.hidden = true
        self.lblPasswordError.hidden = true
        
        self.validator.registerField(self.txtEmail, errorLabel: self.lblEmailError, rules: [EmailRule(message: "Invalid email")])
        self.validator.registerField(self.txtPassword, errorLabel: self.lblPasswordError, rules: [MinLengthRule(length: 6, message: "Password must be at least 6 characters")])
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        self.view.endEditing(true)
    }
    
    @IBAction func login() {
        self.validator.validate(self)
    }
    
    // MARK: Text Field Delegate Methods
    func textFieldShouldReturn(textField: UITextField) -> Bool{
        switch textField {
        case txtEmail:
            txtPassword.becomeFirstResponder()
            break
        default:
            textField.resignFirstResponder()
        }
        return true
    }
    
    // MARK: Valiadion Delegate Methods
    
    func validationSuccessful() {
        self.lblEmailError.hidden = true
        self.lblPasswordError.hidden = true
        
        PKHUD.sharedHUD.contentView = PKHUDProgressView()
        PKHUD.sharedHUD.show()
        
        Networking.login(self.txtEmail.text, password: self.txtPassword.text)
    }
    
    func validationFailed(errors:[UITextField:ValidationError]) {
        self.lblEmailError.hidden = true
        self.lblPasswordError.hidden = true
        
        // turn the fields to red
        for (_, error) in validator.errors {
            error.errorLabel?.text = error.errorMessage // works if you added labels
            error.errorLabel?.hidden = false
        }
    }
    
    // MARK: Networking Delegate Methods
    
    func loginDidSucceed(authToken: String?, userType: String?) {
        print("login did succeed")
        
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(authToken, forKey: Constants.authToken)
        defaults.setObject(userType, forKey: Constants.userType)
        defaults.synchronize()
        
        if let stringOne = defaults.stringForKey(Constants.authToken) {
            print("token")
            print(stringOne) // Some String Value
        } else {
            print("token not set")
        }
        
        self.performSegueWithIdentifier(Constants.showEventList, sender: self)
        
        PKHUD.sharedHUD.hide(animated: false)
    }
    
    func loginAuthenticationDidFail() {
        print("invalid login")
        PKHUD.sharedHUD.hide(animated: false)
        
        let alert = UIAlertController(title: "Wrong credentials", message:"Please try again with valid credentials.", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default) { _ in })
        self.presentViewController(alert, animated: true){}
    }
    
    func loginDidFail(error: NSError?, message: String?) {
        print("login did fail")
        print(error)
        PKHUD.sharedHUD.hide(animated: false)
        
        var errMessage:String!
        
        if error != nil {
            switch error!.code {
            case -1003:
                errMessage = "Your Internet does not seem to be working."
                break
            default:
                errMessage = error!.localizedDescription
                break
            }
        } else {
            errMessage = "Wrong data sent from server. Please report this to us."
        }
        
        
        Utility.showAlert("Error", message: errMessage, vc: self)
        
    }
    

}





