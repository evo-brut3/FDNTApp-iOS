//
//  InboxTableViewController.swift
//  FDNT
//
//  Created by Konrad Startek on 15/09/2020.
//  Copyright © 2020 Konrad Startek. All rights reserved.
//

import UIKit

class InboxTableViewController: UITableViewController, UISearchResultsUpdating {
    
    var emailFolderType: EmailFolderType!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TODO: Move to strings
        navigationItem.title = emailFolderType.name
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = true
        // TODO: Move to strings
        searchController.searchBar.placeholder = "Szukaj"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return EmailManager.shared.countEmails(folderType: emailFolderType)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "emailCell")
        cell.textLabel!.text = EmailManager.shared.getEmailFrom(index: indexPath.row, folderType: emailFolderType)
        cell.textLabel!.font = .boldSystemFont(ofSize: 17.0)
        cell.detailTextLabel!.text = EmailManager.shared.getEmailSubject(index: indexPath.row, folderType: emailFolderType)
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "readEmailSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch (segue.identifier, segue.destination) {
        case (.some("readEmailSegue"), let vc as PreviewEmailViewController):
            if let index = self.tableView.indexPathForSelectedRow?.row {
                vc.message = EmailManager.shared.getMessage(index: index, folderType: emailFolderType)
            }
        default: break
        }
    }
}
