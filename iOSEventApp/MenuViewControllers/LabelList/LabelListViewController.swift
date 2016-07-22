//
//  LabelListViewController.swift
//  iOSEventApp
//
//  Created by Kiran Thapa on 3/21/16.
//  Copyright © 2016 Swiss Magic. All rights reserved.
//

import UIKit
import PKHUD
import SwiftyJSON

class LabelListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, GetAllLabelListDelegate {
    // MARK: - Properties
    @IBOutlet weak var tableView : UITableView!
    
    var refreshControl : UIRefreshControl!
    var labelsArray = [JSON]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        Networking.labelListingDelegate = self
        
        self.refreshControl=UIRefreshControl()
        self.refreshControl.addTarget(self, action: #selector(LabelListViewController.updateLabelList(_:)), forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshControl)
        
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        
        self.updateLabelList(self.refreshControl)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Custom Methods
    func updateLabelList(sender:AnyObject){
        PKHUD.sharedHUD.contentView = PKHUDProgressView()
        PKHUD.sharedHUD.show()
        
        Networking.getLabelList()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - Table view data source
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50.0
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.labelsArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "LabelListTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! LabelListTableViewCell
        
        let labelDictionary = self.labelsArray[indexPath.row].dictionary
        
        let label = labelDictionary!["name"]?.string
        let count = labelDictionary!["count"]?.string
        
        cell.loadCell(label!, count: count!)
        
        
        // Create full length cell separator without indent
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsetsZero
        cell.layoutMargins = UIEdgeInsetsZero
        
        return cell
    }
    
    // MARK: - Label Listing Delegate
    func labelListingDidSucced(data: JSON) {
        print("success")
        if self.refreshControl.refreshing{
            self.refreshControl.endRefreshing()
        }
        PKHUD.sharedHUD.hide(animated: false)
        
        self.labelsArray = data["data"].array!
        self.labelsArray.sortInPlace{$0["name"] < $1["name"]}
        
        self.tableView.reloadData()
    }
    
    func labelListingDidFail(error: NSError) {
        print("error")
        if self.refreshControl.refreshing{
            self.refreshControl.endRefreshing()
        }
        PKHUD.sharedHUD.hide(animated: false)
    }


}
