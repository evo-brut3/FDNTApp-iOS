//
//  LoggingViewController.swift
//  FDNT
//
//  Created by Konrad on 27/09/2019.
//  Copyright © 2019 Konrad. All rights reserved.
//

import UIKit

class LoggingViewController: UIViewController {

    @IBOutlet var logOnButton: UIButton!
    @IBOutlet var emailUser: UITextField!
    @IBOutlet var passUser: UITextField!
    @IBOutlet var wrongDataPrompt: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.wrongDataPrompt.isHidden = true
        self.logOnButton.layer.cornerRadius = 5
    }

    @IBAction func checkOnBtnClicked(_ sender: UIButton) {

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
            let sidebar = MenuViewController.self
            
            if (error == nil) {
                print("SUCCESS")                
                AccountManager.shared.collectUserTables(completion: { (result) in
                    for element in result {
                        print(element)
                        let t = Tab(name: element.key, website: element.value)
                        TabAPI.addUserTab(tab: t)
                    }
                })
            }
            else {
                print("FAILURE")
            }
            
            // wait until sining is done and hide the spinner
            child.willMove(toParent: nil)
            child.view.removeFromSuperview()
            child.removeFromParent()
        }
    }
    
}
