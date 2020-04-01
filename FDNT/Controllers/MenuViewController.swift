//
//  MenuViewController.swift
//  FDNT
//
//  Created by Konrad on 19/09/2019.
//  Copyright © 2019 Konrad. All rights reserved.
//

import UIKit

class MenuViewController: UITableViewController {
    
    static let shared = MenuViewController()
    private let userTabs = TabAPI.getUserTabs()

    @IBOutlet var tabsTableView: UITableView!
    @IBOutlet weak var accountView: UIView!
    @IBOutlet var emailAccountLabel: UILabel!
    @IBOutlet var signInBtn: UIButton!
    var didTapMenuType: ((Int) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(MenuCellViewController.self, forCellReuseIdentifier: "tabCell")
        tabsTableView.delegate = self
        tabsTableView.dataSource = self
        
        if AccountManager.shared.isSigned() {
            self.emailAccountLabel.text = AccountManager.shared.userEmail
            self.emailAccountLabel.isHidden = false
            self.signInBtn.setTitle("Wyloguj się", for: .normal)
        } else {
            self.emailAccountLabel.text = ""
            self.emailAccountLabel.isHidden = true
            self.signInBtn.setTitle("Zaloguj się", for: .normal)
        }
    }
    
    @IBAction func signInBtnClicked(_ sender: Any) {
        dismiss(animated: true)
        if AccountManager.shared.isSigned() == false {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "LoggingViewController") as! LoggingViewController
            
            if let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController {
                navigationController.pushViewController(nextViewController, animated: false)
                }
        } else {
            AccountManager.shared.singOut()
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
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "tabCell", for: indexPath) as! MenuCellViewController
        cell.tab = userTabs[indexPath.row]
        return cell
    }
    
}
