
import UIKit

class AdminHomeNav: UINavigationController {
    
    var index = 1
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if index == 1 {
            if let navigation = UIStoryboard.main.instantiateViewController(withClass: MyEventListVC.self) {
                self.pushViewController(navigation, animated: true)
            }
        }else if index == 2 {
            if let navigation = UIStoryboard.main.instantiateViewController(withClass: CreateEventVC.self) {
                self.pushViewController(navigation, animated: true)
            }
        }else if index == 3 {
            if let navigation = UIStoryboard.main.instantiateViewController(withClass: OngoingEventVC.self) {
                self.pushViewController(navigation, animated: true)
            }
        }
        // Do any additional setup after loading the view.
    }
}
