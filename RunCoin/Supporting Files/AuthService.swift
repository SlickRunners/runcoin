//
//  AuthService.swift
//  RunCoin
//
//  Created by Roland Christensen on 4/20/18.
//  Copyright © 2018 Roland Christensen. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage

class AuthService {
    static func signInToAccount(email: String, password: String, onSuccess: @escaping () -> Void, onError: @escaping (_ errorMessage: String?) -> Void){
        Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
            if error != nil {
                onError("Error logging user into Firebase with existing credentials \(error!.localizedDescription)")
                return
            }
            onSuccess()
        })
    }
    
    static func signUp(email: String, username: String, password: String, imageData: Data, birthday: String, gender: String,  onSuccess: @escaping () -> Void, onError: @escaping (_ errorMessage: String?) -> Void){
        Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
            if error != nil {
                onError("Error registering/singing in new user into Firebase! \(error!.localizedDescription)")
                return
            }
            guard let user = user else {return}
            let uid = user.user.uid
            let storageRef = Storage.storage().reference(forURL: Config.STORAGE_ROOT_REF).child("profile_image").child(uid)
            storageRef.putData(imageData, metadata: nil) { (metadata, error) in
                if error != nil {
                    return
                }
                storageRef.downloadURL { (url, error) in
                    if error != nil {
                        print("error with signin url dL method", error!.localizedDescription)
                        return
                    }
                    guard let downloadUrl = url else {return}
                    let profileUrl = downloadUrl.absoluteString
                    self.setUserInformation(email: email, username: username, birthday: birthday, gender: gender, profileImageUrl: profileUrl, uid: uid, onSuccess: onSuccess)
                }
            }
        })
    }
    
    static func setUserInformation(email: String, username: String, birthday: String, gender: String, profileImageUrl: String, uid: String, onSuccess: @escaping () -> Void){
        let ref = Database.database().reference()
        let userRef = ref.child("users")
        let newUserRef = userRef.child(uid)
        newUserRef.setValue(["email": email, "username": username, "birthday": birthday, "gender": gender, "profileImageUrl": profileImageUrl])
        onSuccess()
    }
    
    static func logout(onSuccess: @escaping () -> Void, onError: @escaping (_ errorMessage: String?) -> Void){
        do {
            try Auth.auth().signOut()
            onSuccess()
        }
        catch let logoutError {
            onError(logoutError.localizedDescription)
        }
    }
    
    static func sendPasswordReset(email: String, onSuccess: @escaping () -> Void, onError: @escaping (_ errorMessage: String?) -> Void){
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            if error != nil {
                onError(error?.localizedDescription)
                return
            }
            onSuccess()
        }
    }
    
    static func updateUserInfo(email: String, username: String, profileImageData: Data, onSuccess: @escaping () -> Void, onError: @escaping (_ errorMessage: String?) -> Void){
        Auth.auth().currentUser?.updateEmail(to: email, completion: { (error) in
            if error != nil {
                onError(error!.localizedDescription)
            } else {
                guard let currentUser = Api.User.CURRENT_USER else {return}
                let uid = currentUser.uid
                
                let storageRef = Storage.storage().reference(forURL: Config.STORAGE_ROOT_REF).child("profile_image").child(uid)
                storageRef.putData(profileImageData, metadata: nil) { (metadata, error) in
                    if error != nil {
                        return
                    }
                    storageRef.downloadURL { (url, error) in
                        if error != nil {
                            print("error with signin url dL method", error!.localizedDescription)
                            return
                        }
                        let profileImageUrl = url?.absoluteString
                        
                        self.updateUserInfoDatabase(email: email, username: username, profileImageUrl: profileImageUrl!, onSuccess: onSuccess, onError: onError)
                    }
                }
            }
        })
    }
    
    static func updateUserInfoDatabase(email: String, username: String, profileImageUrl: String, onSuccess: @escaping () -> Void, onError: @escaping (_ errorMessage: String?) -> Void){
        let dict = ["email": email, "username": username, "username_lowercase": username.lowercased(), "profileImageUrl": profileImageUrl]
        Api.User.REF_CURRENT_USER?.updateChildValues(dict, withCompletionBlock: { (error, ref) in
            if error != nil {
                onError(error!.localizedDescription)
            } else {
                onSuccess()
            }
            
        })
    
    }
}
