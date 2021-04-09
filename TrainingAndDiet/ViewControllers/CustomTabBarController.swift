
import Foundation
import UIKit

class CustomTabBarController : UITabBarController{
    
    @IBInspectable var default_index : Int = 0
    
    override func viewDidLoad() {
        self.selectedIndex = default_index
    }
}
