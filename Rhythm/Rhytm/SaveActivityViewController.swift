//
//  SaveActivityViewController.swift
//  Rhytm
//
//  Created by Ziyuan Li on 4/24/20.
//  Copyright © 2020 NYUiOS. All rights reserved.
//

import UIKit

class SaveActivityViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, datePickerDelegate {
    //@IBOutlet weak var scrolllView: UIScrollView!
    
    @IBOutlet weak var blueTag: UIButton!
    @IBOutlet weak var redTag: UIButton!
    @IBOutlet weak var yellowTag: UIButton!
    
    @IBOutlet weak var blueHL: UIButton!
    @IBOutlet weak var redHL: UIButton!
    @IBOutlet weak var yellowHL: UIButton!
    
    @IBOutlet weak var timeTable: UITableView!
    var datePickerIndexPath: IndexPath?
    var myTexts: [String] = ["Start time", "End time"]
    var myDates: [Date] = [Date(),Date()]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
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
    
    @IBAction func addSave(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func goBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    //setting up inline date picker
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
            
            //dateCell.delegate = self
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
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
