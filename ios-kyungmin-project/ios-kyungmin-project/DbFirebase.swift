//
//  DbFirebase.swift
//  ch11-kyungmin-navigation
//
//  Created by kyungmin on 2023/05/22.
//


import Foundation
import UIKit
import FirebaseFirestore

class DbFirebase: Database {

    var reference: CollectionReference                    // firestore에서 데이터베이스 위치
    var parentNotification: ((Plan?, DbAction?) -> Void)? // PlanGroupViewController에서 설정
    var existQuery: ListenerRegistration?                 // 이미 설정한 Query의 존재여부

    required init(parentNotification: ((Plan?, DbAction?) -> Void)?) {
        self.parentNotification = parentNotification
         reference = Firestore.firestore().collection("plans") // 첫번째 "plans"라는 Collection
    }
    
//    func queryPlan(fromDate: Date, toDate: Date) {
//
//    }

//    func saveChange(plan: Plan, action: DbAction){
//
//    }

}

extension DbFirebase{
    
    func saveChange(plan: Plan, action: DbAction){
        if action == .Delete{
            reference.document(plan.key).delete()    // key로된 plan을 지운다
            return
        }
        // plan을 아카이빙한다.
       // let data = try? NSKeyedArchiver.archivedData(withRootObject: plan, requiringSecureCoding: false)

        // 저장 형태로 만든다
        let storeDate: [String : Any] = ["date": plan.date, "data": plan.toDict()]
        reference.document(plan.key).setData(storeDate)
    }
}

extension DbFirebase{
    
    func queryPlan(fromDate: Date, toDate: Date) {
        
        if let existQuery = existQuery{    // 이미 적용 쿼리가 있으면 제거, 중복 방지
            existQuery.remove()
        }
        // where plan.date >= fromDate and plan.date <= toDate
        let queryReference = reference.whereField("date", isGreaterThanOrEqualTo: fromDate).whereField("date", isLessThanOrEqualTo: toDate)

        // onChangingData는 쿼리를 만족하는 데이터가 있거나 firestore내에서 다른 앱에 의하여
        // 데이터가 변경되어 쿼리를 만족하는 데이터가 발생하면 호출해 달라는 것이다.
        existQuery = queryReference.addSnapshotListener(onChangingData)
    }
}

extension DbFirebase{
    func onChangingData(querySnapshot: QuerySnapshot?, error: Error?){
        guard let querySnapshot = querySnapshot else{ return }
        // 초기 데이터가 하나도 없는 경우에 count가 0이다
        if(querySnapshot.documentChanges.count <= 0){
            if let parentNotification = parentNotification { parentNotification(nil, nil)} // 부모에게 알림
        }
        // 쿼리를 만족하는 데이터가 많은 경우 한꺼번에 여러 데이터가 온다
        for documentChange in querySnapshot.documentChanges {
            let data = documentChange.document.data() //["date": date, "data": data!]로 구성되어 있다
            // [“data”: data]에서 data는 아카이빙되어 있으므로 언아카이빙이 필요
          //  let plan = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data["data"] as! Data) as? Plan
            let plan = Plan(date: Date(), owner: nil, kind: .Etc, content: " ")
            if let dictData = data["data"] as? [String : Any] {
                plan.toPlan(dict: dictData)
            }
            var action: DbAction?
            switch(documentChange.type){    // 단순히 DbAction으로 설정
                case    .added: action = .Add
                case    .modified: action = .Modify
                case    .removed: action = .Delete
            }
            if let parentNotification = parentNotification {parentNotification(plan, action)} // 부모에게 알림
        }
    }
}
