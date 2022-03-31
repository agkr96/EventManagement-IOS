
//
//  UserModel.swift


import Foundation


class UserModel {
    var id: String!
    var userName: String!
    var phone:String!
    var gender:String!
    var bDay: String!

    init(id: String,phone:String,userName:String,gender:String,bDay:String){
        self.id = id
        self.phone = phone
        self.bDay = bDay
        self.gender = gender
        self.userName = userName
    }
    
    init(){
    }
}
