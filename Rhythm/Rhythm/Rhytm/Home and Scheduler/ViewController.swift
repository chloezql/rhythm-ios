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


class ViewController: UIViewController, activityDelegate, activityEditDelegate,saveActivityDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var scheduleTable: UITableView!
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var username: UILabel!
    
    
    var pickerRow = 0
    var mySchedule: [Activity] = []
    var savedList: [Activity] = [Activity]()
    var scheduleIndexPath: IndexPath?
    var indexToEdit = -1
    var myIndex = 0
    
    var addNewSegue: UIStoryboardSegue!
    var addSaveSegue: UIStoryboardSegue!
    
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
        photo.roundImage()
        photo.image = UIImage(named: "AH.jpg")
        photo.layer.borderWidth = 1
        photo.layer.masksToBounds = false
        photo.layer.borderColor = UIColor.black.cgColor
        photo.layer.cornerRadius = photo.frame.height/2
        photo.clipsToBounds = true
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
    
    
    //add activity
    func addActivity(activity: Activity,addOrNot: Bool) {
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
    
    
    //add activity from saved
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
                _ =
                db.collection("users").document(userID).collection("Activities").document(dateAsString).setData(from: activity)
        } catch{
            print("Unable to add activity to firestore")
        }
    }
    
    
    func getActivitiesFromFirestore()
    {
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
                            self.mySchedule.sort(by: {$0.start_time < $1.start_time})
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
        //print(title)
        return title
    }
    
    //set up tableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mySchedule.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let activityCell = tableView.dequeueReusableCell(withIdentifier: "DisplayScheduleTableViewCellIdentifier",for: indexPath) as! DisplayScheduleTableViewCell
        
        activityCell.updateCell(startingTime: mySchedule[indexPath.row].start_time, color: mySchedule[indexPath.row].color, name: mySchedule[indexPath.row].name ,title: mySchedule[indexPath.row].song.Title!)
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
            
            let actToRemove = self.mySchedule[self.mySchedule.index(after: (indexPath.row)-1)]
            self.removeFromFirebase(activity: actToRemove)            
            self.indexToEdit = indexPath.row
            self.performSegue(withIdentifier: "editSegue", sender: self)
            completion(true)
        }
        
        return UISwipeActionsConfiguration(actions: [edit])
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editSegue"{
            let vc: EditActivityViewController = segue.destination as! EditActivityViewController
            vc.delegate = self
            vc.activityToEdit = mySchedule[indexToEdit]
            vc.activityIndex = indexToEdit
        }
        else if (segue.identifier == "timerSegue") {
            let vc: TimerViewController = segue.destination as! TimerViewController
            vc.schedule = mySchedule[indexToEdit]
        }
        
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        self.indexToEdit = indexPath.row

        // Create an instance of PlayerTableViewController and pass the variable
        //let destinationVC = TimerViewController()
        //destinationVC.schedule = schedule
        //destinationVC.performSegue(withIdentifier: "timerSegue", sender: self)
        self.performSegue(withIdentifier: "timerSegue", sender: self)
        tableView.deselectRow(at: indexPath, animated: false)
        
    }
}

extension UIImageView {
    
    func roundImage() {
        let radius = self.frame.width / 2
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
}

