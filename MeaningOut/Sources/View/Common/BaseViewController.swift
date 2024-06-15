//
//  BaseViewController.swift
//  MeaningOut
//
//  Created by gnksbm on 6/15/24.
//

import UIKit

class BaseViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .meaningWhite
        navigationController?.navigationBar.topItem?.title = ""
    }
}
