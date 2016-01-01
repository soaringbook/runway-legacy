//
//  WinterView.swift
//  Runway
//
//  Created by Jelle Vandebeeck on 21/11/15.
//  Copyright © 2015 Soaring Book. All rights reserved.
//

import UIKit

protocol WinterViewDelegate {
    func winterView(view: WinterView, didSelectRegistration registration: Registration, atIndexPath indexPath: NSIndexPath)
    func winterViewWillStartRegistration(view: WinterView)
}

class WinterView: UIView, UICollectionViewDataSource, UICollectionViewDelegate {
    @IBOutlet var collectionView: UICollectionView!
    
    var delegate: WinterViewDelegate?
    
    var registrations: [Registration] = [Registration]()
    
    // MARK: - Init
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.registerNib(UINib(nibName: "NamedImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        collectionView.registerNib(UINib(nibName: "IconCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "Add")
        invalidateLayout()
        
        NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: "updateTimer", userInfo: nil, repeats: true)
    }
    
    func invalidateLayout() {
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.sectionInset = UIEdgeInsetsMake(0.0, 20.0, 20.0, 20.0)
        }
    }
    
    // MARK: - Data
    
    func reloadData() {
        collectionView.reloadData()
    }
    
    func removeRegistration(atIndexPath indexPath: NSIndexPath) {
        registrations.removeAtIndex(rowForRegistration(atIndexPath: indexPath))
        collectionView.deleteItemsAtIndexPaths([indexPath])
    }
    
    // MARK: - Timer
    
    func updateTimer() {
        for cell in collectionView.visibleCells() {
            if let indexPath = collectionView.indexPathForCell(cell) {
                if let cell = cell as? NamedImageCollectionViewCell {
                    let registration = registrations[rowForRegistration(atIndexPath: indexPath)]
                    cell.update(time: registration.startedAt)
                }
            }
        }
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0 {
            delegate?.winterViewWillStartRegistration(self)
        } else {
            let registration = registrations[rowForRegistration(atIndexPath: indexPath)]
            delegate?.winterView(self, didSelectRegistration: registration, atIndexPath: indexPath)
        }
    }
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Add an extra add cell.
        return registrations.count + 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            return addCell(forIndexPath: indexPath)
        } else {
            return registrationCell(forIndexPath: indexPath)
        }
    }
    
    // MARK: - Cells
    
    private func addCell(forIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Add", forIndexPath: indexPath)
        return cell
    }
    
    private func registrationCell(forIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! NamedImageCollectionViewCell
        let item = registrations[rowForRegistration(atIndexPath: indexPath)]
        cell.configure(item: item.pilot!)
        return cell
    }
    
    // MARK: - Index path
    
    private func rowForRegistration(atIndexPath indexPath: NSIndexPath) -> Int {
        return indexPath.item - 1
    }
}