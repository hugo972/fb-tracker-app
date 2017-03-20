//
//  InfoViewController.swift
//  fbtracker
//
//  Created by Moshe Sivan on 17/03/2017.
//  Copyright © 2017 n72. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController {
    @IBOutlet weak var postsCount: UILabel!
    @IBOutlet weak var lastRunTime: UILabel!
    @IBOutlet weak var lastMatchTime: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if (TrackerDbService.posts.count == 0) {
            return
        }
        
        let dateFor: DateFormatter = DateFormatter()
        dateFor.dateFormat = "HH:mm dd/MM/yyyy"
        
        self.postsCount.text = "\(TrackerDbService.posts.count) Posts - \(TrackerDbService.matches.count) Matches"
        self.lastRunTime.text = dateFor.string(from: (TrackerDbService.posts.max { $0.time < $1.time }?.time)!)
        self.lastMatchTime.text = dateFor.string(from: (TrackerDbService.posts.filter { $0.match }.max { $0.time < $1.time }?.time)!)
    }
}
