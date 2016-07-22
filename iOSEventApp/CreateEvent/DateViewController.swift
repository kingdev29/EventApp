//
//  DateViewController.swift
//  iOSEventApp
//
//  Created by sunil maharjan on 1/11/16.
//  Copyright © 2016 Swiss Magic. All rights reserved.
//

import UIKit
import SwiftValidator

class DateViewController: UIViewController, ValidationDelegate {
    
    // MARK: - Properties
    
    var txtfield:UITextField!
    var datePicker = UIDatePicker()
    var numberSelected:String!
    var selectedTextField:UITextField!
    var validationFailed:Bool = true
    var startDate:String!
    var endDate:String!
    let validator = Validator()
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var lblStartDate: UILabel!
    @IBOutlet weak var btnShowDate: UIButton!
    @IBOutlet weak var lblEndDate: UILabel!
    @IBOutlet weak var btnShowTime: UIButton!
    @IBOutlet weak var textAge: UITextFieldWithBottomBorder!
    
    // MARK: - View Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datePicker.locale = NSLocale(localeIdentifier: "de_DE")
        
        lblStartDate.text = "\(getDateString(NSDate())) Uhr"
        lblEndDate.text = "\(getDateString(NSDate())) Uhr"
        
        let df = NSDateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm:00"
        startDate = df.stringFromDate(NSDate())
        endDate = df.stringFromDate(NSDate())
        self.title = "EVENT ERSTELLEN"
        
