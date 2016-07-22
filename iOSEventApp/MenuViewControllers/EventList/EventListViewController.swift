//
//  CenterViewController.swift
//  SlideOutNavigation
//
//  Created by sunil maharjan on 12/28/15.
//  Copyright © 2015 Sunil Maharjan. All rights reserved.
//

import UIKit
import SwiftyJSON
class EventListViewController: UIViewController, EventListTableViewCellDelegate, GetAllEventsDelegate, ShowAlertViewDelegate, AcceptInvitaionInEventDelegate{
    
    // MARK: Properties
    @IBOutlet weak var tableView: UITableView!
    
    var refreshControl : UIRefreshControl!
    var events = [Event]()
    var selectedEvent: Event!

    var firstLoad: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Hide "Create Event" button for promoter
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if defaults.stringForKey(Constants.userType) == Constants.promoter {
            let searchEventButton = UIBarButtonItem(barButtonSystemItem: .Search, target: self, action: #selector(EventListViewController.searchEvents))
            self.navigationItem.rightBarButtonItem = searchEventButton
        } else {
            let searchEventButton = UIBarButtonItem(barButtonSystemItem: .Search, target: self, action: #selector(EventListViewController.searchEvents))
            let addEventButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(EventListViewController.createEvent))
            self.navigationItem.rightBarButtonItems = [searchEventButton, addEventButton]
        }
        
        // Set var for detecing first load
        self.firstLoad = true
        
        // Set up Table View
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        self.tableView.backgroundColor = UIColor.clearColor()
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 200.0
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.addTarget(self, action: #selector(EventListViewController.refreshEventList), forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshControl)
        
        // Set up Delegates
        Networking.getAllEventsDelegate = self
        Networking.acceptInvitationInEventDelegate = self
        
        
        // Load events from core datas
        self.loadEvents()
        
        // Refresh event list
        self.refreshEventList()
        
    }
    
    // MARK: View Methods
    override func viewWillDisappear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.firstLoad = false
        CreateEventHelper.removeBackFromNavigationButton(self)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        Utility.alertViewDelegate = self
        
        if firstLoad != nil && firstLoad == false {
            self.refreshEventList()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // MARK: Custom Methods
    func createEvent() {
        GlobalVariables.editEventData = nil
        self.performSegueWithIdentifier(Constants.showCreateEventFromList, sender: self)
    }
    
    @IBAction func showMenu() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func loadEvents() {
        self.events = CoreDataAPI.sharedInstance.getEvents()
    }
    
    func refreshEventList() {
        print("refreshing events")
        if CoreDataAPI.sharedInstance.getEvents().count > 0 {
            let defaults = NSUserDefaults.standardUserDefaults()
            if let maxUpdateDate = defaults.stringForKey(Constants.eventMaxUpdatedDate) {
                Networking.getAllEvent(maxUpdateDate)
            }
        } else {
            Networking.getAllEvent("0")
        }
    }
    
    func searchEvents(){
        print("Search Code")
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
        return events.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "EventListTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! EventListTableViewCell
        
        let event = events[indexPath.row]
        
        // Set cell with data
        cell.delegate = self
        cell.loadCell(withEvent: event)
        
        // Create full length cell separator without indent
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsetsZero
        cell.layoutMargins = UIEdgeInsetsZero
        
        return cell
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == Constants.showEventDetails {
            let eventDetailsVC = segue.destinationViewController as! EventDetailViewController
            eventDetailsVC.currentEvent = self.selectedEvent
        } else if segue.identifier == Constants.showPromoterListFromEventListView {
            let promoterListVC = segue.destinationViewController as! AssignPromoterViewController
            promoterListVC.eventId = self.selectedEvent.id
            promoterListVC.eventName = self.selectedEvent.name
        } else if segue.identifier == Constants.showAddContactFromEventList {
            let addContactVC = segue.destinationViewController as! CollectEmailViewController
            addContactVC.eventId = self.selectedEvent.id
        } else if segue.identifier == Constants.showEmailInvitation {
            let emailInvitationVC = segue.destinationViewController as! TemplateSelectionViewController
            emailInvitationVC.currentEvent = self.selectedEvent
        } else if segue.identifier == Constants.showQRCodeFromEventList {
            let qrCodeScannerVC = segue.destinationViewController as! QRCodeScannerViewController
            qrCodeScannerVC.eventId = self.selectedEvent.id
        }

        
    }
    
    
    func alertViewDidTapped(didTappedYes: Bool) {
        if didTappedYes {
            Networking.acceptEventInvitationByPromoter(self.selectedEvent.id!)
        }
    }
    
    
    func acceptInvitaionInEventDidFail(error: NSError) {
        Utility.showAlert("Error", message: error.localizedDescription, vc: self)
    }
    
    func acceptInvitaionInEventDidSucceed(data: JSON) {
        let statusCode = data["status_code"].int
        if statusCode == 200 {
            Utility.showAlert("Erfolg", message: "Sie haben die Einladung akzeptiert.", vc: self)
            let eventData = data["data"].array
            CoreDataAPI.sharedInstance.updateEvent(eventData![0]["event_id"].number!, promoterStatus: eventData![0]["status"].string!)
            self.loadEvents()
            self.tableView.reloadData()
        }else{
             Utility.showAlert("Error", message: "Invitation couldnot be Accepted at this moment.", vc: self)
        }
    }
    
    // MARK: - EventListTableViewCellDelegate Methods
    func showEventDetails(cell: EventListTableViewCell) {
        self.selectedEvent = cell.event
        self.performSegueWithIdentifier(Constants.showEventDetails, sender: self)
    }
    
    
    func acceptJobForEvent(cell: EventListTableViewCell) {
        self.selectedEvent = cell.event
        Utility.showYesNoAlert("Bestätigung ", message: "Sind Sie sicher, dass Sie diesen Job annehmen wollen?", vc: self)
    }
    
    func showPromoterList(cell: EventListTableViewCell) {
        self.selectedEvent = cell.event
        self.performSegueWithIdentifier(Constants.showPromoterListFromEventListView, sender: self)
    }
    
    func showEmailInvitation(cell: EventListTableViewCell) {
        self.selectedEvent = cell.event
        self.performSegueWithIdentifier(Constants.showEmailInvitation, sender: self)
    }
    
    func showAddContactView(cell: EventListTableViewCell) {
        self.selectedEvent = cell.event
        self.performSegueWithIdentifier(Constants.showAddContactFromEventList, sender: self)
    }
    
    func showQRCodeView(cell: EventListTableViewCell) {
        self.selectedEvent = cell.event
        self.performSegueWithIdentifier(Constants.showQRCodeFromEventList, sender: self)
    }
    
    // MARK: - GetAllEvents Delegate methods
    
    func getAllEventDidFail(error: NSError) {
        if self.refreshControl.refreshing{
            self.refreshControl.endRefreshing()
        }
        
        Utility.showAlert("Error", message: error.localizedDescription, vc: self)
    }
    
    func getAllEventDidSucceed(data: JSON) {
        if self.refreshControl.refreshing{
            self.refreshControl.endRefreshing()
        }
        
        let statusCode = data["status_code"].int
        if statusCode == 200 {
            CoreDataAPI.sharedInstance.saveEvent(data)
            self.events = CoreDataAPI.sharedInstance.getEvents()
            self.tableView.reloadData()
        }
        
        
    }
}










