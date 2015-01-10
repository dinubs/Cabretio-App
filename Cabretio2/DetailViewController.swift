//
//  DetailViewController.swift
//  Cabretio2
//
//  Created by Gavin Dinubilo on 12/3/14.
//  Copyright (c) 2014 Gavin Dinubilo. All rights reserved.
//

import UIKit
import Foundation

class DetailViewController: UIViewController {
    
    @IBOutlet weak var detailDescriptionLabel: UILabel!
    
    var id: String?
    var data = NSMutableData()
    
    @IBOutlet weak var articleTitle: UILabel!
    @IBOutlet weak var articleContent: UITextView!
    var loadIcon: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        var style1 = NSMutableParagraphStyle()
        style1.lineSpacing = 15
        let attributes1 = [NSParagraphStyleAttributeName : style1]
        articleTitle.attributedText = NSAttributedString(string: "Loading...", attributes: attributes1)
        articleTitle.font = UIFont(name: "Verdana-Bold", size: 18.0)
        var style = NSMutableParagraphStyle()
        style.lineSpacing = 15
        let attributes = [NSParagraphStyleAttributeName : style]
        articleContent.attributedText = NSAttributedString(string: "Loading...", attributes:attributes)
        articleContent.font = UIFont(name: "Verdana", size: 14.0)
        println(articleContent.bounds.width)
        articleContent.editable = false
        
        loadIcon = UIActivityIndicatorView(frame: CGRect(x: 25, y: 125, width: 50, height: 50)) as UIActivityIndicatorView
        loadIcon.center = self.view.center
        loadIcon.hidesWhenStopped = true
        loadIcon.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        self.view.addSubview(loadIcon)
        loadIcon.startAnimating()
        startConnection()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func startConnection(){
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let localOrWeb = appDelegate.url
        let urlPath: String = "\(localOrWeb)/articles/\(id!).json"
        println(urlPath)
        var url: NSURL = NSURL(string: urlPath)!
        var request: NSURLRequest = NSURLRequest(URL: url)
        var connection: NSURLConnection = NSURLConnection(request: request, delegate: self, startImmediately: false)!
        connection.start()
    }
    
    func connection(connection: NSURLConnection!, didReceiveData data: NSData!){
        self.data.appendData(data)
    }
    
    func buttonAction(sender: UIButton!){
        startConnection()
    }
    
    func connectionDidFinishLoading(connection: NSURLConnection!) {
        var err: NSError?
        // throwing an error on the line below (can't figure out where the error message is)
        let jsonResult = JSON(data: self.data)
        var str = ""
        if let array = jsonResult["content"].arrayValue{
            for paragraph in array {
                str = "\(str)\(paragraph)\n"
            }
        }
        println(jsonResult["title"])
        self.navigationItem.title = jsonResult["title"].stringValue
        self.navigationItem.leftBarButtonItem?.title = "back"
        self.articleTitle.text = jsonResult["title"].stringValue
        self.articleContent!.text = str
        loadIcon.stopAnimating()
    }
    
}