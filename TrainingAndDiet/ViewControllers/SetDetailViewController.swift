//
//  SetDetailViewController.swift
//  TrainingAndDiet
//
//  Created by Hüseyin  Gencer on 25.03.2021.
//

import UIKit
protocol SetDetailViewControllerDelegate {
    func saveSuccesfull()
    func backButton()
    func sendDataBack(meal : Meal?, exercise : Exercise?)
}

class SetDetailViewController: UIViewController, UITextViewDelegate {
    var delegate : SetDetailViewControllerDelegate!
    
    var counterString : String?// öğün adı ya da antrenman tipini önceki vcden alan
    let decoder = JSONDecoder()
    let defaults = UserDefaults.standard
    var presenter : String! //önceki vcden
    var mealOrTraningType : String!//önceki vcden
    var propertyList : [String] = [] // Mirror için
    var valueList : [Any] = [] // Mirror için
    var decodedMeal : Meal?
    var decodedExercise : Exercise?
    var genericTextFieldList : [UITextField]?
    
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var textField1: UITextField!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var textField2: UITextField!
    @IBOutlet weak var label3: UILabel!
    @IBOutlet weak var textField3: UITextField!
    @IBOutlet weak var label4: UILabel!
    @IBOutlet weak var textField4: UITextField!
    @IBOutlet weak var label5: UILabel!
    @IBOutlet weak var textField5: UITextField!
    @IBOutlet weak var label6: UILabel!
    @IBOutlet weak var textField6: UITextField!
    @IBOutlet weak var label7: UILabel! // serving_portion bilgilendirmesi için.
    @IBOutlet weak var textField7: UITextField!
    
    @IBOutlet weak var noteText: UITextView!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var saveButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        noteText.delegate = self
        let data = defaults.object(forKey: presenter!) as! Data
        if(presenter == "NutritionViewController"){
            if let meal : Meal = decodeIncomingDict(data: data){
                print(meal.name!)
                (propertyList, valueList) = getMirror(anyInstance: meal)
                let labelList = [label1!,label2!,label3!,label4!,label5!,label7!,label6!]
                let textFieldList = [textField1!,textField2!,textField3!,textField4!,textField5!,textField7!,textField6!]
                genericTextFieldList = textFieldList
                setUIComponents(presenter: self.presenter,labelList: labelList, textFieldList: textFieldList, propertyList: propertyList, valueList: valueList)
                
            }
            else{
                print("hata")
                return
            }
        }
        else {
            if let exercise : Exercise = decodeIncomingDict(data: data){
                print(exercise.name!)
                (propertyList, valueList) = getMirror(anyInstance: exercise)
                let labelList = [label1!,label2!,label3!,label4!,label5!]
                let textFieldList = [textField1!,textField2!,textField3!,textField4!,textField5!]
                genericTextFieldList = textFieldList
                setUIComponents(presenter: self.presenter,labelList: labelList,textFieldList: textFieldList,propertyList: propertyList, valueList: valueList)
            }
            else{
                print("hata")
                return
            }
            
        }
        self.noteText.layer.borderWidth = 1
        self.noteText.layer.borderColor = UIColor.systemGray2.cgColor
        //viewdidLoad sonu
    }
    
    func decodeIncomingDict(data : Data) -> Meal?{
        var counter = 0
        let decodedDict = try? decoder.decode([String : [Meal]].self, from: data)
        for i in decodedDict!.keys{
            if(counter != 0){
                break
            }
            for j in decodedDict![i]!{
                if(j.name == self.counterString){
                    counter += 1
                    return j
                }
            }
        }
        return nil
    }
    
    func decodeIncomingDict(data : Data) -> Exercise?{
        var counter = 0
        let decodedDict = try? decoder.decode([String : [Exercise]].self, from: data)
        for i in decodedDict!.keys{
            if(counter != 0){
                break
            }
            for j in decodedDict![i]!{
                if(j.name == self.counterString){
                    counter += 1
                    return j
                }
            }
        }
        return nil
    }
    
    func setUIComponents(presenter : String,labelList : [UILabel], textFieldList : [UITextField], propertyList : [String], valueList : [Any]){
        
        if(presenter == "TrainingViewController"){
            
            label6.isHidden = true
            textField6.isHidden = true
            label7.isHidden = true
            textField7.isHidden = true
            saveButton.backgroundColor = UIColor.init(hexString: "65FDC9")
        }
        else{
            saveButton.backgroundColor = UIColor.init(hexString: "94FF8E")
        }
            for i in 0...labelList.count-1{
                
                labelList[i].text = propertyList[i+1]
                if(i != labelList.count-1){
                    if(valueList[i+1] is String){
                        
                        textFieldList[i].text = valueList[i+1] as? String
                }
                    else if(valueList[i+1] is Int){
                        let j = valueList[i+1] as? Int
                        textFieldList[i].text = "\(j!)"
                        if(textFieldList[i].text == "nil"){
                            textFieldList[i].text = ""
                        }
                    }
                }
                else{
                    textFieldList.last?.text = mealOrTraningType
                }
            }
        
    }
    
    func getMirror<T>(anyInstance : T) -> ([String], [Any]){
        let mirror = Mirror(reflecting: anyInstance)
        var propertyList : [String] = []
        var valueList : [Any] = []
        
        for i in mirror.children{
            propertyList.append(i.label!)
            valueList.append(i.value)
            if(i.label! == "energy"){
                print(i.value,"energy")
            }
        }
        return (propertyList, valueList)
    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        print("butona basıldı")
        for i in genericTextFieldList!{
            if(i.text == ""){
                print("textfield boş bırakılamaz")
                let alertVC = UIAlertController(title: "Alan Boş Bırakılamaz", message: "Gösterilen Alan Boş Bırakılamaz", preferredStyle: .alert)
                let action = UIAlertAction(title: "Geri Dön", style: .cancel,handler: {_ in
                    i.becomeFirstResponder()
                })
                alertVC.addAction(action)
                self.present(alertVC, animated: true, completion: nil)
                return
            }
        }
        
        if(self.presenter == "NutritionViewController"){
            decodedMeal = Meal(name: textField1.text!, energy_rate: Int(textField2.text!)!, protein: Int(textField3.text!)!, fat: Int(textField4.text!)!, serving: Int(textField5.text!)!, serving_portion: Int(textField7.text!)!, repast_name: textField6.text!, comment: noteText.text!)
            print(decodedMeal!.name, decodedMeal!.energy_rate,decodedMeal?.serving)
            self.delegate.saveSuccesfull()
            self.delegate.sendDataBack(meal: decodedMeal, exercise: nil)
        }
        else{
            decodedExercise = Exercise(name: textField1.text!, repeat_count: Int(textField2.text!)!, set_count: Int(textField3.text!)!,energy : Int(textField4.text!)!, workout_type: textField5.text!, comment: noteText.text!)
            print(decodedExercise!.name, decodedExercise!.repeat_count,decodedExercise!.energy)
            self.delegate.saveSuccesfull()
            self.delegate.sendDataBack(meal: nil, exercise: decodedExercise)
            
        }
    }
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.delegate.backButton()
    }
    @IBAction func imageTapped(_ sender: UITapGestureRecognizer) {
        self.image.image = UIImage(named: "healtyfood")
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text.removeAll()
    }
    
   //Class sonu
}
