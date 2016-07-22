//
//  FeaturesViewController.swift
//  iOSEventApp
//
//  Created by sunil maharjan on 1/6/16.
//  Copyright © 2016 Swiss Magic. All rights reserved.
//

import UIKit
import SwiftyJSON
import PKHUD

class FeaturesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, AddEventDelegate {
   
    // MARK: - Properties
    
    var selectedFeatureItems:[Int]=[]
    var arrFeatureItems:[String] = ["Gratis Shot","Gratis Bier","Gratis Cüpli","Gratis Drink","Gratis Garderobe","Gratis +1 Person"]
    
    @IBOutlet weak var tblItem: UITableView!
    @IBOutlet weak var btnCreateEventDone: UIButton!
    
    // MARK: - View Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CreateEventHelper.removeBackFromNavigationButton(self)
         Networking.addEventDelegate = self
     //  arrFeatureItems.sortInPlace{ $0 < $1 }
         if let editEvent = GlobalVariables.editEventData {
            if editEvent.features != nil {
            let features = editEvent.features!
            let featureLists = features.componentsSeparatedByString(", ")
            print(featureLists)
            print(arrFeatureItems)
            for i in 0...arrFeatureItems.count - 1 {
                
                if featureLists.contains(arrFeatureItems[i]){
                    selectedFeatureItems.append(i+1)
                }
                
            }
            tblItem.reloadData()
        
        }
        }
        
        tblItem.dataSource = self
        tblItem.delegate = self
        
        print(GlobalVariables.priceStaffelung)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if let features = GlobalVariables.createEventData["features"] as? [Int]{
           selectedFeatureItems = features
            tblItem.reloadData()
            
        }

    }
    
    @IBAction func btnCreateEventDoneClick(sender: AnyObject) {
        
        PKHUD.sharedHUD.contentView = PKHUDProgressView()
        PKHUD.sharedHUD.show()
       
        GlobalVariables.createEventData["features"] = selectedFeatureItems
        if let editEvent = GlobalVariables.editEventData{
            print("Update bhayo")
            Networking.addEvent(GlobalVariables.createEventData, eventPrices: GlobalVariables.priceStaffelung,eventId: editEvent.id)
            
        }else{
             print("Create bhayo")
        Networking.addEvent(GlobalVariables.createEventData, eventPrices: GlobalVariables.priceStaffelung,eventId: nil)
           
        }
    }
    
    // MARK: - Segue Methods
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "createEvent" {
            GlobalVariables.editEventData = nil
            print("yessss")
        }
    }
    
    // MARK: - Table Methods
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrFeatureItems.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CreateEventItemCell")!
        let imageUnchecked  = UIImageView(frame:CGRectMake(20, 20, 20, 20))
        imageUnchecked.layer.masksToBounds = true
        imageUnchecked.layer.borderColor = UIColor.whiteColor().CGColor
        imageUnchecked.layer.borderWidth = 1
        
        let imageChecked : UIImageView
        imageChecked  = UIImageView(frame:CGRectMake(20, 20, 20, 20))
        imageChecked.image = UIImage(named:"GenreChecked")
        
        if selectedFeatureItems.contains(indexPath.row + 1){
            cell.textLabel?.font = UIFont.boldSystemFontOfSize(15.0)
            cell.accessoryView = imageChecked
            
        }else
        {
            cell.textLabel?.font = UIFont.systemFontOfSize(14.0)
            cell.accessoryView = imageUnchecked
        }
        cell.selectionStyle = .None
        cell.textLabel?.textColor = UIColor.whiteColor()
        cell.textLabel?.text = arrFeatureItems[indexPath.row]
        return cell
        
    }
    
    func tableView(tableView: UITableView, didHighlightRowAtIndexPath indexPath: NSIndexPath) {
        let mySelectedCell:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        mySelectedCell.contentView.backgroundColor = UIColor.clearColor()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
      
        let mySelectedCell:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        let imageUnchecked  = UIImageView(frame:CGRectMake(20, 20, 20, 20))
        imageUnchecked.layer.masksToBounds = true
        imageUnchecked.layer.borderColor = UIColor.whiteColor().CGColor
        imageUnchecked.layer.borderWidth = 1
        
        let imageChecked : UIImageView
        imageChecked  = UIImageView(frame:CGRectMake(20, 20, 20, 20))
        imageChecked.image = UIImage(named:"GenreChecked")
        
     
        if selectedFeatureItems.contains(indexPath.row + 1){
            let index = selectedFeatureItems.indexOf(indexPath.row+1)
            selectedFeatureItems.removeAtIndex(index!)
            mySelectedCell.accessoryView = imageUnchecked
            tableView.cellForRowAtIndexPath(indexPath)?.textLabel?.font = UIFont.systemFontOfSize(14)
        }else
        {
            
           selectedFeatureItems.append(indexPath.row+1)
            mySelectedCell.accessoryView = imageChecked
              tableView.cellForRowAtIndexPath(indexPath)?.textLabel?.font = UIFont.boldSystemFontOfSize(15)
            
        }
         GlobalVariables.createEventData["features"] = selectedFeatureItems        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 40.0
    }
    
       
// MARK: - Create Event delegate Methods
    
    func addEventDidFail(error: NSError) {
        PKHUD.sharedHUD.hide(animated: false)
        if error.code == -1003
        {
            Utility.showAlert("Error", message: "Your internet does not seem to be working.", vc: self)
        }else{
            Utility.showAlert("Error", message: error.localizedDescription, vc: self)
        }
 
        
    }
    
    
    func addEventDidSucceed(data: JSON) {
        PKHUD.sharedHUD.hide(animated: false)
        let statusCode = data["status_code"].int
        if statusCode == 200 {
            CoreDataAPI.sharedInstance.saveEvent(data)
            Utility.showAlertWithDismissVC("Erfolg", message: "Event erfolgreich hinzugefügt", vc: self)
        }
    }
}
