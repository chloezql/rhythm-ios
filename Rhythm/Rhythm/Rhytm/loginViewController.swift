//
//  loginViewController.swift
//  Rhytm
//
//  Created by Ramses Sanchez Hernandez on 4/18/20.
//  Copyright © 2020 NYUiOS. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class loginViewController: UIViewController {

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errorLabel.isHidden = true

        // Do any additional setup after loading the view.
    }
    
    
    func checkFields() -> Bool
    {
        if(email.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            password.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "")
        {
            return false
        }
        
        return true
    }
    
    
    
    @IBAction func loginPressed(_ sender: Any)
    {
        if checkFields()
        {
            let em = email.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let pword = password.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            Auth.auth().signIn(withEmail: em, password: pword) { (result, error) in
                if error != nil
                {
                    //Couldnt Sign in
                }
                else
                {
                    self.transitionToHomeScreen()
                }
            }
        }
        else
        {
            
        }
        
        
    }
    
    func transitionToHomeScreen()
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "homeVC") as UIViewController
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
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
