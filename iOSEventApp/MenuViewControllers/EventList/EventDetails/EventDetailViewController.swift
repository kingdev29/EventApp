//
//  EventDetailViewController.swift
//  iOSEventApp
//
//  Created by Kiran Thapa on 1/8/16.
//  Copyright © 2016 Swiss Magic. All rights reserved.
//

import UIKit
import SwiftyJSON

class EventDetailViewController: UIViewController, DeleteEventDelegate, ShowAlertViewDelegate, AcceptInvitaionInEventDelegate {
    
    // MARK: Properties
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var btnDeleteEvent: UIBarButtonItem!
    @IBOutlet weak var imgEditEvent: UIImageViewWithBorder!
    
    @IBOutlet weak var buttonViewForAdminHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var buttonViewForNewPromoterHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var buttonViewForAssignedPromoterHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerViewForAllButtonsHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var containerViewForAllButtons: UIView!
    @IBOutlet weak var containerViewForAdmin: UIView!
    @IBOutlet weak var containerViewForNewPromoter: UIView!
    @IBOutlet weak var containerViewForAssignedPromoter: UIView!
    
    var currentEvent: Event!
    var eventId:NSNumber!

    // MARK: View Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        self.loadEventDetails()
        
        // Set up Delegates
        Networking.deleteEventDelegate = self
        Networking.acceptInvitationInEventDelegate = self
        Utility.alertViewDelegate = self
        
