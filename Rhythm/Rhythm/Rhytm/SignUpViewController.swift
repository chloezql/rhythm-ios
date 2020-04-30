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





class SignUpViewController: UIViewController, UITextFieldDelegate{

    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    
    @IBOutlet weak var errorMessage: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errorMessage.isHidden = true
        
        // Do any additional setup after loading the view.
    }
    
    func textFieldShouldReturn(_textField: UITextField) -> Bool
    {
        _textField.resignFirstResponder();

    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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

        if(isValidPassword(password: password.text!) == false)
        {
            callError(errorText: "Password must include at least one number, a special character ($@$#!%?&), and an uppercase letter.")
            return false
        }
        
        if(confirmPassword.text?.trimmingCharacters(in: .whitespacesAndNewlines) != password.text?.trimmingCharacters(in: .whitespacesAndNewlines))
        {
            callError(errorText: "Passwords do not match")
            return false
        }
        
        return true
    }

    
    
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
    
    
    func isValidPassword(password: String) -> Bool
    {
        //Password requires 1 uppercase, 1 lowercase, one special char, one number, length 8
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[A-Z])(?=.*[$@$#!%*?&])(?=.*[0-9])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
        
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
