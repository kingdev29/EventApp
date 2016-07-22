//
//  LabelViewController.swift
//  iOSEventApp
//
//  Created by sunil maharjan on 1/20/16.
//  Copyright © 2016 Swiss Magic. All rights reserved.
//

import UIKit
import SwiftValidator

class LabelViewController: UIViewController, ValidationDelegate {
    
    // MARK: - Properties
    
    @IBOutlet weak var textCategory: UITextFieldWithBottomBorder!
    @IBOutlet weak var tableArtist: UITableView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var selectedTextField:UITextField!
    var artist = [""]
    var validationDidFailed:Bool = true
    let validator = Validator()
    // MARK: - View Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(LabelViewController.dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
        CreateEventHelper.removeBackFromNavigationButton(self)
        
        tableArtist.separatorStyle = UITableViewCellSeparatorStyle.None
        
        print(GlobalVariables.createEventData)
        initializeViews()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if let label = GlobalVariables.createEventData["label"] as? String{
            textCategory.text = label
            artist = (GlobalVariables.createEventData["artists"] as? [String])!
            
        }
        
        tableArtist.dataSource = self
        tableArtist.delegate = self
        tableArtist.reloadData()
        registerKeyboardObserver()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        deRegisterKeyboardObserver()
    }
    
    @IBAction func addMore(sender: AnyObject) {
        if !artist.contains(""){
            artist.append("")
            tableArtist.reloadData()
            let indexPath = NSIndexPath(forRow: artist.count-1, inSection: 0)
            self.tableArtist.scrollToRowAtIndexPath(indexPath,
                atScrollPosition: UITableViewScrollPosition.Middle, animated: true)
        }
        
        
    }
    
    
    @IBAction func btnNext(sender: AnyObject) {
        self.validator.validate(self)
        
    }
    
    
    // MARK: - Validation delegate methods
    
    func validationSuccessful() {
        validationDidFailed = false
        
        if artist.contains(""){
            let index = artist.indexOf("")
            artist.removeAtIndex(index!)
        }
        if artist.count != 0 {
            GlobalVariables.createEventData["label"] = textCategory.text
            GlobalVariables.createEventData["artists"] = artist
        }else{
            validationDidFailed = true
            Utility.showAlert("Error", message: "All Fields are Mandatory", vc: self)
            artist.append("")
            tableArtist.reloadData()
        }
    }
    
    func validationFailed(errors: [UITextField : ValidationError]) {
        validationDidFailed = true
        Utility.showAlert("Error", message: "All Fields are Mandatory", vc: self)
        tableArtist.reloadData()
        
    }
    
    // MARK: - Keyboard Methods
    
    
    func registerKeyboardObserver(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LabelViewController.keyboardShow(_:)), name:UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LabelViewController.keyboardHide(_:)), name:UIKeyboardWillHideNotification, object: nil)
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
        
        if selectedTextField.tag > 0
        {
            self.scrollView.scrollRectToVisible(tableArtist!.frame, animated: true)
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
        if textField != textCategory{
            if textField.text?.characters.count > 0 {
                artist[textField.tag] = textField.text!
            }
        }
        selectedTextField = nil
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    
    
    // MARK: - Segue Methods
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        return !validationDidFailed
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue == "ss" {
            
        }else{
            print(artist)
        }
    }
    
    
}


//MARK: - Extension  Table View Methods

extension LabelViewController:UITableViewDataSource, UITableViewDelegate {
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        print(artist.count)
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return artist.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ArtistCell") as! ArtistTableViewCell!
        cell.textArtistName.text = artist[indexPath.row]
        cell.textArtistName.tag = indexPath.row
        cell.btnRemove.addTarget(self, action: #selector(LabelViewController.removeRow(_:)), forControlEvents:  UIControlEvents.TouchUpInside )
        cell.btnRemove.tag = indexPath.row
        if indexPath.row == 0 {
            cell.btnRemove.hidden = true
        }else{
            cell.btnRemove.hidden = false
        }
        
        cell?.selectionStyle = UITableViewCellSelectionStyle.None
        return cell
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60.0
    }
    
    func removeRow(sender: AnyObject){
        artist.removeAtIndex(sender.tag)
        tableArtist.reloadData()
    }
    
    // MARK: - Custom Methods
    
    func initializeViews(){
         if let editEvent = GlobalVariables.editEventData {
        let artist = editEvent.artists
            self.artist = (artist?.componentsSeparatedByString(", "))!
            tableArtist.reloadData()
            textCategory.text = editEvent.label!
            
         }else{
        textCategory.text = ""
        }
        validator.registerField(textCategory, rules: [RequiredRule()])
    }
    
}
