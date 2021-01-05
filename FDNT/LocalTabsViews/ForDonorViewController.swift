//
//  ForDonorViewController.swift
//  FDNT
//
//  Created by Konrad Startek on 01/09/2020.
//  Copyright © 2020 Konrad Startek. All rights reserved.
//

import UIKit
import MessageUI

class ForDonorViewController: UIViewController, MFMessageComposeViewControllerDelegate {
    
    @IBOutlet weak var smsButton: UIButton!
    @IBOutlet weak var onePercentButton: UIButton!
    @IBOutlet weak var donateButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func smsButtonClicked(_ sender: Any) {
        print("Clicked SMS")
        
        if !MFMessageComposeViewController.canSendText() {
            print("SMS Services are not available")
        } else {
            let composeViewController = MFMessageComposeViewController()
            composeViewController.messageComposeDelegate = self
            
            composeViewController.recipients = ["74265"]
            composeViewController.body = "STYPENDIA"
            
            self.present(composeViewController, animated: true, completion: nil)
        }
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func onePercentButtonClicked(_ sender: Any) {
        if let url = URL(string: "https://2018.pit-format-online.pl/?rid=b1b5566183bd3f337c9a1f4bd2b2daa0f0728ad2") {
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func donateButtonClicked(_ sender: Any) {
        if let url = URL(string: "https://dzielo.pl/wp-content/uploads/up_media/przelewFDNT.pdf") {
            UIApplication.shared.open(url)
        }
    }
}
