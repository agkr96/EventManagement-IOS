import UIKit

class ContactUSVC: UIViewController {

    //MARK:- Outlets
    @IBOutlet weak var btnMenu: UIButton!
    @IBOutlet weak var vwMain: UIView!
    @IBOutlet weak var vwDetails: UIView!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var tvMessage: UITextView!
    //MARK:- Class Variables
    
    //MARK:- Custom Methods
    func setUpView() {
        self.tvMessage.layer.borderColor = UIColor.colorLine.cgColor
        self.tvMessage.layer.borderWidth = 1
        self.vwDetails.layer.borderWidth = 1
        self.vwDetails.layer.borderColor = UIColor.colorLine.cgColor
        self.vwDetails.layer.cornerRadius = 2
        self.btnSubmit.layer.cornerRadius = 3
        self.btnSubmit.backgroundColor = .colorLine
        self.vwMain.layer.cornerRadius = 25
        self.tvMessage.contentInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        self.btnMenu.layer.borderColor = UIColor.lightGray.cgColor
        self.btnMenu.layer.borderWidth = 1
        self.btnMenu.layer.cornerRadius = 3
    }
    
    
    func checkValidation() -> String {
        if self.txtPhone.text?.trim() == "" {
            return "Please enter phone number"
        } else if (self.txtPhone.text?.trim().count)! < 10 {
            return "Please enter 10 character for phone"
        }else if self.txtEmail.text?.trim() == "" {
            return "Please enter email address"
        }else if (self.tvMessage.text?.trim() == "" || self.tvMessage.text == "Message") {
            return "Please enter message"
        }
        return ""
    }
    
    //MARK:- Action Methods
    @IBAction func btnSubmitClick(_ sender: Any) {
        let error = self.checkValidation()
        if error == "" {
            UIApplication.shared.setTab(index: 1)
        }else{
            Alert.shared.showAlert(message: error, completion: nil)
        }
    }
    
    @IBAction func btnMenuClick(_ sender: Any) {
        if let vc = UIStoryboard.main.instantiateViewController(withClass: SideMenuVC.self) {
            vc.modalPresentationStyle = .overFullScreen
            present(vc, animated: true, completion: nil)
        }
    }
    
    //MARK:- ViewLifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }

}
