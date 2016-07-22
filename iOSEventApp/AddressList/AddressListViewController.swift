//
//  AddressListViewController.swift
//  iOSEventApp
//
//  Created by sunil maharjan on 1/26/16.
//  Copyright © 2016 Swiss Magic. All rights reserved.
//

import UIKit
import SwiftyJSON
import PKHUD

class AddressListViewController: UIViewController,ShowAddressListDelegate, UITableViewDataSource , UITableViewDelegate, UISearchBarDelegate{
    
    // MARK: - Properties
    @IBOutlet weak var tableAddress : UITableView!
    @IBOutlet weak var searchContact : UISearchBar!
    
    var refreshControl : UIRefreshControl!
    var is_searching = false
    var contactsDictionary = Dictionary<String, Array<JSON>>()
    var contactSectionTitles : [String] = []
    var jsonSearchedContact = [JSON]()
    var jsonContacts = [JSON]()
    var finalContacts = [JSON]()
    var searchedContacts : JSON!
    
    //MARK: - View Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        tableAddress.opaque = false
        tableAddress.backgroundView = nil;
        tableAddress.separatorStyle = UITableViewCellSeparatorStyle.None
        
        let textFieldInsideSearchBar = searchContact.valueForKey("searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = UIColor.whiteColor()
        searchContact.returnKeyType = UIReturnKeyType.Done
        searchContact.delegate = self
        
        PKHUD.sharedHUD.contentView = PKHUDProgressView()
        PKHUD.sharedHUD.show()
        
        Networking.addressDelegate = self
        Networking.getAllAddress()
        
        self.refreshControl=UIRefreshControl()
        self.refreshControl.addTarget(self, action: #selector(AddressListViewController.pullToRefresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        tableAddress.addSubview(refreshControl)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        CreateEventHelper.removeBackFromNavigationButton(self)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        PKHUD.sharedHUD.show()
        Networking.getAllAddress()
        tableAddress.reloadData()
    }
    
    // MARK: - Networking Api Call
    
    func showAddressDidFailed(error: NSError) {
        if self.refreshControl.refreshing{
            self.refreshControl.endRefreshing()
        }
        PKHUD.sharedHUD.hide(animated: false)
        if error.code == -1003
        {
            Utility.showAlert("Error", message: "Your internet does not seem to be working.", vc: self)
        }else{
            Utility.showAlert("Error", message: error.localizedDescription, vc: self)
        }
    }
    
    func showAddressDidSucceed(data: JSON) {
        if self.refreshControl.refreshing{
            self.refreshControl.endRefreshing()
        }
        PKHUD.sharedHUD.hide(animated: false)
        let statusCode = data["status_code"].int
        if statusCode == 200{
            finalContacts.removeAll()
            let  jsonContactsFromApi = data["data"]
            if jsonContactsFromApi.count != 0 {
                for index in 0...jsonContactsFromApi.count - 1 {
                    finalContacts.append(jsonContactsFromApi[index])
                }
                jsonContacts = finalContacts
                searchContact.delegate = self
                
                tableAddress.delegate = self
                tableAddress.dataSource = self
                tableAddress.reloadData()
            } else {
                Utility.showAlert("", message: "No entries to display. ", vc: self)
            }
        } else {
            Utility.showAlert("Error", message: data["message"].string!, vc: self)
        }
    }
    
    // MARK: - Search Bar  Methods
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String){
        jsonSearchedContact.removeAll()
        if(searchBar.text!.isEmpty){
            is_searching = false
            finalContacts = jsonContacts
        }else{
            is_searching = true
            for index in 0...jsonContacts.count - 1 {
                let contactFirstName = jsonContacts[index]["first_name"].string!
                let contactLastName = jsonContacts[index]["last_name"].string!
                if (contactFirstName.lowercaseString.rangeOfString(searchText.lowercaseString) != nil) ||  (contactLastName.lowercaseString.rangeOfString(searchText.lowercaseString) != nil)   {
                    jsonSearchedContact.append(jsonContacts[index])
                }
            }
            finalContacts = jsonSearchedContact
        }
        tableAddress.reloadData()
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        self.view.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        self.view.endEditing(true)
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        self.view.endEditing(true)
    }
    
