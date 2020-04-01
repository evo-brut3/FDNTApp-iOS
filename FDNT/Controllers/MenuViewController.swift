//
//  MenuViewController.swift
//  FDNT
//
//  Created by Konrad on 19/09/2019.
//  Copyright © 2019 Konrad. All rights reserved.
//

import UIKit
//import FirebaseAuth

enum MenuType: String, CaseIterable {
    case FDNT
    case Subtitle1
    case O_Fundacji
    case Nasz_Patron
    case Dla_Darczyńcy
    case Materiały_prasowe
    case Kontakt
}

class MenuViewController: UITableViewController {
    
    static let shared = MenuViewController()
    private let userTabs = TabAPI.getUserTabs()
    
    static var emailAccountLabelText : String!
    static var emailAccountLabelVisibility = false
    
    @IBOutlet var tabsTableView: UITableView!
    @IBOutlet weak var accountView: UIView!
    @IBOutlet var emailAccountLabel: UILabel!
    @IBOutlet var signInBtn: UIButton!
    var didTapMenuType: ((Int) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //tableView.register(UITableViewCell.self, forCellReuseIdentifier: "tabsCellsIdentifier")
        tableView.register(MenuCellViewController.self, forCellReuseIdentifier: "tabCell")
        //tableView.register(MenuCellSeparatorViewController.self, forCellReuseIdentifier: "tabSeparatorCell")
        tabsTableView.delegate = self
        tabsTableView.dataSource = self

        NSLayoutConstraint.activate([
            //tabsTableView.topAnchor.constraint(equalTo: self.accountView.bottomAnchor, constant: 64)
        ])
        
        self.emailAccountLabel.text = MenuViewController.emailAccountLabelText
        self.emailAccountLabel.isHidden = !MenuViewController.emailAccountLabelVisibility
        
        var signInBtnText = "Zaloguj się"
        if MenuViewController.emailAccountLabelVisibility {
            signInBtnText = "Wyloguj się"
        }
        signInBtn.setTitle(signInBtnText, for: .normal)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //let menuType = MenuType.allCases[indexPath.row]
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
        //let sepCell = self.tableView.dequeueReusableCell(withIdentifier: "tabSeparatorCell", for: indexPath) as! MenuCellViewController
        cell.tab = userTabs[indexPath.row]
        return cell
    }
    
}
