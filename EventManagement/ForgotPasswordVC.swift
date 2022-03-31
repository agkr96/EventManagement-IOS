import UIKit

class ForgotPasswordVC: UIViewController {

    //MARK:- Outlets
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var txtCreatePassowrd: UITextField!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    @IBOutlet weak var btnSubmit: UIButton!
    
    //MARK:- Class Variables
    var flag: Bool = true
    
    //MARK:- Custom Methods
    func checkValidation() -> String {
        if self.txtPhone.text?.trim() == "" {
            return "Please enter user name"
//        }else if (self.txtPhone.text?.trim().count)! < 10 {
//            return "Please enter valid phone Number"
        }else if self.txtCreatePassowrd.text?.trim() == "" {
            return "Please enter create password"
        } else if (self.txtCreatePassowrd.text?.trim().count)! < 8 {
            return "Please enter 8 character for create password"
        } else if self.txtConfirmPassword.text?.trim() == "" {
            return "Please enter confirm password"
        } else if self.txtConfirmPassword.text?.trim() != self.txtCreatePassowrd.text?.trim() {
            return "Password mismatched"
        }
        
        return ""
    }
    //MARK:- Action Methods
    @IBAction func btnSubmitClick(_ sender: Any) {
        self.flag = false
        let msg = self.checkValidation()
        if msg == "" {
            self.checkUser(userName: self.txtPhone.text!, password: self.txtCreatePassowrd.text!)
        }else{
            Alert.shared.showAlert(message: msg, completion: nil)
        }
    }
    
    @IBAction func btnResendOTPClick(_ sender: UIButton) {
        Alert.shared.showAlert(message: "OTP has been send it on your phone number", completion: nil)
    }
    
    //MARK:- ViewLifeCycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.btnSubmit.layer.cornerRadius = 5
    }
    
    func checkUser(userName:String,password:String) {
        
        _ = AppDelegate.shared.db.collection(eUser).whereField(eUserName, isEqualTo: userName).addSnapshotListener{ querySnapshot, error in
            
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            
            if snapshot.documents.count != 0 {
                let data = snapshot.documents[0]
                self.updatePAssword(docID: data.documentID, password: password)
                self.flag = false
            }else{
                if self.flag {
                    Alert.shared.showAlert(message: "Please enter valid user name !!!", completion: nil)
                    self.flag = false
                }
            }
        }
    }
    
    func updatePAssword(docID: String,password:String) {
        let ref = AppDelegate.shared.db.collection(eUser).document(docID)
        ref.updateData([
            ePassword : password
        ]){ err in
            if let err = err {
                print("Error updating document: \(err)")
                self.navigationController?.popViewController(animated: true)
            } else {
                print("Document successfully updated")
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}
