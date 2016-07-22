//
//  EmailTemplateOverviewViewController.swift
//  iOSEventApp
//
//  Created by sunil maharjan on 3/3/16.
//  Copyright © 2016 Swiss Magic. All rights reserved.
//

import UIKit

class EmailTemplateOverviewViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var tableEmailTemplate: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableEmailTemplate.dataSource = self
        tableEmailTemplate.reloadData()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: -Table View DataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("EmailTemplateCell") as! EmailTemplateTableViewCell!
        cell.selectionStyle = .None
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsetsZero
        cell.layoutMargins = UIEdgeInsetsZero
        return cell
    }
    
}

