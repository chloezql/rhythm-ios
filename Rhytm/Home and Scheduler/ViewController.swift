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


class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, activityDelegate, activityEditDelegate,saveActivityDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var scheduleTable: UITableView!
    
    @IBOutlet weak var selectButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var createActivity: UIPickerView!
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var username: UILabel!
    
    var createAct: [String] = [String]()
    var pickerRow = 0
    var mySchedule: [Activity] = []
    var savedList: [Activity] = [Activity]()
    var scheduleIndexPath: IndexPath?
    var indexToEdit = -1
    
    
    let userID = Auth.auth().currentUser!.uid
    let db = Firestore.firestore()
    
    let dateFormatter = DateFormatter()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getActivitiesFromFirestore()
        
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .short
        //ask user if allow notification
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted == true && error == nil {
            }
        }
        
        // Do any additional setup after loading the view.
        createActivity.isHidden = true
        selectButton.isHidden = true
        
        self.createActivity.delegate = self;
        self.createActivity.dataSource = self;
        createAct = ["Create a new activity", "Create from save", "View Saved Activities"]
        
        photo.roundImage()
        photo.image = UIImage(named: "AH.jpg")
        
        self.scheduleTable.delegate = self
        self.scheduleTable.dataSource = self
        scheduleTable.register(UINib(nibName: "DisplayScheduleTableViewCell", bundle: nil), forCellReuseIdentifier: "DisplayScheduleTableViewCellIdentifier")
        
        scheduleTable.tableFooterView = UIView()
        
        for acti in mySchedule{
            setNotification(time: acti.start_time)
        }
        
    }
    

    
    //set up notification
    func setNotification(time:Date){
        let content = UNMutableNotificationContent()
        content.body = "You have a schedule happening. Play your music now!"

        
        let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: time), repeats: true)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString,
                                            content: content, trigger: trigger)
        
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.add(request) { (error) in
            if error != nil {
                // Handle any errors.
            }
        }
        
    }
  
    
    //add button
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
        if pickerRow == 0 {
            
            self.performSegue(withIdentifier: "createNewSegue", sender: self)
            createActivity.isHidden = true
            selectButton.isHidden = true
        }
        else if pickerRow == 1 {
            self.performSegue(withIdentifier: "fromSaveSegue", sender: self)
            createActivity.isHidden = true
            selectButton.isHidden = true
        }
        else if pickerRow == 2 {
            self.performSegue(withIdentifier: "viewSavedSegue", sender: self)
            createActivity.isHidden = true
            selectButton.isHidden = true
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 3
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return createAct[row]
    }
    
    //add activity when segue back
    func addActivity(activity: Activity) {
        mySchedule.append(activity)
        addActivityToFirebase(activity: activity)
        mySchedule.sort(by: {$0.start_time < $1.start_time})
        
        savedList.append(activity)
        savedList.sort(by: {$0.name < $1.name})
        scheduleTable.reloadData()
        
        setNotification(time: activity.start_time)
    }
    
    //update activity when segue back after editing
    func saveChange(activity: Activity, index:Int){
        mySchedule[index] = activity
        mySchedule.sort(by: {$0.start_time < $1.start_time})
        scheduleTable.reloadData()
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        for acti in mySchedule{
            setNotification(time: acti.start_time)
        }
    }
    
    
    //add activity from saved when segue back
    func addSavedActivity(activity: Activity) {
        mySchedule.append(activity)
        addActivityToFirebase(activity: activity)
        mySchedule.sort(by: {$0.start_time < $1.start_time})
        scheduleTable.reloadData()
        setNotification(time: activity.start_time)
    }
    
    //Add Activity to firebase
    func addActivityToFirebase(activity: Activity)
    {
        dateFormatter.timeStyle = .short
        let dateAsString = dateFormatter.string(from: activity.start_time)
        do{
            try
                _ = //db.collection("users").document(userID).collection("Activities").addDocument(from: activity)
                db.collection("users").document(userID).collection("Activities").document(dateAsString).setData(from: activity)
        } catch{
            print("Unable to add activity to firestore")
        }
    }
    
    
    func getActivitiesFromFirestore()
    {
        //print("isCalled")
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
                        self.mySchedule.append(newAct!)
                        self.setNotification(time: newAct!.start_time)
                        self.scheduleTable.reloadData()
                        
                        
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
        //print(title)
        return title
    }
    
    //set up tableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mySchedule.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let activityCell = tableView.dequeueReusableCell(withIdentifier: "DisplayScheduleTableViewCellIdentifier",for: indexPath) as! DisplayScheduleTableViewCell
        
        activityCell.updateCell(startingTime: mySchedule[indexPath.row].start_time, color: mySchedule[indexPath.row].color, name: mySchedule[indexPath.row].name)
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
    
    //delete an activity and table cell (swipe to the left)
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            
            //Delete from firebase
            let actToRemove = mySchedule[mySchedule.index(after: (indexPath.row)-1)]
            removeFromFirebase(activity: actToRemove)
            //remove old notifications and add new ones
            mySchedule.remove(at: indexPath.row)
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
            for acti in mySchedule{
                setNotification(time: acti.start_time)
            }
            scheduleTable.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    //edit existing activity and update table cell (swipe to the right)
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let edit = UIContextualAction(style: .normal, title: "Edit") { (action, view, completion) in
            
            self.indexToEdit = indexPath.row
            self.performSegue(withIdentifier: "editSegue", sender: self)
            completion(true)
        }
        
        return UISwipeActionsConfiguration(actions: [edit])
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "createNewSegue" {
            let vc: NewActivityViewController = segue.destination as! NewActivityViewController
            vc.delegate = self
        }
        else if segue.identifier == "editSegue"{
            let vc: EditActivityViewController = segue.destination as! EditActivityViewController
            vc.delegate = self
            vc.activityToEdit = mySchedule[indexToEdit]
            vc.activityIndex = indexToEdit
        }
        else if segue.identifier == "fromSaveSegue"{
            let vc: SaveActivityViewController = segue.destination as! SaveActivityViewController
            vc.delegate = self
            vc.savedSchedule = savedList
        }
        else if segue.identifier == "viewSavedSegue"{
            let vc: SavedDisplayViewController = segue.destination as! SavedDisplayViewController
            vc.delegate = self
            vc.mySchedule = mySchedule
        }
       
    }
    
    
}

extension UIImageView {
    
    func roundImage() {
        let radius = self.frame.width / 2
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
}

