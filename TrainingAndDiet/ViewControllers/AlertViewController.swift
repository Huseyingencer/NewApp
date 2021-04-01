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
        print("görünmez butona basıldı")
        
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
        let defaults = UserDefaults.standard
        let user = User(username: usernameTextField.text!, password: passwordTextField.text!,mail : mailTextField.text!,day : [])
        //bu array cihaz önbelleğindeki userArrayi getiriyor.Böylece birden fazla user ve gün, user instance içinde saklanabilir halde. Uygulama ilk defa da açılıyor olabilir. if let ve else cümlecikleri bunun için, dikkat edilmeli.
        if let userArray : Data = defaults.object(forKey: "userArray") as? Data{
        //burası yeni alınan userı bir satır yukarıdaki arrayin içine atmak için. decode edilmeli data değil user atılacak çünkü.
            var decodedUserArray = NSKeyedUnarchiver.unarchiveObject(with: userArray) as! [User]
        //pushlandı
            decodedUserArray.append(user)
        //yeni elemana sahip array yeniden encode edildi.
            let encodedUserArray : Data = try! NSKeyedArchiver.archivedData(withRootObject: decodedUserArray, requiringSecureCoding: false)
        //defaults içine atıldı.
            defaults.set(encodedUserArray, forKey: "userArray")
        }
        //eğer uygulamaya ilk defa kayıt olunuyorsa burası çalışacak
        else {
            var userArray = [User]()
            userArray.append(user)
            let encodedUserArray : Data = try! NSKeyedArchiver.archivedData(withRootObject: userArray, requiringSecureCoding: false)
            defaults.set(encodedUserArray, forKey: "userArray")
            
        }
        print(user.username!, user.password!)
        //openpagecontroller bu controllerın delegatesi. burda alınan yeni userdan openpagein haberi var.
        self.delegate?.sendDataBack(data : user)
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = .push
        transition.subtype = .fromLeft
        view.window!.layer.add(transition, forKey: "kCATtransition")
        self.dismiss(animated:false, completion:nil)//alınan data gönderilebilir
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
