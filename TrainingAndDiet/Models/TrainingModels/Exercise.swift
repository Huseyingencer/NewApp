
import Foundation


public class Exercise : Codable{
    static var class_id : Int = 0
    var exercise_id : Int?
    var name : String?
    var repeat_count : Int?
    var set_count : Int?
    var energy : Int?
    var workout_type : String?
    var comment : String?
    
    init(name : String, _ energy : Int) {
        Exercise.class_id += 1
        self.exercise_id = Exercise.class_id
        self.name = name
        self.energy = energy
    }
    
    init(name : String, repeat_count : Int, set_count : Int,energy : Int, workout_type : String, comment : String?) {
        self.name = name
        self.repeat_count = repeat_count
        self.set_count = set_count
        self.workout_type = workout_type
        self.energy = energy
        if comment != nil{
            self.comment = comment
        }
        else {
            self.comment = ""
        }
        
    }
}
