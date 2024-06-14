//
//  ViewController.swift
//  MeaningOut
//
//  Created by gnksbm on 6/13/24.
//

import UIKit

final class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

#if DEBUG
import SwiftUI
struct ViewControllerPreview: PreviewProvider {
    static var previews: some View {
        ViewController().swiftUIView
    }
}
#endif
