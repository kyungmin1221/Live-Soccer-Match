//
//  PlanGroup.swift
//  ch09-kyungmin-tableView
//
//  Created by kyungmin on 2023/05/01.
//

import Foundation
import Firebase
import FirebaseFirestore

class PlanGroup: NSObject{
    var plans = [Plan]()
    var fromDate, toDate: Date?
    var database: Database!
    var parentNotification: ((Plan?, DbAction?) -> Void)?
    
    
    init(parentNotification: ((Plan?, DbAction?) -> Void)? ){
        super.init()
        self.parentNotification = parentNotification
        //database = DbMemory(parentNotification: receivingNotification)
        database =  DbFirebase(parentNotification: receivingNotification)
        //database =  DbFile(parentNotification: receivingNotification)

    }
    
    func receivingNotification(plan: Plan?, action: DbAction?){
       
        if let plan = plan{
            switch(action){
                case .Add: addPlan(plan: plan)
                case .Modify: modifyPlan(modifiedPlan: plan)
                case .Delete: removePlan(removedPlan: plan)
                default: break
            }
        }
        if let parentNotification = parentNotification{
            parentNotification(plan, action)
        }
    }
    
    func queryData(date: Date){
        plans.removeAll()
        
     
        fromDate = date.firstOfMonth().firstOfWeek()
        toDate = date.lastOfMonth().lastOfWeek()
        database.queryPlan(fromDate: fromDate!, toDate: toDate!)
    }
    
    func saveChange(plan: Plan, action: DbAction){
        
        database.saveChange(plan: plan, action: action)
    }
    
    func getPlans(date: Date? = nil) -> [Plan] {
        
       
        if let date = date{
            var planForDate: [Plan] = []
            let start = date.firstOfDay()
            let end = date.lastOfDay()
            for plan in plans{
                if plan.date >= start && plan.date <= end {
                    planForDate.append(plan)
                }
            }
            return planForDate
        }
        return plans
    }

    private func count() -> Int{ return plans.count }
    
    func isIn(date: Date) -> Bool{
        if let from = fromDate, let to = toDate{
            return (date >= from && date <= to) ? true: false
        }
        return false
    }
    
    private func find(_ key: String) -> Int?{
        for i in 0..<plans.count{
            if key == plans[i].key{
                return i
            }
        }
        return nil
    }
    
    private func addPlan(plan:Plan){ plans.append(plan) }
    private func modifyPlan(modifiedPlan: Plan){
        if let index = find(modifiedPlan.key){
            plans[index] = modifiedPlan
        }
    }
    private func removePlan(removedPlan: Plan){
        if let index = find(removedPlan.key){
            plans.remove(at: index)
        }
    }
    func changePlan(from: Plan, to: Plan){
        if let fromIndex = find(from.key), let toIndex = find(to.key) {
            plans[fromIndex] = to
            plans[toIndex] = from
        }
    }
}
