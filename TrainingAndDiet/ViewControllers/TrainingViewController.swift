
import UIKit
import FSCalendar
import LGButton
class TrainingViewController: UIViewController, FSCalendarDelegate, SetDietOrTrainingDelegate, UITableViewDelegate, UITableViewDataSource, EditViewControllerDelegate {
    func editVCSendBack() {
        encodeDayList()
        tableView.reloadData()
        dismiss(animated: true, completion: {let alert = UIAlertController(title: nil, message: "İşlem başarılı", preferredStyle: .actionSheet)
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
        //let sectionNum = self.tableView.numberOfSections
        if(self.selectedDate != nil){
            for i in decodedDayList!{
                if(selectedDate?.day == i.day){
                    for j in 0...i.training!.workoutList.count-1{
                        if(section == j){
                            return i.training?.workoutList[j].workout_name
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
                    return i.training!.workoutList.count
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
                    for j in i.training!.workoutList{
                        if(j.workout_name == title){
                            return j.exercise_list!.count
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
        var allExerciseLists : [[Exercise]] = []
        
        for m in 0...sectionNum{
            let title = self.tableView(tableView, titleForHeaderInSection: m)!
            if(title != ""){
            sectionTitles.append(title)
        }
    }
        let cell = tableView.dequeueReusableCell(withIdentifier: "trainingCell")!
        if(self.selectedDate != nil){
            for i in decodedDayList!{
                if(i.day == self.selectedDate!.day){
                    for j in i.training!.workoutList{
                        allExerciseLists.append(j.exercise_list!)
                    }
                    
                }
                
            }
        }
        cell.textLabel!.text = allExerciseLists[indexPath.section][indexPath.row].name
        print(indexPath.row,"indexpath", indexPath.section,"section")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "trainingEditSegue", sender: tableView.cellForRow(at: indexPath))
    }
    
    
    func sendDataBack(mealList: [Meal]?, exerciseList: [Exercise]?) {
        var counter : Int = 0
        for i in exerciseList!{
            if(self.selectedDate?.training?.workoutList.count == 0){
                let newWorkOut = WorkOutType(workout_name: i.workout_type!, exercise_list: [])
                newWorkOut.exercise_list?.append(i)
                self.selectedDate?.training?.workoutList.append(newWorkOut)
                print(newWorkOut.workout_name,"workout listesi boştu eklendi")
            }
            else{
                for j in self.selectedDate!.training!.workoutList{
                    if(i.workout_type == j.workout_name){
                        j.exercise_list?.append(i)
                        print(j.workout_name,"boş değildi buldu")
                        break
                    }
                    else {
                        counter+=1
                        if(j === self.selectedDate?.training?.workoutList.last){
                            let newWorkOut = WorkOutType(workout_name: i.workout_type!, exercise_list: [])
                            newWorkOut.exercise_list?.append(i)
                            self.selectedDate?.training?.workoutList.append(newWorkOut)
                            print(newWorkOut.workout_name, "boş değildi bulamadı")
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
    //delegate sonu
    

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var calendar: FSCalendar!
    var formatter = DateFormatter()
    //uygulamaya giriş yapan userı uygulamanın ileri evrelerine aktarabiliyoruz.
    var user : User?
    var workOutTypeList : [WorkOutType] = []
    var training : Training?
    let defaults = UserDefaults.standard
    let decoder = JSONDecoder()
    let encoder = JSONEncoder()
    var dayList : [Day] = []
    var selectedDate : Day?
    var delegate : DelegateForHomePage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendar.scope = .week
        calendar.locale = Locale(identifier: "tr")
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
    
   //calendara iş yaptıracak fonksiyon bu. Seçildiğinde
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
        if(segue.identifier == "trainingEditSegue"){
            let vc = segue.destination as! EditViewController
            vc.comingDate = self.selectedDate
            vc.instance = tableView.cellForRow(at: tableView.indexPathForSelectedRow!)?.textLabel?.text
            vc.presenter = "TrainingViewController"
            vc.headerTitle = tableView(tableView, titleForHeaderInSection: tableView.indexPathForSelectedRow!.section)
            vc.user = self.user
            vc.delegate = self
        }
        else{
            let vc = segue.destination as? SetDietOrTraining
            vc!.presenter = "TrainingViewController"
            vc!.delegate = self
        }
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
