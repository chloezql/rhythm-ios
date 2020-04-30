//
//  SignUpViewController.swift
//  Rhytm
//
//  Created by Ramses Sanchez Hernandez on 4/29/20.
//  Copyright © 2020 NYUiOS. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth





class SignUpViewController: UIViewController {

    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var errorMessage: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errorMessage.isHidden = true
        
        // Do any additional setup after loading the view.
    }
    
    
    func checkFields() -> Bool
    {
        if(firstName.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || lastName.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            email.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            password.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "")
        {
            callError(errorText: "One or more fields have been left empty")
            return false
        }
        
        //TODO: If password invalid
        return true
    }
    
    //TODO: ADD isPasswordValid method
    // func isPasswordValid() -> Bool{}
    
    
    @IBAction func signUp(_ sender: Any)
    {
        if checkFields()
        {
            let fName = firstName.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lName = lastName.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let em = email.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let pword =  password.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                        
            Auth.auth().createUser(withEmail: em, password: pword) { (result, error) in
                if error != nil
                {
                    //self.callError(errorText: "Something unexpected happened creating user. Try Again.")
                    self.callError(errorText: error!.localizedDescription)
                }
                else
                {
                    let db = Firestore.firestore()
                    db.collection("users").addDocument(data: ["firstName":fName , "lastName": lName, "uid": result!.user.uid]) { (error) in
                        if error != nil
                        {
                            self.callError(errorText: error!.localizedDescription)
                        }
                    }
                    self.transitionToHomeScreen()
                }
            }
        }
            
        else
        {
        }
        
    }
    
    func callError(errorText: String)
    {
        errorMessage.isHidden = false
        errorMessage.text = errorText
    }
    
    
    func transitionToHomeScreen()
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "homeVC") as UIViewController
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
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
