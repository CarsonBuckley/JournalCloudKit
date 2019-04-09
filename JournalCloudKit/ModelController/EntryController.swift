//
//  EntryController.swift
//  JournalCloudKit
//
//  Created by Carson Buckley on 4/8/19.
//  Copyright © 2019 Launch. All rights reserved.
//

import Foundation
import CloudKit

class EntryController{
    
    static let shared = EntryController()
    private init() {}
    
    var entries: [Entry] = []
    
    func save(entry: Entry, completion: @escaping (Bool) -> ()){
        let record = CKRecord(entry: entry)
        CKContainer.default().publicCloudDatabase.save(record) { (record, error) in
            if let error = error{
                print("\(error.localizedDescription) \(error) in function: \(#function)")
                completion(false)
                return
            }
            guard let record = record,
                let entry = Entry(ckRecord: record) else { completion(false) ; return }
            self.entries.append(entry)
            completion(true)
        }
    }
    
    func addEntryWith(title: String, body: String, completion: @escaping (Bool) -> Void){
        let entry = Entry(title: title, body: body)
        save(entry: entry, completion: completion)
    }
    
    func fetchEntries(completion: @escaping (Bool) -> Void){
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: EntryConstants.RecordType, predicate: predicate)
        CKContainer.default().publicCloudDatabase.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error{
                print("\(error.localizedDescription) \(error) in function: \(#function)")
                completion(false)
                return
            }
            guard let records = records else { completion(false) ; return }
            let entries = records.compactMap{ Entry(ckRecord: $0) }
            self.entries = entries
            completion(true)
        }
    }
}
