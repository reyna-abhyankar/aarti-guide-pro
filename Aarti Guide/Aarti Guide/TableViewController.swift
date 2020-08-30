//
//  ViewController.swift
//  Aarti Guide
//
//  Created by Viren Abhyankar on 6/9/15.
//  Copyright (c) 2015 Rahul Abhyankar. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    var aartiRootArray = [Dictionary<String, String>]()
    var aartiObjectArray = [Aarti]()
    var devTrue: Bool = true
    
    let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
    var path = ""
    let fileManager = NSFileManager.defaultManager()
    var data = NSMutableArray()
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @IBAction func translate(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            devTrue = true
        case 1:
            devTrue = false
        default:
            devTrue = true
        }
    }
    
    func readWritePlistFactor() {
        path = paths.stringByAppendingPathComponent("Aarti List.plist")
        
        if (!(fileManager.fileExistsAtPath(path))) {
            let bundle: NSString = NSBundle.mainBundle().pathForResource("Aarti List", ofType: "plist")!
            fileManager.copyItemAtPath(bundle as String, toPath: path, error: nil)
        }
    }
    
    func readFromPlist() {
        
        readWritePlistFactor()
        
        let dict = NSArray(contentsOfFile: path)
        
        aartiRootArray = dict as! [(Dictionary<String, String>)]
        
        for items in aartiRootArray {
            var newAarti = Aarti()
            
            for item in items {
                newAarti.devfile = items["devfile"]!
                newAarti.engfile = items["engfile"]!
                newAarti.pic = items["pic"]!
                newAarti.devname = items["devname"]!
                newAarti.engname = items["engname"]!
            }
            
            aartiObjectArray.append(newAarti)
        }
    }
    
    func writeToPlist() {
        
        readWritePlistFactor()
        
        data.setArray(aartiRootArray)
        data.writeToFile(path, atomically: true)
    }
    
    func longPressGestureRecognized(gestureRecognizer: UIGestureRecognizer) {
        let longPress = gestureRecognizer as! UILongPressGestureRecognizer
        let state = longPress.state
        var locationInView = longPress.locationInView(tableView)
        var indexPath = tableView.indexPathForRowAtPoint(locationInView)
        
        struct My {
            static var cellSnapshot: UIView? = nil
        }
        
        struct Path {
            static var initialIndexPath: NSIndexPath? = nil
        }
        
        switch state {
        case UIGestureRecognizerState.Began:
            if indexPath != nil {
                Path.initialIndexPath = indexPath
                let cell = tableView.cellForRowAtIndexPath(indexPath!) as! TableViewCell
                My.cellSnapshot = snapshopOfCell(cell)
                var center = cell.center
                My.cellSnapshot!.center = center
                My.cellSnapshot!.alpha = 0.0
                tableView.addSubview(My.cellSnapshot!)
                
                UIView.animateWithDuration(0.25, animations: {() -> Void in
                    center.y = locationInView.y
                    My.cellSnapshot!.center = center
                    My.cellSnapshot!.transform = CGAffineTransformMakeScale(1.05, 1.05)
                    My.cellSnapshot!.alpha = 0.98
                    cell.alpha = 0.0
                    }, completion: {(finished) -> Void in
                        if finished {cell.hidden = true}})
            }
        
        case UIGestureRecognizerState.Changed:
        var center = My.cellSnapshot!.center
        center.y = locationInView.y
        My.cellSnapshot!.center = center
            if ((indexPath != nil) && (indexPath != Path.initialIndexPath)) {
                swap(&aartiObjectArray[indexPath!.row], &aartiObjectArray[Path.initialIndexPath!.row])
                swap(&aartiRootArray[indexPath!.row], &aartiRootArray[Path.initialIndexPath!.row])
                tableView.moveRowAtIndexPath(Path.initialIndexPath!, toIndexPath: indexPath!)
                Path.initialIndexPath = indexPath
            }
        
        default:
            let cell = tableView.cellForRowAtIndexPath(Path.initialIndexPath!) as! TableViewCell
            cell.hidden = false
            cell.alpha = 0.0
            UIView.animateWithDuration(0.25, animations: { () -> Void in
                My.cellSnapshot!.center = cell.center
                My.cellSnapshot!.transform = CGAffineTransformIdentity
                My.cellSnapshot!.alpha = 0.0
                cell.alpha = 1.0
                }, completion: {(finished) -> Void in
                    if finished {
                        Path.initialIndexPath = nil
                        My.cellSnapshot!.removeFromSuperview()
                        My.cellSnapshot = nil
                    }
            })
            
        }
        
        writeToPlist()
    }
    
    func snapshopOfCell(inputView: UIView) -> UIView {
        UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, false, 0.0)
        inputView.layer.renderInContext(UIGraphicsGetCurrentContext())
        let image = UIGraphicsGetImageFromCurrentImageContext() as UIImage
        UIGraphicsEndImageContext()
        let cellSnapshot: UIView = UIImageView(image: image)
        
        cellSnapshot.layer.masksToBounds = false
        cellSnapshot.layer.cornerRadius = 0.0
        cellSnapshot.layer.shadowOffset = CGSizeMake(-5.0, 0.0)
        cellSnapshot.layer.shadowRadius = 5.0
        cellSnapshot.layer.shadowOpacity = 0.4
        
        return cellSnapshot
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("aartiCell", forIndexPath: indexPath) as! TableViewCell
        
        let cellAarti = aartiObjectArray[indexPath.row]
        
        cell.thumbImage.image = UIImage(named: cellAarti.pic)
        cell.devLabel.text = cellAarti.devname
        cell.engLabel.text = cellAarti.engname
        
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return aartiObjectArray.count
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        readFromPlist()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "detailSegue" {
            let cellIndexPath = tableView.indexPathForCell(sender as! TableViewCell)
            
            let detailVC = segue.destinationViewController as! DetailViewController
            detailVC.detailObjectArray = aartiObjectArray
            detailVC.row = cellIndexPath!.row
            detailVC.detailDevTrue = devTrue
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        title = "Aartis"
        
        let longPress = UILongPressGestureRecognizer(target: self, action: "longPressGestureRecognized:")
        tableView.addGestureRecognizer(longPress)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

