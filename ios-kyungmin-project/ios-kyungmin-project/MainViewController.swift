//
//  MainViewController.swift
//  ios-kyungmin-project
//
//  Created by kyungmin on 2023/06/17.
//

import UIKit
import FSCalendar

class MainViewController: UIViewController, MatchDelegate, FSCalendarDelegate  {

    @IBOutlet weak var imageView: UIImageView!
    @IBAction func matchesButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "ShowMatches", sender: self)
    }

    var matches = [Match]()
    
    var selectDate : Date?
    
    func didAddMatch(_ match: Match) {
           matches.append(match)
           
       }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        imageView.image = UIImage(named: "soccerGround.png")
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))

       
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowMatches",
            let matchesVC = segue.destination as? MatchesTableViewController {
            matchesVC.matches = matches
        }
        if segue.identifier == "goToMatchTimeSelection",
           let selectTeamVC = segue.destination as? SelectTeamMainViewController {
            selectTeamVC.delegate = self
            //selectTeamVC.initiaDate = selectDate
            selectTeamVC.initialDate = selectDate
        }
    }

    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        selectDate = date
    }

    @objc func addButtonTapped() {
        // 버튼이 눌렸을 때의 코드를 작성
        performSegue(withIdentifier: "goToMatchTimeSelection", sender: self)
    }
    

}

