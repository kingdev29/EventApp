//
//  TemplateSelectionViewController.swift
//  iOSEventApp
//
//  Created by sunil maharjan on 3/21/16.
//  Copyright © 2016 Swiss Magic. All rights reserved.
//

import UIKit

class TemplateSelectionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var currentEvent:Event!
    
    @IBOutlet weak var lbldate: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblMonthYear: UILabel!
    @IBOutlet weak var lblEventName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let eventName = currentEvent.name!
        lblEventName.text = eventName
        
        let eventStartDate = GlobalFunctions.formatDate(currentEvent.start_date!)
        let dateOnly = String(eventStartDate.characters.prefix(2))
        let monthYear = String(eventStartDate.characters.suffix(eventStartDate.characters.count - 3))
        lbldate.text = dateOnly
        lblMonthYear.text = monthYear
        
        self.title = "VORLAGE AUSWÄHLEN"
        //tableView setSeparatorInset:UIEdgeInsetsZero
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.reloadData()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("emailTemplateCell")!
        cell.textLabel?.textColor = UIColor.whiteColor()
        cell.textLabel?.text = "E-MAIL TEMPLATE"
        cell.textLabel?.font = UIFont.systemFontOfSize(13.0)
        cell.separatorInset = UIEdgeInsetsZero
        cell.layoutMargins = UIEdgeInsetsZero
        cell.selectionStyle = .None
        return cell
    }
    
    // MARK: - Table view delegate methods
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60.0
    }
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
