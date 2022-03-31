import UIKit

class SideMenuAdminVC: UIViewController, UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arraySideMenuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuTableViewCell") as! SideMenuTableViewCell
        cell.configCell(data: self.arraySideMenuItems[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dismiss(animated: true, completion: nil)
        print(self.selectedOption)
        UIApplication.shared.setAdmin(index: indexPath.row+1)
    }
     //MARK:- Outlet
    @IBOutlet weak var sideMenuTableView :UITableView!
    @IBOutlet weak var btnLogout : UIButton!
    
    //MARK:- Class Variable
    var arraySideMenuItems : [SideMenuItemModel] = []
    var selectedOption = ""
    var delegate: DataEnteredDelegate? = nil
    
    //MARK:- Custom Method
    
    func setUpView(){
        self.applyStyle()
        self.sideMenuTableView.delegate = self
        self.sideMenuTableView.dataSource = self
        
        self.arraySideMenuItems = [
            SideMenuItemModel(image: "homekit", title: "My Events"),
            SideMenuItemModel(image: "homekit", title: "Create New Events"),
            SideMenuItemModel(image: "person.crop.circle.badge.checkmark.fill", title: "Ongoing Events"),
//            SideMenuItemModel(image: "plus.circle.fill", title: "Contact Us"),
        ]
    }
  @IBAction func btnBlankClick(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnSignOutClick(_ sender: Any) {
        UIApplication.shared.setStart()
    }
    
    func applyStyle(){
        self.btnLogout.layer.cornerRadius = 10.0
    }
    
    //MARK:- Action Method
    
    //MARK:- Delegates
    
    //MARK:- UILifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
    }

}

