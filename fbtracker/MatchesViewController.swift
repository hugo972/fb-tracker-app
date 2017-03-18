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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.matches = TrackerDbService.matches
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
        
        cell.matchText.text = match.text
        
        return cell
    }
}

class MatchViewCell: UITableViewCell {
    @IBOutlet weak var matchText: UILabel!
}
