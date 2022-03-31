
//
//  HomeNav.swift
//  EventManagement

import UIKit

class HomeNav: UINavigationController {

    var index = 1
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if index == 1 {
            if let navigation = UIStoryboard.main.instantiateViewController(withClass: EventsVC.self) {
                self.pushViewController(navigation, animated: true)
            }
        }else if index == 2 {
            if let navigation = UIStoryboard.main.instantiateViewController(withClass: MyBookingVC.self) {
                self.pushViewController(navigation, animated: true)
            }
        }else if index == 4 {
            if let navigation = UIStoryboard.main.instantiateViewController(withClass: ContactUSVC.self) {
                self.pushViewController(navigation, animated: true)
            }
        }
        // Do any additional setup after loading the view.
    }
}
