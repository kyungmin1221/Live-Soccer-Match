//
//  Owner.swift
//  ch10-kyungmin-stackView
//
//  Created by kyungmin on 2023/05/08.
//

import UIKit

class Owner{
    static var owner: String?
    static func loadOwner(sender: UIViewController){
        if let owner = UserDefaults.standard.string(forKey: "owner"){
            Owner.owner = owner; return
        }
        
        let alertController = UIAlertController(title: "Owner", message: "Owner을 입력하세요", preferredStyle: .alert)
        alertController.addTextField(configurationHandler: nil)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: {
            (action) in
            if let owner = alertController.textFields?[0].text{
                Owner.owner = owner
                UserDefaults.standard.set(owner, forKey: "owner")
            }
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        sender.present(alertController, animated: true, completion: nil)
    }
    static func getOwner() -> String{
        if let owner = Owner.owner{return owner}
        return ""
    }
}
