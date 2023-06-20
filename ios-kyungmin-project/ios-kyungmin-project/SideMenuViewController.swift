//
//  SideMenuViewController.swift
//  ios-kyungmin-project
//
//  Created by kyungmin on 2023/06/18.
//

import Foundation
import UIKit

class SideMenuViewController: UITableViewController {
    let sections = ["내 정보", "매치 신청 현황"]

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        cell.textLabel?.text = sections[indexPath.section]

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let userDetailsViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UserDetailsViewController") as! UserDetailsViewController
        userDetailsViewController.section = sections[indexPath.section]

        navigationController?.pushViewController(userDetailsViewController, animated: true)
    }
}
