//
//  EditUserInfoViewController.swift
//  Rhytm
//
//  Created by Ramses Sanchez Hernandez on 5/10/20.
//  Copyright © 2020 NYUiOS. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestoreSwift
import FirebaseFirestore

class EditUserInfoViewController: UIViewController {
    
    
    @IBOutlet weak var currentValLabel: UILabel!
    @IBOutlet weak var newValTextField: UITextField!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var errorLabel: UILabel!
    
    var currentUser: User!
    var tag: Int!
    
    let userID = Auth.auth().currentUser!.uid
    let db = Firestore.firestore()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errorLabel.isHidden = true
        
        
        switch tag {
        case 1:
            currentValLabel.text = currentUser.firstName
            titleLabel.text = "Edit First Name"
            newValTextField.placeholder = "New First Name"
        case 2:
            currentValLabel.text = currentUser.lastName
            titleLabel.text = "Edit Last Name"
            newValTextField.placeholder = "New Last Name"
        case 3:
            currentValLabel.text = currentUser.email
            titleLabel.text = "Edit Email"
            newValTextField.placeholder = "New Email"
        default:
            currentValLabel.text = "Error"
            titleLabel.text = "Error"
            newValTextField.placeholder = "Error"
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func SaveNewInfo(_ sender: Any) {
        let newVal = newValTextField.text
        switch tag {
        case 1:
            updateSimple(newValue: newVal!)
            dismiss(animated: true, completion: nil)
        case 2:
            updateSimple(newValue: newVal!)
            dismiss(animated: true, completion: nil)
        case 3:
            updateEmail(newEmail: newVal!)
        default:
            print("Error")
        }   
    }
    
    
    func updateEmail(newEmail: String)
    {
        Auth.auth().currentUser?.updateEmail(to: newEmail, completion: { (error) in
            if let error = error
            {
                self.callError(errorText: error.localizedDescription)
            }
            else{
                self.updateSimple(newValue: newEmail)
                self.dismiss(animated: true, completion: nil)
                print("email Changed")
            }
        })
    }
    
    func updateSimple(newValue: String)
    {
        var fieldName: String!
        switch tag {
        case 1:
            fieldName = "firstName"
            //homeVC.currentUser.firstName = newValue
        case 2:
            fieldName = "lastName"
            //homeVC.currentUser.lastName = newValue
        case 3:
            fieldName = "email"
            //homeVC.currentUser.email = newValue
        default:
            fieldName = "error"
        }
        
        
        
        
        let ref = db.collection("users").document(userID)
        ref.updateData([fieldName : newValue]) { (err) in
            if let err = err
            {
                self.callError(errorText: err.localizedDescription)
            }
        }
        
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func callError(errorText: String)
    {
        errorLabel.isHidden = false
        errorLabel.text = errorText
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