    //MARK: - Table View Methods
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        tableAddress.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
        if is_searching{
            finalContacts = jsonSearchedContact
        }else{
            finalContacts = jsonContacts
        }
        prepareContactsDictionary(finalContacts)
        return contactSectionTitles.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let contactNamePrefixAsKey = self.contactSectionTitles[section]
        guard let validContactArrayForKey = self.contactsDictionary[contactNamePrefixAsKey] else { return 0 }
        return validContactArrayForKey.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("AddressCell")!
        let contactNamePrefixAsKeu = self.contactSectionTitles[indexPath.section]
        guard let validContactArrayForKey = self.contactsDictionary[contactNamePrefixAsKeu] else { return cell }
        let cc = validContactArrayForKey[indexPath.row]
        cell.textLabel?.text = "\(cc["first_name"].string!) \(cc["last_name"].string!)"
        cell.textLabel?.textColor = UIColor.whiteColor()
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        return cell
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.contactSectionTitles[section]
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.view.endEditing(true)
        self.performSegueWithIdentifier(Constants.showContactDetails, sender: indexPath)
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame:CGRectMake(0, 0, tableView.bounds.size.width, 25))
        headerView.backgroundColor = UIColor.clearColor()
        let label = UILabel(frame:CGRectMake(5, 0, tableView.bounds.size.width, 20))
        label.text = "  \(self.contactSectionTitles[section])"
        label.textColor = UIColor.whiteColor()
        label.backgroundColor = UIColor(red: 26/255, green: 48/255, blue: 69/255, alpha: 1.0)
        headerView.addSubview(label)
        return headerView
    }
    
    func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
        return self.contactSectionTitles
    }
    
    func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int {
        guard let validIndex = self.contactSectionTitles.indexOf(title) else { return -1 }
        return validIndex
    }
    
    // MARK: - Segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == Constants.showContactDetails) {
            let controller = segue.destinationViewController as!  AddressDetailViewController
            let row = (sender as! NSIndexPath).row
            let contactNamePrefixAsKeu = self.contactSectionTitles[sender.section]
            let validContactArrayForKey = self.contactsDictionary[contactNamePrefixAsKeu]
            let detailAddress = validContactArrayForKey![row]
            controller.detailAddress = detailAddress
        }
    }
    
    // MARK: - Custom Methods
    func pullToRefresh(sender:AnyObject){
        Networking.getAllAddress()
    }
    
    // Prepare Data for indexed Table
    private func prepareContactsDictionary(jsonContact:[JSON]) {
        guard jsonContact.count > 0 else {
            self.contactsDictionary.removeAll()
            self.contactSectionTitles.removeAll()
            return }
        
        self.contactsDictionary.removeAll()
        self.contactSectionTitles.removeAll()
        
        for index in 0...jsonContact.count-1{
            var firstName:String!
            firstName = jsonContact[index]["first_name"].string!
            let contactNamePrefixAsDictionaryKey = firstName.substringToIndex(firstName.startIndex.advancedBy(1))
            if var validContactsArrayForKey = self.contactsDictionary[contactNamePrefixAsDictionaryKey]{
                validContactsArrayForKey.append(jsonContact[index])
                self.contactsDictionary[contactNamePrefixAsDictionaryKey] = validContactsArrayForKey
            }
            else {
                self.contactsDictionary[contactNamePrefixAsDictionaryKey] = [jsonContact[index]]
            }
        }
        self.contactSectionTitles.insertContentsOf(self.contactsDictionary.keys, at: 0)
        self.contactSectionTitles.sortInPlace { $0 < $1 }
    }
}
