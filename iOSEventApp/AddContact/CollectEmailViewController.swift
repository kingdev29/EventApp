//
//  CollectEmailViewController.swift
//  iOSEventApp
//
//  Created by sunil maharjan on 1/22/16.
//  Copyright © 2016 Swiss Magic. All rights reserved.
//

import UIKit
import SwiftyJSON
import PKHUD
import SwiftValidator

class CollectEmailViewController: UIViewController, AddContactDelegate, ValidationDelegate, ShowAlertViewPopVCDelegate {
    // MARK: - Properties
    @IBOutlet weak var btnMannlich: UIButtonWithBorder!
    @IBOutlet weak var btnWeiblich: UIButtonWithBorder!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var textFirstName: UITextFieldWithBottomBorder!
    @IBOutlet weak var textSurname: UITextFieldWithBottomBorder!
    @IBOutlet weak var textEmailAddress: UITextFieldWithBottomBorder!
    @IBOutlet weak var textPhone: UITextFieldWithBottomBorder!
    @IBOutlet weak var textDOB: UITextFieldWithBottomBorder!
    @IBOutlet weak var lblErrorNachname: UILabel!
    @IBOutlet weak var lblErrorVorname: UILabel!
    @IBOutlet weak var lblErrorPhone: UILabel!
    @IBOutlet weak var lblErrorEmail: UILabel!
    @IBOutlet weak var saveButtonCenterY: NSLayoutConstraint!
    @IBOutlet weak var lblErrorGender: UILabel!
    @IBOutlet weak var lblErrorDOB: UILabel!
    
    var numberOfEmailsSaved = 0
    var isMale:Bool?
    var selectedTextField:UITextFieldWithBottomBorder!
    let datePicker = UIDatePicker()
    let validator = Validator()
    var eventId: NSNumber?
    var currentContact:JSON!
    
