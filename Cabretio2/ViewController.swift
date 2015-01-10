//
//  ViewController.swift
//  Cabretio2
//
//  Created by Gavin Dinubilo on 12/3/14.
//  Copyright (c) 2014 Gavin Dinubilo. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UITableViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet
    var items: [String] = []
    var ids: [String] = []
    var likes: [String] = []
    var contents: [String] = []
    var data = NSMutableData()
    var jsonResult:JSON?
    var loadIcon: UIActivityIndicatorView?
    var page: Int = 1
    var canLoadNextPage = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.separatorColor = UIColor(rgba: "#444444")
        
        loadIcon = UIActivityIndicatorView(frame: CGRect(x: 25, y: 125, width: 50, height: 50)) as UIActivityIndicatorView
        loadIcon!.center = self.view.center
        loadIcon!.hidesWhenStopped = true
        loadIcon!.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        self.view.addSubview(loadIcon!)
        loadIcon!.startAnimating()
        tableView.reloadData()
    }
    override func viewDidAppear(animated: Bool) {
        
        tableView.reloadData()
        startConnection()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count;
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as TableCell
        cell.title!.text = self.items[indexPath.row]
        cell.likes!.text = self.likes[indexPath.row]
        cell.content!.text = self.contents[indexPath.row]
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let indexPath = self.tableView.indexPathForSelectedRow() {
            (segue.destinationViewController as DetailViewController).id = self.ids[indexPath.row]
        }
    }
    
    func startConnection(){
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let localOrWeb = appDelegate.url
        var urlPath: String = "\(localOrWeb)/articles.json?page=\(page)"
        println(urlPath)
        self.loadIcon!.startAnimating()
        canLoadNextPage = false
        Alamofire.request(.GET, urlPath)
            .responseJSON {(request, response, data, error) in
                println("Finished Connection")
                var err: NSError?
                let jsonResult = JSON(object: data!)
                if let array = jsonResult.arrayValue{
                    for string in array {
                        println(array.count)
                        if let str = string["title"].stringValue{
                            self.items.append(str)
                            println(str)
                            self.ids.append(string["id"].stringValue!)
                            let upVotes = string["cached_votes_up"].integerValue!
                            let downVotes = string["cached_votes_down"].integerValue!
                            self.likes.append("\(upVotes - downVotes)")
                            var content: String = ""
                            if let arry = string["content"].arrayValue{
                                content = "\(arry[0].stringValue!) \(arry[1].stringValue!)"
                                content = "\(content.substringToIndex(advance(content.startIndex, 140)))..."
                                println(content)
                            }
                            self.contents.append(content)
                            self.tableView.reloadData()
                        }
                    }
                }
                self.loadIcon!.stopAnimating()
                self.canLoadNextPage = true
        }
    }
    
    func connection(connection: NSURLConnection!, didReceiveData data: NSData!){
        self.data.appendData(data)
    }
    
    func buttonAction(sender: UIButton!){
        startConnection()
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if (indexPath.row == self.items.count - 5 && canLoadNextPage) {
            page = page + 1
            startConnection()
        }
        let view = cell.contentView
        view.layer.opacity = 0.1
        UIView.animateWithDuration(0.75) {
            view.layer.opacity = 1
        }
    }
    

}

