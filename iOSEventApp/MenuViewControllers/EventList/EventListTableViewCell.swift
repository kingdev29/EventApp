//
//  EventListTableViewCell.swift
//  iOSEventApp
//
//  Created by Kiran Thapa on 1/6/16.
//  Copyright © 2016 Swiss Magic. All rights reserved.
//

import UIKit

protocol EventListTableViewCellDelegate {
    func showEventDetails(cell: EventListTableViewCell)
    func acceptJobForEvent(cell: EventListTableViewCell)
    func showPromoterList(cell: EventListTableViewCell)
    func showAddContactView(cell: EventListTableViewCell)
    func showEmailInvitation(cell: EventListTableViewCell)
    func showQRCodeView(cell: EventListTableViewCell)
}

class EventListTableViewCell: UITableViewCell {
    // MARK: Properties
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var clubLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var btnShowEventDetailsForAdmin: UIButton!
    @IBOutlet weak var btnShowEventDetailsForPromoter: UIButton!
    @IBOutlet weak var btnQrCode: UIButton!
    @IBOutlet weak var btnShowAddGuestView: UIButton!
    @IBOutlet weak var btnShowSendInviteView: UIButton!
    @IBOutlet weak var btnShowAssignPromoterView: UIButton!
    @IBOutlet weak var btnAcceptJob: UIButton!
    
    @IBOutlet weak var buttonViewForAdminHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var buttonViewForNewPromoterHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var buttonViewForAssignedPromoterHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var containerViewForButtons: UIView!
    @IBOutlet weak var containerViewForAdmin: UIView!
    @IBOutlet weak var containerViewForNewPromoter: UIView!
    @IBOutlet weak var containerViewForAssignedPromoter: UIView!
    
    
    var delegate: EventListTableViewCellDelegate?
    var event: Event!
    
    // MARK: View methods
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    // MARK: Custom Methods
    
    func loadCell(withEvent event: Event) {
        self.event = event
        
        if self.event != nil {
            self.nameLabel.text = event.name
            self.dateLabel.text = GlobalFunctions.formatDate(event.start_date!)
            self.clubLabel.text = event.club
            self.addressLabel.text = event.state! + ", " + event.area! + ", " + event.country!
            
            let defaults = NSUserDefaults.standardUserDefaults()
            
            if let userType = defaults.stringForKey(Constants.userType) {
                self.containerViewForButtons .layoutIfNeeded()
                if userType == Constants.administrator {
                    self.presentButtonsViewForAdmin()
                } else {
                    let promoterStatus = event.promoter_status
                    if promoterStatus == "Pending" {
                        self.presentButtonsViewForNewPromoter()
                    } else{
                        self.presentButtonsViewForAssignedPromoter()
                    }
                }
                self.containerViewForButtons.layoutIfNeeded()
            } else {
                print("token not set")
            }
        }
    }
    
    @IBAction func showEventDetailsButtonTapped(sender: AnyObject) {
        delegate?.showEventDetails(self)
    }
    
    @IBAction func showPromoterListButtonTapped(sender: AnyObject) {
        delegate?.showPromoterList(self)
    }
    
    @IBAction func showEmailInvitation(sender: AnyObject) {
        delegate?.showEmailInvitation(self)
    }
    
    @IBAction func acceptJobForEvent(sender: AnyObject) {
        delegate?.acceptJobForEvent(self)
    }
    
    @IBAction func showAddContactView(sender: AnyObject) {
        delegate?.showAddContactView(self)
    }
    
    @IBAction func showQRCodeView(sender: AnyObject) {
        delegate?.showQRCodeView(self)
    }
    
    func presentButtonsViewForNewPromoter () {
        self.buttonViewForAssignedPromoterHeightConstraint.constant = 0.0
        self.buttonViewForAdminHeightConstraint.constant = 0.0
        self.buttonViewForNewPromoterHeightConstraint.constant = 40.0
        
        self.containerViewForAssignedPromoter.hidden = true
        self.containerViewForAdmin.hidden = true
        self.containerViewForNewPromoter.hidden = false
        
        self.containerViewForButtons.backgroundColor = UIColor.clearColor()
    }
    
    func presentButtonsViewForAdmin () {
        self.buttonViewForNewPromoterHeightConstraint.constant = 0.0
        self.containerViewForNewPromoter.hidden = true
    }
    
    func presentButtonsViewForAssignedPromoter () {
        self.buttonViewForNewPromoterHeightConstraint.constant = 0.0
        self.buttonViewForAdminHeightConstraint.constant = 0.0
        self.buttonViewForAssignedPromoterHeightConstraint.constant = 40.0
        
        self.containerViewForAdmin.hidden = true
        self.containerViewForNewPromoter.hidden = true
        self.containerViewForAssignedPromoter.hidden = false
        
        self.containerViewForButtons.backgroundColor = UIColor.clearColor()
    }
    
}








