//
//  BaseViewController.swift
//  MeaningOut
//
//  Created by gnksbm on 6/15/24.
//

import UIKit

class BaseViewController: UIViewController {
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .meaningWhite
        navigationController?.navigationBar.topItem?.title = ""
    }
}
