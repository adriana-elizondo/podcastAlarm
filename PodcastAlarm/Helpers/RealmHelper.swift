//
//  RealmHelper.swift
//  PodcastAlarm
//
//  Created by Adriana Elizondo on 11/19/16.
//  Copyright © 2016 Adriana Elizondo. All rights reserved.
//

import Foundation
import RealmSwift

let realm = try! Realm()

class RealmHelper{
    
    static func fetchAlarms() -> [Alarm]{
        return Array(realm.objects(Alarm.self))
    }
    
    static func persistObject(object: Object, completion : @escaping (_ success : Bool, _ error: Any?) -> Void){
        DispatchQueue.main.async {
            do {
                try realm.write {
                    realm.add(object, update:true)
                }
                completion(true, object)
            }catch{
                completion(false, error)
            }
        }
    }
    
    static func deleteObject(object: Object, completion : @escaping (_ success : Bool, _ error: Any?) -> Void){
        DispatchQueue.main.async {
            do {
                try realm.write {
                    realm.delete(object)
                }
                completion(true, object)
            }catch{
                completion(false, error)
            }
        }
    }
}

protocol Persistable {
    associatedtype ManagedObject: RealmSwift.Object
    init(managedObject: ManagedObject)
    func managedObject() -> ManagedObject
}
