//
//  LoadingViewController.swift
//  fbtracker
//
//  Created by Moshe Sivan on 17/03/2017.
//  Copyright © 2017 n72. All rights reserved.
//

import UIKit

class LoadingViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        TrackerDbService.loadData() {
            DispatchQueue.main.async {
                let mainVC = self.storyboard?.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
                self.present(mainVC, animated: true, completion: nil)
            }
        }
    }
}
