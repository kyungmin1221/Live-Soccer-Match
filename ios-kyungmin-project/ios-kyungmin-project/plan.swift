//
//  plan.swift
//  ch09-kyungmin-tableView
//
//  Created by kyungmin on 2023/05/01.
//

import Foundation
import FirebaseFirestore
import Firebase

class Plan: NSObject, NSCoding{
    enum Kind: Int {
        case Todo = 0, Meeting, Study, Etc
        func toString() -> String{
            switch self {
                case .Todo: return "할일";     case .Meeting: return "미팅"
                case .Study: return "공부";    case .Etc: return "기타"
            }
        }
        static var count: Int { return Kind.Etc.rawValue + 1}
    }
    var key: String;        var date: Date
    var owner: String?;     var kind: Kind
    var content: String
    
    init(date: Date, owner: String?, kind: Kind, content: String){
        self.key = UUID().uuidString
        self.date = Date(timeInterval: 0, since: date)
        self.owner = Owner.getOwner()
        self.kind = kind; self.content = content
        super.init()
    }
    
    convenience init(date: Date? = nil, withData: Bool = false){
        if withData == true{
            var index = Int(arc4random_uniform(UInt32(Kind.count)))
            let kind = Kind(rawValue: index)!

            let contents = ["iOS 숙제", "졸업 프로젝트", "아르바이트","데이트","엄마 도와드리기"]
            index = Int(arc4random_uniform(UInt32(contents.count)))
            let content = contents[index]
            
            self.init(date: date ?? Date(), owner: "me", kind: kind, content: content)
            
        }else{
            self.init(date: date ?? Date(), owner: "me", kind: .Etc, content: "")

        }
    }
    
    func clone() -> Plan {
        let clonee = Plan()

        clonee.key = self.key
        clonee.date = Date(timeInterval: 0, since: self.date)
        clonee.owner = self.owner
        clonee.kind = self.kind
        clonee.content = self.content
        return clonee
    }
    
    // archiving할때 호출된다
        func encode(with aCoder: NSCoder) {
            aCoder.encode(key, forKey: "key")       // 내부적으로 String의 encode가 호출된다
            aCoder.encode(date, forKey: "date")
            aCoder.encode(owner, forKey: "owner")
            aCoder.encode(kind.rawValue, forKey: "kind")
            aCoder.encode(content, forKey: "content")
        }
        // unarchiving할때 호출된다
        required init(coder aDecoder: NSCoder) {
            key = aDecoder.decodeObject(forKey: "key") as! String? ?? "" // 내부적으로 String.init가 호출된다
            date = aDecoder.decodeObject(forKey: "date") as! Date
            owner = aDecoder.decodeObject(forKey: "owner") as? String
            let rawValue = aDecoder.decodeInteger(forKey: "kind")
            kind = Kind(rawValue: rawValue)!
            content = aDecoder.decodeObject(forKey: "content") as! String? ?? ""
            super.init()
        }
    
}

extension Plan {
    func toDict() -> [String: Any?]{
        var dict: [String: Any?] = [:]
        
        dict["key"] = key
        dict["date"] = Timestamp(date: date)
        dict["owner"] = owner
        dict["kind"] = kind.rawValue
        dict["content"] = content
        
        return dict
    }
    
    func toPlan(dict: [String: Any?]) {
        key = dict["key"] as! String
        date = Date()
        if let timestamp = dict["date"] as? Timestamp {
            date = timestamp.dateValue()
        }
        owner = dict["owner"] as? String
        let rawValue = dict["kind"] as! Int
        kind = Plan.Kind(rawValue: rawValue)!
        content = dict["content"] as! String
    }
}


class ViewController: UIViewController {
    // Plan 객체 생성
    let plan = Plan(date: Date(), owner: "me", kind: .Todo, content: "Test Content")

    override func viewDidLoad() {
        super.viewDidLoad()
        savePlanToFirebase()
        loadPlanFromFirebase()
    }

    func savePlanToFirebase() {
        // Firestore 인스턴스 생성
        let db = Firestore.firestore()

        // Plan 객체를 Firestore에 저장
        db.collection("plans").document(plan.key).setData(plan.toDict()) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
    }

    func loadPlanFromFirebase() {
        // Firestore 인스턴스 생성
        let db = Firestore.firestore()

        // Firestore에서 Plan 객체 불러오기
        db.collection("plans").document(plan.key).getDocument { (document, error) in
            if let document = document, document.exists {
                if let data = document.data() {
                    self.plan.toPlan(dict: data)
                }
            } else {
                print("Document does not exist")
            }
        }
    }
}