        /* To dismiss the keyboard on tap anywhere */
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(DateViewController.dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        /* To invoke inputview property of textfield  */
        txtfield = UITextField()
        self.view.addSubview(txtfield)
        
        let toolBar = UIToolbar(frame: CGRectMake(0,0,320,44))
        let alterDoneBtn = UIBarButtonItem(title: "Fertig", style: .Plain, target: self, action: #selector(DateViewController.doneAlterNumber(_:)))
        let space = UIBarButtonItem.init(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
        toolBar.setItems([space,alterDoneBtn], animated: true)
        textAge.inputAccessoryView = toolBar
        
        initializeViews()
        
        CreateEventHelper.removeBackFromNavigationButton(self)
        
        print(GlobalVariables.createEventData)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if let x = GlobalVariables.createEventData["min_age"]{
            textAge.text = x as? String
            lblStartDate.text = GlobalVariables.createEventData["start_date_display"] as? String
            lblEndDate.text = GlobalVariables.createEventData["end_date_display"] as? String
        }
        registerKeyboardObserver()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        deRegisterKeyboardObserver()
    }
    
    @IBAction func btnNext(sender: AnyObject) {
        self.validator.validate(self)
    }
    
    // MARK: Validation Delegate methods
    
    func validationFailed(errors: [UITextField : ValidationError]) {
        validationFailed = true
        Utility.showAlert("error", message: "All fields are Mandatory", vc: self)
    }
    
    func validationSuccessful() {
        validationFailed = false
        let age = textAge.text
        GlobalVariables.createEventData["start_date_display"] = lblStartDate.text
        GlobalVariables.createEventData["end_date_display"] = lblEndDate.text
        GlobalVariables.createEventData["min_age"] = age
        GlobalVariables.createEventData["start_date"] = startDate
        GlobalVariables.createEventData["end_date"] = endDate
    }
    
    
    // MARK: - Keyboard Methods
    
    func registerKeyboardObserver(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(DateViewController.keyboardShow(_:)), name:UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(DateViewController.keyboardHide(_:)), name:UIKeyboardWillHideNotification, object: nil)
    }
    
    func deRegisterKeyboardObserver(){
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardShow(notif:NSNotification){
        
        self.scrollView.scrollEnabled = true
        let info : NSDictionary = notif.userInfo!
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue().size
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize!.height - 40, 0.0)
        
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
    
    func keyboardHide(notif:NSNotification)
    {
        let info : NSDictionary = notif.userInfo!
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue().size
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, -keyboardSize!.height, 0.0)
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
        self.view.endEditing(true)
        self.scrollView.scrollEnabled = false
        btnShowDate.setImage(UIImage(named: "DateEditOff"), forState: .Normal)
        btnShowTime.setImage(UIImage(named: "DateEditOff"), forState: .Normal)
    }
    
    func dismissKeyboard(){
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func doneAlterNumber(sender:AnyObject){
        textAge.endEditing(true)
    }
    
    // MARK: - Picker view Methods
    
    @IBAction func showPicker(sender:AnyObject){
        datePicker.addTarget(self, action: nil, forControlEvents: UIControlEvents.ValueChanged)
        datePicker.setValue(UIColor.whiteColor(), forKeyPath: "textColor")
        datePicker.backgroundColor = UIColor(red: 25/255, green: 41/255, blue: 64/255, alpha: 1.0)
        txtfield.inputView = datePicker
        
        let toolBar = UIToolbar(frame: CGRectMake(0,0,320,44))
        toolBar.barTintColor = UIColor(red: 25/255, green: 41/255, blue: 64/255, alpha: 1.0)
        toolBar.backgroundColor = UIColor(red: 25/255, green: 41/255, blue: 64/255, alpha: 1.0)
        
        var cancelBtn:UIBarButtonItem!
        var doneBtn:UIBarButtonItem!
        switch sender as! UIButton {
        case btnShowDate:
            cancelBtn = UIBarButtonItem(title: "Abbrechen", style: .Plain, target: self, action: #selector(DateViewController.cancelPickerView(_:)))
            doneBtn = UIBarButtonItem(title: "Sichern", style: .Plain, target: self, action: #selector(DateViewController.doneDatePickerView(_:)))
            btnShowDate.setImage(UIImage(named: "DateEditOn"), forState: .Normal)
            break
        case btnShowTime:
            cancelBtn = UIBarButtonItem(title: "Abbrechen", style: .Plain, target: self, action: #selector(DateViewController.cancelPickerView(_:)))
            doneBtn = UIBarButtonItem(title: "Sichern", style: .Plain, target: self, action: #selector(DateViewController.doneTimePickerView(_:)))
            btnShowTime.setImage(UIImage(named: "DateEditOn"), forState: .Normal)
            break
        default :
            break
        }
        
        let space = UIBarButtonItem.init(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
        toolBar.setItems([cancelBtn,space,doneBtn], animated: true)
        txtfield.inputAccessoryView = toolBar
        txtfield.becomeFirstResponder()
    }
    
    func cancelPickerView(sender:AnyObject){
        txtfield.resignFirstResponder()
        btnShowTime.setImage(UIImage(named: "DateEditOff"), forState: .Normal)
        btnShowDate.setImage(UIImage(named: "DateEditOff"), forState: .Normal)
    }
    
    func doneDatePickerView(sender:AnyObject){
        let df = NSDateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        startDate = "\(df.stringFromDate(datePicker.date))"
        
        let strDate = getDateString(datePicker.date)
        lblStartDate.text = "\(strDate) Uhr"
        btnShowDate.setImage(UIImage(named: "DateEditOff"), forState: .Normal)
        txtfield.resignFirstResponder()
    }
    
    func doneTimePickerView(sender:AnyObject){
        let df = NSDateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        endDate = "\(df.stringFromDate(datePicker.date))"
        
        let strDate = getDateString(datePicker.date)
        lblEndDate.text = "\(strDate) Uhr"
        
        btnShowTime.setImage(UIImage(named: "DateEditOff"), forState: .Normal)
        txtfield.resignFirstResponder()
    }
    
    // MARK: - Custom Methods
    
    func initializeViews(){
        if let editEvent = GlobalVariables.editEventData {
            print(GlobalVariables.editEventData)
            let start_date = editEvent.start_date!
            let start_time = editEvent.start_time!
            let end_date = editEvent.end_date!
            let end_time = editEvent.end_time!
            startDate = start_date + " " + start_time
            endDate = end_date + " " + end_time
            
        lblStartDate.text = getDateForEdit(start_date, strTime: start_time)
        lblEndDate.text = getDateForEdit(end_date, strTime: end_time)
        textAge.text = editEvent.min_age!
        }else{
           textAge.text = ""
        }
        self.validator.registerField(textAge, rules: [RequiredRule()])
    }
    
    func getDateForEdit(strDate:String , strTime:String)->String{
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let formatted_start_date = dateFormatter.dateFromString(strDate)
        let df = NSDateFormatter()
        df.dateFormat = "MMM dd , yyy"
        let datestr = df.stringFromDate(formatted_start_date!)
        let index2 = strTime.rangeOfString(":", options: .BackwardsSearch)?.startIndex
        let substring2 = strTime.substringToIndex(index2!)
        return datestr + " " + substring2 + "  Uhr"
    }
    
    
    func getDateString(date:NSDate)-> String{
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMM dd , yyy  HH:mm "
        return dateFormatter.stringFromDate(date)
    }
    
    // MARK: - Segue Methods
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        return !validationFailed
    }
}
