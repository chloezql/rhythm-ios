//
//  ViewController.swift
//  TableDatabase
//
//  Created by sunshine on 5/3/20.
//  Copyright © 2020 NYUiOS. All rights reserved.
//
import UIKit
import Foundation
import Firebase
import FirebaseDatabase
import AVKit


class PlaylistViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
   

    @IBOutlet weak var TableView: UITableView!
    
    var table = [Videos]()
    var ref: DatabaseReference!
    //var ref2 : Firebase(url: FIREBASE_URL)

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference().child("songs")
        ref.observe(DataEventType.value, with: {(snapshot) in
            if snapshot.childrenCount > 0 {
                print(snapshot)//worked
                self.table.removeAll()
                
                for video in snapshot.children.allObjects as! [DataSnapshot] {
                    
                    let Object = video.value as? [String: AnyObject]
                    let Title = Object?["Title"]
                    let videolink = Object?["Link"]
                    
                    
                    let video = Videos(Title: Title as! String, Link: (videolink as! String))
                    self.table.append(video)
                    print(video.Title!)//worked
                    
                    self.TableView.reloadData()
                
                    
                }
            }
            
        })
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return table.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = TableView.dequeueReusableCell(withIdentifier: "playlistCell") as! TableViewCell
        
        let video: Videos
        
        video = table[indexPath.row]
        cell.titleLabel.text = video.Title
        
        return cell
        
        
    }
    /*
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let videoURL = URL(string: table[indexPath.row].Link!) else {
            return
        }
        
        let player = AVPlayer(url: videoURL)
        
        let controller = AVPlayerViewController()
        controller.player = player
        
        present(controller, animated: true) {
            player.play()
        }
    }
    */
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

