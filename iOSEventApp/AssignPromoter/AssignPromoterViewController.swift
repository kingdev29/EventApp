//
//  AssignPromoterViewController.swift
//  iOSEventApp
//
//  Created by sunil maharjan on 2/25/16.
//  Copyright © 2016 Swiss Magic. All rights reserved.
//

import UIKit
import SwiftyJSON
import PKHUD
class AssignPromoterViewController: UIViewController {
    
    // MARK: - Properties
    @IBOutlet weak var tablePromoter: UITableView!
    @IBOutlet weak var lblPromoterCount: UILabel!
    @IBOutlet weak var lblEventname: UILabel!
    
    var selectedPromoterList:[Int] = []
    var promoterList:[String] = []
    var statusList:[String] = []
    var promoters:[JSON] = []
    var eventId: NSNumber!
    var eventName: String!

    
    // MARK: - View Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "PROMOTER ZUWEISEN"
        
        Networking.getMyPromotersDelegate = self
        Networking.assignPromotersToEventDelegate = self
        
        PKHUD.sharedHUD.contentView = PKHUDProgressView()
        PKHUD.sharedHUD.show()
        
        Networking.getMyPromoters(self.eventId)
        lblPromoterCount.text = "(\(selectedPromoterList.count))"
        lblEventname.text = eventName
       
    }
    
    @IBAction func btnAssign(sender: AnyObject) {
        PKHUD.sharedHUD.contentView = PKHUDProgressView()
        PKHUD.sharedHUD.show()
        Networking.assignPromotersToEvent(selectedPromoterList, eventId: self.eventId)
    }
}


// MARK: - TableView DataSource Methods

extension AssignPromoterViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return promoterList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PromoterCell") as! PromoterTableViewCell!
        let obj = promoters[indexPath.row]
        let promoterId = obj["id"].int!
       // let promoterStaus = obj["event_status"].string!
        //print("selectedpromoterlist=\(selectedPromoterList)")
        //print("indexpathrow=\(promoterId)")
        // Create full length cell separator without indent
        if selectedPromoterList.contains(promoterId){
            cell.imgSelection.image = UIImage(named: "BlueTick")
            
        }else{
            cell.imgSelection.image = UIImage(named: "BlueNoTick")
        }
        
        let promoterStatus = statusList[indexPath.row]
        if promoterStatus == "Pending"{
             //cell.imgSelection.image = UIImage(named: "BlueTick")
            cell.imgPersonal.image = UIImage(named: "ProfileEmpty")
        }else if promoterStatus == "Accepted"{
           // cell.imgSelection.image = UIImage(named: "BlueTick")
            cell.imgPersonal.image = UIImage(named: "ProfileStar")
        }else if promoterStatus == "none" {
           // cell.imgSelection.image = UIImage(named: "BlueNoTick")
            cell.imgPersonal.image = UIImage(named: "ProfileEmpty")
        }
        
        cell.labelName.text = promoterList[indexPath.row]
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsetsZero
        cell.layoutMargins = UIEdgeInsetsZero
        cell.selectionStyle = .None
        return cell
    }
}

// MARK: - TableView Delegate Methods
extension AssignPromoterViewController: UITableViewDelegate{
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let mySelectedPromoter : PromoterTableViewCell = tableView.cellForRowAtIndexPath(indexPath)! as! PromoterTableViewCell
        
        let obj = promoters[indexPath.row]
        let promoterId = obj["id"].int!
        
        if selectedPromoterList.contains(promoterId){
            let index = selectedPromoterList.indexOf(promoterId)
            selectedPromoterList.removeAtIndex(index!)
            mySelectedPromoter.imgSelection.image = UIImage(named: "BlueNoTick")
        }else{
            selectedPromoterList.append(promoterId)
            mySelectedPromoter.imgSelection.image = UIImage(named: "BlueTick")
        }
        lblPromoterCount.text = "(\(selectedPromoterList.count ))"
    }
}

// MARK: - Network Delegate methods
extension AssignPromoterViewController:GetMyPromotersDelegate {
    
    func getMyPromotersDidSucceed(data: JSON) {
        PKHUD.sharedHUD.hide(animated: false)
        let statusCode = data["status_code"].int
        if statusCode == 200 {
        promoters = data["data"].array!
            
            if promoters.count > 0 {
                for i in 0 ... (promoters.count) - 1 {
                    let obj = promoters[i].dictionary!
                    //print(obj)
                    let fullName = obj["full_name"]?.string
                    let promoterStatus = obj["event_status"]?.string
                    let promoterId = obj["id"]!.int!
                    if promoterStatus == "Accepted" || promoterStatus == "Pending"{
                        selectedPromoterList.append(promoterId)
                  //  alreadyInvitedPromoters += 1
                    }
                    self.promoterList.append(fullName!)
                    self.statusList.append(promoterStatus!)
                }
                lblPromoterCount.text = "(\(selectedPromoterList.count))"
            }else{
                Utility.showAlert("Error", message: "No Promoter Found", vc: self)
            }
            promoterList.sortInPlace { $0 < $1 }
            tablePromoter.dataSource = self
            tablePromoter.delegate = self
            tablePromoter.reloadData()
        }else{
            let errorMessage = data["message"].string!
            Utility.showAlert("Error", message: errorMessage, vc: self)
        }
    }
    
    func getMyPromotersDidFail(error: NSError) {
        PKHUD.sharedHUD.hide(animated: false)
        print(error)
    }
}

// MARK: - AssignPromoterToEventDelegate Methods

extension AssignPromoterViewController:AssignPromotersToEventDelegate{
    
    func AssignPromotersToEventDidSucceed(data: JSON) {
        PKHUD.sharedHUD.hide(animated: false)
        let statusCode = data["status_code"].int
        if statusCode == 200 {
        Utility.showAlert("Einladung verschickt.", message: "Einladung wurde an ausgewählte Promoter verschickt.", vc: self)
        }
    }
    
    func AssignPromotersToEventDidFail(error: NSError) {
         PKHUD.sharedHUD.hide(animated: false)
    }
}