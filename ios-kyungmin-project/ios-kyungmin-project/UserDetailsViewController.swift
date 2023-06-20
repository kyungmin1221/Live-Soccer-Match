//
//  UserDetailsViewController.swift
//  ios-kyungmin-project
//
//  Created by kyungmin on 2023/06/18.
//

import Foundation
import UIKit

class UserDetailsViewController: UIViewController {
    var section: String?

    @IBOutlet weak var infoLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        switch section {
        case "내 정보":
            infoLabel.text = "내 정보입니다." // 실제 정보로 변경해주세요.
        case "매치 신청 현황":
            infoLabel.text = "매치 신청 현황입니다." // 실제 정보로 변경해주세요.
        default:
            break
        }
    }
}

