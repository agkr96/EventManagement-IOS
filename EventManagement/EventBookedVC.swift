
//
//  EventBookedVC.swift


import UIKit

class EventBookedVC: UIViewController {

    @IBOutlet weak var lblBookingID: UILabel!
    @IBOutlet weak var lblEventName: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblPlace: UILabel!
    @IBOutlet weak var btnDashBoard: UIButton!
    
    var data: EventModel!
    var docId: String!
    
    func setUpView(){
        self.btnDashBoard.layer.cornerRadius = 5
    }
    
    func setUpData() {
        if self.data != nil {
            self.lblPlace.text = "Event Place: \(self.data.location.description)"
            self.lblEventName.text = "Event Name: \(self.data.name.description)"
            self.lblDate.text = "Event Date:  \(self.data.date.description) \(self.data.time.description)"
        }
        
        if self.docId != nil  {
            self.lblBookingID.text = "Booking Id: \(self.docId.description)"
        }
    }
    
    @IBAction func btnDashClick(_ sender: UIButton){
        UIApplication.shared.setTab(index: 2)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
        self.setUpData()
        // Do any additional setup after loading the view.
    }

}
