
import Foundation

public class Nutrition : Codable {
    var day : String
    var repastList : [Repast]?
    
    init(day : String, repastList : [Repast]) {
        self.day = day
        self.repastList = repastList
    }
}
