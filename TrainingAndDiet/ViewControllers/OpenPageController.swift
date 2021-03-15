//
//  ViewController.swift
//  TrainingAndDiet
//
//  Created by Hüseyin  Gencer on 11.03.2021.
//

import UIKit
import LGButton

class OpenPageController: UIViewController, AlertViewControllerDelegate {
    
    
    func sendDataBack(data: User) {
        usernameTextField.text = data.username
        passwordTextField.text = data.password
        print("openpagedeyim")
    }
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    let signUpStoryboard = UIStoryboard(name: "SignUp", bundle: .main)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameTextField.attributedPlaceholder = NSAttributedString(string: "Kullanıcı Adı", attributes: [NSAttributedString.Key.foregroundColor : UIColor.darkGray])
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Şifre", attributes: [NSAttributedString.Key.foregroundColor : UIColor.darkGray])
        usernameTextField.leftViewMode = .always
        passwordTextField.leftViewMode = .always
        usernameTextField.leftView = UIImageView(image: UIImage(systemName: "person.fill")?.withTintColor(.darkGray,renderingMode: .alwaysOriginal))
        passwordTextField.leftView = UIImageView(image: UIImage(systemName: "key")?.withTintColor(.darkGray,renderingMode: .alwaysOriginal))
        
    }

    
    @IBAction func signInButtonTapped(_ sender: LGButton) {
        guard usernameTextField.text != "" && passwordTextField.text != "" else {
            print("username")
            return
        }
        print("password")
     }
    
    @IBAction func signUpButtonTapped(_ sender: LGButton) {
        //signup alertini gösterirken delegate olarak kendini ayarlaması gerek.
        let alertVC = signUpStoryboard.instantiateViewController(withIdentifier: "SignUpAlertController") as! AlertViewController
        alertVC.delegate = self
        present(alertVC, animated: true)
        
    }
    @IBAction func dismissKeyboard(_ sender: UITextField) {
        if(sender === usernameTextField){
            passwordTextField.becomeFirstResponder()
        }
    }
}