    // MARK: - View Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        Networking.contactDelegate = self
        self.title = "E-MAIL GESAMMELT"
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CollectEmailViewController.dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        initializeView()
        addDoneToNumberPad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        Utility.alertViewPopVCDelegate = self
        registerKeyboardObserver()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        deRegisterKeyboardObserver()
    }
    
    
    // MARK: - Network Api Delegates
    func addContactDidFailed(error: NSError) {
        var errMessage:String!
        switch error.code {
        case -1003:
            errMessage = "Your Internet does not seem to be working."
            break
        default:
            errMessage = error.localizedDescription
            break
        }
        Utility.showAlert("Error", message: errMessage, vc: self)
        PKHUD.sharedHUD.hide(animated: false)
    }
    
    func addContactDidSucceed(statusCode: Int32) {
        PKHUD.sharedHUD.hide(animated: false)
        switch statusCode {
        case 200:
            if (currentContact) != nil{
                Utility.showAlertWithPopVC("Success", message: "Contact updated successfully", vc: self)
            }else{
                self.initializeView()
                numberOfEmailsSaved += 1
                switch numberOfEmailsSaved {
                case 1:
                    self.title = "(\(numberOfEmailsSaved)) E-MAIL GESAMMELT"
                    break
                default:
                    self.title = "(\(numberOfEmailsSaved)) E-MAILS GESAMMELT"
                    break
                }
            }
            break
        case 422:
            Utility.showAlert("Error", message: "This Email Address is already registered.", vc: self)
            break
        case 421:
            Utility.showAlert("Error", message: "Unauthorized Access.", vc: self)
            break
        default:
            break
        }
        
    }
    
    // MARK: - UIButton Methods
    
    @IBAction func btnSex(sender: UIButtonWithBorder) {
        lblErrorGender.hidden = true
        switch sender {
        case btnMannlich :
            isMale = true
            btnMannlich.setImage(UIImage(named: "GenreChecked"), forState: .Normal)
            btnWeiblich.setImage(nil, forState: .Normal)
            break
        case btnWeiblich :
            isMale = false
            btnMannlich.setImage(nil, forState: .Normal)
            btnWeiblich.setImage(UIImage(named: "GenreChecked"), forState: .Normal)
            break
        default:
            break
        }
    }
    
    @IBAction func btnSave(sender: AnyObject) {
        
        self.validator.validate(self)
    }
    
    //MARK: - Custom Methods
    
    func initializeView(){
        if let editContact = currentContact{
            
            self.title =  "KONTAKT BEARBEITEN"
            let email = editContact["email"].string
            let firstName = editContact["first_name"].string!
            let lastName = editContact["last_name"].string!
            let dob = editContact["dob"].string!
            let phone = editContact["phone"].string!
            let gender = editContact["gender"].string!
            
            textFirstName.text = firstName
            textSurname.text = lastName
            textDOB.text = dob
            textEmailAddress.text = email
            textPhone.text = phone
            if(gender == "Male"){
                btnMannlich.setImage(UIImage(named: "GenreChecked"), forState: .Normal)
                btnWeiblich.setImage(nil, forState: .Normal)
                isMale = true
            }else{
                btnMannlich.setImage(nil, forState: .Normal)
                btnWeiblich.setImage(UIImage(named: "GenreChecked"), forState: .Normal)
                isMale = false
            }
        }else{
            textFirstName.text = ""
            textSurname.text = ""
            textEmailAddress.text = ""
            textPhone.text = ""
            textDOB.text = ""
            isMale = nil
            btnMannlich.setImage(nil, forState: .Normal)
            btnWeiblich.setImage(nil, forState: .Normal)
        }
        
        textDOB.inputView = datePicker
        datePicker.datePickerMode = .Date
        datePicker.backgroundColor = UIColor(red: 25/255, green: 41/255, blue: 64/255, alpha: 1.0)
        datePicker.setValue(UIColor.whiteColor(), forKeyPath: "textColor")
        let toolBar = UIToolbar(frame: CGRectMake(0,0,320,44))
        toolBar.barTintColor = UIColor(red: 25/255, green: 41/255, blue: 64/255, alpha: 1.0)
        toolBar.backgroundColor = UIColor(red: 25/255, green: 41/255, blue: 64/255, alpha: 1.0)
        let alterDoneBtn = UIBarButtonItem(title: "Done", style: .Plain, target: self, action: #selector(CollectEmailViewController.doneDOB(_:)))
        let space = UIBarButtonItem.init(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
        toolBar.setItems([space,alterDoneBtn], animated: true)
        textDOB.inputAccessoryView = toolBar
        
        lblErrorPhone.hidden = true
        lblErrorEmail.hidden = true
        lblErrorNachname.hidden = true
        lblErrorVorname.hidden = true
        lblErrorGender.hidden = true
        lblErrorDOB.hidden = true
        
        self.validator.registerField(textFirstName, errorLabel: lblErrorVorname, rules: [RequiredRule()])
        self.validator.registerField(textSurname, errorLabel: lblErrorNachname, rules: [RequiredRule()])
        self.validator.registerField(textEmailAddress, errorLabel: lblErrorEmail, rules: [RequiredRule(), EmailRule(message: "Invalid email")])
        self.validator.registerField(textPhone, errorLabel: lblErrorPhone, rules: [RequiredRule()])
        self.validator.registerField(textDOB, errorLabel: lblErrorDOB, rules: [RequiredRule()])
    }
    
    func doneDOB(sender:AnyObject){
        let df = NSDateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        textDOB.text = df.stringFromDate(datePicker.date)
        self.view.endEditing(true)
    }
    
    // MARK: - ShowAlertViewPopVCDelegate Method
    
    func alertViewPopVCDidTapped() {
        
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
        print("\(viewControllers.count)")
        self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true)
        
}
    
    // MARK: - ValidationDelegate Methods
    
    func validationSuccessful() {
        let firstName = textFirstName.text!
        let surName = textSurname.text!
        let emailAddress = textEmailAddress.text!
        let dob = textDOB.text!
        let phone = textPhone.text!
        if isMale != nil {
            let gender = isMale! ? "Male" : "Female"
            let contact = Contact(firstName: firstName, surName: surName, emailAddress: emailAddress, dob: dob, phone: phone, sex: gender)
            PKHUD.sharedHUD.contentView = PKHUDProgressView()
            PKHUD.sharedHUD.show()
            if let editContact = currentContact{
                Networking.addContact(contact!, eventId: nil, contactId: editContact["id"].number)
            }else{
                Networking.addContact(contact!, eventId: self.eventId!,contactId: nil)
            }
        }else
        {
            lblErrorGender.hidden = false
        }
        
    }
    
    func validationFailed(errors: [UITextField : ValidationError]) {
        
        for (_, error) in validator.errors {
            error.errorLabel?.text = error.errorMessage // works if you added labels
            error.errorLabel?.hidden = false
        }
        
    }
    
    // MARK:  Keyboard Methods
    
    func registerKeyboardObserver(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CollectEmailViewController.keyboardShow(_:)), name:UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CollectEmailViewController.keyboardHide(_:)), name:UIKeyboardWillHideNotification, object: nil)
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
        let offSet = UIScreen.mainScreen().bounds.size.height * (1 - saveButtonCenterY.multiplier)
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize!.height - offSet, 0.0)
        
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
    
    func textFieldDidBeginEditing(textField: UITextFieldWithBottomBorder!)
    {
        selectedTextField = textField
    }
    
    func textFieldDidEndEditing(textField: UITextField!)
    {
        selectedTextField = nil
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        switch selectedTextField {
        case textFirstName:
            textSurname.becomeFirstResponder()
            break
        case textSurname:
            textEmailAddress.becomeFirstResponder()
            break
        case textEmailAddress:
            textPhone.becomeFirstResponder()
            break
        case textDOB:
            self.view.endEditing(true)
            break
        default:
            break
        }
        return false
    }
    
    func addDoneToNumberPad(){
        let toolBar = UIToolbar(frame: CGRectMake(0,0,320,44))
        let alterDoneBtn = UIBarButtonItem(title: "Next", style: .Plain, target: self, action: #selector(CollectEmailViewController.donePhoneNumber(_:)))
        let space = UIBarButtonItem.init(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
        toolBar.setItems([space,alterDoneBtn], animated: true)
        textPhone.inputAccessoryView = toolBar
    }
    
    func donePhoneNumber(sender:AnyObject){
        textDOB.becomeFirstResponder()
        //textPhone.endEditing(true)
    }
}