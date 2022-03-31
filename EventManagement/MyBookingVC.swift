
//
//  MyBookingVC.swift


import UIKit

class MyBookingVC: UIViewController {

    //MARK:- Outlets
    @IBOutlet weak var btnMenu: UIButton!
    @IBOutlet weak var tblEventList: UITableView!
    
    
    //MARK:- Class Variables
    var arrData = [OrderModel]()
    //MARK:- Custom Methods
    
    //MARK:- Action Methods
    @IBAction func btnMenuClick(_ sender: Any) {
        if let vc = UIStoryboard.main.instantiateViewController(withClass: SideMenuVC.self) {
            vc.modalPresentationStyle = .overFullScreen
            present(vc, animated: true, completion: nil)
        }
    }
    
    //MARK:- ViewLifeCycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.btnMenu.layer.borderColor = UIColor.lightGray.cgColor
        self.btnMenu.layer.borderWidth = 1
        self.btnMenu.layer.cornerRadius = 3
//        self.tblEventList.delegate = self
//        self.tblEventList.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getBookedEventList()
        self.navigationController?.navigationBar.isHidden = true
    }

}

extension MyBookingVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventBookedCell") as! EventBookedCell
        cell.configCell(data: self.arrData[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        self.dismiss(animated: true, completion: nil)
//        self.selectedOption = self.arraySideMenuItems[indexPath.row].title
//        delegate?.userDidSelectMenu(selectedMenu: self.selectedOption)
//        print(self.selectedOption)
//    }
}


class EventBookedCell: UITableViewCell {
    
    //MARK:- Outlets
    @IBOutlet weak var imgView : UIImageView!
    @IBOutlet weak var lblName : UILabel!
    @IBOutlet weak var lblTime : UILabel!
    @IBOutlet weak var lblStatus : UILabel!
    @IBOutlet weak var vwCell : UIView!
    //MARK:- Class Variables
    
    //MARK:- Custom Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        self.vwCell.layer.cornerRadius = 20
    }
    
    func configCell(data: OrderModel){
        self.lblTime.text = data.date.description
        self.lblName.text = data.name.description
        self.lblStatus.text = data.status.description
    }
    
}


extension MyBookingVC {
    func getBookedEventList() {
        _ = AppDelegate.shared.db.collection(eOrders).whereField(eUserName, isEqualTo: GFunction.user.userName.description).addSnapshotListener{ querySnapshot, error in
            
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            self.arrData.removeAll()
            if snapshot.documents.count != 0 {
                for data in snapshot.documents {
                    let data1 = data.data()
                    if let date : String = data1[eDate] as? String, let name: String = data1[eEventName] as? String, let time: String = data1[eTime] as? String, let userName : String = data1[eUserName] as? String,let location : String = data1[eLocation] as? String,let status: String = data1[eStatus] as? String {
                        print("Data Count : \(self.arrData.count)")
                        self.arrData.append(OrderModel(docID: data.documentID, time: time, name: name, date: date, location: location, userName: userName,status: status))
                    }
                }
                self.tblEventList.delegate = self
                self.tblEventList.dataSource = self
                self.tblEventList.reloadData()
            }else{
                Alert.shared.showAlert(message: "No Event Found", completion: nil)
            }
        }
    }
}
