//
//  MatchesTableViewController.swift
//  ios-kyungmin-project
//
//  Created by kyungmin on 2023/06/17.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase

class MatchesTableViewController : UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var matches: [Match] = []
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var matchOkButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "일정삭제", style: .plain, target: self, action: #selector(toggleEditing))

    }
    
    @IBAction func OkButton(_ sender: UIButton) {
        let matches = MatchManager.shared.completedMatches
        self.performSegue(withIdentifier: "showCompletedMatches", sender: self)
    }

    @objc func toggleEditing() {
        tableView.isEditing = !tableView.isEditing
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matches.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MatchCell", for: indexPath)
        let match = matches[indexPath.row]
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        let dateString = formatter.string(from: match.time)
        cell.textLabel?.text = "\(dateString)-\(match.sport) - \(match.level) - \(match.name)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // 알림창을 생성하고 설정합니다.
            let alert = UIAlertController(title: "경고", message: "정말로 일정을 삭제하시겠습니까?", preferredStyle: .alert)
            
            // 취소 버튼을 추가합니다.
            alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
            
            // 삭제 버튼을 추가합니다. 이 버튼을 누르면 실제로 목록이 삭제됩니다.
            alert.addAction(UIAlertAction(title: "삭제", style: .destructive, handler: { action in
                self.matches.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }))
            
            // 알림창을 표시합니다.
            present(alert, animated: true, completion: nil)
        }
    }
    
    // 셀 선택 시, 새로운 창으로 이동
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let match = matches[indexPath.row]
        performSegue(withIdentifier: "gotoMatch", sender: match)
    }
    
    // 데이터를 다음 ViewController로 전달
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "gotoMatch",
           let matchRequestVC = segue.destination as? MakeMatchViewController,
           let match = sender as? Match {
            matchRequestVC.match = match
        } else if segue.identifier == "showCompletedMatches",
                  let completedMatchesVC = segue.destination as? CompletedMatchesViewController {
            completedMatchesVC.matches = MatchManager.shared.completedMatches
            
        }
 
    }
    
}
