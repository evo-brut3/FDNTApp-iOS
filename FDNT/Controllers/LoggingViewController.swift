//
//  LoggingViewController.swift
//  FDNT
//
//  Created by Konrad Startek on 27/09/2019.
//  Copyright © 2019 Konrad Startek. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {

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
    
    @IBAction func signInButtonClicked(_ sender: UIButton) {
        let child = SpinnerViewController()
        
        // add the spinner view controller
        addChild(child)
        child.view.frame = view.frame
        view.addSubview(child.view)
        child.didMove(toParent: self)
 
        FirebaseManager.shared.signIn(email: emailUser.text!, pass: passUser.text!) { (error) in
            if (error == nil) {
                self.wrongDataPrompt.isHidden = true
                self.emailUser.isEnabled = false
                self.passUser.isEnabled = false
            }
            else {
                self.wrongDataPrompt.isHidden = false
            }
            
            if FirebaseManager.shared.isSigned() {
                FirebaseManager.shared.collectUserTabs(completion: { (result) in
                    self.navigationController?.popViewController(animated: true)
                })
            }
            
            // wait until signing is done and hide the spinner
            child.willMove(toParent: nil)
            child.view.removeFromSuperview()
            child.removeFromParent()
        }
    }
    
}
