//
//  MakeMatchViewController.swift
//  ios-kyungmin-project
//
//  Created by kyungmin on 2023/06/17.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase


class MakeMatchViewController : UIViewController {
    
    var match : Match!
    var completedMatches = [Match]()
    
    
    @IBOutlet weak var matchTextField: UILabel!
    @IBOutlet weak var matchButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let match = match {
            matchTextField.text = "\(match.sport) - \(match.level) - \(match.time) - \(match.name)"
               }
   
    }
    
    @IBAction func applyButtonTapped(_ sender: UIButton) {
        let alert = UIAlertController(title: "매치 신청", message: "정말로 매치를 신청하시겠습니까?", preferredStyle: .alert)
           alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
           alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { _ in
               // 신청 코드를 여기에 작성
               print("매치 신청이 완료되었습니다!")

               // 그리고, 신청 상황을 사용자 정보에 업데이트
               // 새로운 매치를 completedMatches 배열에 추가합니다.
               MatchManager.shared.completedMatches.append(self.match)
               print(MatchManager.shared.completedMatches) // 배열에 추가된 후 배열 상태 출력

            
        }))
        present(alert, animated: true, completion: nil)
           
        
       }
 
    
}
