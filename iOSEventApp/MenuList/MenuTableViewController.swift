//
//  MenuTableViewController.swift
//  iOSEventApp
//
//  Created by Kiran Thapa on 1/11/16.
//  Copyright © 2016 Swiss Magic. All rights reserved.
//

import UIKit

enum MenuItems: Int {
    case EventOverview = 0, Labels, CreateEvent, EmailTemplate, AddressList, Logout, Count
}

class MenuTableViewController: UITableViewController {
    
    // MARK: Properties
    @IBOutlet weak var eventListTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imageView = UIImageView(frame: self.view.frame)
        let image = UIImage(named: "EventListBg")!
        imageView.image = image
        self.view.addSubview(imageView)
        self.view.sendSubviewToBack(imageView)
        
        self.eventListTableView.tableFooterView = UIView(frame: CGRectZero)
        self.eventListTableView.backgroundColor = UIColor.clearColor()
        
        navigationController!.navigationBar.barTintColor = Constants.navigationBarTintColor
        navigationController!.navigationBar.tintColor = UIColor.whiteColor()
        navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let eventListViewController: EventListViewController = storyboard.instantiateViewControllerWithIdentifier("EventListViewController")as! EventListViewController
        self.navigationController?.pushViewController(eventListViewController, animated: false)
        
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        CreateEventHelper.removeBackFromNavigationButton(self)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let defaults = NSUserDefaults.standardUserDefaults()
        if defaults.stringForKey(Constants.userType) == Constants.promoter {
            if indexPath.row == MenuItems.EventOverview.rawValue || indexPath.row == MenuItems.Logout.rawValue {
                return 50.0
            } else {
                return 0.0
            }
        }
        return 50.0
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return MenuItems.Count.rawValue
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        switch indexPath.row {
        case MenuItems.EventOverview.rawValue:
            self.performSegueWithIdentifier(Constants.showEventList, sender: self)
            break
        case MenuItems.Labels.rawValue:
            self.performSegueWithIdentifier(Constants.showLabelListing, sender: self)
            break
        case MenuItems.CreateEvent.rawValue:
            self.performSegueWithIdentifier(Constants.showCreateEvent, sender: self)
            break
        case MenuItems.AddressList.rawValue:
            self.performSegueWithIdentifier(Constants.showContactList, sender: self)
            break
        case MenuItems.Logout.rawValue:
            self.cleanUpStoredData()
            self.dismissViewControllerAnimated(true, completion: nil)
            break
        default:
            Utility.showAlert("Sorry", message: "This feature is not available right now.", vc: self)
        }
    }

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == Constants.showCreateEvent {
            GlobalVariables.editEventData = nil
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    func cleanUpStoredData() {
        // Delete all events
        CoreDataAPI.sharedInstance.deleteAllEvents()
        
        // Delete stored keys
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.removeObjectForKey(Constants.authToken)
        defaults.removeObjectForKey(Constants.userType)
        defaults.synchronize()

    }
    

}
