//
//  SettingsViewController.swift
//  Runway
//
//  Created by Jelle Vandebeeck on 11/11/15.
//  Copyright © 2015 Soaring Book. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    var settingsView: SettingsView! { return self.view as! SettingsView }
    
    private let service: SBSyncService = SBSyncService()
    private var updatesTimer: NSTimer?
    
    // MARK: - View
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingsView.setupUpdateText(updatedPilots: 0)
        fetchUpdates()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        updatesTimer?.invalidate()
        service.cancel()
    }
    
    // MARK: - Updates
    
    private func scheduleFetchUpdates() {
        self.updatesTimer = NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: "fetchUpdates", userInfo: nil, repeats: false)
    }
    
    func fetchUpdates() {
        updatesTimer?.invalidate()
        service.fetchUpdates { updatedPilots in
            dispatch_main {
                self.settingsView.setupUpdateText(updatedPilots: updatedPilots)
                self.scheduleFetchUpdates()
            }
        }
    }
    
    // MARK: - Actions
    
    @IBAction func disconnect(sender: AnyObject) {
        SBKeychain.sharedInstance.token = nil
        SBSyncService().deleteData()
        performSegueWithIdentifier("Disconnect", sender: nil)
    }
    
    @IBAction func synchronise(sender: AnyObject) {
        updatesTimer?.invalidate()
        settingsView.startAnimating()
        service.sync { error in
            dispatch_main {
                self.updatesTimer?.invalidate()
                self.fetchUpdates()
                self.settingsView.stopAnimating()
            }
        }
    }
    
    // MARK: - Status bar
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}