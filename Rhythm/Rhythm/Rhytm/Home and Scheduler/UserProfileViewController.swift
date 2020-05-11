//
//  UserProfileViewController.swift
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

class UserProfileViewController: UIViewController {
    
    let userID = Auth.auth().currentUser!.uid
    let db = Firestore.firestore()
    
    
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var editFirstName: UIButton!
    @IBOutlet weak var editLastName: UIButton!
    @IBOutlet weak var editEmail: UIButton!
    
    weak var delegate: ViewController?
    
    var currentUser: User!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //This works, with lag
        //getUserInfo()
        
        
        
        let homeVC = self.tabBarController!.viewControllers![0] as! ViewController
        currentUser = homeVC.currentUser
        firstNameLabel.text = currentUser.firstName
        lastNameLabel.text = currentUser.lastName
        emailLabel.text = currentUser.email
        
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func logOut(_ sender: Any) {
        try! Auth.auth().signOut()
        transitionToLogin()  
    }
    
    @IBAction func editAField(_sender: UIButton)
    {
        switch _sender{
        case editFirstName:
            print("")
        case editLastName:
            print("")
        case editEmail:
            print("")
        default:
            print("")
        }
    }
    
    func transitionToLogin()
    {
        let storyboard = UIStoryboard(name: "login", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "welcomeVC") as UIViewController
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    
    func getUserInfo()//(completion: @escaping (Error?) -> Void)
    {
        db.collection("users").document(userID).getDocument { (document, error) in
            if let error = error{
                print(error)
                return
            }
            let result = Result{
                try document?.data(as: User.self)
            }
            
            switch result{
            case .success(let newUser):
                let newUser = newUser
                self.updateUser(user: newUser!)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    func updateUser(user: User)
    {
        currentUser = user
        firstNameLabel.text = currentUser.firstName
        lastNameLabel.text = currentUser.lastName
        emailLabel.text = currentUser.email
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
