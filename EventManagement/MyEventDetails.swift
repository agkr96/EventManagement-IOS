
//
//  MyEventDetails.swift


import UIKit

class MyEventDetailVC: UIViewController {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    
    @IBOutlet weak var btnUpdate: UIButton!
    @IBOutlet weak var btnGuestList: UIButton!
    @IBOutlet weak var btnDelete: UIButton!
    
    var data : EventModel!
    
    
    func setUpData() {
        if data != nil {
            self.lblName.text = data.name.description
            self.lblDescription.text = data.description.description
        }
    }
    
    @IBAction func btnClick(_ sender: UIButton) {
        if sender == btnUpdate {
            if let vc = UIStoryboard.main.instantiateViewController(withClass: UpdateEventVC.self){
                vc.data = self.data
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }else if sender == btnGuestList {
            if let vc = UIStoryboard.main.instantiateViewController(withClass: GuestListVC.self) {
                vc.eventName = self.data.name.description
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        }else if sender == btnDelete {
            Alert.shared.showAlert("", actionOkTitle: "Delete", actionCancelTitle: "Cancel", message: deletePopup) { _ in
                self.deleteEvent(data: self.data)
            }
        }
    }
    
    func deleteEvent(data:EventModel) {
        let ref = AppDelegate.shared.db.collection(eEvent).document(data.docID)
        ref.delete(){ err in
            if let err = err {
                print("Error Delete document: \(err)")
                //self.navigationController?.popViewController(animated: true)
            } else {
                print("Document successfully deleted")
                if let vc = UIStoryboard.main.instantiateViewController(withClass: UpdateSucessVC.self) {
                    vc.index = 2
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpData()
    }

}
