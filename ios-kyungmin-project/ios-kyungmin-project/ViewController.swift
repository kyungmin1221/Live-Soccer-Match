//
//  ViewController.swift
//  ios-kyungmin-project
//
//  Created by kyungmin on 2023/06/17.
//

import UIKit

class ViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var mainimageView: UIImageView!
    @IBOutlet weak var liveimageView: UIImageView!
    
    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.textField.delegate = self
        liveimageView.image = UIImage(named: "live.png")
        mainimageView.image = UIImage(named: "formation.png")
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tapGesture)
    }
    

    @objc func handleTap(){
        textField.resignFirstResponder()
           
       }
    // "Enter" 키를 눌렀을 때 호출될 메소드
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // 입력된 팀 이름에 따라서 화면을 전환합니다.
        if let teamName = textField.text {
            performSegue(withIdentifier: "team", sender: self)
        }
        // 키보드를 내립니다.
        textField.resignFirstResponder()

        return true
    }
    
    

}


