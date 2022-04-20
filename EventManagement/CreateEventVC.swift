
//
//  CreateEventVC.swift


import UIKit

class CreateEventVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var btnMenu: UIButton!
    
    @IBOutlet weak var txtName: UITextField!
    
    @IBOutlet weak var tvDescription: UITextView!
    
    @IBOutlet weak var txtLocation: UITextField!
    
    @IBOutlet weak var txtDate: UITextField!
    
    @IBOutlet weak var txtTime: UITextField!

    @IBOutlet weak var btnSubmit: NSLayoutConstraint!
    
    
    var dpDate = UIDatePicker()
    var dpTime = UIDatePicker()
    //var data: OrderModel!
    
    func createDatePicker(){
        
        dpDate.backgroundColor = UIColor.black
        dpDate.preferredDatePickerStyle = .wheels
        dpDate.datePickerMode = UIDatePicker.Mode.date
        dpTime.backgroundColor = UIColor.black
        dpTime.preferredDatePickerStyle = .wheels
        dpTime.datePickerMode = .time
        dpTime.minuteInterval = 5
        
        
        var components = DateComponents()
        components.month = 2
        dpDate.minimumDate = Calendar(identifier: .gregorian).date(byAdding: DateComponents(), to: Date())
        dpDate.maximumDate = Calendar(identifier: .gregorian).date(byAdding: components, to: Date())
        dpTime.minimumDate = Calendar(identifier: .gregorian).date(byAdding: DateComponents(), to: Date())
        txtDate.inputView = dpDate
        txtTime.inputView = dpTime
        
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.themePurple
        toolBar.sizeToFit()
        toolBar.backgroundColor = .white
        
        let cancelButton = UIBarButtonItem(title: "Ok", style: .plain, target: self, action: #selector(self.cancelClick))
        toolBar.setItems([cancelButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        txtDate.inputAccessoryView = toolBar
        txtTime.inputAccessoryView = toolBar
        dpDate.addTarget(self, action: #selector(changeValue), for: .valueChanged)
        dpTime.addTarget(self, action: #selector(changeTimeValue), for: .valueChanged)
    }
    
    
    @objc func cancelClick() {
        txtDate.resignFirstResponder()
        txtTime.resignFirstResponder()
    }

    @objc func changeValue(){
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateStyle = .short
        dateFormatter1.dateFormat = "dd MMM, yy"
        self.txtDate.text = dateFormatter1.string(from: dpDate.date)
    }
    
    @objc func changeTimeValue(){
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateStyle = .short
        dateFormatter1.dateFormat = "hh:mm a"
        self.txtTime.text = dateFormatter1.string(from: dpTime.date)
    }
    
    func validation() -> String {
        if self.txtName.text?.trim() == "" {
            return "Please enter event name"
        }else if self.tvDescription.text.trim() == "" || self.tvDescription.text.trim() == "Enter Description..." {
            return "Please enter description"
        }else if self.txtLocation.text?.trim() == "" {
            return "Please enter location"
        }else if self.txtDate.text?.trim() == "" {
            return "Please select date"
        }else if self.txtTime.text?.trim() == "" {
            return "Please select time"
        }
        return ""
    }
    
    @IBAction func btnMenuClick(_ sender: UIButton) {
        if let vc = UIStoryboard.main.instantiateViewController(withClass: SideMenuAdminVC.self) {
            vc.modalPresentationStyle = .overFullScreen
            vc.modalTransitionStyle = .flipHorizontal
            present(vc, animated: true, completion: nil)
        }
    }
    
    @IBAction func btnSubmitClick(_ sender: Any) {
        let msg = self.validation()
        if msg == "" {
            self.createEvent(eventName: self.txtName.text!, description: self.tvDescription.text!, location: self.txtLocation.text!, date: self.txtDate.text!, time: self.txtTime.text!, userName: GFunction.user.userName)
        }else {
            Alert.shared.showAlert(message: msg, completion: nil)
        }
    }
    
    
    func setUpView(){
        self.txtDate.delegate = self
        self.txtTime.delegate = self
        self.btnMenu.layer.borderColor = UIColor.lightGray.cgColor
        self.btnMenu.layer.borderWidth = 1
        self.btnMenu.layer.cornerRadius = 3
        self.createDatePicker()
    }
    
    
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

//MARK:- Extension for Login Function
extension CreateEventVC {
    
    func createEvent(eventName: String, description:String, location:String, date:String, time:String,userName:String) {
        var ref : DocumentReference? = nil
       
        ref = AppDelegate.shared.db.collection(eEvent).addDocument(data:
            [
              eEventName: eventName,
              eUserName: userName,
              eTime: time,
              eDate: date,
              eLocation : location,
              eDescription: description,
            ])
        {  err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
                UIApplication.shared.setAdmin(index: 1)
            }
        }
    }
}

