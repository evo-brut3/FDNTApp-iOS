//
//  SignInViewController.swift
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch (segue.identifier, segue.destination) {
        case (.some("askForEmailPasswordSegue"), let vc as SignInMailAccountViewController):
            vc.emailUser = self.emailUser.text
        default: break
        }
    }
    
    @IBAction func signUpInfoButtonClicked(_ sender: Any) {
        
        let alert = UIAlertController(title: "Rejestracja", message: "Najpierw upewnij się, że Twój email jest już w bazie. Aby ustawić hasło do aplikacji wpisz poniżej swój adres mailowy w domenie dzielo.pl. Na podany adres dostaniesz maila z linkiem do ustawienia hasła. W przypadku niepowodzenia lub pytań skontaktuj się z administratorem aplikacji.", preferredStyle: UIAlertController.Style.alert)
        alert.addTextField(configurationHandler: nil)
        
        alert.addAction(UIAlertAction(title: "Wyślij", style: .default, handler: { (_) in
            
            let textField = alert.textFields![0]
            
            if textField.text != "", textField.text!.contains("dzielo.pl") {
                FirebaseManager.shared.resetUserPassword(email: textField.text!)
            } else {
                
                let prompt = UIAlertController(title: "Błąd", message: "Niepoprawny adres e-mail, upewnij się czy podany adres e-mail znajduje się w domenie dzielo.pl", preferredStyle: UIAlertController.Style.alert)
                
                prompt.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                
                self.present(prompt, animated: true)
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Anuluj", style: .cancel, handler: nil))
        present(alert, animated: true)
    }

    @IBAction func signInButtonClicked(_ sender: UIButton) {
                
        // add the spinner view controller
        let loadingVC = SpinnerViewController()
        add(loadingVC)
 
        FirebaseManager.shared.signIn(email: emailUser.text!, pass: passUser.text!) { (error) in
            if (error == nil) {
                
                self.wrongDataPrompt.isHidden = true
                self.emailUser.isEnabled = false
                self.passUser.isEnabled = false
                
                // show a view to log into mail account                
                self.performSegue(withIdentifier: "askForEmailPasswordSegue", sender: nil)
                
                // collect user tabs
                FirebaseManager.shared.collectUserTabs(completion: { (result) in
                    self.navigationController?.popViewController(animated: true)
                })
                
            }
            else {
                print("FirebaseManager: Failed to sign in")
                self.wrongDataPrompt.isHidden = false
            }
            
            // wait until signing is done and hide the spinner
            loadingVC.willMove(toParent: nil)
            loadingVC.view.removeFromSuperview()
            loadingVC.removeFromParent()
        }
    }
    
}
