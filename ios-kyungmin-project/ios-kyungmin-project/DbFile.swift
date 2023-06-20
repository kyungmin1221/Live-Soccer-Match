//
//  DbFile.swift
//  ch11-kyungmin-navigation
//
//  Created by kyungmin on 2023/05/22.
//

import Foundation


class DbFile: Database {

    var parentNotification: ((Plan?, DbAction?) -> Void)?       // PlanGroup에서 설정
    var dbDir: URL                    // 디렉토리 위치
        
    required init(parentNotification: ((Plan?, DbAction?) -> Void)?) {
    self.parentNotification = parentNotification
            
    // 샌드박스에서     documents의 위치이다
    dbDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    print(dbDir.path) // 디렉토리 출력
        
    }
    
}

extension DbFile{
    func saveChange(plan: Plan, action: DbAction){
        // 파일 이름을 만든다 yyyy-mm-dd hh:mm:ss.archive
        let fileName = plan.date.toStringDateTime() + ".achive"
        if action == .Delete{
            // 파일자체를 지운다
            if let _ = try? FileManager.default.removeItem(at: dbDir.appendingPathComponent(fileName)){
                if let parentNotification = parentNotification{
                    parentNotification(plan, action) // planGroup에게도 삭제 사실을 알린다
                }
            }
            return
        }
        // 아카이빙을 한다
        let archivedPlan = try? NSKeyedArchiver.archivedData(withRootObject: plan, requiringSecureCoding: false)
        // 파일이 이미 존재하면 overwrite, 없으면 생성한다
        if let _ = try? archivedPlan?.write(to: dbDir.appendingPathComponent(fileName)){
            if let parentNotification = parentNotification{
                parentNotification(plan, action) // planGroup에게도 삽입 또는 수정 사실을 알린다
            }
        }
    }
}

extension DbFile {
    func queryPlan(fromDate: Date, toDate: Date) {
        
        // 디렉토리의 모든 파일 목록을 읽어 온다. fileList는 단순히 파일이름들의 배열이다.
        guard var fileList = try? FileManager.default.contentsOfDirectory(atPath: dbDir.path) else{ return }
        // 파일 이름으로 정렬한다
        fileList.sort(by: {$0 < $1})
        
        let fromStr = fromDate.toStringDateTime() // 20XX-MM-dd hh:mm:ss
        let toStr = toDate.toStringDateTime()    // 20XX-MM-dd hh:mm:ss
        
        for i in 0..<fileList.count{
            if fileList[i] < fromStr{continue}  // 이전 파일은 패스
            if fileList[i] > toStr{break}       // 이후 파일도 패스
            guard let archived = try? Data(contentsOf: dbDir.appendingPathComponent(fileList[i])) else{ continue }
            guard let plan = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(archived) as? Plan else{ continue }
            
            if let parentNotification = parentNotification{
                parentNotification(plan, .Add) // 부모에게 알림
            }
        }
    }
}
    
