//
//  SelectKeyViewController.swift
//  Hina
//
//  Created by Jerry Zhou on 3/18/20.
//  Copyright © 2020 Jerry Zhou. All rights reserved.
//

import UIKit

class SelectKeyViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getKeystore().count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "keyEntryCell", for: indexPath)
        cell.textLabel!.text = getKeystore()[indexPath.row]
        if cell.textLabel!.text == "" {
            cell.textLabel!.text = "Empty"
            cell.textLabel!.textColor = .lightGray
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        globalPassword = getKeystore()[indexPath.row]
        let vc = storyboard!.instantiateViewController(identifier: "scaleViewController")
        navigationController!.pushViewController(vc, animated: true)
    }
}
