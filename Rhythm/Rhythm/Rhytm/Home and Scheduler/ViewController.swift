//
//  ViewController.swift
//  Rhytm
//
//  Created by Ramses Sanchez Hernandez on 4/18/20.
//  Copyright © 2020 NYUiOS. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestoreSwift
import FirebaseFirestore


class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, activityDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var scheduleTable: UITableView!
    
    @IBOutlet weak var selectButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var createActivity: UIPickerView!
    @IBOutlet weak var photo: UIImageView!
    
    
    let userID = Auth.auth().currentUser!.uid
    let db = Firestore.firestore()
    
    let dateFormatter = DateFormatter()
    
    
    var createAct: [String] = [String]()
    var pickerRow = 0
    var mySchedule: [Activity] = []
    var scheduleIndexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getActivitiesFromFirestore()
        
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .short
        
        // Do any additional setup after loading the view.
        createActivity.isHidden = true
        selectButton.isHidden = true
        //createActivity.setValue(UIColor .lightGray, forKey: "backgroundColor")
        
        self.createActivity.delegate = self;
        self.createActivity.dataSource = self;
        createAct = [" ","Create a new activity", "Create from save"]
        
        photo.image = UIImage(named: "AH.jpg")
        
        self.scheduleTable.delegate = self
        self.scheduleTable.dataSource = self
        scheduleTable.register(UINib(nibName: "DisplayScheduleTableViewCell", bundle: nil), forCellReuseIdentifier: "DisplayScheduleTableViewCellIdentifier")
        
        scheduleTable.tableFooterView = UIView()
//        var act = Activity(myName: "ame", myDesc: "", myStart: Date(), myEnd: Date(), myColor: "blue")
//        mySchedule.append(act)
    } 
    

    @IBAction func dropDownCreate(_ sender: Any) {
        if (createActivity.isHidden == true){
            createActivity.selectRow(0, inComponent: 0, animated: false)
            createActivity.isHidden = false
            selectButton.isHidden = false
        }
        else{
            createActivity.isHidden = true
            selectButton.isHidden = true
           
        }
    }
    

    //set up pickerView
    @IBAction func selectCreate(_ sender: Any) {
        pickerRow = createActivity.selectedRow(inComponent: 0)
        if pickerRow == 1 {
            
            self.performSegue(withIdentifier: "createNewSegue", sender: self)
            createActivity.isHidden = true
            selectButton.isHidden = true
        }
        else if pickerRow == 2 {
            self.performSegue(withIdentifier: "fromSaveSegue", sender: self)
            createActivity.isHidden = true
            selectButton.isHidden = true
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1;
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 3
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return createAct[row]
    }
    
    func addActivity(activity: Activity) {
//        let vc = NewActivityViewController(nibName: "NewActivityViewController", bundle: nil)
//        vc.delegate = self
        //let newActivity = vc.newActivity
        mySchedule.append(activity)
        addActivityToFirebase(activity: activity)

        
        //dateFormatter.timeStyle = .short
        

        mySchedule.sort(by: {$0.start_time < $1.start_time})
        scheduleTable.reloadData()
    }
    
    
    
    //Add Activity to firebase
    func addActivityToFirebase(activity: Activity)
    {
        //dateFormatter.dateStyle = .short
        let docuTitle = activityTitle(activity: activity)
        do{
            try
                _ = //db.collection("users").document(userID).collection("Activities").addDocument(from: activity)
                db.collection("users").document(userID).collection("Activities").document(docuTitle).setData(from: activity)
                    
        } catch{
            print("Unable to add activity to firestore")
        }
    }
    
    
    func getActivitiesFromFirestore()
    {
        print("isCalled")
        db.collection("users").document(userID).collection("Activities").getDocuments() { (snapshot, error) in
            if let error = error
            {
                print(error)
                return
            }
            else
            {
                for document in snapshot!.documents
                {
                    let result = Result{
                        try document.data(as: Activity.self)
                    }
                    switch result{
                    case .success(let newAct):
                        let newAct = newAct
                        
                        if(newAct!.start_time > Date())
                        {
                            self.mySchedule.append(newAct!)
                            self.scheduleTable.reloadData()
                        }
                    case .failure(let error):
                        print(error)
                    }
                    
                }
            }
        }
        
    }
    
        
    
    func removeFromFirebase(activity: Activity)
    {
        let docuTitle = activityTitle(activity: activity)
        db.collection("users").document(userID).collection("Activities").document(docuTitle).delete()
    }
    
    
    func activityTitle(activity:Activity) ->String
    {
        let title = dateFormatter.string(from: activity.start_time)
        print(title)
        return title
    }
    
    
    
    //set up tableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mySchedule.count

    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print(mySchedule[0].color)
        let activityCell = tableView.dequeueReusableCell(withIdentifier: "DisplayScheduleTableViewCellIdentifier",for: indexPath) as! DisplayScheduleTableViewCell
        //activityCell.activityName.text = mySchedule[indexPath.row].name
        
        activityCell.updateCell(startingTime: mySchedule[indexPath.row].start_time, color: mySchedule[indexPath.row].color, name: mySchedule[indexPath.row].name)
        //activityCell.delegate = self
        return activityCell
        
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
    
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {

        if let indexPathForSelectedRow = tableView.indexPathForSelectedRow,
            indexPathForSelectedRow == indexPath {
            tableView.deselectRow(at: indexPath, animated: false)
            return nil
        }
        return indexPath
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
           
            //TODO:Implement Delete from firebase
            let actToRemove = mySchedule[mySchedule.index(after: (indexPath.row)-1)]
            removeFromFirebase(activity: actToRemove)
            
            mySchedule.remove(at: indexPath.row)
            scheduleTable.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "createNewSegue" {
            let vc: NewActivityViewController = segue.destination as! NewActivityViewController
            vc.delegate = self
        }
    }
}

