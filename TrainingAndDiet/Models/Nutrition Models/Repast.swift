
import Foundation

public class Repast : Codable{
    var repastName : String?
    var mealList : [Meal]?
    var earningCal = 0
    
    init(repastName : String, mealList : [Meal]) {
        self.repastName = repastName
        self.mealList = mealList
    }
}
