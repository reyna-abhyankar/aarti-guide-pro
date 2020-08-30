//
//  AboutViewController.swift
//  
//
//  Created by Viren Abhyankar on 6/10/15.
//
//

import UIKit
import MessageUI

class AboutViewController: UITableViewController, MFMailComposeViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "About"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func mailTo(sender: UIButton) {
        
        if (MFMailComposeViewController.canSendMail()) {
            let mailVC = MFMailComposeViewController()
            mailVC.mailComposeDelegate = self
            
            let toRecipient = ["theaartiguide@gmail.com"]
            mailVC.setToRecipients(toRecipient)
            
            mailVC.setSubject("Aarti App")
            mailVC.setMessageBody("Your app is amazing! Here is an idea to make it even better!", isHTML: false)
            
            presentViewController(mailVC, animated: true, completion: nil)
            
        } else {
            let mailAlert: UIAlertController = UIAlertController(title: "Sorry", message: "Mail isn't set up on this device.", preferredStyle: .Alert)
            
            presentViewController(mailAlert, animated: true, completion: nil)
        }
    }
    
    func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
        switch result.value {
        case MFMailComposeResultCancelled.value:
            println("Cancelled")
        case MFMailComposeResultSaved.value:
            println("Saved")
        case MFMailComposeResultSent.value:
            println("Sent")
        case MFMailComposeResultFailed.value:
            println("Failed \(error.localizedDescription)")
        default:
            break
        }
        dismissViewControllerAnimated(true, completion: nil)
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
