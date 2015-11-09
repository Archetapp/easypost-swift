//
//  ShipmentsViewController.swift
//  EasyPostApi
//
//  Created by William Welbes on 10/28/15.
//  Copyright © 2015 CocoaPods. All rights reserved.
//

import UIKit
import EasyPostApi

class ShipmentsViewController: UITableViewController {

    var shipments:[EasyPostShipment] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadShipments()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadShipments() {
        EasyPostApi.sharedInstance.getShipments(onlyPurchased:true, pageSize: 50, beforeShipmentId: nil) { (result) -> () in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                switch(result) {
                case .Success(let resultShipments):
                    self.shipments = resultShipments
                    self.tableView.reloadData()
                case .Failure(let error):
                    print("Error getting shipments: \((error as NSError).localizedDescription)")
                }
            })
        }
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // return the number of rows
        return shipments.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("shipmentCell", forIndexPath: indexPath)

        // Configure the cell...
        let shipment = shipments[indexPath.row]
        
        if let trackingCode = shipment.trackingCode {
            cell.textLabel!.text = trackingCode
        } else {
            cell.textLabel!.text = "[No tracking code for shipment]"
        }

        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        
        let shipment = shipments[indexPath.row]
        if let shipmentId = shipment.id {
        
            //Ask to refund
            let alertController = UIAlertController(title: "Request Refund?", message: "Request a refund for this shipment?", preferredStyle: UIAlertControllerStyle.Alert)
            
            alertController.addAction(UIAlertAction(title: "Request Refund", style: UIAlertActionStyle.Destructive, handler: { (action) -> Void in
                //Request the refund
                EasyPostApi.sharedInstance.requestRefund(shipmentId, completion: { (result) -> () in
                    //Check for error
                    switch(result) {
                    case .Success(let refund):
                        print("Refund requested: \(refund.id)")
                    case .Failure(let error):
                        print("Error requesting refund: \((error as NSError).localizedDescription)")
                    }
                })
            }))
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        
        
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
