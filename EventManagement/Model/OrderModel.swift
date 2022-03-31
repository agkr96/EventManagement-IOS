import Foundation


class OrderModel {
    var docID: String!
    var userName: String!
    var name: String!
    var date: String!
    var time: String!
    var location: String!
    var status: String!

    init(docID: String, time:String, name:String, date:String, location:String, userName:String,status:String){
        self.date = date
        self.name = name
        self.time = time
        self.location = location
        self.userName = userName
        self.docID = docID
        self.status = status
    }
    
    init(){
    }
}
