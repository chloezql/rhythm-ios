//
//  SavedDisplayViewController.swift
//  Rhytm
//
//  Created by Ziyuan Li on 5/3/20.
//  Copyright © 2020 NYUiOS. All rights reserved.
//

import UIKit

class SavedDisplayViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    var mySchedule: [Activity] = []
    //weak var delegate: ViewController?
    
    @IBOutlet weak var displaySavedActivities: UICollectionView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let homeVC = self.tabBarController!.viewControllers![0] as! ViewController
        mySchedule = homeVC.savedList
        displaySavedActivities.reloadData()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let bar = self.tabBarController!
        let homeVC = bar.viewControllers![0] as! ViewController
        mySchedule = homeVC.savedList
        
        displaySavedActivities.backgroundColor = UIColor(red: 205/255, green: 213/255, blue: 238/255, alpha: 1)
        
        self.displaySavedActivities.delegate = self
        self.displaySavedActivities.dataSource = self
        displaySavedActivities.register(UINib(nibName: "ActivityCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ActivityCollectionViewCellIdentifier")
        
        let flow = UICollectionViewFlowLayout()
        flow.sectionInset = UIEdgeInsets(top: 30, left: 6, bottom: 10, right: 6)
        flow.itemSize = CGSize(width: CGFloat(128), height: CGFloat(128))
        flow.minimumInteritemSpacing = 5
        flow.minimumLineSpacing = 10

        displaySavedActivities.setCollectionViewLayout(flow, animated: false)

        
    }
    
    
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mySchedule.count
    }
    

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        
        let displaySaved = collectionView.dequeueReusableCell(withReuseIdentifier: "ActivityCollectionViewCellIdentifier", for: indexPath) as! ActivityCollectionViewCell
        var currentDiscription = mySchedule[indexPath[1]].descrip
        if currentDiscription == ""{
            currentDiscription = "No Description"
        }
        displaySaved.updateText(name: mySchedule[indexPath[1]].name, description: currentDiscription)
        //print(mySchedule[indexPath[1]].name)
        //displaySaved.updateText(name: "name", description: "des")
        displaySaved.backgroundColor = UIColor.white
        return displaySaved
    }
    
    
    
    
}
