//
//  PreviewViewController.swift
//  Hina
//
//  Created by Jerry Zhou on 3/19/20.
//  Copyright © 2020 Jerry Zhou. All rights reserved.
//

import UIKit

class PreviewViewController: UIViewController, UIScrollViewDelegate {
    @IBOutlet weak var scrollView: UIScrollView!
    var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftBarButtonItem!.target = self
        navigationItem.leftBarButtonItem!.action = #selector(doneButtonClicked)
        navigationItem.rightBarButtonItem!.target = self
        navigationItem.rightBarButtonItem!.action = #selector(shareButtonClicked)
        navigationItem.leftBarButtonItem!.isEnabled = false
        navigationItem.rightBarButtonItem!.isEnabled = false

        imageView = UIImageView()
        imageView.frame = scrollView.frame
        imageView.backgroundColor = .black
        imageView.contentMode = .scaleAspectFit
        scrollView.addSubview(imageView)

        let indicator = UIActivityIndicatorView(style: .large)
        indicator.frame = scrollView.frame
        indicator.color = .white
        scrollView.addSubview(indicator)
        indicator.startAnimating()

        DispatchQueue.global(qos: .userInitiated).async {
            let image = hinaWrapper(image: globalImage!, password: globalPassword, decrypt: globalDecrypting)
            DispatchQueue.main.async {
                guard image != nil else {
                    let alert = UIAlertController(title: "Error", message: "An unexpected error has occurred.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction) in
                        self.navigationController!.popToRootViewController(animated: true)
                    }))
                    self.present(alert, animated: true, completion: nil)
                    return
                }
                self.imageView.image = image
                indicator.stopAnimating()
                self.navigationItem.leftBarButtonItem!.isEnabled = true
                self.navigationItem.rightBarButtonItem!.isEnabled = true
                self.navigationItem.title = "\(Int(image!.size.width))x\(Int(image!.size.height))"
            }
        }
    }

    @objc func doneButtonClicked() {
        navigationController!.popToRootViewController(animated: true)
    }

    @objc func shareButtonClicked() {
        let activity = UIActivityViewController(activityItems: [imageView.image!], applicationActivities: nil)
        present(activity, animated: true, completion: nil)
    }

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
