//
//  welcomeViewController.swift
//  Rhytm
//
//  Created by Ramses Sanchez Hernandez on 4/26/20.
//  Copyright © 2020 NYUiOS. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class welcomeViewController: UIViewController, UITextFieldDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        //self.view.backgroundColor = UIColor(patternImage: UIImage(named: "welcome-background.png")!)
        
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if user != nil{
                self.transitionToHomeScreen()
            }
        }
        
        

        // Do any additional setup after loading the view.
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
