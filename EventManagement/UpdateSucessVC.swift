import UIKit

class UpdateSucessVC: UIViewController {

    @IBOutlet weak var btnHome: UIButton!
    
    @IBOutlet weak var lblTitle: UILabel!
    
    
    var index: Int = 0
    
    @IBAction func btnHomeClick(_ sender: UIButton) {
        UIApplication.shared.setAdmin(index: 1)
    }
    
    func setUpView(){
        self.lblTitle.text = index == 0 ? (eUpdateEvent) : (index == 1 ? eDeleteEvent : eUserBlock)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.btnHome.layer.cornerRadius = 5
        self.setUpView()
        // Do any additional setup after loading the view.
    }

}
