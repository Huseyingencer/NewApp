//
//  EditViewController.swift
//  TrainingAndDiet
//
//  Created by Hüseyin  Gencer on 5.04.2021.
//

import UIKit
import LGButton

protocol EditViewControllerDelegate {
    func editVCSendBack()
}

class EditViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.propertyList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "editCell") as! EditTableViewCell
        
        cell.propertyNameLabel.text = propertyList[indexPath.row]
        if(self.valueList[indexPath.row] is String){
            cell.valueTextField.text = self.valueList[indexPath.row] as! String
            self.cellCollection.append(cell)
            return cell
            }
            else{
                let m = self.valueList[indexPath.row] as! Int
                cell.valueTextField.text = "\(m)"
                self.cellCollection.append(cell)
                return cell
            }
        
        return cell
        
    }
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activateSwitch: UISwitch!
    @IBOutlet weak var saveButton: LGButton!
    @IBOutlet weak var infoLabel: UILabel!
    
    var delegate : EditViewControllerDelegate!
    var user : User!
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()
    var comingDate : Day!
    var presenter : String!
    var instance : String!
    var headerTitle : String!
    var propertyList : [String] = []
    var valueList : [Any] = []
    var cellCollection : [EditTableViewCell] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activateSwitchTapped(self.activateSwitch)
        setPropertyandValueList()
    }
    
    @IBAction func activateSwitchTapped(_ sender: UISwitch) {
        if (sender.isOn) {
            self.tableView.isUserInteractionEnabled = true
            self.saveButton.isUserInteractionEnabled = true
            self.saveButton.showTouchFeedback = true
            self.saveButton.bgColor = self.saveButton.bgColor.withAlphaComponent(1)
            self.infoLabel.isHidden = true
            
        }
        else{
            self.tableView.isUserInteractionEnabled = false
            self.saveButton.isUserInteractionEnabled = false
            self.saveButton.showTouchFeedback = false
            self.saveButton.bgColor = self.saveButton.bgColor.withAlphaComponent(0.5)
            self.infoLabel.isHidden = false
        }
    }
    
    
    
    func setPropertyandValueList(){
        if(self.presenter == "NutritionViewController"){
            for i in self.comingDate.nutrition!.repastList!{
                if(self.headerTitle == i.repastName){
                    for j in i.mealList!{
                        if(j.name == self.instance){
                            let mirror = Mirror(reflecting: j)
                            for k in mirror.children{
                                if(k.label == "class_id" || k.label == "meal_id" || k.label == "is_select") {
                                    print(k.label!)
                                    continue
                                }
                                else{
                                    self.propertyList.append(k.label!)
                                    self.valueList.append(k.value)
                                    
                                }
                            }
                        }
                    }
                }
            }
        }
        else{
            for i in self.comingDate.training!.workoutList{
                if(self.headerTitle == i.workout_name){
                    for j in i.exercise_list!{
                        if(j.name == self.instance){
                            let mirror = Mirror(reflecting: j)
                            for k in mirror.children{
                                if(k.label == "class_id" || k.label == "exercise_id"){
                                    continue
                                }
                                else{
                                    self.propertyList.append(k.label!)
                                    self.valueList.append(k.value)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    @IBAction func saveButtonTapped(_ sender: LGButton) {
        if(self.presenter == "NutritionViewController"){
            for i in comingDate.nutrition!.repastList!{
                if(i.repastName == self.headerTitle){
                    for j in i.mealList!{
                        if(j.name == self.instance){
                            j.name = self.cellCollection[0].valueTextField.text!
                            j.energy_rate = Int(self.cellCollection[1].valueTextField.text!)!
                            j.protein = Int(self.cellCollection[2].valueTextField.text!)!
                            j.fat = Int(self.cellCollection[3].valueTextField.text!)!
                            j.serving = Int(self.cellCollection[4].valueTextField.text!)!
                            j.serving_portion = Int(self.cellCollection[5].valueTextField.text!)!
                            j.repast_name = self.cellCollection[6].valueTextField.text!
                            j.comment = self.cellCollection[7].valueTextField.text!
                            self.delegate.editVCSendBack()
                            }
                        }
                    }
            }
        }
        else {
            for i in comingDate.training!.workoutList{
                if(i.workout_name == self.headerTitle){
                    for j in i.exercise_list!{
                        if(j.name == self.instance){
                            j.name = self.cellCollection[0].valueTextField.text!
                            j.repeat_count = Int(self.cellCollection[1].valueTextField.text!)!
                            j.set_count = Int(self.cellCollection[2].valueTextField.text!)!
                            j.energy = Int(self.cellCollection[3].valueTextField.text!)!
                            j.workout_type = self.cellCollection[4].valueTextField.text!
                            j.comment = self.cellCollection[5].valueTextField.text!
                            self.delegate.editVCSendBack()
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func getBack(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
