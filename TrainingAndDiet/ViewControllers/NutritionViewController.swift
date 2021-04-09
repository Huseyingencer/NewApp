//
//  NutritionViewController.swift
//  TrainingAndDiet
//
//  Created by Hüseyin  Gencer on 15.03.2021.
//

import UIKit
import FSCalendar
import LGButton

protocol DelegateForHomePage{
    func reCalculateValuesForCharts()
}

class NutritionViewController: UIViewController, FSCalendarDelegate, SetDietOrTrainingDelegate,UITableViewDelegate,UITableViewDataSource, EditViewControllerDelegate{
    
    
    func editVCSendBack() {
        encodeDayList()
        tableView.reloadData()
        dismiss(animated: true, completion: {
            let alert = UIAlertController(title: nil, message: "İşlem başarılı", preferredStyle: .actionSheet)
            self.present(alert, animated: true, completion: nil)
            let duration = DispatchTime.now()+1
            DispatchQueue.main.asyncAfter(deadline: duration){
                alert.dismiss(animated: true, completion: nil)
            }
        })
        self.delegate?.reCalculateValuesForCharts()
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let decodedDayList = decodeDayList()
        let sectionNum = self.tableView.numberOfSections
        if(self.selectedDate != nil){
            for i in decodedDayList!{
                if(selectedDate?.day == i.day){
                    for j in 0...(i.nutrition?.repastList?.count)!-1{
                        if(section == j){
                            return i.nutrition!.repastList![j].repastName
                        }
                    }
                }
            }
        }
        return ""
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        let decodedDayList = decodeDayList()
        if(self.selectedDate != nil){
            for i in decodedDayList!{
                if(i.day == self.selectedDate!.day){
                    return i.nutrition!.repastList!.count
                }
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let decodedDayList = decodeDayList()
        let title = self.tableView(tableView, titleForHeaderInSection: section)
        if(self.selectedDate != nil){
            for i in decodedDayList!{
                if(i.day == self.selectedDate!.day){
                    for j in i.nutrition!.repastList!{
                        if(j.repastName == title){
                            return j.mealList!.count
                    }
                }
                }
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let decodedDayList = decodeDayList()
        let sectionNum = tableView.numberOfSections
        var sectionTitles : [String] = []
        var allMealLists : [[Meal]] = []
        
        for m in 0...sectionNum{
            let title = self.tableView(tableView, titleForHeaderInSection: m)!
            if(title != ""){
            sectionTitles.append(title)
        }
    }
        let cell = tableView.dequeueReusableCell(withIdentifier: "nutritionCell")!
        if(self.selectedDate != nil){
            for i in decodedDayList!{
                if(i.day == self.selectedDate!.day){
                    for j in i.nutrition!.repastList!{
                        allMealLists.append(j.mealList!)
                    }
                    
                }
            }
        }
        cell.textLabel!.text = allMealLists[indexPath.section][indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "nutritionEditSegue", sender: tableView.cellForRow(at: indexPath))
    }
    
    func sendDataBack(mealList: [Meal]?, exerciseList: [Exercise]?) {
        for i in mealList!{
            if(self.selectedDate?.nutrition?.repastList!.count == 0){
                let newRepast = Repast(repastName: i.repast_name!, mealList: [])
                newRepast.mealList?.append(i)
                self.selectedDate?.nutrition?.repastList!.append(newRepast)
                print(newRepast.repastName,"workout listesi boştu eklendi")
            }
            else{
                for j in self.selectedDate!.nutrition!.repastList!{
                    if(i.repast_name == j.repastName){
                        j.mealList!.append(i)
                        print(j.mealList!.count )
                        print(j.repastName,"boş değildi buldu")
                        break
                    }
                    else{
                       // counter+=1
                        if(j === self.selectedDate?.nutrition?.repastList!.last){
                            let newRepast = Repast(repastName: i.repast_name!, mealList: [])
                            newRepast.mealList!.append(i)
                            self.selectedDate?.nutrition?.repastList!.append(newRepast)
                            print(newRepast.repastName, "boş değildi bulamadı")
                        }
                    }
                }
                
            }
        }
        self.encodeDayList()
        self.tableView.reloadData()
        self.delegate?.reCalculateValuesForCharts()
        dismiss(animated: true, completion: nil)
    }
    

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var calendar: FSCalendar!
    //uygulamaya giriş yapan userı uygulamanın ileri evrelerine aktarabiliyoruz.
    var user : User?
    var formatter = DateFormatter()
    var repastList : [Repast] = []
    var nutrition : Nutrition?
    var selectedDate : Day?
    var dayList : [Day] = []
    var defaults = UserDefaults.standard
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()
    var delegate : DelegateForHomePage?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.calendar.scope = .week
        calendar.locale = Locale.init(identifier: "tr")
        calendar.delegate = self
        if let dayList = decodeDayList(){
            self.dayList = dayList
        }
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
        var counter : Int = 0
        if(self.dayList.count == 0){
            let newDay = Day(day: dayString, nutrition: Nutrition(day: dayString, repastList: []), training: Training(day: dayString, workoutList: []))
            self.dayList.append(newDay)
            self.selectedDate = newDay
            print(newDay.day,"dayList boş")
        }
        else {
            for i in self.dayList{
                if(i.day == dayString){
                    self.selectedDate = i
                    print(self.selectedDate?.day,"listeden buldu")
                }
                //daylistte seçilen gün yoktur.
                else{
                    counter+=1
                    if(counter == self.dayList.count){
                        let newDay = Day(day: dayString, nutrition: Nutrition(day: dayString, repastList: []), training: Training(day: dayString, workoutList: []))
                        self.dayList.append(newDay)
                        self.selectedDate = newDay
                        print(newDay.day,"liste boş değildi ama içinde bulamadı")
                    }
                }
            }
        }
        self.encodeDayList()
        self.tableView.reloadData()
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "nutritionEditSegue"){
            let vc = segue.destination as? EditViewController
            vc?.comingDate = self.selectedDate
            vc?.instance = tableView.cellForRow(at: tableView.indexPathForSelectedRow!)?.textLabel?.text
            vc?.presenter = "NutritionViewController"
            vc?.headerTitle = tableView(tableView, titleForHeaderInSection: tableView.indexPathForSelectedRow!.section)
            vc?.user = self.user
            vc?.delegate = self
        }
        else{
            let vc = segue.destination as? SetDietOrTraining
            vc?.presenter = "NutritionViewController"
            vc?.delegate = self
        }
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
    
    func decodeDayList() -> [Day]?{
        let userDayList = try defaults.object(forKey: self.user!.username!) as! Data
        do{
            let decodedUserDayList = try self.decoder.decode([Day].self, from: userDayList)
            return decodedUserDayList
        }
        catch{
            print("daylist çevirilirken hata oluştu.")
            return nil
            }
    }
    
    func encodeDayList(){
        do{
            let willEncodingList = try self.encoder.encode(self.dayList) as Data
            let encodedList = try! self.defaults.setValue(willEncodingList, forKey: self.user!.username!)
    }
        catch{
            print("liste encode durumunda hata aldı.")
        }
    }
}
