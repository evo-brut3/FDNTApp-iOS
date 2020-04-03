//
//  LoggingViewController.swift
//  FDNT
//
//  Created by Konrad on 27/09/2019.
//  Copyright © 2019 Konrad. All rights reserved.
//

import UIKit

class LoggingViewController: UIViewController {

    @IBOutlet var stackView: UIStackView!
    @IBOutlet var logOnButton: UIButton!
    @IBOutlet var emailUser: UITextField!
    @IBOutlet var passUser: UITextField!
    @IBOutlet var wrongDataPrompt: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.wrongDataPrompt.isHidden = true
        self.logOnButton.layer.cornerRadius = 5
        self.emailUser.isEnabled = true
        self.passUser.isEnabled = true
    }
    
    @IBAction func logOnBtnClicked(_ sender: UIButton) {
        print("Signing")
        let child = SpinnerViewController()
        
        // add the spinner view controller
        addChild(child)
        child.view.frame = view.frame
        view.addSubview(child.view)
        child.didMove(toParent: self)
 
        AccountManager.shared.signIn(email: emailUser.text!, pass: passUser.text!) { (error) in
            if (error == nil) {
                print("SUCCESS")
                self.wrongDataPrompt.isHidden = true
                self.emailUser.isEnabled = false
                self.passUser.isEnabled = false
                AccountManager.shared.collectUserTables(completion: { (result) in
                    if result.count > 0 {
                        let t = Tab(name: "Twoje zakładki", isSeparator: true)
                        TabAPI.addUserTab(tab: t)
                    }
                    for element in result {
                        print(element)
                        let t = Tab(name: element.key, website: element.value)
                        TabAPI.addUserTab(tab: t)
                    }
                    self.navigationController?.popViewController(animated: true)
                })
            }
            else {
                print("FAILURE")
                self.wrongDataPrompt.isHidden = false
            }
            
            // wait until sining is done and hide the spinner
            child.willMove(toParent: nil)
            child.view.removeFromSuperview()
            child.removeFromParent()
        }
    }
    
}
