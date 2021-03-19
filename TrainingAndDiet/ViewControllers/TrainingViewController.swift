//
//  TrainingViewController.swift
//  TrainingAndDiet
//
//  Created by Hüseyin  Gencer on 15.03.2021.
//

import UIKit
import FSCalendar
import LGButton
class TrainingViewController: UIViewController, FSCalendarDelegate {

    @IBOutlet weak var calendar: FSCalendar!
    var formatter = DateFormatter()
    //uygulamaya giriş yapan userı uygulamanın ileri evrelerine aktarabiliyoruz.
    var user : User?
    override func viewDidLoad() {
        super.viewDidLoad()
        calendar.scope = .week
        calendar.locale = Locale(identifier: "tr")
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
    
   //calendara iş yaptıracak fonksiyon bu. Seçildiğinde
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        formatter.dateFormat = "dd-MM-yyyy"
        print(formatter.string(from : date))
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as? SetDietOrTraining
        vc?.presenter = "TrainingViewController"
    }
    @IBAction func setTraining(_ sender: LGButton) {
        self.performSegue(withIdentifier: "toSetTraining", sender: sender)
    }
}
