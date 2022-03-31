
//
//  EventModel.swift

import Foundation


class EventModel {
    var docID: String!
    var userName: String!
    var description:String!
    var name: String!
    var date: String!
    var time: String!
    var location: String!
  

    init(docID: String, time:String, name:String, date:String, location:String, userName:String,description:String){
        
        self.date = date
        self.name = name
        self.time = time
        self.location = location
        self.userName = userName
        self.docID = docID
        self.description = description
    }
    
    init(){
    }
}
