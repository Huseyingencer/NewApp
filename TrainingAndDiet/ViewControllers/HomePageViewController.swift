
import UIKit
import FSCalendar
import Charts


class HomePageViewController: UIViewController, FSCalendarDelegate, DelegateForHomePage {
    func reCalculateValuesForCharts() {
        print("homepagedelegate")
    }
    
    //uygulamaya giriş yapan userı uygulamanın ileri evrelerine aktarabiliyoruz.
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var barChartView: BarChartView!
    @IBOutlet weak var pieChartViewForBurning: PieChartView!
    @IBOutlet weak var pieChartViewForEarning: PieChartView!
    @IBOutlet weak var pieChartForNutritiveValues: PieChartView!
    @IBOutlet weak var tapGestureForNutritiveChart: UITapGestureRecognizer!
    var defaults = UserDefaults.standard
    var user : User?
    var selectedDayList : [Day] = []
    var repastList : [Repast] = []
    var workOutList : [WorkOutType] = []
    var tapCounterForCharts = 0
    let nutritionVC = NutritionViewController()
    let trainingVC = TrainingViewController()
    var willNutritiveChartActive : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.calendar.scope = .week
        self.calendar.locale = Locale.init(identifier: "tr")
        self.calendar.delegate = self
        self.calendar.allowsMultipleSelection = true
        self.barChartView.noDataText = "Bar Grafiği İçin Gösterilecek Bilgi Yok."
        self.barChartView.backgroundColor = .white
        self.pieChartViewForBurning.noDataText = "Dilim Grafiği İçin Gösterilecek Bilgi Yok."
        nutritionVC.delegate = self
        trainingVC.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if(self.user?.enter_counter == 1){
            let alertController = UIAlertController(title: "Bilgilendirme", message: "Takvimden gün seçtiğinizde grafikler açılacaktır. Çoklu gün seçimi yapabilirsiniz.", preferredStyle: .actionSheet)
            let action = UIAlertAction(title: "Anladım", style: .default, handler: nil)
            alertController.addAction(action)
            self.present(alertController, animated: true, completion: nil)
            print(user?.enter_counter,"anasayfada")
        }
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let formatter = DateFormatter()
        var counter = 0
        formatter.dateFormat = "dd-MM-yyyy"
        let dayString = formatter.string(from: date)
        if let dayList = decodeDayList(){
            for i in dayList{
                if(i.day == dayString){
                    counter+=1
                    self.selectedDayList.append(i)
                    calculateEarningCal()
                    calculateBurningCal()
                    calculateBurningCalForPieChart()
                    calculateEarningCalForPieChart()
                    print("güne ulaşıldı")
                    self.setBarChart()
                    self.setPieChartForBurningActivities()
                    self.setPieChartEarningActivities()
                    if(self.willNutritiveChartActive == true){
                        self.setPieChartNutritiveValues()
                    }
                }
            }
            
            if(counter == 0){
                let alert = UIAlertController(title: "", message: (dayString + " ile ilgili bilgi yok."), preferredStyle: .alert)
                self.present(alert, animated: true, completion: nil)
                let duration = DispatchTime.now() + 1
                DispatchQueue.main.asyncAfter(deadline: duration, execute: {
                    self.dismiss(animated: true, completion: nil)
                })
                self.calendar(self.calendar, didDeselect: date, at: monthPosition)
                print("güne ulaşamadık")
            }
        }
        else{
            print("Gün Listesine ulaşamadık")
        }
    }
    
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        let dayString = formatter.string(from: date)
        for i in self.selectedDayList{
                if (i.day == dayString){
                    if let index = self.selectedDayList.firstIndex(where: { $0 === i}){
                        self.selectedDayList.remove(at: index)
                        if(self.selectedDayList.count != 0){
                            self.setBarChart()
                            self.setPieChartForBurningActivities()
                            self.setPieChartEarningActivities()
                            self.setPieChartNutritiveValues()
                        }
                        else{
                            self.barChartView.clear()
                            self.pieChartViewForBurning.clear()
                            self.pieChartViewForEarning.clear()
                            self.pieChartForNutritiveValues.clear()
                        }
                }
            }
        }
        calendar.deselect(date)
    }
    
    @IBAction func setCalendarScope(_ sender: UIButton) {
        if(self.calendar.scope == .week){
            self.calendar.scope = .month
        }
        else{
            self.calendar.scope = .week
        }
    }
    
    func decodeDayList() -> [Day]?{
        let decoder = JSONDecoder()
        let dayList = try self.defaults.object(forKey: user!.username!) as! Data
        do{
        let decodedDayList = try decoder.decode([Day].self, from: dayList)
            return decodedDayList
        }
        catch{
            return nil
        }
    }
    
    func calculateEarningCal() {
        for i in self.selectedDayList{
            var totalEarning = 0
            var totalProtein = 0
            var totalFat = 0
            for j in i.nutrition!.repastList!{
                for k in j.mealList!{
                    totalEarning += k.energy_rate * k.serving
                    totalProtein += k.protein * k.serving
                    totalFat += k.fat * k.serving
                    i.totalEarning = totalEarning
                    i.totalProtein = totalProtein
                    i.totalFat = totalFat
                }
            }
            print(i.day,"gününde ",totalEarning,"kalori alındı, ", totalProtein, "protein alındı, ", totalFat, "yağ alındı.")
        }
    }
    
    func calculateBurningCal(){
        for i in self.selectedDayList{
            var totalBurning = 0
            for j in i.training!.workoutList{
                for k in j.exercise_list!{
                    totalBurning += k.energy! * k.repeat_count! * k.set_count!
                    i.totalBurning = totalBurning
                }
            }
            print(i.day,"gününde ", "toplam yakılan kalori", totalBurning)
        }
    }
    
    func calculateBurningCalForPieChart(){
        for i in self.selectedDayList{
            for j in i.training!.workoutList{
                self.workOutList.append(j)
                var totalWorkoutBurning = 0
                for k in j.exercise_list!{
                    totalWorkoutBurning += k.energy! * k.repeat_count! * k.set_count!
                    j.burningCal = totalWorkoutBurning
                    print(j.burningCal!,"toplam yakılan", j.workout_name,"antrenman tipi")
                }
                
            }
        }
    }
    
    func calculateEarningCalForPieChart(){
        for i in self.selectedDayList{
            for j in i.nutrition!.repastList!{
                self.repastList.append(j)
                var totalRepastEarning = 0
                for k in j.mealList!{
                    totalRepastEarning += k.energy_rate * k.serving
                    j.earningCal = totalRepastEarning
                }
            }
        }
    }
    
    func setBarChart(){
        var burningDataEntries : [BarChartDataEntry] = []
        var earningDataEntries : [BarChartDataEntry] = []
        var dayListDays : [String] = []
        var totalBurningValues : [Int] = []
        var totalEarningValues : [Int] = []
        var maxValue = 0
        
        guard self.selectedDayList.count != 0 else{
            return
        }
        for i in 0...self.selectedDayList.count-1{
            dayListDays.append(self.selectedDayList[i].day)
            if(self.selectedDayList[i].totalBurning != nil && self.selectedDayList[i].totalEarning != nil){
                totalBurningValues.append(self.selectedDayList[i].totalBurning!)
                totalEarningValues.append(self.selectedDayList[i].totalEarning!)
            }
            else{
                totalEarningValues.append(self.selectedDayList[i].totalEarning ?? 0)
                totalBurningValues.append(self.selectedDayList[i].totalBurning ?? 0)
            }
        }
        for i in totalBurningValues{
            if(i >= maxValue){
                maxValue = i
            }
        }
        for i in totalEarningValues{
            if(i >= maxValue){
                maxValue = i
            }
        }
        for i in 0...dayListDays.count-1{
            let burningValueEntry = BarChartDataEntry(x: Double(i), y: Double(totalBurningValues[i]))
            let earningValueEntry = BarChartDataEntry(x: Double(i), y: Double(totalEarningValues[i]))
            burningDataEntries.append(burningValueEntry)
            earningDataEntries.append(earningValueEntry)
        }
        let chartDataSetForBurning = BarChartDataSet(entries: burningDataEntries, label: "Yakılan Toplam Kalori")
        let chartDataSetForEarning = BarChartDataSet(entries: earningDataEntries, label: "Alınan Toplam Kalori")
        let chartData = BarChartData(dataSets: [chartDataSetForBurning,chartDataSetForEarning])
        let groupSpace = 0.3
        chartDataSetForBurning.colors = [UIColor(hexString: "65FDC9")]
        chartDataSetForEarning.colors = [UIColor(hexString: "94FF8E")]
                let barSpace = 0.05
                let barWidth = 0.3
                // (0.3 + 0.05) * 2 + 0.3 = 1.00 -> interval per "group"s
                let groupCount = self.selectedDayList.count
                let startYear = 0
                chartData.barWidth = barWidth;
                barChartView.xAxis.axisMinimum = Double(startYear)
                let gg = chartData.groupWidth(groupSpace: groupSpace, barSpace: barSpace)
                print("Groupspace: \(gg)")
                barChartView.xAxis.axisMaximum = Double(startYear) + gg * Double(groupCount)
                chartData.groupBars(fromX: Double(startYear), groupSpace: groupSpace, barSpace: barSpace)
                //barChartView.notifyDataSetChanged()
                barChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: dayListDays)
                barChartView.xAxis.granularity = 1
                barChartView.leftAxis.axisMinimum = 0
                barChartView.leftAxis.axisMaximum = Double(maxValue + 50)
                barChartView.rightAxis.drawAxisLineEnabled = false
                barChartView.rightAxis.drawGridLinesEnabled = false
                barChartView.rightAxis.enabled = false
                barChartView.xAxis.labelPosition = .bottom
                barChartView.leftAxis.drawAxisLineEnabled = false
                barChartView.leftAxis.drawGridLinesEnabled = false
                barChartView.leftAxis.gridColor = NSUIColor.clear
                barChartView.xAxis.drawGridLinesEnabled = false
                barChartView.data = chartData
                barChartView.animate(xAxisDuration: 0.5, yAxisDuration : 1, easingOption: .easeOutSine)
    }
    func setPieChartForBurningActivities(){
        var dataEntries : [PieChartDataEntry] = []
        var workOutBurningValues : [Int] = []
        var workOutNameList : [String] = []
        
        guard self.selectedDayList.count != 0 else{
            return
        }
        for i in self.selectedDayList{
            for j in i.training!.workoutList{
                if(workOutNameList.count == 0){
                    workOutNameList.append(j.workout_name!)
                    workOutBurningValues.append(j.burningCal!)
                }
                else{
                    for k in workOutNameList{
                        if(k == j.workout_name){
                            let index = workOutNameList.firstIndex(where: {$0 == j.workout_name})
                            workOutBurningValues[index!]+=j.burningCal!
                            break
                        }
                        else if(k == workOutNameList.last){
                            workOutNameList.append(j.workout_name!)
                            workOutBurningValues.append(j.burningCal!)
                        }
                    }
                }
            }
        }
        guard (workOutNameList.count != 0) else{
            return
        }
        for i in 0...workOutNameList.count-1{
            let burningValueEntry = PieChartDataEntry()
            burningValueEntry.label = workOutNameList[i]
            burningValueEntry.value = Double(workOutBurningValues[i])
            dataEntries.append(burningValueEntry)
        }
        let chartDataSet = PieChartDataSet(entries: dataEntries, label: "")
        var colors : [UIColor] = []
        for _ in 0...workOutNameList.count {
                let red = Double(arc4random_uniform(256))
                let green = Double(arc4random_uniform(256))
                let blue = Double(arc4random_uniform(256))
                let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
                colors.append(color)
            }
        chartDataSet.colors = colors
        let chartData = PieChartData(dataSet: chartDataSet)
        pieChartViewForBurning.data = chartData
        pieChartViewForBurning.animate(yAxisDuration: 0.5, easing: .none)
    }
    
    func setPieChartEarningActivities(){
        var dataEntries : [PieChartDataEntry] = []
        var repastEarningValues : [Int] = []
        var repastNameList : [String] = []
        
        
        guard self.selectedDayList.count != 0 else{
            return
        }
        for i in self.selectedDayList{
            for j in i.nutrition!.repastList!{
                if(repastNameList.count == 0){
                    repastNameList.append(j.repastName!)
                    repastEarningValues.append(j.earningCal)
                }
                else{
                    for k in repastNameList{
                        if(k == j.repastName){
                            let index = repastNameList.firstIndex(where: {$0 == j.repastName})
                            repastEarningValues[index!]+=j.earningCal
                            break
                        }
                        else if(k == repastNameList.last){
                            repastNameList.append(j.repastName!)
                            repastEarningValues.append(j.earningCal)
                        }
                    }
                }
            }
        }
        guard (repastNameList.count != 0) else{
            return
        }
        for i in 0...repastNameList.count-1{
            let earningValueEntry = PieChartDataEntry()
            earningValueEntry.label = repastNameList[i]
            earningValueEntry.value = Double(repastEarningValues[i])
            dataEntries.append(earningValueEntry)
        }
        let chartDataSet = PieChartDataSet(entries: dataEntries, label: "")
        var colors : [UIColor] = []
        for _ in 0...repastNameList.count {
                let red = Double(arc4random_uniform(256))
                let green = Double(arc4random_uniform(256))
                let blue = Double(arc4random_uniform(256))
                let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
                colors.append(color)
            }
        chartDataSet.colors = colors
        let chartData = PieChartData(dataSet: chartDataSet)
        pieChartViewForEarning.data = chartData
        pieChartViewForEarning.animate(yAxisDuration: 0.5, easing: .none)
        
    }
    
    func setPieChartNutritiveValues(){
        guard self.selectedDayList.count == 1 else{
            let formatter = DateFormatter()
            formatter.dateFormat = "dd-MM-yyyy"
            let alert = UIAlertController(title: "Grafik Hatası", message: "Bu Grafiği Görmek İçin Yalnızca Bir Gün Seçmeniz Gerekli.İlk Seçiminiz Hesaplanacaktır.", preferredStyle: .alert)
            let actionAccept = UIAlertAction(title: "Onayla", style: .cancel, handler: {_ in
                for i in 1...self.selectedDayList.count-1{
                    let dayString = self.selectedDayList[i].day
                    let date = formatter.date(from: dayString)
                    self.calendar(self.calendar, didDeselect: date!, at: .current)
                }
            })
            let actionDenied = UIAlertAction(title: "Reddet", style: .default, handler: { [self] _ in
                pieChartNutritiveValuesTapped(self.tapGestureForNutritiveChart)
            })
            alert.addAction(actionAccept)
            alert.addAction(actionDenied)
            self.present(alert, animated: true, completion: nil)
            return
        }
        var dataEntries : [PieChartDataEntry] = []
        let nutritiveNameList : [String] = ["Toplam Kalori", "Toplam Protein", "Toplam Yağ"]
        let nutritiveValuesList : [Int] = [
            self.selectedDayList.first!.totalEarning!,
            self.selectedDayList.first!.totalProtein!,
            self.selectedDayList.first!.totalFat!
        ]
        for i in 0...nutritiveNameList.count-1{
            let dataEntry = PieChartDataEntry()
            dataEntry.label = nutritiveNameList[i]
            dataEntry.value = Double(nutritiveValuesList[i])
            dataEntries.append(dataEntry)
        }
        let chartDataSet = PieChartDataSet(entries: dataEntries, label: "")
        var colors : [UIColor] = []
        for _ in 0...nutritiveNameList.count {
                let red = Double(arc4random_uniform(256))
                let green = Double(arc4random_uniform(256))
                let blue = Double(arc4random_uniform(256))
                let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
                colors.append(color)
            }
        chartDataSet.colors = colors
        let chartData = PieChartData(dataSet: chartDataSet)
        pieChartForNutritiveValues.data = chartData
        pieChartForNutritiveValues.animate(yAxisDuration: 0.5, easing: .none)
        
    }
    
    @IBAction func barChartTapped(_ sender: UITapGestureRecognizer) {
        print("tapped")
        setPieChartForBurningActivities()
        self.pieChartViewForBurning.isHidden = false
        self.pieChartViewForEarning.isHidden = true
        self.barChartView.isHidden = true
        self.pieChartForNutritiveValues.isHidden = true
    }
    
    @IBAction func pieChartBurningTapped(_ sender: UITapGestureRecognizer) {
        setPieChartEarningActivities()
        self.pieChartViewForBurning.isHidden = true
        self.barChartView.isHidden = true
        self.pieChartForNutritiveValues.isHidden = true
        self.pieChartViewForEarning.isHidden = false
        
    }
    @IBAction func pieChartEarningTapped(_ sender: UITapGestureRecognizer) {
        setPieChartNutritiveValues()
        self.pieChartViewForBurning.isHidden = true
        self.pieChartViewForEarning.isHidden = true
        self.barChartView.isHidden = true
        self.pieChartForNutritiveValues.isHidden = false
        self.willNutritiveChartActive = true
    }
    @IBAction func pieChartNutritiveValuesTapped(_ sender: UITapGestureRecognizer) {
        setBarChart()
        self.pieChartViewForBurning.isHidden = true
        self.pieChartViewForEarning.isHidden = true
        self.pieChartForNutritiveValues.isHidden = true
        self.barChartView.isHidden = false
        self.willNutritiveChartActive = false
    }
}
