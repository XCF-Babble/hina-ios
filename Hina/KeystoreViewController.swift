//
//  KeystoreViewController.swift
//  Hina
//
//  Created by Jerry Zhou on 3/18/20.
//  Copyright © 2020 Jerry Zhou. All rights reserved.
//

import UIKit

class KeystoreViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem!.target = self
        navigationItem.rightBarButtonItem!.action = #selector(addButtonClicked)
    }

    @objc func addButtonClicked() {
        let alert = UIAlertController(title: "Add a new key", message: "Please enter the key to be added:", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { (action: UIAlertAction) -> Void in
            addKeyToKeystore(alert.textFields![0].text!)
            self.tableView.insertRows(at: [IndexPath(row: getKeystore().count - 1, section: 0)], with: .top)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addTextField { (textField: UITextField) in
            textField.placeholder = "Key"
        }
        present(alert, animated: true, completion: nil)
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

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            delKeyFromKeystore(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
