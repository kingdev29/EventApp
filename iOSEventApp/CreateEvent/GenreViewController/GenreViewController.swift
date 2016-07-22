//
//  GenreViewController.swift
//  iOSEventApp
//
//  Created by sunil maharjan on 1/5/16.
//  Copyright © 2016 Swiss Magic. All rights reserved.
//

import UIKit

class GenreViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Properties
    var selectedGenreList:[Int] = []
    var genreList = ["Hip Hop","Deep House","Techno","Elektronic","Trap","Open Format","Reggaeton","Pop","Latin","House","Drum & Bass","Dubstep","R&B","Mash up","Dancehall","Rock","Metal"]
    
    @IBOutlet weak var tblGenreList: UITableView!
    
    // MARK: - View Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CreateEventHelper.removeBackFromNavigationButton(self)
        
        genreList.sortInPlace { $0 < $1 }
        
        if let editEvent = GlobalVariables.editEventData {
        let selectedGenres = editEvent.genres!
            let arrGenre = selectedGenres.componentsSeparatedByString(", ")
            for i in 0...genreList.count - 1 {
                if arrGenre.contains(genreList[i]){
                   selectedGenreList.append(i+1)
                }
            }
        }
        
        tblGenreList.dataSource = self
        tblGenreList.delegate = self
        tblGenreList.reloadData()
        
        print(GlobalVariables.createEventData)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if let genres = GlobalVariables.createEventData["genres"] as? [Int]{
            selectedGenreList = genres
             tblGenreList.reloadData()
        }
        
    }
    
    @IBAction func btnNext(sender: AnyObject) {
    }
    
    
    //MARK: - Table view Methods
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return genreList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MusicGenreCell")!
        // let genre = genreList[indexPath.row]
        
        let imageUnchecked  = UIImageView(frame:CGRectMake(20, 20, 20, 20))
        imageUnchecked.layer.masksToBounds = true
        imageUnchecked.layer.borderColor = UIColor.whiteColor().CGColor
        imageUnchecked.layer.borderWidth = 1
        
        let imageChecked : UIImageView
        imageChecked  = UIImageView(frame:CGRectMake(20, 20, 20, 20))
        imageChecked.image = UIImage(named:"GenreChecked")
        print("selectedGenreList=\(selectedGenreList)")
        print("indexPath.row=\(indexPath.row)")
        if selectedGenreList.contains(indexPath.row + 1 ){
            cell.textLabel?.font = UIFont.boldSystemFontOfSize(15.0)
            cell.accessoryView = imageChecked
        }else
        {
            cell.textLabel?.font = UIFont.systemFontOfSize(14.0)
            cell.accessoryView = imageUnchecked
        }
        
        cell.selectionStyle = .None
        cell.textLabel?.textColor = UIColor.whiteColor()
        cell.textLabel!.text = genreList[indexPath.row]
        
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
        
        if selectedGenreList.contains(indexPath.row + 1){
            let index = selectedGenreList.indexOf(indexPath.row + 1)
            selectedGenreList.removeAtIndex(index!)
            mySelectedCell.accessoryView = imageUnchecked
            tableView.cellForRowAtIndexPath(indexPath)?.textLabel?.font = UIFont.systemFontOfSize(14)
            
        }else
        {
            selectedGenreList.append(indexPath.row + 1)
            mySelectedCell.accessoryView = imageChecked
            tableView.cellForRowAtIndexPath(indexPath)?.textLabel?.font = UIFont.boldSystemFontOfSize(15)
        }
        GlobalVariables.createEventData["genres"] = selectedGenreList
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 40.0
    }
    
    // MARK: - Segue Methods
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if selectedGenreList.count > 0{
            GlobalVariables.createEventData["genres"] = selectedGenreList
            return true
        }else{
            Utility.showAlert("Error", message: "Choose Atleast one.", vc: self)
            return false
        }
        
    }
    
}
