//
//  CompletedMatchesViewController.swift
//  ios-kyungmin-project
//
//  Created by kyungmin on 2023/06/18.
//

import Foundation
import UIKit

class CompletedMatchesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    var matches : [Match] = []

    @IBOutlet weak var tableView: UITableView!
    
       override func viewDidLoad() {
           super.viewDidLoad()
           tableView.dataSource = self
            tableView.delegate = self
           // matches를 사용하여 화면에 정보를 표시하세요.
           tableView.register(UITableViewCell.self, forCellReuseIdentifier: "MatchCell")

       }
    
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            
            // 매치 배열을 최신 상태로 업데이트하고 테이블 뷰를 새로고침합니다.
            matches = MatchManager.shared.completedMatches
            print(matches)
            tableView.reloadData()
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return matches.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
            let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell")!
            let match = matches[indexPath.row]
            
            // 셀에 표시할 데이터 설정
            cell.textLabel?.text = match.name
            // 날짜 표시를 위한 DateFormatter 설정
               let formatter = DateFormatter()
               formatter.dateFormat = "yyyy-MM-dd HH:mm"
               let dateString = formatter.string(from: match.time)
        
            print(match.name, match.sport,match.level,match.time) // 추가한 코드

               cell.detailTextLabel?.text = "\(match.sport), \(dateString), \(match.level)"
            
            return cell
        }

   
}

