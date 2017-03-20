//
//  ViewController.swift
//  fbtracker
//
//  Created by Moshe Sivan on 13/03/2017.
//  Copyright © 2017 n72. All rights reserved.
//

import UIKit

class MatchesViewController: UITableViewController {

    var matches = [(String, [Match])]()
    var postsIndex = [String: Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.isOpaque = true
        
        let dateFor: DateFormatter = DateFormatter()
        dateFor.dateFormat = "dd/MM/yyyy"

        var matchesMap = [String: [Match]]()
        TrackerDbService.posts.forEach { self.postsIndex[$0.id] = $0 }
        TrackerDbService.matches.forEach {match in
            let post = self.postsIndex[match.id]
            if (post == nil) {
                return
            }
            
            let matchDate = dateFor.string(from: (post?.time)!)
            if (matchesMap[matchDate] == nil) {
                matchesMap[matchDate] = [match]
            } else {
                matchesMap[matchDate]?.append(match)
            }
        }
        
        matchesMap.keys.sorted(by: { $0 > $1 }).forEach { matchDate in
            matches.append((matchDate, (matchesMap[matchDate]?.sorted(by: { (self.postsIndex[$0.id]?.time)! > (self.postsIndex[$1.id]?.time)! }))!))
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.matches.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.matches[section].0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.matches[section].1.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "MatchViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MatchViewCell  else {
            fatalError("The dequeued cell is not an instance of MatchViewCell.")
        }
        
        // Fetches the appropriate meal for the data source layout.
        let match = self.matches[indexPath.section].1[indexPath.row]
        let matchTime = self.postsIndex[match.id]?.time
        
        let dateFor: DateFormatter = DateFormatter()
        dateFor.dateFormat = "HH:mm"
        
        cell.matchTime.text = dateFor.string(from: matchTime!)
        cell.matchText.text = match.text
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let match = self.matches[indexPath.section].1[indexPath.row]
        UIApplication.shared.open(URL(string: match.link)!, options: [:], completionHandler: nil)
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let favoriteAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Favorite", handler:{action, indexpath in
            print("fav");
        });
        favoriteAction.backgroundColor = UIColor(red: 0.298, green: 0.851, blue: 0.3922, alpha: 1.0);
        
        return [favoriteAction];
    }
}

class MatchViewCell: UITableViewCell {
    @IBOutlet weak var matchTime: UILabel!
    @IBOutlet weak var matchText: UILabel!
}
