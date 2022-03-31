
import UIKit

class GuestListVC: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tblEventList: UITableView!

    var eventName: String!
    var arrData = [OrderModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getEventGuestList()
        self.navigationController?.navigationBar.isHidden = true
    }
    
    @objc func cancelledData(_ sender: UIButton){
        self.updateStatus(data: self.arrData[sender.tag], status: eReject)
    }
    
    @objc func confirmData(_ sender: UIButton){
        self.updateStatus(data: self.arrData[sender.tag], status: eConfirm)
    }

}

extension GuestListVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventGuestCell") as! EventGuestCell
        cell.vwCell.isUserInteractionEnabled = true
        let data = self.arrData[indexPath.row]
        cell.configCell(data: data)
        cell.btnAccept.tag = indexPath.row
        cell.btnReject.tag = indexPath.row
        cell.btnReject.addTarget(self, action: #selector(self.cancelledData(_:)), for: .touchUpInside)
        cell.btnAccept.addTarget(self, action: #selector(self.confirmData(_:)), for: .touchUpInside)
        cell.selectionStyle = .none
        return cell
    }
    
    func getEventGuestList() {
        _ = AppDelegate.shared.db.collection(eOrders).whereField(eOUserName, isEqualTo: GFunction.user.userName!).whereField(eEventName, isEqualTo: self.eventName.description).whereField(eStatus, isEqualTo: ePending).addSnapshotListener{ querySnapshot, error in
            
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
                Alert.shared.showAlert(message: "No Guest Found", completion: nil)
            }
        }
    }
    
    func updateStatus(data: OrderModel,status: String){
        let ref = AppDelegate.shared.db.collection(eOrders).document(data.docID)
        ref.updateData([
            eStatus: status
        ]){ err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
                if status == eReject {
                    if let vc = UIStoryboard.main.instantiateViewController(withClass: UpdateSucessVC.self) {
                        vc.index = 2
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }else {
                    UIApplication.shared.setAdmin(index: 1)
                }
            }
        }
    }
}



class EventGuestCell: UITableViewCell {
    //MARK:- Outlets
    @IBOutlet weak var lblName : UILabel!
    @IBOutlet weak var imgCheck : UIImageView!
    @IBOutlet weak var vwCell : UIView!
    @IBOutlet weak var btnReject: UIButton!
    @IBOutlet weak var btnAccept: UIButton!
    
    //MARK:- Class Variables
    
    //MARK:- Custom Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        self.vwCell.layer.cornerRadius = 15
    }
    
    func configCell(data: OrderModel) {
        self.lblName.text = data.userName.description
    }
}
