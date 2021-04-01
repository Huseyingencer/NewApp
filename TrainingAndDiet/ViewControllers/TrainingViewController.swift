//
//  TrainingViewController.swift
//  TrainingAndDiet
//
//  Created by Hüseyin  Gencer on 15.03.2021.
//

import UIKit
import FSCalendar
import LGButton
class TrainingViewController: UIViewController, FSCalendarDelegate, SetDietOrTrainingDelegate {
    
    func sendDataBack(mealList: [Meal]?, exerciseList: [Exercise]?) {
        for i in exerciseList!{
            if(self.workOutTypeList.count == 0){
                let workOutType = WorkOutType(workout_name: i.workout_type!, exercise_list: [])
                workOutType.exercise_list?.append(i)
                self.workOutTypeList.append(workOutType)
            }
            else{
                for j in workOutTypeList{
                    if(j.workout_name == i.workout_type){
                        j.exercise_list?.append(i)
                    }
                    else{
                        let workOutType = WorkOutType(workout_name: i.workout_type!, exercise_list: [])
                        workOutType.exercise_list?.append(i)
                        self.workOutTypeList.append(workOutType)
                    }
                }
            }
        }
        
        self.training = Training(day: self.day!.day, workoutList: self.workOutTypeList)
        print(training!.day)
        self.day?.training = self.training
       
        var decodedUsers = self.decodedDefaults()
        for var i in decodedUsers!{
            if(self.user?.username == i.username){
                i = self.user!
            }
    }
        self.encodeAndSaveNewUser(userList: decodedUsers!)
        dismiss(animated: true, completion: nil)
    }
    //delegate sonu
    

    @IBOutlet weak var calendar: FSCalendar!
    var formatter = DateFormatter()
    //uygulamaya giriş yapan userı uygulamanın ileri evrelerine aktarabiliyoruz.
    var user : User?
    var newDayList : [Day]? = []
    var day : Day?
    var dayList : [Day] = []
    var workOutTypeList : [WorkOutType] = []
    var training : Training?
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendar.scope = .week
        calendar.locale = Locale(identifier: "tr")
        calendar.delegate = self
    }
    
    @IBAction func setCalendarScope(_ sender: UIButton) {
        if(calendar.scope == .week){
            calendar.scope = .month
            sender.setTitle("Takvimi Kapat", for: .normal)
        }
        else {
            calendar.scope = .week
            sender.setTitle("Takvimi Aç", for: .normal)
        }
    }
    
   //calendara iş yaptıracak fonksiyon bu. Seçildiğinde
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        formatter.dateFormat = "dd-MM-yyyy"
        let dayString : String = formatter.string(from: date)
        print(dayString)
        if (user!.day!.count == 0){
            let day = Day(day: dayString)
            self.day = day
            user?.day?.append(self.day!)
        }
        else{
            for j in user!.day!{
                if(j.day == dayString){
                    self.day = j
                }
                else{
                    let day = Day(day : dayString)
                    self.day = day
                    user!.day!.append(self.day!)
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as? SetDietOrTraining
        vc!.presenter = "TrainingViewController"
        vc!.delegate = self
    }
    @IBAction func setTraining(_ sender: LGButton) {
        if(calendar.selectedDate == nil){
            let alert = UIAlertController(title: nil, message: "Gün seçmeniz gerek", preferredStyle: .alert)
            let action = UIAlertAction(title: "Geri Dön", style: .cancel, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
        self.performSegue(withIdentifier: "toSetTraining", sender: sender)
    }
    
    func decodedDefaults() -> [User]?{
        if let userArray = try? defaults.object(forKey: "userArray") as? Data{
            var decodedUserArray = NSKeyedUnarchiver.unarchiveObject(with: userArray) as! [User]
            
            return decodedUserArray
        }
        else{
            return nil
        }
    }
    
    func encodeAndSaveNewUser(userList : [User]){
        
        if userList != nil{
            let new_encoded_array = try! NSKeyedArchiver.archivedData(withRootObject: userList, requiringSecureCoding: false)
            defaults.set(new_encoded_array, forKey: "userArray")
        }
    }
    
    
}
