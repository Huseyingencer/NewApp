//
//  ViewController.swift
//  TrainingAndDiet
//
//  Created by Hüseyin  Gencer on 11.03.2021.
//

import UIKit
import LGButton

class OpenPageController: UIViewController, AlertViewControllerDelegate {
    //delegate ile alertten bilgi alacak
    func sendDataBack(data: User) {
        usernameTextField.text = data.username
        passwordTextField.text = data.password
    }
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    let signUpStoryboard = UIStoryboard(name: "SignUp", bundle: .main)
    var user : User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameTextField.attributedPlaceholder = NSAttributedString(string: "Kullanıcı Adı", attributes: [NSAttributedString.Key.foregroundColor : UIColor.darkGray])
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Şifre", attributes: [NSAttributedString.Key.foregroundColor : UIColor.darkGray])
        usernameTextField.leftViewMode = .always
        passwordTextField.leftViewMode = .always
        usernameTextField.leftView = UIImageView(image: UIImage(systemName: "person.fill")?.withTintColor(.darkGray,renderingMode: .alwaysOriginal))
        passwordTextField.leftView = UIImageView(image: UIImage(systemName: "key")?.withTintColor(.darkGray,renderingMode: .alwaysOriginal))
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! CustomTabBarController
        let trainingVC = vc.viewControllers?.first as! TrainingViewController
        let homepageVC = vc.viewControllers?[1] as! HomePageViewController
        let NutritionVC = vc.viewControllers?[2] as! NutritionViewController
        trainingVC.user = self.user
        homepageVC.user = self.user
        NutritionVC.user = self.user
    }

    
    @IBAction func signInButtonTapped(_ sender: LGButton) {
        guard usernameTextField.text != "" && passwordTextField.text != "" else {
            print("textler boş")
            return
        }
        let defaults = UserDefaults.standard
        //userdefaults class insatncelarıyla dolu bir dizi tutuyor. Bu diziyi encode biçimde alıyoruz. Biçim data
        let userArray : Data = defaults.object(forKey: "userArray") as! Data
        //alınan data arrayi sınıfta belirtilen nscoding protokolüne göre class instance haline geliyor.
        let decodedUserArray = NSKeyedUnarchiver.unarchiveObject(with: userArray) as! [User]
        print(decodedUserArray.count)
        var alert_flag = 0
        for i in 0...decodedUserArray.count - 1{
            if(decodedUserArray[i].username == usernameTextField.text! && decodedUserArray[i].password == passwordTextField.text!){
                decodedUserArray[i].enter_counter += 1
                self.user = decodedUserArray[i]
                print(decodedUserArray[i],"giriş sayfasında")
                let encodedUserArray : Data = try! NSKeyedArchiver.archivedData(withRootObject: decodedUserArray, requiringSecureCoding: false)
            //defaults içine atıldı.
                defaults.set(encodedUserArray, forKey: "userArray")
                self.performSegue(withIdentifier: "toHomePage", sender: LGButton.self)
                break
            }
            else {
                alert_flag+=1
                if(alert_flag == decodedUserArray.count){
                    print("giriş başarısız")
                    let failedEntryRequest = UIAlertController(title: "Giriş Başarısız", message: "Kullanıcı adı ya da parola yanlış", preferredStyle: .alert)
                    let cancelAction = UIAlertAction(title: "Geri Dön", style: .cancel, handler: {_ in self.usernameTextField.text?.removeAll()
                        self.passwordTextField.text?.removeAll()
                    })
                    failedEntryRequest.addAction(cancelAction)
                    self.present(failedEntryRequest, animated: true, completion: nil)
                }
            }
        }
     }
    
    @IBAction func signUpButtonTapped(_ sender: LGButton) {
        //signup alertini gösterirken delegate olarak kendini ayarlaması gerek.
        //transition soldan sağa doğru ayarlandı.Değiştirilebilir
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = .push
        transition.subtype = .fromRight
        view.window!.layer.add(transition, forKey: "kCATtransition")
        let alertVC = signUpStoryboard.instantiateViewController(withIdentifier: "SignUpAlertController") as! AlertViewController
        alertVC.delegate = self
        present(alertVC, animated:false)
       
    }
    @IBAction func dismissKeyboard(_ sender: UITextField) {
        if(sender === usernameTextField){
            passwordTextField.becomeFirstResponder()
        }
        
    }
}

