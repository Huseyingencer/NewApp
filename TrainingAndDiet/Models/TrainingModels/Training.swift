

import Foundation

public class Training : Codable{
    var day : String
    var workoutList : [WorkOutType]
    
    init(day : String, workoutList : [WorkOutType]) {
        self.day = day
        self.workoutList = workoutList
    }
}
