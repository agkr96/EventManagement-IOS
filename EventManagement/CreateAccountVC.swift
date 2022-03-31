
//
//  CreateAccountVC.swift


import UIKit

class CreateAccountVC: UIViewController, UITextFieldDelegate {

    //MARK:- Outlets
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var txtUserName: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var txtGender: UITextField!
    @IBOutlet weak var txtBirthDate: UITextField!
    @IBOutlet weak var txtCreatePassowrd: UITextField!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    @IBOutlet weak var btnCheck: UIButton!
    @IBOutlet weak var btnCreateAccount: UIButton!
    
    //MARK:- Class Variables
    var isOrganizer: Bool = false
    var flag: Bool = true
    var isApple: Bool = false
    
    var dpDate = UIDatePicker()
    var dpGender = UIPickerView()
    var arrayGender = ["Male","Female","Other"];
    
    
    
    //MARK:- Custom Methods
    func createDatePicker(){
        
        dpDate.backgroundColor = UIColor.black
        dpDate.preferredDatePickerStyle = .wheels
        dpDate.datePickerMode = UIDatePicker.Mode.date
        
        dpDate.maximumDate = Calendar(identifier: .gregorian).date(byAdding: DateComponents(), to: Date())
        txtBirthDate.inputView = dpDate
        txtGender.inputView = dpGender
        
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.themePurple
        toolBar.sizeToFit()
        toolBar.backgroundColor = .white
        
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.cancelClick))
        toolBar.setItems([cancelButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        txtBirthDate.inputAccessoryView = toolBar
        txtGender.inputAccessoryView = toolBar
        dpDate.addTarget(self, action: #selector(changeValue), for: .valueChanged)
    }
    
    
    @objc func cancelClick() {
        txtGender.resignFirstResponder()
        txtBirthDate.resignFirstResponder()
    }

    @objc func changeValue(){
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateStyle = .short
        dateFormatter1.dateFormat = "dd-MM-yyyy"
        self.txtBirthDate.text = dateFormatter1.string(from: dpDate.date)
    }
    
    func checkValidation() -> String {
        if self.txtUserName.text?.trim() == "" {
            return "Please enter username"
        }else if self.txtPhone.text?.trim() == "" {
            return "Please enter username"
        }else if (self.txtPhone.text?.trim().count)! < 10 {
            return "Please enter valid phone Number"
        }else if self.txtGender.text?.trim() == "" {
            return "Please select gender"
        }else if self.txtBirthDate.text?.trim() == "" {
            return "Please select birth day"
        } else if self.txtCreatePassowrd.text?.trim() == "" {
            return "Please enter create password"
        } else if (self.txtCreatePassowrd.text?.trim().count)! < 8 {
            return "Please enter 8 character for create password"
        } else if self.txtConfirmPassword.text?.trim() == "" {
            return "Please enter confirm password"
        } else if self.txtConfirmPassword.text?.trim() != self.txtCreatePassowrd.text?.trim() {
            return "Password mismatched"
        } else if !self.btnCheck.isSelected {
            return "Please select with terms"
        }
        
        return ""
    }
    //MARK:- Action Methods
    @IBAction func createAccountClick(_ sender: Any) {
        self.flag = false
        let msg = self.checkValidation()
        if msg == "" {
            self.getExistingUser(userName: (self.txtUserName.text?.trim())!, phone: (self.txtPhone.text?.trim())!, birthDate: (self.txtBirthDate.text?.trim())!, gender: (self.txtGender.text?.trim())!, password: (self.txtCreatePassowrd.text?.trim())!, confirmPassword: (self.txtConfirmPassword.text?.trim())!, isOrganizer: isOrganizer)
        }else{
            Alert.shared.showAlert(message: msg, completion: nil)
        }
    }
    
    @IBAction func btnCheckClick(_ sender: UIButton) {
        sender.isSelected.toggle()
    }
    
    //MARK:- ViewLifeCycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.txtPhone.delegate = self
        self.txtGender.delegate = self
        self.txtBirthDate.delegate = self
        self.dpGender.delegate = self
        self.dpGender.dataSource = self
        self.createDatePicker()
        self.btnCreateAccount.layer.cornerRadius = 5
        
        if isApple {
            self.txtCreatePassowrd.isHidden = true
            self.txtConfirmPassword.isHidden = true
        }
        
        self.lblTitle.text =  isOrganizer ? eOrganizer : eCustomer
    }

}


extension CreateAccountVC  :UIPickerViewDelegate,UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrayGender.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return arrayGender[row].description
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.txtGender.text = arrayGender[row].description
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //txtPhone allowed only Digits, and maximum 10 Digits allowed
        if textField == self.txtPhone {
            if ((string.rangeOfCharacter(from: CharacterSet.decimalDigits) != nil) && textField.text!.count < 10) || string.isEmpty{
                return true
            }
            return false
        }
        return true
    }
}


//MARK:- Extension for Login Function
extension CreateAccountVC {
    
    func createAccount(userName: String, phone:String, birthDate:String, gender:String, password:String,confirmPassword:String,isOrganizer:Bool) {
        var ref : DocumentReference? = nil
       
        ref = AppDelegate.shared.db.collection(eUser).addDocument(data:
            [
              ePhone: phone,
              eUserName: userName,
              eGender: gender,
              eBirthDate: birthDate,
              ePassword : password,
              eIsOrganizer: isOrganizer,
            ])
        {  err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
                GFunction.user = UserModel(id: ref!.documentID.description, phone: phone, userName: userName, gender: gender, bDay: birthDate)
                isOrganizer ? (UIApplication.shared.setAdmin(index: 1)) : (UIApplication.shared.setTab(index: 1))
                self.flag = true
            }
        }
    }
    
    func getExistingUser(userName: String, phone:String, birthDate:String, gender:String, password:String,confirmPassword:String,isOrganizer:Bool) {
    
        _ = AppDelegate.shared.db.collection(eUser).whereField(eUserName, isEqualTo: userName).addSnapshotListener{ querySnapshot, error in
            
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            
            if snapshot.documents.count == 0 {
                self.createAccount(userName: userName, phone:phone, birthDate:birthDate, gender:gender, password:password,confirmPassword:confirmPassword,isOrganizer:isOrganizer)
                self.flag = true
            }else{
                if !self.flag {
                    Alert.shared.showAlert(message: "UserName is already exist !!!", completion: nil)
                    self.flag = true
                }
            }
        }
    }
}

