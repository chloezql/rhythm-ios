//
//  NewActivityViewController.swift
//  Rhytm
//
//  Created by Ziyuan Li on 4/24/20.
//  Copyright © 2020 NYUiOS. All rights reserved.
//

import UIKit

protocol activityDelegate{
    func addActivity(activity: Activity)
}

class NewActivityViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, datePickerDelegate, UITextFieldDelegate{
    
    //@IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var descriptionText: UITextField!
    @IBOutlet weak var timeTable: UITableView!
    
    @IBOutlet weak var blueTag: UIButton!
    @IBOutlet weak var redTag: UIButton!
    @IBOutlet weak var yellowTag: UIButton!
    
    @IBOutlet weak var blueHL: UIButton!
    @IBOutlet weak var redHL: UIButton!
    @IBOutlet weak var yellowHL: UIButton!
    
    weak var delegate: ViewController?
    
    var datePickerIndexPath: IndexPath?
    var myTexts: [String] = ["Start time", "End time"]
    var myDates: [Date] = [Date(),Date()]
    var newActivity = Activity(myName: "",myDesc: "",myStart: Date(), myEnd: Date(), myColor:"")
    var displayViewController: ViewController?
    
    override func viewDidLoad() {
        // Do any additional setup after loading the view.
        super.viewDidLoad()
        
        //scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height+100)
        
        timeTable.tableFooterView = UIView()
        
        timeTable.register(UINib(nibName: "DatePickerTableViewCell", bundle: nil), forCellReuseIdentifier: "DatePickerTableViewCellIdentifier")
        timeTable.register(UINib(nibName: "DateTextTableViewCell", bundle: nil), forCellReuseIdentifier: "DateTextTableViewCellIdentifier")
        
        self.timeTable.delegate = self
        self.timeTable.dataSource = self
        
        blueHL.isHidden = true
        redHL.isHidden = true
        yellowHL.isHidden = true
        
        blueTag.isSelected = false
        redTag.isSelected = false
        yellowTag.isSelected = false
    }
    
    
    
    @IBAction func addNew(_ sender: Any){
        //name of an activity is required
        //description and color are not required
        //start and end time has default
        
        //if missing required field, pop up alert
        if (nameText!.text == ""){
            let alert = UIAlertController(title: "Cannot add activity", message: "You are missing information to create an activity", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Got it!", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
            
        //schedule end time must be equal or later to start time
        else if (myDates[1]<myDates[0]){
            let alert2 = UIAlertController(title: "Cannot add activity", message: "You activity cannot end before it starts", preferredStyle: .alert)
                
                alert2.addAction(UIAlertAction(title: "Got it!", style: .default, handler: nil))
                self.present(alert2, animated: true)
        }
            
        //startDate cannot be in the past
        else if(myDates[0] < Date())
        {
            let alert = UIAlertController(title: "Cannot Add activity", message: "Start date cannot be in the past", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Got it!", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
        
        //If start time is the same as another schedule item, pop up alert
        else if (invalidStartTime())
        {
            let alert = UIAlertController(title: "Cannot add activity", message: "Start time confilict with other schedule item", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Got it!", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
            
        //go back and add activity to schedule if all requirements satisfied
        else {
            var currentColor = ""
            if (blueTag.isSelected == true){
                currentColor = "blue"
            }
            else if(redTag.isSelected == true){
                currentColor = "red"
            }
            else if(yellowTag.isSelected == true){
                currentColor = "yellow"
            }
            
            newActivity = Activity(myName: nameText.text!,myDesc: descriptionText.text!,myStart: myDates[0], myEnd: myDates[1], myColor: currentColor)
            
            self.delegate?.addActivity(activity: newActivity)
            
            dismiss(animated: true, completion: nil)
            
        }
    }
    
    func invalidStartTime() -> (Bool)
    {
        
        for activity in self.delegate!.mySchedule
        {
            if(myDates[0] == activity.start_time)
            {
                return (true)
            }
        }
        return (false)
    }

    //go back without adding anything
    @IBAction func goBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //add a color tag for activity
    @IBAction func addBlueTag(_ sender: Any) {
        blueTag.isSelected = true
        redTag.isSelected = false
        yellowTag.isSelected = false
        
        blueHL.isHidden = false;
        redHL.isHidden = true;
        yellowHL.isHidden = true;
        
    }
    
    @IBAction func addRedTag(_ sender: Any) {
        redTag.isSelected = true
        blueTag.isSelected = false
        yellowTag.isSelected = false
        
        redHL.isHidden = false;
        blueHL.isHidden = true;
        yellowHL.isHidden = true;
    }
    
    @IBAction func addYellowTag(_ sender: Any) {
        yellowTag.isSelected = true
        blueTag.isSelected = false
        redTag.isSelected = false
        
        yellowHL.isHidden = false;
        blueHL.isHidden = true;
        redHL.isHidden = true;
    }
    

    //setting up table view for inline date picker
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if datePickerIndexPath != nil {
            return 3
        } else {
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if datePickerIndexPath == indexPath {
            let datePickerCell = tableView.dequeueReusableCell(withIdentifier: "DatePickerTableViewCellIdentifier") as! DatePickerTableViewCell
            datePickerCell.updatePicker(date: myDates[indexPath.row - 1], indexPath: indexPath)
            datePickerCell.delegate = self
            return datePickerCell
        } else {
            let dateCell = tableView.dequeueReusableCell(withIdentifier: "DateTextTableViewCellIdentifier") as! DateTextTableViewCell
            dateCell.updateText(text: myTexts[indexPath.row], date: myDates[indexPath.row])

            return dateCell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if datePickerIndexPath == indexPath {
            return 165.0
        } else {
            return 44.0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.beginUpdates()
        if let datePickerIndexPath = datePickerIndexPath, datePickerIndexPath.row - 1 == indexPath.row {
            tableView.deleteRows(at: [datePickerIndexPath], with: .fade)
            tableView.deselectRow(at: indexPath, animated: true)
            self.datePickerIndexPath = nil
        } else {
            if let datePickerIndexPath = datePickerIndexPath {
                tableView.deleteRows(at: [datePickerIndexPath], with: .fade)
            }
            datePickerIndexPath = indexPathToInsertDatePicker(indexPath: indexPath)
            tableView.insertRows(at: [datePickerIndexPath!], with: .fade)
            tableView.deselectRow(at: indexPath, animated: true)
        }
        tableView.endUpdates()
    }
    
    func indexPathToInsertDatePicker(indexPath: IndexPath) -> IndexPath {
        if let datePickerIndexPath = datePickerIndexPath, datePickerIndexPath.row < indexPath.row {
            return indexPath
        } else {
            return IndexPath(row: indexPath.row + 1, section: indexPath.section)
        }
    }
    
    func dateChange(indexPath: IndexPath, date: Date) {
        myDates[indexPath.row] = date
        timeTable.reloadRows(at: [indexPath], with: .none)
    }
    
  
}
