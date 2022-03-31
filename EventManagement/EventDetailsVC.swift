//
//  EventDetailsVC.swift


import UIKit

class EventDetailsVC: UIViewController {

    //MARK:- Outlets
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgEvent: UIImageView!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var imgLike: UIImageView!
    @IBOutlet weak var stLike: UIStackView!
    @IBOutlet weak var imgAttending: UIImageView!
    @IBOutlet weak var stAttending: UIStackView!
    @IBOutlet weak var btnSubscribe: UIButton!
    @IBOutlet weak var stShare: UIStackView!
    @IBOutlet weak var btnBook: UIButton!
    @IBOutlet weak var vwMain: UIView!
    
    
    //MARK:- Class Variables
    var data: EventModel!
    
    
    //MARK:- Custom Methods
    func setUpData(){
        if self.data != nil {
            self.lblName.text = data.name.description
            self.lblDescription.text = data.description.description
        }
    }
    
    func setUpView() {
        self.btnBook.backgroundColor = .colorLine
        self.btnBook.layer.cornerRadius = 3
        self.btnSubscribe.backgroundColor = .colorLine
        self.btnSubscribe.layer.cornerRadius = 3
        self.vwMain.layer.cornerRadius = 15
        
        let tap = UITapGestureRecognizer()
        tap.addAction {
            self.imgLike.isHighlighted.toggle()
        }
        self.stLike.isUserInteractionEnabled = true
        self.stLike.addGestureRecognizer(tap)
        
        let tap1 = UITapGestureRecognizer()
        tap1.addAction {
            self.imgAttending.isHighlighted.toggle()
        }
        self.stAttending.isUserInteractionEnabled = true
        self.stAttending.addGestureRecognizer(tap1)
        
        let tap2 = UITapGestureRecognizer()
        tap2.addAction {
            self.presentActivitySheet()
        }
        self.stShare.isUserInteractionEnabled = true
        self.stShare.addGestureRecognizer(tap2)
        
        self.setUpData()
        
    }
    
    
    func presentActivitySheet(){
        let textToShare = ["Hey there, i am inviting you to attend this event."]
        let presentActivityVC = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        presentActivityVC.popoverPresentationController?.sourceView = self.view
        self.present(presentActivityVC, animated: true, completion: nil)
    }
    
    
    //MARK:- Action Methods
    
    @IBAction func btnBookClick(_ sender: Any) {
        self.bookEvent(userName: GFunction.user.userName, status: ePending, data: self.data)
    }
    
    @IBAction func btnSubscribeClick(_ sender: Any) {
        if let vc = UIStoryboard.main.instantiateViewController(withClass: EventSubscribeVC.self){
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    //MARK:- ViewLifeCycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
        // Do any additional setup after loading the view.
    }
    
    func bookEvent(userName: String,status:String,data:EventModel) {
        var ref : DocumentReference? = nil
       
        ref = AppDelegate.shared.db.collection(eOrders).addDocument(data:
            [
                eOUserName: data.userName.description,
                eUserName: userName,
                eEventName: data.name.description,
                eLocation: data.location.description,
                eDate : data.date.description,
                eTime: data.time.description,
                eStatus: status
            ])
        {  err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
                if let vc = UIStoryboard.main.instantiateViewController(withClass: EventBookedVC.self){
                    vc.data = data
                    vc.docId = ref!.documentID
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }

}

