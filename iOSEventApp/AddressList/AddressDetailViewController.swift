//
//  AddressDetailViewController.swift
//  iOSEventApp
//
//  Created by sunil maharjan on 1/28/16.
//  Copyright © 2016 Swiss Magic. All rights reserved.
//

import UIKit
import SwiftyJSON
import PKHUD

class AddressDetailViewController: UIViewController, ShowAlertViewDelegate,ShowAlertViewPopVCDelegate, DeleteContactDelegate {
    // MARK: - Properties
    var detailAddress:JSON!
    
    @IBOutlet weak var labelFullName: UILabel!
    @IBOutlet weak var labelEmail: UILabel!
    @IBOutlet weak var labelTelephone: UILabel!
    @IBOutlet weak var labelAlter: UILabel!
    @IBOutlet weak var labelCategory: UILabel!
    
    // MARK: - View methods
    override func viewDidLoad() {
        super.viewDidLoad()
         Networking.deleteContact = self
        populateData()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        Utility.alertViewDelegate = self
        Utility.alertViewPopVCDelegate = self
    }

    
    @IBAction func deleteContact(sender: AnyObject) {
         Utility.showYesNoAlert("", message: "Do you want to delete this contact?", vc: self)
    }
    
    // MARK: - DeleteContact Delegate methods
    
    func deleteContactDidSucceed(data: JSON) {
        PKHUD.sharedHUD.hide(animated: false)
        let statusCode = data["status_code"].int!
        let message = data["message"].string!
        if statusCode == 200 {
           // Utility.showAlert("Success", message: "Contact deleted successfully", vc: self)
            Utility.showAlertWithPopVC("Success", message: "Contact deleted successfully", vc: self)
        }else{
            Utility.showAlert("Error", message: message, vc: self)
        }
    }
    
    func deleteContactDidFail(error: NSError) {
        PKHUD.sharedHUD.hide(animated: false)
        if error.code == -1003
        {
            Utility.showAlert("Error", message: "Your internet does not seem to be working.", vc: self)
        }else{
            Utility.showAlert("Error", message: error.localizedDescription, vc: self)
        }
        
    }
    
    // MARK: - AlertViewPopVCDelegate methods
    
    func alertViewPopVCDidTapped() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    // MARK: - AlertViewDelegate methods
    
    func alertViewDidTapped(didTappedYes: Bool) {
        if didTappedYes{
            PKHUD.sharedHUD.show()
            Networking.deleteContact(detailAddress["id"].int!)
        }else{
            print("tapped no")
        }
    }
    
    // MARK: - Segue Methods
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == Constants.showEditContact {
            let editContactVC = segue.destinationViewController as! CollectEmailViewController
            editContactVC.currentContact = detailAddress
        }
    }

    // MARK: - Custom Methods
    func populateData(){
        let email = detailAddress["email"].string
        let firstName = detailAddress["first_name"].string!
        let lastName = detailAddress["last_name"].string!
        let dob = detailAddress["dob"].string!
        let phone = detailAddress["phone"].string!
        labelFullName.text = "\(firstName) \(lastName)"
        labelEmail.text = email
        labelTelephone.text = phone
        labelAlter.text =  "\(calculateAge(dob))"
        //labelAlter.text = (dob == "") ? "0" : "\(calculateAge(dob))"
    }
    
    func calculateAge (strBirthday: String) -> Int {
        let df = NSDateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        if let birthday = df.dateFromString(strBirthday){
            let age = NSCalendar.currentCalendar().components(.Year, fromDate: birthday, toDate: NSDate(), options: []).year
            return (age > 0 ? age : 0) }
        else {
            return 0
        }
    }
    
}
