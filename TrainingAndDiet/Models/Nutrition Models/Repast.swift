
import Foundation

public class Repast : Codable{
    var repastName : String?
    var mealList : [Meal]?
    
    init(repastName : String, mealList : [Meal]) {
        self.repastName = repastName
        self.mealList = mealList
    }
}
