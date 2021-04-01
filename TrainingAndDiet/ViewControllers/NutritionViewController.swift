//
//  NutritionViewController.swift
//  TrainingAndDiet
//
//  Created by Hüseyin  Gencer on 15.03.2021.
//

import UIKit
import FSCalendar
import LGButton
class NutritionViewController: UIViewController, FSCalendarDelegate, SetDietOrTrainingDelegate,UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "nutritionCell")
        return cell!
    }
    
    func sendDataBack(mealList: [Meal]?, exerciseList: [Exercise]?) {
        for i in mealList!{
            if(self.repastList.count == 0){
                let repast = Repast(repastName: i.repast_name!, mealList: [])
                repast.mealList?.append(i)
                self.repastList.append(repast)
            }
            else{
                for j in repastList{
                    if(j.repastName == i.repast_name){
                        j.mealList?.append(i)
                    }
                    else{
                        let repast = Repast(repastName: i.repast_name!, mealList: [])
                        repast.mealList?.append(i)
                        self.repastList.append(repast)
                    }
                }
            }
        }
        self.nutrition = Nutrition(day: self.day!.day, repastList: self.repastList)
        print(nutrition!.day)
        self.day?.nutrition = self.nutrition!
        var decodedUsers = self.decodedDefaults()
        for var i in decodedUsers!{
            if(self.user?.username == i.username){
                i = self.user!
            }
    }
        self.encodeAndSaveNewUser(userList: decodedUsers!)
        self.tableView.reloadData()
        dismiss(animated: true, completion: nil)
    }
    

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var calendar: FSCalendar!
    //uygulamaya giriş yapan userı uygulamanın ileri evrelerine aktarabiliyoruz.
    var user : User?
    var formatter = DateFormatter()
    var repastList : [Repast] = []
    var nutrition : Nutrition?
    var day : Day?
    var dayList : [Day] = []
    var defaults = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        self.calendar.scope = .week
        calendar.locale = Locale.init(identifier: "tr")
        calendar.delegate = self
        print(self.user?.username)
        
        // Do any additional setup after loading the view.
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
    //calendara seçildiğinde iş yaptıracak delegate fonksiyonu bu
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
        vc?.presenter = "NutritionViewController"
        vc?.delegate = self
        
    }
    @IBAction func setDiet(_ sender: LGButton) {
        if(calendar.selectedDate == nil){
            let alert = UIAlertController(title: nil, message: "Gün seçmeniz gerek", preferredStyle: .alert)
            let action = UIAlertAction(title: "Geri Dön", style: .cancel, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
        self.performSegue(withIdentifier: "toSetDiet", sender: sender)
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
    
    func encodeAndSaveNewUser(userList : [User]?){
        
        if userList != nil{
            let new_encoded_array = try! NSKeyedArchiver.archivedData(withRootObject: userList, requiringSecureCoding: false)
            defaults.set(new_encoded_array, forKey: "userArray")
        }
    }
    
    
}
