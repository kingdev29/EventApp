//
//  PriceViewController.swift
//  iOSEventApp
//
//  Created by sunil maharjan on 1/14/16.
//  Copyright © 2016 Swiss Magic. All rights reserved.
//

import UIKit
import SwiftValidator

class PriceViewController: UIViewController, UITableViewDataSource, ValidationDelegate {
    
    // MARK: - Properties
    
    @IBOutlet weak var textPrice: UITextFieldWithBottomBorder!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tablePrice: UITableView!
    
    var selectedTextField:UITextField!
    var numberOfRows = 1
    var artist = [""]
    var staffelung = [(From: "",To: "",Price: "")]
    var validationDidSucceed:Bool = false
    let validator = Validator()
    
    // MARK: - View Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CreateEventHelper.removeBackFromNavigationButton(self)
        
        
        let toolBar = UIToolbar(frame: CGRectMake(0,0,320,44))
        let alterDoneBtn = UIBarButtonItem(title: "Fertig", style: .Plain, target: self, action: #selector(PriceViewController.donePriceNumber(_:)))
        let space = UIBarButtonItem.init(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
        toolBar.setItems([space,alterDoneBtn], animated: true)
        textPrice.inputAccessoryView = toolBar
        
        
        tablePrice.dataSource = self
        tablePrice.separatorStyle = UITableViewCellSeparatorStyle.None
        
        let tapGesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(PriceViewController.dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
        initializeViews()
        print(GlobalVariables.createEventData)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if let price = GlobalVariables.createEventData["entrance_fee"] {
            textPrice.text = price as? String
            if GlobalVariables.priceStaffelung.count == 0{
                staffelung = [(From: "",To: "",Price: "")]
            }else{
                //  GlobalVariables.priceStaffelung = staffelung
                staffelung = GlobalVariables.priceStaffelung
            }
            tablePrice.reloadData()
        }
        registerKeyboardObserver()
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        deRegisterKeyboardObserver()
    }
    
    
    @IBAction func btnAddMore(sender: AnyObject) {
        let lastStaffelung = staffelung[staffelung.count-1]
        if lastStaffelung.From != "" && lastStaffelung.To != "" && lastStaffelung.Price != "" {
            
            staffelung.append(("","",""))
            tablePrice.reloadData()
            
            let indexPath = NSIndexPath(forRow: staffelung.count-1, inSection: 0)
            self.tablePrice.scrollToRowAtIndexPath(indexPath,
                atScrollPosition: UITableViewScrollPosition.Middle, animated: true)
        }
        
    }
    
    
    @IBAction func btnNext(sender: AnyObject) {
        
        self.validator.validate(self)
    }
    
    // MARK: - Validation delegate Methods
    
    func validationFailed(errors: [UITextField : ValidationError]) {
        validationDidSucceed = false
        Utility.showAlert("Error", message: "All fields are mandatory.", vc: self)
    }
    
    func validationSuccessful() {
        validationDidSucceed = true
        GlobalVariables.createEventData["entrance_fee"] = textPrice.text
        if staffelung.count > 0 {
            for i in 0 ... staffelung.count - 1 {
                if staffelung[i].From == "" && staffelung[i].To == "" &&  staffelung[i].Price == ""{
                    staffelung.removeAtIndex(i)
                }
            }
        }
        GlobalVariables.priceStaffelung = staffelung
        
    }
    
    
    // MARK: - Custom Methods
    
    func initializeViews(){
        
        if let editEvent = GlobalVariables.editEventData {
            let entranceFee = editEvent.entrance_fee!
            let prices = editEvent.prices!
            if prices.count > 0 {
                staffelung.removeAll()
                for price in prices  {
                    //     print("priceee=\()")
                    let pp = price as! Price
                    
                    let price_to = pp.to!
                    let price_from = pp.from!
                    let fee = pp.fee!
                    let ss = (price_from,price_to,fee)
                    print("priceeee=\(ss)")
                    
                    staffelung.append(ss)
                    
                }}else{
                staffelung = [(From: "",To: "",Price: "")]
            }
            textPrice.text = entranceFee
            
            staffelung.sortInPlace { $0.0 < $1.0 }
            
            tablePrice.reloadData()
            
        }else{
            textPrice.text = ""
        }
        validator.registerField(textPrice, rules: [RequiredRule()])
        
    }
    
    func donePriceNumber(sender:AnyObject){
        textPrice.endEditing(true)
    }
    // MARK: - Keyboard Methods
    
    func registerKeyboardObserver(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(PriceViewController.keyboardShow(_:)), name:UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(PriceViewController.keyboardHide(_:)), name:UIKeyboardWillHideNotification, object: nil)
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
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize!.height - 60.0, 0.0)
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
        var aRect : CGRect = self.view.frame
        aRect.size.height -= keyboardSize!.height
        self.scrollView.scrollRectToVisible(tablePrice!.frame, animated: true)
        let indexPath = NSIndexPath(forRow: (selectedTextField.superview?.tag)!, inSection: 0)
        self.tablePrice.scrollToRowAtIndexPath(indexPath,
            atScrollPosition: UITableViewScrollPosition.Middle, animated: true)
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
        if textField != textPrice {
            let index = textField.superview!.tag
            var tempTupleStaffelung = staffelung[index]
            let from = tempTupleStaffelung.From
            let to = tempTupleStaffelung.To
            let price = tempTupleStaffelung.Price
            switch textField.tag {
            case 11:
                tempTupleStaffelung = (textField.text!,to,price)
                break
            case 12:
                tempTupleStaffelung = (from,textField.text!,price)
                break
            default:
                tempTupleStaffelung = (from,to,textField.text!)
                break
                
            }
            
            staffelung[index] = tempTupleStaffelung
            
        }
        
        selectedTextField = nil
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    func next(sender:AnyObject){
        let tag = selectedTextField.tag
        var responder:UIResponder!
        if tag == 11
        {
            responder = selectedTextField.superview?.viewWithTag(12)
            
            
        } else {
            responder = selectedTextField.superview?.viewWithTag(13)
        }
        
        responder.becomeFirstResponder()
        
        
        /*
        let nextTage = selectedTextField.tag + 1;
        let nextResponder=selectedTextField.superview?.viewWithTag(nextTage) as UIResponder!
        if (nextResponder != nil){
        nextResponder?.becomeFirstResponder()
        }
        else
        {
        // Not found, so remove keyboard
        sender.resignFirstResponder()
        }
        */
    }
    
    // MARK: - Table Methods
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return numberOfRows
        return staffelung.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PriceCell") as! PriceTableViewCell
        let dataStaffelung = staffelung[indexPath.row]
        cell.contentView.tag = indexPath.row
        
        let toolBar = UIToolbar(frame: CGRectMake(0,0,320,44))
        let alterDoneBtn = UIBarButtonItem(title: "Next", style: .Plain, target: self, action: #selector(PriceViewController.next(_:)))
        let space = UIBarButtonItem.init(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
        toolBar.setItems([space,alterDoneBtn], animated: true)
        //        textAge.inputAccessoryView = toolBar
        
        cell.textFrom.inputAccessoryView = toolBar
        cell.textTo.inputAccessoryView = toolBar
        
        cell.textFrom.text = "\(dataStaffelung.From)"
        cell.textTo.text = "\(dataStaffelung.To)"
        cell.textPrice.text = "\(dataStaffelung.Price)"
        
        cell.textFrom.placeholder = "1"
        cell.textTo.placeholder = "100"
        cell.textPrice.placeholder = "Gratis"
        
        cell.textFrom.tag = 11
        cell.textFrom.returnKeyType = UIReturnKeyType.Next
        cell.textTo.tag = 12
        cell.textTo.returnKeyType = UIReturnKeyType.Next
        cell.textPrice.tag = 13
        cell.btnRemove.addTarget(self, action: #selector(PriceViewController.removeRow(_:)), forControlEvents:  UIControlEvents.TouchUpInside )
        cell.btnRemove.tag = indexPath.row
        if indexPath.row == 0 {
            cell.btnRemove.hidden = true
        }else{
            cell.btnRemove.hidden = false
        }
        
        return cell
    }
    
    func removeRow(sender:AnyObject){
        staffelung.removeAtIndex(sender.tag)
        tablePrice.reloadData()
        
    }
    
    // MARK: - Segue Methods
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        return validationDidSucceed
    }
    
}
