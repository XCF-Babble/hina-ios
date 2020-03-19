//
//  ScaleViewController.swift
//  Hina
//
//  Created by Jerry Zhou on 4/4/20.
//  Copyright © 2020 Jerry Zhou. All rights reserved.
//

import UIKit

class ScaleViewController: UITableViewController {
    @IBOutlet var widthTextField: UITextField!
    @IBOutlet var heightTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem!.target = self
        navigationItem.rightBarButtonItem!.action = #selector(nextButtonClicked)
        widthTextField.text = String(Int(globalImage!.size.width))
        heightTextField.text = String(Int(globalImage!.size.height))
    }

    @objc func nextButtonClicked() {
        let width = Int(widthTextField.text!)
        let height = Int(heightTextField.text!)
        guard width != nil && height != nil else {
            let alert = UIAlertController(title: "Error", message: "Please enter a valid size.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        DispatchQueue.global(qos: .userInitiated).async {
            globalImage = globalImage?.scale(CGSize(width: width!, height: height!))
            DispatchQueue.main.async {
                let vc = self.storyboard!.instantiateViewController(identifier: "previewViewController")
                self.navigationController!.pushViewController(vc, animated: true)
            }
        }
    }
}
