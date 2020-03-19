//
//  HinaViewController.swift
//  Hina
//
//  Created by Jerry Zhou on 3/18/20.
//  Copyright © 2020 Jerry Zhou. All rights reserved.
//

import UIKit

class HinaViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                globalDecrypting = false
            } else {
                globalDecrypting = true
            }
            doHina()
        }
    }

    func doHina() {
        if getKeystore().count == 0 {
            let alert = UIAlertController(title: "No Key Available", message: "Please add a key in the keystore to proceed.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction) in
                let vc = self.storyboard!.instantiateViewController(identifier: "keystoreViewController")
                self.navigationController!.pushViewController(vc, animated: true)
            }))
            present(alert, animated: true, completion: nil)
            return
        }

        let picker = UIImagePickerController()
        picker.delegate = self
        picker.mediaTypes = ["public.image"]
        picker.sourceType = .photoLibrary
        let handler = { () -> Void in
            self.present(picker, animated: true, completion: nil)
        }
        if !globalDecrypting && UIImagePickerController.isSourceTypeAvailable(.camera) {
            let alert = UIAlertController(title: "Choose a Source", message: nil, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action: UIAlertAction) in
                handler()
            }))
            alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action: UIAlertAction) in
                picker.sourceType = .camera
                handler()
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        handler()
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        globalImage = (info[.originalImage] as! UIImage).fixOrientation()
        if picker.sourceType == .camera {
            UIImageWriteToSavedPhotosAlbum(globalImage!, nil, nil, nil)
        }
        let vc = storyboard!.instantiateViewController(identifier: "selectKeyViewController") as! SelectKeyViewController
        navigationController!.pushViewController(vc, animated: true)
    }
}
