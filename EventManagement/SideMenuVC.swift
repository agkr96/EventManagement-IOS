import UIKit
import SideMenu

// protocol used for sending data back
protocol DataEnteredDelegate {
    func userDidSelectMenu(selectedMenu: String)
}

class SideMenuItemModel {
    var image : String
    var title : String
    
    init(image:String,title:String) {
        self.image = image
        self.title = title
    }
}

class SideMenuTableViewCell : UITableViewCell {
    @IBOutlet weak var imgView : UIImageView!
    @IBOutlet weak var lblName : UILabel!
    
    
     override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configCell(data:SideMenuItemModel) {
      //  self.imgView.image = UIImage(systemName: data.image)
        self.lblName.text = data.title
    }
}

class SideMenuVC: UIViewController , UITableViewDelegate,UITableViewDataSource{
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
        UIApplication.shared.setTab(index: indexPath.row+1)
//        self.selectedOption = self.arraySideMenuItems[indexPath.row].title
//        delegate?.userDidSelectMenu(selectedMenu: 
      self.selectedOption)
        
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
            SideMenuItemModel(image: "homekit", title: "Events"),
            SideMenuItemModel(image: "person.crop.circle.badge.checkmark.fill", title: "My Bookings"),
//            SideMenuItemModel(image: "plus.circle.fill", title: "My Profile"),
            SideMenuItemModel(image: "plus.circle.fill", title: "Contact Us"),
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
