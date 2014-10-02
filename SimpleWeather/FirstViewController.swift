//
//  FirstViewController.swift
//  SimpleWeather
//
//  Created by Andrey on 23.09.14.
//  Copyright (c) 2014 Andrey. All rights reserved.
//

import UIKit
import CoreData

class FirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tblWeathers: UITableView!
    
    var refreshControl: UIRefreshControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Updating...")
        refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        tblWeathers.addSubview(refreshControl)
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "updateTable", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "checkRes:", name: "updateTable", object: nil);
        
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let context: NSManagedObjectContext = appDel.managedObjectContext!
        let request = NSFetchRequest(entityName: "Weathers")
        
        var results: NSArray = context.executeFetchRequest(request, error: nil)!
        
        for weather in results {
            let w = weather as Weathers
            weatherMng.addTCityNotStored(w.city, temp: w.temp, condition: w.condition)
        }
    }
    
    func refresh(sender: AnyObject) {
        for weather in weatherMng.weathers {
            weather.updateWeatherInfo() // async
        }
        refreshControl.endRefreshing()
    }
    
    func checkRes(notif: NSNotification) {
        if notif.name == "updateTable" {
            tblWeathers.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return weatherMng.weathers.count
    }
    
    func tableView(tableView: UITableView!, canEditRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView!, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath!) {
        
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            let appDel: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
            let context: NSManagedObjectContext = appDel.managedObjectContext!
            let request = NSFetchRequest(entityName: "Weathers")
            
            request.predicate = NSPredicate(format: "city = %@", weatherMng.weathers[indexPath.row].city)
            
            var results: NSArray = context.executeFetchRequest(request, error: nil)!
            
            for weather in results {
                context.deleteObject(weather as NSManagedObject)
            }
            context.save(nil)
            weatherMng.weathers.removeAtIndex(indexPath.row)
            tblWeathers.reloadData()
        }
    }

    
    override func viewWillAppear(animated: Bool) {
        tblWeathers.reloadData()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "Test")
        
        cell.textLabel?.text = weatherMng.weathers[indexPath.row].city
        cell.detailTextLabel?.text = weatherMng.weathers[indexPath.row].temp + weatherMng.weathers[indexPath.row].condition
        
        return cell
    }
}

