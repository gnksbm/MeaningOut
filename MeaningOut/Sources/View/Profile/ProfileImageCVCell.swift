//
//  ProfileImageCVCell.swift
//  MeaningOut
//
//  Created by gnksbm on 6/15/24.
//

import UIKit

import SnapKit

final class ProfileImageCVCell: UICollectionViewCell {
    private let imageView = ProfileImageView(borderType: .small)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        setUnselected()
    }
    
    func configureCell(item: ProfileImage) {
        imageView.configureView(item: item)
    }
    
    func setSelected() {
        imageView.setBorderColor(color: .meaningOrange)
        imageView.alpha = 1
    }
    
    private func setUnselected() {
        imageView.setBorderColor(color: .meaningGray)
        imageView.alpha = 0.5
    }
    
    private func configureUI() {
        setUnselected()
    }
    
    private func configureLayout() {
        [imageView].forEach { contentView.addSubview($0) }
        
        imageView.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }
    }
}

#if DEBUG
import SwiftUI
struct ProfileImageCVCellPreview: PreviewProvider {
    static var previews: some View {
        let cell = ProfileImageCVCell()
        return cell.swiftUIView
            .frame(width: 100, height: 100)
            .onAppear {
                cell.configureCell(
                    item: ProfileImage(image: UIImage.profile0)
                )
            }
    }
}
#endif
