//
//  SetDietOrTraining.swift
//  TrainingAndDiet
//
//  Created by Hüseyin  Gencer on 18.03.2021.
//

import UIKit
import LGButton

class SetDietOrTraining: UIViewController, UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(tableView == popOverTable){
            if(self.presenter == "TrainingViewController"){
                return antrenmanListesi.count
            }
            else {
                return yemekListesi.count
            }
        }
        else{
            return kahvaltıListesi.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(tableView == popOverTable){
        let cell = popOverTable.dequeueReusableCell(withIdentifier: "popOverCell")!
        
        if(self.presenter == "TrainingViewController"){
            cell.textLabel?.text = antrenmanListesi[indexPath.row]
        }
        else {
            cell.textLabel?.text = yemekListesi[indexPath.row]
        }
        return cell
        }
        let cell2 = UITableViewCell()
        
        return cell2 // Buraya popoverın seçili olduğu hal gelecek
        /*else {
            return UITableViewCell // Buraya popoverın seçili olduğu hal gelecek
        }*/
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(tableView == popOverTable){
        let cell = tableView.cellForRow(at: indexPath)
        popOverButton.titleString = (cell?.textLabel?.text!)!
            popOverButton(popOverButton)
        }
    }
    

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var popOverTable: UITableView!
    @IBOutlet weak var popOverSelected: UITableView!
    @IBOutlet weak var popOverButton: LGButton!
    var antrenmanListesi = ["Ön Kol Antrenmanı", "Arka Kol Antrenmanı", "Sırt Antrenmanı", "Bacak Antrenmanı", "Göğüs Antrenmanı", "Full Body Antrenmanı", "Yürüyüş", "Koşu", "Bisiklet"]
    var yemekListesi = ["Kahvaltı", "Öğle Yemeği", "Akşam Yemeği", "Ara Öğün", "İçecekler"]
    var kahvaltıListesi = ["a","b","c","d","e","f"]
    var presenter : String?
    var popOverCounter = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.layer.cornerRadius = 20
        titleView.layer.cornerRadius = 20
        //self.popOverTable.layer.cornerRadius = 20
        if(presenter == "TrainingViewController"){
            titleView.backgroundColor = UIColor.init(hexString: "65FDC9")
        }
        else {
            titleView.backgroundColor = UIColor(hexString: "94FF8E")
        }
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func popOverButton(_ sender: LGButton) {
        popOverCounter += 1
        if(popOverCounter % 2 != 0){
            popOverTable.isHidden = false
            popOverSelected.backgroundColor = .clear
            popOverButton.rightImageSrc = UIImage(systemName: "arrow.up.square")
        }
        else {
            popOverTable.isHidden = true
            popOverSelected.backgroundColor = .white
            popOverButton.rightImageSrc = UIImage(systemName: "arrow.down.app")

        
        }
    }
    
}
