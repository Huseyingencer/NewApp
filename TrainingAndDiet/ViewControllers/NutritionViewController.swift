//
//  NutritionViewController.swift
//  TrainingAndDiet
//
//  Created by Hüseyin  Gencer on 15.03.2021.
//

import UIKit
import FSCalendar
import LGButton
class NutritionViewController: UIViewController, FSCalendarDelegate {

    @IBOutlet weak var calendar: FSCalendar!
    //uygulamaya giriş yapan userı uygulamanın ileri evrelerine aktarabiliyoruz.
    var user : User?
    var formatter = DateFormatter()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.calendar.scope = .week
        calendar.locale = Locale.init(identifier: "tr")
        calendar.delegate = self
        
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
        formatter.dateFormat = "dd-mm-yyyy"
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as? SetDietOrTraining
        vc?.presenter = "NutritionViewController"
    }
    @IBAction func setDiet(_ sender: LGButton) {
        self.performSegue(withIdentifier: "toSetDiet", sender: sender)
    }
}
