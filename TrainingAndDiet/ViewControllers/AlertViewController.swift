//
//  AlertViewController.swift
//  TrainingAndDiet
//
//  Created by Hüseyin  Gencer on 11.03.2021.
//

import UIKit
import LGButton

protocol AlertViewControllerDelegate{
    func sendDataBack(data: User)
}

class AlertViewController: UIViewController {

    var delegate : AlertViewControllerDelegate? 
    
    @IBOutlet weak var cameraButton: LGButton!
    @IBOutlet weak var signUpAlertView: UIView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var mailTextField: UITextField!
    @IBOutlet weak var signUpButton: LGButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signUpAlertView.layer.cornerRadius = 20
        usernameTextField.leftView = UIImageView(image: UIImage(systemName: "person.fill")?.withTintColor(cameraButton.leftImageColor!,renderingMode: .alwaysOriginal))
        passwordTextField.leftView = UIImageView(image: UIImage(systemName: "key")?.withTintColor(cameraButton.leftImageColor!,renderingMode: .alwaysOriginal))
        mailTextField.leftView = UIImageView(image: UIImage(systemName: "envelope.fill")?.withTintColor(cameraButton.leftImageColor!,renderingMode: .alwaysOriginal))
        usernameTextField.leftViewMode = .always
        passwordTextField.leftViewMode = .always
        mailTextField.leftViewMode = .always
        // Do any additional setup after loading the view.
       
        
    }
    
    //Görünmez bir buton. FormViewin dışına tıklandığında dismiss fonksiyonunu çağırıyor.
    @IBAction func dismissSignup(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        
    }
    //Hesap Oluştur butonu
    @IBAction func signUpButtonTapped(_ sender: LGButton) {
        print("signup basıldı")
        guard usernameTextField.text != "" && passwordTextField.text != "" && mailTextField.text != "" else{
            let alert = UIAlertController(title: "Hata", message: "Kullanıcı adı, şifre ve e-mail alanları boş bırakılamaz", preferredStyle: .alert)
            let action = UIAlertAction(title: "Geri Dön", style: .cancel, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
            return
        }
        let user = User(username: usernameTextField.text!, password: passwordTextField.text!,mail : mailTextField.text!)
        let defaults = UserDefaults.standard
        defaults.object(forKey: "user") as? User
        print(user.username!, user.password!)
        self.delegate?.sendDataBack(data : user)
        self.dismiss(animated:true, completion:nil)//alınan data gönderilebilir
        
    }
    //Kamera Butonu
    @IBAction func cameraButtonTapped(_ sender: LGButton) {
    }
    //Klavyeden return keye basılınca responder değişecek
    @IBAction func dismissKeyboard(_ sender: UITextField) {
        if(sender === usernameTextField){
            passwordTextField.becomeFirstResponder()
        }
        else if(sender === passwordTextField){
            mailTextField.becomeFirstResponder()
        }
        else {
            signUpButtonTapped(signUpButton)
        }
    }
    
}
