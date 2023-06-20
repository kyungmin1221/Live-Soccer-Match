//
//  SelectTeamViewController.swift
//  ios-kyungmin-project
//
//  Created by kyungmin on 2023/06/17.
//
//
import UIKit

class SelectTeamMainViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var datePickerView: UIDatePicker!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var levelPickerView: UIPickerView!
    
    var initialDate: Date?

    let sports = ["풋살", "축구"]
    let levels = ["상", "중", "하"]

    override func viewDidLoad() {
        super.viewDidLoad()

        pickerView.delegate = self
        pickerView.dataSource = self

        levelPickerView.delegate = self
        levelPickerView.dataSource = self

        // datePickerView의 date를 현재 시간으로 설정하고, 시간을 선택할 수 있도록 설정
        datePickerView.date = initialDate ?? Date()
        datePickerView.datePickerMode = .time
        
        datePickerView.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tapGesture)


    }
    

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == self.pickerView {
            return sports.count
        } else if pickerView == self.levelPickerView {
            return levels.count
        } else {
            return 0
        }
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == self.pickerView {
            return sports[row]
        } else if pickerView == self.levelPickerView {
            return levels[row]
        } else {
            return nil
        }
    }
    
    var delegate: MatchDelegate?

       @IBAction func doneButtonPressed(_ sender: UIButton) {
           let sport = sports[pickerView.selectedRow(inComponent: 0)]
           let level = levels[levelPickerView.selectedRow(inComponent: 0)]
           let name = nameTextField.text ?? ""


           let time = datePickerView.date

           let match = Match(sport: sport, level: level, name: name, time: time)
           delegate?.didAddMatch(match)

           self.dismiss(animated: true, completion: nil)

       }

    @objc func dateChanged(_ sender: UIDatePicker) {
            let selectedDate = sender.date
            let currentDate = Date()
            let twoHoursAfter = Calendar.current.date(byAdding: .hour, value: 2, to: currentDate)!

            if selectedDate < currentDate || selectedDate < twoHoursAfter {
                let alert = UIAlertController(title: "경고", message: "선택하신 시간이 현재시간보다 이전이거나, 현재시간으로부터 2시간 이전입니다. 올바른 시간을 선택해주세요.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { _ in
                    self.datePickerView.date = currentDate // Reset to current date
                }))
                present(alert, animated: true)
            }
        }
    

    @objc func handleTap(){
        nameTextField.resignFirstResponder()
           
       }
    // "Enter" 키를 눌렀을 때 호출될 메소드
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        // 키보드를 내립니다.
        textField.resignFirstResponder()

        return true
     }
}

   protocol MatchDelegate {
       func didAddMatch(_ match: Match)
   }

struct Match {
    var sport: String
    var level: String
    var name: String
    var time: Date
    var weather: WeatherData?
    
    func toDictionary() -> [String: Any] {
        return [
            "sport": sport,
            "level": level,
            "teamName": name,
            "date": time
        ]
    }
    
    static func fromDictionary(_ dictionary: [String: Any]) -> Match? {
        guard let sport = dictionary["sport"] as? String,
            let level = dictionary["level"] as? String,
            let name = dictionary["teamName"] as? String,
            let time = dictionary["date"] as? Date else {
                return nil
        }

        return Match(sport: sport, level: level, name: name, time: time)
    }
}


