//
//  PlanDetailViewController.swift
//  ch10-kyungmin-stackView
//
//  Created by kyungmin on 2023/05/08.
//


import UIKit

class PlanDetailViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var dateDatePicker: UIDatePicker!
    @IBOutlet weak var ownerLabel: UILabel!
    @IBOutlet weak var typePicker: UIPickerView!
    @IBOutlet weak var contentTextView: UITextView!
    
    var plan: Plan?
    var saveChangeDelegate: ((Plan)-> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        typePicker.dataSource = self
        typePicker.delegate = self
        
        plan = plan ?? Plan(date: Date(), withData: true)
        dateDatePicker.date = plan?.date ?? Date()
        ownerLabel.text = plan?.owner

        if let plan = plan{
            typePicker.selectRow(plan.kind.rawValue, inComponent: 0, animated: false)
        }
        contentTextView.text = plan?.content
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)

        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPress))
        contentTextView.addGestureRecognizer(longPressGesture)

    }
    override func viewDidDisappear(_ animated: Bool) {
        if let saveChangeDelegate = saveChangeDelegate{
            plan!.content = contentTextView.text
            plan!.date = dateDatePicker.date
            plan!.owner = ownerLabel.text
            plan!.kind = Plan.Kind(rawValue: typePicker.selectedRow(inComponent: 0))!
            plan!.content = contentTextView.text
            saveChangeDelegate(plan!)
        }
    }
    
    @objc func dismissKeyboard(sender: UITapGestureRecognizer){
        contentTextView.resignFirstResponder()
    }
    
    @objc func longPress(sender: UILongPressGestureRecognizer){
        if sender.state == .began {
            performSegue(withIdentifier: "ShowContent", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowContent" {
            let selectContentViewController = segue.destination as! SelectContentViewController
            selectContentViewController.planDetailViewController = self
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Plan.Kind.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let type = Plan.Kind(rawValue: row)
        return type!.toString()
    }
    
}

extension PlanDetailViewController{
    @IBAction func gotoBack(_ sender: UIButton) {
        plan!.date = dateDatePicker.date
        plan!.owner = ownerLabel.text
        plan!.kind = Plan.Kind(rawValue: typePicker.selectedRow(inComponent: 0))!
        plan!.content = contentTextView.text

        saveChangeDelegate?(plan!)
        //dismiss(animated: true, completion: nil)
        navigationController?.popViewController(animated: true)

    }
}

