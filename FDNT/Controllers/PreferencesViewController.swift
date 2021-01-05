//
//  PreferencesViewController.swift
//  FDNT
//
//  Created by Konrad Startek on 07/09/2020.
//  Copyright © 2020 Konrad Startek. All rights reserved.
//

import UIKit
import MessageUI

class PreferencesViewController: UITableViewController, MFMailComposeViewControllerDelegate {

    let settingsData: [[String]] = [
        [
        "Zgłoś błąd",
        "Changelog",
        "Nasz Github"
        ]
    ]
    
    let detailSettingsData: [[String]] = [
        [
        "Daj nam znać jeżeli napotkałeś błąd!",
        "Zmiany w aplikacji",
        "Zobacz kod źródłowy"
        ]
    ]
    
    let headerSettingsData: [String] = [
        "Tworzenie aplikacji"
    ]
    
    let footerSettingsData: [String?] = [
        "Wersja \(Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String)"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(PreferencesTableViewCell.self, forCellReuseIdentifier: "tabCell")
        title = "Informacje"
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return settingsData.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsData[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let settingCell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "tabCell", for: indexPath) as! PreferencesTableViewCell
        
        print(settingsData[indexPath.section][indexPath.row])
        settingCell.textLabel!.text = settingsData[indexPath.section][indexPath.row]
        settingCell.detailTextLabel!.text = detailSettingsData[indexPath.section][indexPath.row]
        //settingCell.imageView!.image = UIImage(named: "o_fundacji")
        settingCell.accessoryType = .disclosureIndicator
        return settingCell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section < headerSettingsData.count {
            return headerSettingsData[section]
        }
        
        return nil
    }

    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if section < footerSettingsData.count {
            return footerSettingsData[section]
        }
        
        return nil
    }
    
    override func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        let footer = view as! UITableViewHeaderFooterView
        footer.textLabel?.textAlignment = .center
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            if !MFMailComposeViewController.canSendMail() {
                print("Mail services are not available")
                
                let email = "aplikacja@dzielo.pl"
                let alert = UIAlertController(title: "E-mail", message: email, preferredStyle: UIAlertController.Style.alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { _ in
                    tableView.deselectRow(at: indexPath, animated: true)
                }))
                alert.addAction(UIAlertAction(title: "Skopiuj", style: .default, handler: { _ in
                    UIPasteboard.general.string = email
                    tableView.deselectRow(at: indexPath, animated: true)
                }))

                present(alert, animated: true)
                
                return
            }
            
            let composeViewController = MFMailComposeViewController()
            composeViewController.mailComposeDelegate = self
            
            composeViewController.setToRecipients(["aplikacja@dzielo.pl"])
            composeViewController.setSubject("FDNT - iOS - Zgłoszenie błędu")
            
            self.present(composeViewController, animated: true, completion: nil)
            
        case 1:
            performSegue(withIdentifier: "showChangelog", sender: self)
        case 2:
            if let url = URL(string: "https://github.com/evo-brut3/FDNTApp-iOS/tree/master/FDNT") {
                UIApplication.shared.open(url)
            }
        default:
            print("def")
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
