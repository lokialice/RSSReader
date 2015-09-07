//
//  FeedTableViewController.swift
//  RSSReader
//
//  Created by Macbook Pro MD102 on 9/7/15.
//  Copyright (c) 2015 Loki. All rights reserved.
//

import UIKit

class FeedTableViewController: UITableViewController,MWFeedParserDelegate,SideBarDelegate {

    var feedItems = [MWFeedItem]()
    var sideBar = SideBar()
    var savedFeed = [Feed]()
    var feedNames = [String]()
    
    func request(urlString:String?){
        
        if urlString == nil {
        
        let url = NSURL(string:"http://vnexpress.net/rss/tin-moi-nhat.rss")
        let feedParser = MWFeedParser(feedURL: url)
        feedParser.delegate = self
            feedParser.parse()
        
        }else {
            let url = NSURL(string:urlString!)
            let feedParser = MWFeedParser(feedURL: url)
            feedParser.delegate = self
            feedParser.parse()

        }
        
    }
    func loadSavedFeeds() {
        savedFeed = [Feed]()
        feedNames = [String]()
        
        feedNames.append("Add Feed")
        let moc = SwiftCoreDataHelper.managedObjectContext()
        let result = SwiftCoreDataHelper.fetchEntities(NSStringFromClass(Feed), withPredicate: nil, managedObjectContext: moc)
        if result.count > 0 {
            for feed in result {
                let f = feed as! Feed
                savedFeed.append(f)
                feedNames.append(f.name)
            }
        }
        sideBar = SideBar(sourceView: self.navigationController!.view, menuItems: feedNames)
        sideBar.delegate = self
    }
    
    //Mark // Feed Parser Delegate
    func feedParserDidStart(parser: MWFeedParser!) {
        feedItems = [MWFeedItem]()
    }
    func feedParserDidFinish(parser: MWFeedParser!) {
        self.tableView.reloadData()
    }
    func feedParser(parser: MWFeedParser!, didParseFeedInfo info: MWFeedInfo!) {
        println(info)
        self.title = info.title
    }
    func feedParser(parser: MWFeedParser!, didParseFeedItem item: MWFeedItem!) {
        feedItems.append(item)
    }
    func sideBarDidSelectMenuButtonAtIndex(index: Int) {
        if index == 0 {
            let alert = UIAlertController(title: "New Feed", message: "Enter feed name and URL", preferredStyle: .Alert)
            alert.addTextFieldWithConfigurationHandler({ (textField:UITextField!) -> Void in
                textField.placeholder = "Feed Name"
            })
            alert.addTextFieldWithConfigurationHandler({ (textField:UITextField!) -> Void in
                textField.placeholder = "Feed URL"
            })
            alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Save", style: .Default, handler: { (alertAction:UIAlertAction!) -> Void in
                let textField = alert.textFields
                let feedNameTextField = textField?.first as! UITextField
                let feedURLTextField = textField?.last as! UITextField
                if feedNameTextField.text != "" && feedURLTextField.text != "" {
                    let moc = SwiftCoreDataHelper.managedObjectContext()
                    let feed = SwiftCoreDataHelper.insertManagedObject(NSStringFromClass(Feed), managedObjectConect: moc) as! Feed
                    feed.name = feedNameTextField.text
                    feed.url = feedURLTextField.text
                    
                    SwiftCoreDataHelper.saveManagedObjectContext(moc)
                    self.loadSavedFeeds()
                }
            }))
            self.presentViewController(alert, animated: true, completion: nil)
        }else {
           let moc = SwiftCoreDataHelper.managedObjectContext()
            let selectedFeed = moc.existingObjectWithID(savedFeed[index - 1].objectID, error: nil) as! Feed
            request(selectedFeed.url)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        loadSavedFeeds()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        request(nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return feedItems.count
    }
    //Mark // Table view Data Source
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell

        // Configure the cell...
        let item = feedItems[indexPath.row] as MWFeedItem
        cell.textLabel?.text = item.title

        return cell
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let item = feedItems[indexPath.row] as MWFeedItem
        let webBrower = KINWebBrowserViewController()
        let url = NSURL(string: item.link)
        webBrower.loadURL(url)
        self.navigationController?.pushViewController(webBrower, animated: true)
    }

    
}
