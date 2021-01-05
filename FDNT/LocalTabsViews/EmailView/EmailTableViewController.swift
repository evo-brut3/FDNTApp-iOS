//
//  EmailViewController.swift
//  FDNT
//
//  Created by Konrad Startek on 13/09/2020.
//  Copyright © 2020 Konrad Startek. All rights reserved.
//

import UIKit

class EmailTableViewController: UITableViewController {

    var emailFolderType: EmailFolderType!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return EmailFolderType.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = EmailFolderType.allCases[indexPath.row].name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        emailFolderType = EmailFolderType.allCases[indexPath.row]
        performSegue(withIdentifier: "showEmailsListSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch (segue.identifier, segue.destination) {
        case ("showEmailsListSegue", let vc as InboxTableViewController):
            vc.emailFolderType = self.emailFolderType
        default: break
        }
    }
}
