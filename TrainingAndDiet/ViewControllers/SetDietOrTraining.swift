import UIKit
import LGButton

class SetDietOrTraining: UIViewController, UITableViewDataSource, UITableViewDelegate,SetDetailViewControllerDelegate {
    //Detail delegate
    func saveSuccesfull() {
        dismiss(animated: true, completion: {
            let alert = UIAlertController(title: "", message: "Seçiminiz Başarıyla Kaydedildi", preferredStyle: .alert)
            self.present(alert, animated: true, completion: nil)
            let duration = DispatchTime.now()+1
            DispatchQueue.main.asyncAfter(deadline: duration){
                alert.dismiss(animated: true, completion: nil)
                for i in 0...self.popOverSelected.indexPathsForSelectedRows!.count-1{
                    let cell = self.popOverSelected.cellForRow(at: self.popOverSelected.indexPathsForSelectedRows![i])
                    let bgColorView = UIView()
                    if(self.presenter == "NutritionViewController"){
                        bgColorView.backgroundColor = UIColor(hexString: "94FF8E")
                        cell?.selectedBackgroundView = bgColorView
                }
                    else{
                        bgColorView.backgroundColor = UIColor(hexString: "65FDC9")
                        cell?.selectedBackgroundView = bgColorView
                    }
                }
                
            }
        })
    }
    func backButton() {
        dismiss(animated: true, completion: nil)
        self.popOverSelected.deselectRow(at: popOverSelected.indexPathForSelectedRow!, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(tableView == popOverTable){
            if(self.presenter == "TrainingViewController"){
                return antrenmanListesi.count
            }
            else {
                return yemekListesi.count
            }
        }
        //Eğer tableview seçili popover ise
        else{
            if(self.presenter == "NutritionViewController"){
                for i in makeEasierNutritionDict.keys{
                    if(i == popOverButton.titleString){
                        return makeEasierNutritionDict[i]!.count
                    }
                }
            }
            else {
                for i in makeEasierTrainingDict.keys{
                    if (i == popOverButton.titleString){
                        return makeEasierTrainingDict[i]!.count
                    }
                }
            }
            return 0
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
        else {
            let cell = popOverSelected.dequeueReusableCell(withIdentifier: "selectedPopOverCell")!
            if(self.presenter == "NutritionViewController"){
            for i in makeEasierNutritionDict.keys{
                if(i == popOverButton.titleString){
                    cell.textLabel?.text = makeEasierNutritionDict[i]![indexPath.row].name
                }
            }
            return cell
            }
            else { //antrenman sayfası için dinamikliği sağlayacağız sonra. Dict ile
                let cell = popOverSelected.dequeueReusableCell(withIdentifier: "selectedPopOverCell")!
                for i in makeEasierTrainingDict.keys{
                    if(i == popOverButton.titleString){
                        cell.textLabel?.text = makeEasierTrainingDict[i]![indexPath.row].name
                    }
                }
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(tableView == popOverTable){
        let cell = tableView.cellForRow(at: indexPath)
        popOverButton.titleString = (cell?.textLabel?.text!)!
            popOverButton(popOverButton)
            popOverSelected.reloadData()
        }
        //popOverSelected tablo hücreleri seçilirse olacak
        else{
            let cell = tableView.cellForRow(at: indexPath)
            self.performSegue(withIdentifier: "showDetailSegue", sender: cell)
        }
        
    }
    
    
    

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var popOverTable: UITableView!
    @IBOutlet weak var popOverSelected: UITableView!
    @IBOutlet weak var popOverButton: LGButton!
    
    @IBOutlet weak var saveButton: LGButton!
    var antrenmanListesi = ["Ön Kol Antrenmanı", "Arka Kol Antrenmanı", "Sırt Antrenmanı", "Bacak Antrenmanı", "Göğüs Antrenmanı", "Yürüyüş", "Koşu", "Bisiklet"]
    var yemekListesi = ["Kahvaltı","Öğle Yemeği","Akşam Yemeği","Ara Öğün","İçecekler"]
    
    var kahvaltıList : [Meal] = []
    var ogleList : [Meal] = []
    var aksamList : [Meal] = []
    var onKolList : [Exercise] = []
    var arkaKolList : [Exercise] = []
    var sırtList : [Exercise] = []
    var bacakList : [Exercise] = []
    var gogusList : [Exercise] = []
    var kosuList : [Exercise] = []
    var yuruyusList : [Exercise] = []
    var bisiklet : [Exercise] = []
    var detailInfo : Bool?
    
    var presenter : String?
    var popOverCounter = 0
    var makeEasierNutritionDict : [String : [Meal]] = [:]
    var makeEasierTrainingDict : [String : [Exercise]] = [:]
    //Dictleri userdefaultsa eklemek için
    let encoder = JSONEncoder()
    let defaults = UserDefaults.standard
    
    //------------------------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.layer.cornerRadius = 20
        titleView.layer.cornerRadius = 20
        //self.popOverTable.layer.cornerRadius = 20
        if(presenter == "TrainingViewController"){
            titleView.backgroundColor = UIColor.init(hexString: "65FDC9")
            saveButton.bgColor = UIColor.init(hexString: "65FDC9")
            popOverButton.titleString = "Ön Kol Antrenmanı"
            genericTrainingList()
        }
        else {
            titleView.backgroundColor = UIColor(hexString: "94FF8E")
            saveButton.bgColor = UIColor.init(hexString: "94FF8E")
            genericNutritionList()
            
        }
        
        
        
        // Do any additional setup after loading the view.
    }
    //-------------------------------------------------------------------
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
    @IBAction func saveButtonTapped(_ sender: LGButton) {
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as? SetDetailViewController
        vc?.counterString = (sender as! UITableViewCell).textLabel?.text
        vc?.presenter = presenter
        vc?.mealOrTraningType = popOverButton.titleString
        vc?.delegate = self
    }
    
    func genericNutritionList(){
        let yumurta = Meal(name: "Yumurta", energy_rate: 200, protein: 6, fat: 1, repast_name: "Kahvaltı")
        yumurta.serving = 1
        yumurta.serving_portion = 60
        self.kahvaltıList.append(yumurta)
        let ekmek = Meal(name: "Ekmek", energy_rate: 100, protein: 2, fat: 5, repast_name: "Genel")
        ekmek.serving = 1
        ekmek.serving_portion = 25
        self.kahvaltıList.append(ekmek)
        let recel = Meal(name: "Reçel", energy_rate: 300, protein: 1, fat: 10, repast_name: "Kahvaltı")
        recel.serving = 1
        recel.serving_portion = 50
        self.kahvaltıList.append(recel)
        
        let tavuk = Meal(name: "Tavuk", energy_rate: 400, protein: 26, fat: 20, repast_name: "Ogle Aksam")
        tavuk.serving = 1
        tavuk.serving = 100
        self.ogleList.append(tavuk)
        let salata = Meal(name: "Salata", energy_rate: 150, protein: 10, fat: 15, repast_name: "Ogle Aksam")
        salata.serving = 1
        salata.serving_portion = 100
        self.ogleList.append(salata)
        let et = Meal(name: "Et", energy_rate: 250, protein: 30, fat: 15, repast_name: "Ogle Aksam")
        et.serving = 1
        et.serving_portion = 100
        self.ogleList.append(et)
        self.ogleList.append(ekmek)
        
        self.aksamList.append(tavuk)
        self.aksamList.append(et)
        self.aksamList.append(ekmek)
        self.aksamList.append(salata)
        makeEasierNutritionDict["Kahvaltı"] = kahvaltıList
        makeEasierNutritionDict["Öğle Yemeği"] = ogleList
        makeEasierNutritionDict["Akşam Yemeği"] = aksamList
        let encodedmakeEasierNutritionDict = try? encoder.encode(makeEasierNutritionDict)
        defaults.set(encodedmakeEasierNutritionDict, forKey: presenter!)
        for i in 0...kahvaltıList.count-1{
            print(kahvaltıList[i].energy_rate as Int)
        }
        
    }
    func genericTrainingList(){
        let A = Exercise(name: "A")
        let B = Exercise(name: "B")
        onKolList.append(A); onKolList.append(B)
        let C = Exercise(name: "C")
        arkaKolList.append(C)
        let D = Exercise(name: "D")
        let E = Exercise(name: "E")
        let F = Exercise(name: "F")
        sırtList.append(D); sırtList.append(E); sırtList.append(F)
        let H = Exercise(name: "H")
        bacakList.append(H)
        let j = Exercise(name: "J")
        let K = Exercise(name: "K")
        gogusList.append(j); gogusList.append(K)
        let hızlıkosu = Exercise(name: "Hızlı Koşu")
        let yavaskosu = Exercise(name: "Yavaş Koşu")
        kosuList.append(hızlıkosu); kosuList.append(yavaskosu)
        let yuruyus = Exercise(name: "Yürüyüş")
        yuruyusList.append(yuruyus)
        let bisikletex = Exercise(name: "Bisiklet")
        bisiklet.append(bisikletex)
        makeEasierTrainingDict["Ön Kol Antrenmanı"] = onKolList
        makeEasierTrainingDict["Arka Kol Antrenmanı"] = arkaKolList
        makeEasierTrainingDict["Sırt Antrenmanı"] = sırtList
        makeEasierTrainingDict["Bacak Antrenmanı"] = bacakList
        makeEasierTrainingDict["Göğüs Antrenmanı"] = gogusList
        makeEasierTrainingDict["Yürüyüş"] = yuruyusList
        makeEasierTrainingDict["Koşu"] = kosuList
        makeEasierTrainingDict["Bisiklet"] = bisiklet
        
        let encodedMakeEasierTrainingDict = try? encoder.encode(makeEasierTrainingDict)
        defaults.set(encodedMakeEasierTrainingDict, forKey: presenter!)
        
    }
}
