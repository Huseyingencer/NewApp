
import Foundation

public class Day : Codable{
    var day : String
    var nutrition : Nutrition?
    var training : Training?
    var totalBurning : Int?
    var totalFat : Int?
    var totalProtein : Int?
    var totalEarning : Int?
    
    init(day : String) {
        self.day = day
    }
    
    init(day : String, nutrition : Nutrition, training : Training) {
        self.day = day
        self.nutrition = nutrition
        self.training = training
    }
}
