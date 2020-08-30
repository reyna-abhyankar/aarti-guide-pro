//
//  DetailViewController.swift
//  
//
//  Created by Viren Abhyankar on 6/10/15.
//
//

import UIKit

class DetailViewController: UIViewController {
    
    var detailObjectArray = [Aarti]()
    var row: Int = 0
    var detailDevTrue: Bool = true
    
    @IBOutlet var aartiTextView: UITextView!
    
    @IBAction func next(sender: UIBarButtonItem) {
        row++
        
        if row < 22 {
            
        } else if row == 22 {
            row = 0
        }
        
        loadInitialView()
    }
    
    func loadTextView(loadedFileName: String) {
        let fileName = loadedFileName
        let filePath = NSBundle.mainBundle().pathForResource(fileName, ofType: "txt")
        let textString = NSString(contentsOfFile: filePath!, encoding: NSUTF8StringEncoding, error: nil)
            
        aartiTextView.text = textString! as String
    }
    
    func loadInitialView() {
        if detailDevTrue {
            title = detailObjectArray[row].devname
            loadTextView(detailObjectArray[row].devfile)
        } else {
            title = detailObjectArray[row].engname
            loadTextView(detailObjectArray[row].engfile)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        loadInitialView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
