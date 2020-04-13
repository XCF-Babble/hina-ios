/*
* Copyright (c) 2020, The Hina Authors
* All rights reserved.
*
* Redistribution and use in source and binary forms, with or without
* modification, are permitted provided that the following conditions are met:
*
* 1. Redistributions of source code must retain the above copyright notice, this
*    list of conditions and the following disclaimer.
*
* 2. Redistributions in binary form must reproduce the above copyright notice,
*    this list of conditions and the following disclaimer in the documentation
*    and/or other materials provided with the distribution.
*
* 3. Neither the name of the copyright holder nor the names of its
*    contributors may be used to endorse or promote products derived from
*    this software without specific prior written permission.
*
* THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
* AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
* IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
* DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
* FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
* DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
* SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
* CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
* OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
* OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

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
