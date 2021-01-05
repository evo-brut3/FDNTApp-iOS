//
//  SignInMailAccountViewController.swift
//  FDNT
//
//  Created by Konrad Startek on 29/09/2020.
//  Copyright © 2020 Konrad Startek. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

class SignInMailAccountViewController: UIViewController {
    
    var emailUser: String? = nil
    @IBOutlet private weak var passwordMailAccountUser: UITextField!
    @IBOutlet private weak var wrongDataPrompt: UILabel!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.signInButton.layer.cornerRadius = 5
        self.cancelButton.layer.cornerRadius = 5
        self.wrongDataPrompt.isHidden = true
    }
    
    @IBAction func signInMailAccountButtonClicked(_ sender: UIButton) {
        
        // check whether user inputted password and the email is not nil
        guard let password = passwordMailAccountUser.text, !password.isEmpty else {
            self.wrongDataPrompt.isHidden = false
            return
        }
        
        guard let email = emailUser else {
            fatalError("SignInMailAccountViewController: signInMailAccountButtonClicked() - failed to get user's email")
        }
        
        // add the spinner view controller
        let child = SpinnerViewController()
        addChild(child)
        child.view.frame = view.frame
        view.addSubview(child.view)
        child.didMove(toParent: self)
        
        // TODO: Check if spinner view waits for mails to load - don't want that
        EmailManager.shared.connect(login: email, password: password, completion: { isLogged in
            
            // check if logged in
            if isLogged == true {
                
                // success
                EmailManager.shared.fetch()
                TabManager.DefaultTabs.enableEmailTab()
                self.dismiss(animated: true, completion: nil)
                
                // store password in keychain
                if KeychainWrapper.standard.set(password, forKey: email) == true {
                    print("KeychainWrapper: Successfully stored password in keychain")
                } else {
                    print("KeychainWrapper: Ann error has occured")
                }
                
            } else {
                // failure
                self.wrongDataPrompt.isHidden = false
            }
            
            // wait until signing is done and hide the spinner
            child.willMove(toParent: nil)
            child.view.removeFromSuperview()
            child.removeFromParent()
        })
        
    }
    
    @IBAction func cancelButtonClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
