//
//  ViewController.swift
//  tell_me_what_to_do
//
//  Created by Madeline Tjoa on 5/8/20.
//  Copyright © 2020 Madeline Tjoa. All rights reserved.
//
import UIKit
import MongoSwift
import StitchCore

class WelcomeViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        title = "Welcome"
        if stitch.auth.isLoggedIn {
            self.navigationController?.pushViewController(TodoTableViewController(), animated: true)
        } else {
            let alertController = UIAlertController(title: "Login to Stitch", message: "Anonymous Login", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Login", style: .default, handler: { [unowned self] _ -> Void in
                stitch.auth.login(withCredential: AnonymousCredential()) { [weak self] result in
                    switch result {
                    case .failure(let e):
                        fatalError(e.localizedDescription)
                    case .success:
                        DispatchQueue.main.async {
                            self?.navigationController?.pushViewController(TodoTableViewController(), animated: true)
                        }
                    }
                }
            }))
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
