//
//  SidebarViewController.swift
//  FDNT
//
//  Created by Konrad Startek on 19/09/2019.
//  Copyright © 2019 Konrad Startek. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

class SidebarTableViewController: UITableViewController {
    private let userTabs = TabManager.getAllTabs()

    @IBOutlet var tabsTableView: UITableView!
    @IBOutlet weak var accountView: UIView!
    @IBOutlet var emailAccountLabel: UILabel!
    @IBOutlet var signInBtn: UIButton!
    var didTapMenuType: ((Int) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(SidebarTableViewCell.self, forCellReuseIdentifier: "tabCell")
        tabsTableView.delegate = self
        tabsTableView.dataSource = self
        
        if FirebaseManager.shared.isSigned() {
            self.emailAccountLabel.text = FirebaseManager.shared.userEmail
            self.emailAccountLabel.isHidden = false
            self.signInBtn.setTitle("Wyloguj się", for: .normal)
        } else {
            self.emailAccountLabel.text = ""
            self.emailAccountLabel.isHidden = true
            self.signInBtn.setTitle("Zaloguj się", for: .normal)
        }
    }
    
    @IBAction func signInButtonClicked(_ sender: Any) {
        dismiss(animated: true)
                
        if FirebaseManager.shared.isSigned() == false {
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let nextViewController = storyboard.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
            
            if let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController {
                navigationController.pushViewController(nextViewController, animated: false)
                nextViewController.stackView.topAnchor.constraint(equalTo: navigationController.navigationBar.bottomAnchor, constant: 16.0).isActive = true
            }
            
        } else {
            
            FirebaseManager.shared.singOut()
            
            TabManager.DefaultTabs.disableEmailTab()
            
            if let email = FirebaseManager.shared.userEmail {
                let key = KeychainWrapper.Key.init(rawValue: email)
                KeychainWrapper.standard.remove(forKey: key)
            }

        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss(animated: true) { [weak self] in
            print("Dismissing: \(indexPath.row)")
            self?.didTapMenuType?(indexPath.row)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userTabs.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "tabCell", for: indexPath) as! SidebarTableViewCell
        cell.tab = userTabs[indexPath.row]
        cell.tabIndex = indexPath.row
        return cell
    }
    
}
