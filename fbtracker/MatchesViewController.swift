//
//  ViewController.swift
//  fbtracker
//
//  Created by Moshe Sivan on 13/03/2017.
//  Copyright © 2017 n72. All rights reserved.
//

import UIKit

class MatchesViewController: UITableViewController {

    var matches = [Match]()
    var postsIndex = [String: Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TrackerDbService.posts.forEach { self.postsIndex[$0.id] = $0 }
        self.matches = TrackerDbService.matches.filter { self.postsIndex[$0.id] != nil }.sorted(by: { (self.postsIndex[$0.id]?.time)! > (self.postsIndex[$1.id]?.time)! })
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.matches.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "MatchViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MatchViewCell  else {
            fatalError("The dequeued cell is not an instance of MatchViewCell.")
        }
        
        // Fetches the appropriate meal for the data source layout.
        let match = self.matches[indexPath.row]
        let matchTime = self.postsIndex[match.id]?.time
        
        let dateFor: DateFormatter = DateFormatter()
        dateFor.dateFormat = "HH:mm dd/MM/yyyy"
        
        cell.matchTime.text = dateFor.string(from: matchTime!)
        cell.matchText.text = match.text
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let match = self.matches[indexPath.row]
        UIApplication.shared.open(URL(string: match.link)!, options: [:], completionHandler: nil)
    }
}

class MatchViewCell: UITableViewCell {
    @IBOutlet weak var matchTime: UILabel!
    @IBOutlet weak var matchText: UILabel!
}
