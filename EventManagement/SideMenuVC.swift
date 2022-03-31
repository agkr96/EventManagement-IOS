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
      
