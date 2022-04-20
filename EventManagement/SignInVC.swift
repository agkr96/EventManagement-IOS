
//
//  HomeVC.swift

import UIKit

class SignInVC: UIViewController {
    
    //MARK:- Outlets
    @IBOutlet weak var stTypeOfUser: UIStackView!
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var btnCustomer: UIButton!
    @IBOutlet weak var btnOrganizer: UIButton!
    @IBOutlet weak var txtUserName: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var lblOR: UILabel!
    @IBOutlet weak var btnAppleLogin: UIButton!
    @IBOutlet weak var btnForgotPassword: UIButton!
    @IBOutlet weak var btnRegister: UIButton!
    
    
    //MARK:- Class Variables
    var isOrganizer : Bool = false
    var flag: Bool = true
    var appleData: AppleLoginModel!
    private let appleLoginManager: AppleLoginManager = AppleLoginManager()
    
    
    //MARK:- Custom Methods
    func setUpView(){
        self.stTypeOfUser.layer.cornerRadius = 30
        self.btnSubmit.layer.cornerRadius = 5
        self.btnAppleLogin.layer.cornerRadius = 5
        self.view.backgroundColor = .themePurple
        
        self.btnCustomer.backgroundColor = UIColor.themeBlue
        self.btnCustomer.setTitleColor(UIColor.white, for: .normal)
        self.btnOrganizer.backgroundColor = UIColor.themeCyan
        self.btnOrganizer.setTitleColor(UIColor.black, for: .normal)
        self.txtPassword.isSecureTextEntry = true
        
        self.isOrganizer = false
        
    }
    
    func checkValidation() -> String {
        if (self.txtUserName.text?.trim() == "") {
            return "Please enter username"
        }else if (self.txtPassword.text?.trim() == "") {
            return "Please enter password"
        }
        return ""
    }
    
    //MARK:- Action Methods
    @IBAction func btnUserClick(_ sender: UIButton) {
        sender.backgroundColor = UIColor.themeBlue
        sender.setTitleColor(UIColor.white, for: .normal)
        if sender == btnCustomer {
            self.isOrganizer = false
            self.btnAppleLogin.isHidden = false
            self.lblOR.isHidden = false
            btnOrganizer.backgroundColor = UIColor.themeCyan
            btnOrganizer.setTitleColor(UIColor.black, for: .normal)
        }else{
            self.isOrganizer = true
            self.btnAppleLogin.isHidden = true
            self.lblOR.isHidden = true
            btnCustomer.backgroundColor = UIColor.themeCyan
            btnCustomer.setTitleColor(UIColor.black, for: .normal)
        }
    }
    
    @IBAction func btnSubmit(_ sender: UIButton) {
        self.flag = true
        if sender == btnSubmit {
            let msg = self.checkValidation()
            if msg.isEmpty {
                self.loginUser(email: self.txtUserName.text!, password: self.txtPassword.text!)
                
            }else{
                Alert.shared.showAlert(message: msg, completion: nil)
            }
        }else if sender == btnRegister {
            if let vc = UIStoryboard.main.instantiateViewController(withClass: CreateAccountVC.self) {
                vc.isOrganizer = self.isOrganizer
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }else if sender == btnForgotPassword {
            if let vc = UIStoryboard.main.instantiateViewController(withClass: ForgotPasswordVC.self) {
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    @IBAction func btnAppleClick(_ sender: Any) {
        self.appleLoginManager.performAppleLogin()
    }
    
    //MARK:- ViewLifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
        
        self.txtPassword.text = "" //Test@1234
        self.txtUserName.text = "" //oTest1   test123
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
}

//MARK:- Extension for Login Function
extension SignInVC {
    
    
    func loginUser(email:String,password:String) {
        
        _ = AppDelegate.shared.db.collection(eUser).whereField(eUserName, isEqualTo: email).whereField(ePassword, isEqualTo: password).whereField(eIsOrganizer, isEqualTo: self.isOrganizer).addSnapshotListener{ querySnapshot, error in
            
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            
            if snapshot.documents.count != 0 {
                let data1 = snapshot.documents[0].data()
                let docId = snapshot.documents[0].documentID
                if let date : String = data1[eBirthDate] as? String, let name: String = data1[eUserName] as? String, let phone: String = data1[ePhone] as? String, let gender: String = data1[eGender] as? String{
                    GFunction.user = UserModel(id: docId, phone: phone, userName: name, gender: gender, bDay: date)
                    self.isOrganizer ? UIApplication.shared.setAdmin(index: 1) : UIApplication.shared.setTab(index: 1)
                }
            }else{
                if self.flag {
                    Alert.shared.showAlert(message: "Please check your credentials !!!", completion: nil)
                    self.flag = false
                }
            }
        }
        
    }
}

//MARK:- Apple Login
extension SignInVC: AppleLoginDelegate {
    func appleLoginData(data: AppleLoginModel) {
        
        print("Social Id==>", data.socialId ?? "")
        print("First Name==>", data.firstName ?? "")
        print("Last Name==>", data.lastName ?? "")
        print("Email==>", data.email ?? "")
        print("Login type==>", data.loginType ?? "")
    
        
        if let vc = UIStoryboard.main.instantiateViewController(withClass: CreateAccountVC.self) {
            vc.isApple = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}
