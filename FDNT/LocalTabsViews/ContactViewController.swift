//
//  ContactViewController.swift
//  FDNT
//
//  Created by Konrad Startek on 01/09/2020.
//  Copyright © 2020 Konrad Startek. All rights reserved.
//

import UIKit
import MessageUI
import MapKit

class ContactViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    // MARK: Board members - emails & phones
    private enum emails: String {
        case dariuszKowalczyk       = "dariusz.kowalczyk@dzielo.pl"
        case pawelWalkiewicz        = "pawel.walkiewicz@dzielo.pl"
        case marekZdrojewski        = "marek.zdrojewski@dzielo.pl"
        
        case lukaszNycz             = "lukasz.nycz@dzielo.pl"
        case annaMarszalek          = "sekretariat@dzielo.pl"
        case monikaGawracz          = "stypendia@dzielo.pl"
        case marzenaSawula          = "dzienpapieski@dzielo.pl"
        case malgorzataKucharska    = "darczyncy@dzielo.pl"
        case paulinaWorozbit        = "paulina.worozbit@dzielo.pl"
        case hubertSzczypek         = "biuroprasowe@dzielo.pl"
    }
    
    private enum phones: Int {
        case lukaszNycz             = 503_504_407
        case annaMarszalek          = 22_530_48_28
        case monikaGawracz          = 734_445_490
        case marzenaSawula          = 602_830_082
        case malgorzataKucharska    = 668_285_959
        case paulinaWorozbit        = 881_678_857
        case hubertSzczypek         = 662_506_859
    }
    
    private func sendEmail(email: String) {
        if !MFMailComposeViewController.canSendMail() {
            print("Mail services are not available")
            
            let alert = UIAlertController(title: "E-mail", message: email, preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Skopiuj", style: .default, handler: { action in
                UIPasteboard.general.string = email
            }))
            present(alert, animated: true)
            
            return
        }
        
        let composeViewController = MFMailComposeViewController()
        composeViewController.mailComposeDelegate = self
        
        composeViewController.setToRecipients([email])
        self.present(composeViewController, animated: true, completion: nil)
    }
    
    private func callPhone(number: Int) {
        if let callURL = URL(string: "tel://\(number)"), UIApplication.shared.canOpenURL(callURL) {
            UIApplication.shared.open(callURL)
        }
    }
    
    // MARK: Basic information Buttons Clicked
    @IBAction func addressFoundation(_ sender: Any) {
        let title = "Fundacja Dzieło Nowego Tysiąclecia"
        let coords = "52.239900,20.982932"
        let encodedTitle = title.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        let alert = UIAlertController(title: "Mapy", message: "Wybierz aplikację", preferredStyle: UIAlertController.Style.actionSheet)
        
        if let appleURL = URL(string: "https://maps.apple.com/?q=\(encodedTitle)&ll=\(coords)") {
            if UIApplication.shared.canOpenURL(appleURL) {
                alert.addAction(UIAlertAction(title: "Apple Maps", style: .default, handler: { action in
                    UIApplication.shared.open(appleURL)
                }))
                
            }
        }
        
        if let googleURL = URL(string: "comgooglemaps://?q=\(encodedTitle)&center=\(coords)") {
            if UIApplication.shared.canOpenURL(googleURL) {
                alert.addAction(UIAlertAction(title: "Google Maps", style: .default, handler: { action in
                    UIApplication.shared.open(googleURL)
                }))
            }
        }
        
        if alert.actions.count > 0 {
            alert.addAction(UIAlertAction(title: "Anuluj", style: .cancel, handler: nil))
            present(alert, animated: true)
        }
        
    }
    
    @IBAction func phoneFoundation(_ sender: Any) {
        callPhone(number: 22_530_48_28)
    }
    
    @IBAction func emailFoundation(_ sender: Any) {
        sendEmail(email: "dzielo@episkopat.pl")
    }
    
    @IBAction func nipFoundation(_ sender: Any) {
        let alert = UIAlertController(title: "NIP", message: "527-23-16-033", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Skopiuj", style: .default, handler: { action in
            UIPasteboard.general.string = "527-23-16-033"
        }))
        present(alert, animated: true)
    }
    
    // MARK: Email Buttons Clicked
    @IBAction func emailKsDariuszKowalczyk(_ sender: Any) {
        sendEmail(email: emails.dariuszKowalczyk.rawValue)
    }
    
    @IBAction func emailKsPawelWalkiewicz(_ sender: Any) {
        sendEmail(email: emails.pawelWalkiewicz.rawValue)
    }
    
    @IBAction func emailmarekZdrojewski(_ sender: Any) {
        sendEmail(email: emails.marekZdrojewski.rawValue)
    }
    
    @IBAction func emailKsLukaszNycz(_ sender: Any) {
        sendEmail(email: emails.lukaszNycz.rawValue)
    }
    
    @IBAction func emailAnnaMarszalek(_ sender: Any) {
        sendEmail(email: emails.annaMarszalek.rawValue)
    }
    
    @IBAction func emailMonikaGawracz(_ sender: Any) {
        sendEmail(email: emails.monikaGawracz.rawValue)
    }
    
    @IBAction func emailMarzenaSawula(_ sender: Any) {
        sendEmail(email: emails.marzenaSawula.rawValue)
    }
    
    @IBAction func emailMalgorzataKucharska(_ sender: Any) {
        sendEmail(email: emails.malgorzataKucharska.rawValue)
    }
    
    @IBAction func emailPaulinaWorozbit(_ sender: Any) {
        sendEmail(email: emails.paulinaWorozbit.rawValue)
    }
    
    @IBAction func emailHubertSzczypek(_ sender: Any) {
        sendEmail(email: emails.hubertSzczypek.rawValue)
    }

    // MARK: Phone Buttons Clicked
    @IBAction func phoneKsLukaszNycz(_ sender: Any) {
        callPhone(number: phones.lukaszNycz.rawValue)
    }
    
    @IBAction func phoneAnnaMarszalek(_ sender: Any) {
        callPhone(number: phones.annaMarszalek.rawValue)
    }
    
    @IBAction func phoneMonikaGawracz(_ sender: Any) {
        callPhone(number: phones.monikaGawracz.rawValue)
    }
    
    @IBAction func phoneMarzenaSawula(_ sender: Any) {
        callPhone(number: phones.marzenaSawula.rawValue)
    }
    
    @IBAction func phoneMalgorzataKucharska(_ sender: Any) {
        callPhone(number: phones.malgorzataKucharska.rawValue)
    }
    
    @IBAction func phonePaulinaWorozbit(_ sender: Any) {
        callPhone(number: phones.paulinaWorozbit.rawValue)
    }
    
    @IBAction func phoneHubertSzczypek(_ sender: Any) {
        callPhone(number: phones.hubertSzczypek.rawValue)
    }
    
    private static var poteznyKaplanCounter = 1
    @IBOutlet weak var poteznyKaplanButton: UIButton!
    
    @IBAction func poteznyKaplanButtonClicked(_ sender: Any) {
        if ContactViewController.poteznyKaplanCounter  < 7 {
            ContactViewController.poteznyKaplanCounter += 1
        } else {
            poteznyKaplanButton.contentHorizontalAlignment = .fill
            poteznyKaplanButton.contentVerticalAlignment = .fill
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        poteznyKaplanButton.contentHorizontalAlignment = .center
        poteznyKaplanButton.contentVerticalAlignment = .center
    }
}
