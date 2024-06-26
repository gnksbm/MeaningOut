//
//  BaseButton.swift
//  MeaningOut
//
//  Created by gnksbm on 6/27/24.
//

import UIKit

class BaseButton: UIButton {
    init() {
        super.init(frame: .zero)
        configureUI()
        configureLayout()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        configureLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI() { }
    func configureLayout() { }
}
