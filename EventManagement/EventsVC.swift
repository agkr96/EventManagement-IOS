
//
//  EventsVC.swift


import UIKit

class EventsVC: UIViewController {

    //MARK:- Outlets
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var btnMenu: UIButton!
    @IBOutlet weak var tblEventList: UITableView!
    
    
    //MARK:- Class Variables
    var arrData = [EventModel]()
    
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
        self.getEventList()
        self.navigationController?.navigationBar.isHidden = true
    }

}

extension EventsVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell") as! EventCell
        
        let data = self.arrData[indexPath.row]
        cell.configCell(data: data)
        cell.vwCell.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer()
        tap.addAction {
            if let vc = UIStoryboard.main.instantiateViewController(withClass: EventDetailsVC.self){
                vc.data = data
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        cell.vwCell.addGestureRecognizer(tap)
        cell.vwCell.isUserInteractionEnabled = true
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = UIStoryboard.main.instantiateViewController(withClass: EventDetailsVC.self){
            vc.data = self.arrData[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}


class EventCell: UITableViewCell {
    //MARK:- Outlets
    @IBOutlet weak var imgView : UIImageView!
    @IBOutlet weak var lblName : UILabel!
    @IBOutlet weak var lblPlace : UILabel!
    @IBOutlet weak var lblTime : UILabel!
    @IBOutlet weak var vwCell : UIView!
    //MARK:- Class Variables
    
    //MARK:- Custom Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        self.vwCell.layer.cornerRadius = 15
    }
    
    func configCell(data :EventModel) {
        self.lblName.text = data.name.description
        self.lblTime.text = "\(data.date.description) \(data.time.description)"
        self.lblPlace.text = data.location.description
    }
    
}


extension EventsVC {
    func getEventList() {
        _ = AppDelegate.shared.db.collection(eEvent).addSnapshotListener{ querySnapshot, error in
            
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            self.arrData.removeAll()
            if snapshot.documents.count != 0 {
                for data in snapshot.documents {
                    let data1 = data.data()
                    if let date : String = data1[eDate] as? String, let name: String = data1[eEventName] as? String, let time: String = data1[eTime] as? String, let userName : String = data1[eUserName] as? String,let location : String = data1[eLocation] as? String,let description: String = data1[eDescription] as? String {
                        print("Data Count : \(self.arrData.count)")
                        self.arrData.append(EventModel(docID: data.documentID, time: time, name: name, date: date, location: location, userName: userName,description: description))
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