        eventId = self.currentEvent.id!
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(EventDetailViewController.editEvent(_:)))
        imgEditEvent.userInteractionEnabled = true
        imgEditEvent.addGestureRecognizer(tapGestureRecognizer)
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 70.0
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if let userType = defaults.stringForKey(Constants.userType) {
            self.containerViewForAllButtons.layoutIfNeeded()
            if userType == Constants.administrator {
                self.presentButtonsViewForAdmin()
            } else {
                self.imgEditEvent.hidden = true
                self.btnDeleteEvent.enabled = false
                self.btnDeleteEvent.tintColor = UIColor.clearColor()
                
                let promoterStatus = currentEvent.promoter_status
                if promoterStatus == "Pending" {
                    self.presentButtonsViewForNewPromoter()
                } else{
                    self.presentButtonsViewForAssignedPromoter()
                }
            }
            self.containerViewForAllButtons.layoutIfNeeded()
        } else {
            print("User type not set")
        }
        
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.currentEvent = CoreDataAPI.sharedInstance.getEventById(eventId)
        self.loadEventDetails()
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func viewWillDisappear(animated: Bool) {
        super.viewWillAppear(animated)
        CreateEventHelper.removeBackFromNavigationButton(self)
    }
    
    
    @IBAction func acceptJob(sender: AnyObject) {
        Utility.showYesNoAlert("Bestätigung ", message: "Sind Sie sicher, dass Sie diesen Job annehmen wollen?", vc: self)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == Constants.showPromoterListFromEventDetailsView {
            let promoterListVC = segue.destinationViewController as! AssignPromoterViewController
            promoterListVC.eventId = self.currentEvent.id
            promoterListVC.eventName = self.currentEvent.name
        } else if segue.identifier == Constants.showEditEvent {
           GlobalVariables.editEventData = currentEvent
        } else if segue.identifier == Constants.showAddContactFromEventDetails {
            let addContactVC = segue.destinationViewController as! CollectEmailViewController
            addContactVC.eventId = self.currentEvent.id
        }
        
    }
    
    // MARK: Custom Methods
    @IBAction func goBack() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func addContact() {
        self.performSegueWithIdentifier(Constants.showAddContactFromEventDetails, sender: self)
    }
    
    func loadEventDetails() {
        self.nameLabel.text = self.currentEvent.name
    }
    
    func presentButtonsViewForNewPromoter() {
        self.buttonViewForAssignedPromoterHeightConstraint.constant = 0.0
        self.buttonViewForAdminHeightConstraint.constant = 0.0
        self.buttonViewForNewPromoterHeightConstraint.constant = 40.0
        
        
        self.containerViewForAssignedPromoter.hidden = true
        self.containerViewForAdmin.hidden = true
        self.containerViewForNewPromoter.hidden = false
        
        self.containerViewForAllButtonsHeightConstraint.constant = 40.0
        self.containerViewForAllButtons.backgroundColor = UIColor.clearColor()
    }
    
    func presentButtonsViewForAdmin() {
        self.buttonViewForNewPromoterHeightConstraint.constant = 0.0
        self.buttonViewForAssignedPromoterHeightConstraint.constant = 0.0
        
        self.containerViewForAssignedPromoter.hidden = true
        self.containerViewForNewPromoter.hidden = true
        
        self.containerViewForAllButtonsHeightConstraint.constant = 81.0
    }
    
    func presentButtonsViewForAssignedPromoter() {
        self.buttonViewForNewPromoterHeightConstraint.constant = 0.0
        self.buttonViewForAdminHeightConstraint.constant = 0.0
        self.buttonViewForAssignedPromoterHeightConstraint.constant = 40.0
        
        self.containerViewForAdmin.hidden = true
        self.containerViewForNewPromoter.hidden = true
        self.containerViewForAssignedPromoter.hidden = false
        
        self.containerViewForAllButtonsHeightConstraint.constant = 40.0
        self.containerViewForAllButtons.backgroundColor = UIColor.clearColor()
    }
    
    @IBAction func showDeleteAlert() {
        Utility.showYesNoAlert("", message: "Wollen Sie dieses Event wirklich löschen?", vc: self)
    }
    
    // MARK: - Table view data source
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
            return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cellIdentifier = "FirstRowTableViewCell"
            let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! FirstRowTableViewCell
            
            cell.dateLabel.text = GlobalFunctions.formatDate(self.currentEvent.start_date!)
            cell.timeLabel.text = GlobalFunctions.formatTime(self.currentEvent.start_time!) + " Uhr - " + GlobalFunctions.formatTime(self.currentEvent.end_time!) + " Uhr"
            let clubName = self.currentEvent.club
            let address = self.currentEvent.state! + ", " + self.currentEvent.area! + ", " + self.currentEvent.country!
            cell.addressLabel.text = clubName! + "\n" + address
            return cell
        } else {
            let cellIdentifier = "SecondRowTableViewCell"
            let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! SecondRowTableViewCell
            
            switch indexPath.row {
            case 1:
                cell.headingLabel.text = "MUSIKRICHTUNG"
                cell.descriptionLabel.text = self.currentEvent.genres
                cell.descriptionLabel.sizeToFit()
                break
            case 2:
                cell.headingLabel.text = "ARTIST"
                cell.descriptionLabel.text = self.currentEvent.artists
                break
            case 3:
                cell.headingLabel.text = "ALTER"
                cell.descriptionLabel.text = self.currentEvent.min_age! + "+"
                break
            case 4:
                cell.headingLabel.text = "PREIS"
                cell.descriptionLabel.text = self.currentEvent.entrance_fee! + " CHF"
                break
            case 5:
                cell.headingLabel.text = "FEATURES"
                cell.descriptionLabel.text = self.currentEvent.features
                break
            default:
                cell.headingLabel.text = "MITARBEITER"
                cell.descriptionLabel.text = self.currentEvent.active_promoter_count
            }
            return cell
        }
        
        
    }
    
       // MARK: - Custom Methods
    
    func editEvent(sender:AnyObject){
        print("show create event")
        self.performSegueWithIdentifier("showEditEvent", sender: self)
        
        //let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        //let vc : UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier("createEvent") as UIViewController
        //self.presentViewController(vc, animated: true, completion: nil)
    }
    
    // MARK: AlertView Delegate
    
    func alertViewDidTapped(didTappedYes: Bool) {
        if didTappedYes {
            
            let defaults = NSUserDefaults.standardUserDefaults()
            
            if let userType = defaults.stringForKey(Constants.userType) {
                 if userType == Constants.administrator {
                    Networking.deleteEvent(self.currentEvent.id!)
                 }else{
                    Networking.acceptEventInvitationByPromoter(self.currentEvent.id!)
                }
            }
           
        }
    }
    

    // MARK: Delete Event Delegate
    func deleteEventDidSucceed(data: JSON) {
        let statusCode = data["status_code"].int
        if statusCode == 200 {
            CoreDataAPI.sharedInstance.deleteEvent(self.currentEvent.id!)
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    func deleteEventDidFail(error: NSError) {
        Utility.showAlert("Error", message: error.localizedDescription, vc: self)
    }
    
    // MARK: - Invitation Accept By Promoter delegate
    func acceptInvitaionInEventDidFail(error: NSError) {
        Utility.showAlert("Error", message: error.localizedDescription , vc: self)
    }
    
    func acceptInvitaionInEventDidSucceed(data: JSON) {
        let statusCode = data["status_code"].int
        if statusCode == 200 {
            Utility.showAlert("Erfolg", message: "Sie haben die Einladung akzeptiert.", vc: self)
            let eventData = data["data"].array
            CoreDataAPI.sharedInstance.updateEvent(eventData![0]["event_id"].number!, promoterStatus: eventData![0]["status"].string!)
            self.presentButtonsViewForAssignedPromoter()
        }else{
             Utility.showAlert("Error", message: "Invitation couldnot be Accepted at this moment.", vc: self)
        }

    }
    
}
