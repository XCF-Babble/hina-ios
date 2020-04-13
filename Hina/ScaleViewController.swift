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
