//
//  TableViewController.swift
//  TableView
//
//  Created by Tatsuya Tobioka on 2014/06/20.
//  Copyright (c) 2014年 Tatsuya Tobioka. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {

    let reuseIdentifier = "reuseIdentifier"
    var items = RSSItem[]()
    
    init(style: UITableViewStyle) {
        super.init(style: style)
        // Custom initialization
    }

    // fatal error: use of unimplemented initializer 'init(nibName:bundle:)' for class 'TableView.TableViewController'
    init(nibName: String!, bundle: NSBundle!) {
        super.init(nibName: nibName, bundle: bundle)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        self.title = NSLocalizedString(" Apple Developer News", comment: "")
        //self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        self.loadItems()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // #pragma mark - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView?) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView?, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return self.items.count
    }

    override func tableView(tableView: UITableView?, cellForRowAtIndexPath indexPath: NSIndexPath?) -> UITableViewCell? {
        // fatal error: Can't unwrap Optional.None with detailTextLabel
        //let cell = tableView!.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath) as UITableViewCell
        let cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: reuseIdentifier)
        
        // Configure the cell...
        self.configureCell(cell, atIndexPath: indexPath!)

        return cell
    }

    func configureCell(cell: UITableViewCell!, atIndexPath indexPath: NSIndexPath) {
        let item = self.items[indexPath.row]
        
        cell.textLabel.text = item.title.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        cell.textLabel.numberOfLines = 0
        
        cell.detailTextLabel.text = item.link.absoluteString
        cell.detailTextLabel.textColor = UIColor.lightGrayColor()
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView?, canEditRowAtIndexPath indexPath: NSIndexPath?) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView?, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath?) {
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
    override func tableView(tableView: UITableView?, moveRowAtIndexPath fromIndexPath: NSIndexPath?, toIndexPath: NSIndexPath?) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView?, canMoveRowAtIndexPath indexPath: NSIndexPath?) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // #pragma mark - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue?, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    override func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        let item = self.items[indexPath.row]
        
        let webViewController = SVWebViewController(URL: item.link)
        self.navigationController.pushViewController(webViewController, animated: true)
    }
    
    func loadItems() {
        MBProgressHUD.showHUDAddedTo(self.navigationController.view, animated: true)
        
        let url = NSURL(string: "https://developer.apple.com/news/rss/news.rss")
        let req = NSURLRequest(URL: url)
        
        RSSParser.parseRSSFeedForRequest(req,
            success: { feedItems in
                self.items = feedItems as RSSItem[]
                self.tableView.reloadData()
                
                MBProgressHUD.hideHUDForView(self.navigationController.view, animated: true)
            },
            failure: { error in
                // EXC_BAD_ACCESS
                //let alert = UIAlertView(title: NSLocalizedString("Error", comment: ""), message: error.localizedDescription, delegate: nil, cancelButtonTitle: NSLocalizedString("OK", comment: ""))
                let alert = UIAlertView()
                alert.title = NSLocalizedString("Error", comment: "")
                alert.message = error.localizedDescription
                alert.addButtonWithTitle(NSLocalizedString("OK", comment: ""))
                alert.show()
                
                MBProgressHUD.hideHUDForView(self.navigationController.view, animated: true)
            })
    }

}
