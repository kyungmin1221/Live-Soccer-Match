//
//  DbMemory.swift
//  ch09-kyungmin-tableView
//
//  Created by kyungmin on 2023/05/01.
//

import Foundation

class DbMemory: Database {
 
    private var storage: [Plan]

    var parentNotification: ((Plan?, DbAction?) -> Void)?

    required init(parentNotification: ((Plan?, DbAction?) -> Void)?) {

        self.parentNotification = parentNotification
        storage = []
        let amount = 50
        for _ in 0...amount{
            let delta = Int(arc4random_uniform(UInt32(amount))) - amount/2
            let date = Date(timeInterval: TimeInterval(delta*24*60*60), since: Date())
            storage.append(Plan(date: date, withData: true))
        }
    }
    
    func queryPlan(fromDate: Date, toDate: Date) {
        
        for i in 0..<storage.count{
            if storage[i].date >= fromDate && storage[i].date <= toDate{
                if let parentNotification = parentNotification{
        parentNotification(storage[i], .Add)
                }
            }
        }
    }
    
    func saveChange(plan: Plan, action: DbAction){
        if action == .Add{
            storage.append(plan)
        }else{
            for i in 0..<storage.count{
                if plan.key == storage[i].key{
                    if action == .Delete{ storage.remove(at: i) }
                    if action == .Modify{ storage[i] = plan }
                    break
                }
            }
        }
        if let parentNotification = parentNotification{
            parentNotification(plan, action)
        }
    }
}
