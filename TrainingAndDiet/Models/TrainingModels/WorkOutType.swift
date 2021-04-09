

import Foundation

public class WorkOutType : Codable{
    var workout_name : String?
    var exercise_list : [Exercise]?
    var burningCal : Int? = 0
    
    init(workout_name : String, exercise_list : [Exercise]) {
        self.workout_name = workout_name
        self.exercise_list = exercise_list
    }
}
