
import UIKit

class UpdateEventVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var txtName: UITextField!
    
    @IBOutlet weak var tvDescription: UITextView!
    
    @IBOutlet weak var txtLocation: UITextField!
    
    @IBOutlet weak var txtDate: UITextField!
    
    @IBOutlet weak var txtTime: UITextField!

    @IBOutlet weak var btnSubmit: NSLayoutConstraint!
    
    
    var dpDate = UIDatePicker()
    var dpTime = UIDatePicker()
    //var data: OrderModel!
    
    var data: EventModel!
    
    
    func setUpData(){
        if data != nil {
            self.txtTime.text = data.time.description
            self.txtDate.text = data.date.description
            self.txtName.text = data.name.description
            self.tvDescription.text = data.description.description
            self.txtLocation.text = data.location.description
        }
    }
    
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
        
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.cancelClick))
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

    
    @IBAction func btnSubmitClick(_ sender: Any) {
        let msg = self.validation()
        if msg == "" {
            self.updateEvent(data: data, name: self.txtName.text!, location: self.txtLocation.text!, time: self.txtTime.text!, date: self.txtDate.text!,description: self.tvDescription.text!)
        }else {
            Alert.shared.showAlert(message: msg, completion: nil)
        }
    }
    
    
    func setUpView(){
        self.txtDate.delegate = self
        self.txtTime.delegate = self
        self.createDatePicker()
        self.setUpData()
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

    
    func updateEvent(data:EventModel,name:String,location:String,time:String,date:String,description:String) {
        let ref = AppDelegate.shared.db.collection(eEvent).document(data.docID)
        ref.updateData([
            eEventName : name,
            eLocation: location,
            eTime: time,
            eDate: date,
            eDescription :description
        ]){ err in
            if let err = err {
                print("Error updating document: \(err)")
                //self.navigationController?.popViewController(animated: true)
            } else {
                print("Document successfully updated")
                if let vc = UIStoryboard.main.instantiateViewController(withClass: UpdateSucessVC.self) {
                    vc.index = 1
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
}
