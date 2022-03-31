
//
//  GFunction.swift


import Foundation



class GFunction {
    
    static let shared: GFunction = GFunction()
    static var user : UserModel!
    
    func firebaseLogin(data: String) {
        FirebaseAuth.Auth.auth().signIn(withEmail: data, password: "123123") { [weak self] authResult, error in
            guard self != nil else { return }
            //return if any error find
            if error != nil {
                FirebaseAuth.Auth.auth().createUser(withEmail: data, password: "123123") { authResult, error in
                   // ApiManager.shared.removeLoader()
                    //Return if error find
                    if error != nil {
                        return
                    }else{
                        FirebaseAuth.Auth.auth().signIn(withEmail: data, password: "123123") { [weak self] authResult, error in
                            guard self != nil else { return }
                            
                        }
                    }
                }
            }
        }
    }
}
