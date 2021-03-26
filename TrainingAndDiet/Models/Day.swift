
import Foundation

public class Day : Codable{
    var day : String
    var nutrition : Nutrition?
    var training : Training?
    
    init(day : String) {
        self.day = day
    }
}
