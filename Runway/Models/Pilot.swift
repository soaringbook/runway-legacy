//
//  Pilot.swift
//  Runway
//
//  Created by Jelle Vandenbeeck on 02/10/15.
//  Copyright © 2015 Soaring Book. All rights reserved.
//

import RealmSwift

class Pilot: Object {
    dynamic var id: Int = 0
    dynamic var first_name: String = ""
    dynamic var last_name: String = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    // MARK: - Queries
    
    static func filterPilotsToDelete(ids ids: [Int], realm: Realm) -> Results<Pilot> {
        let filter = NSPredicate(format: "NOT (id in %@)", ids)
        return realm.objects(Pilot).filter(filter)
    }
}