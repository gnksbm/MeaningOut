//
//  UIKitPreviewHelper.swift
//  MeaningOut
//
//  Created by gnksbm on 6/13/24.
//

#if DEBUG
import SwiftUI

extension UIView {
    var swiftUIView: some View {
        UIViewSwiftUIView(self)
    }
    
    var randomColorForHierarchy: some View {
        subviews.forEach { $0.setRandomBackground() }
        return setRandomBackground().swiftUIView
    }
    
    @discardableResult
    fileprivate func setRandomBackground() -> Self {
        func makeRandomColor() -> UIColor {
            UIColor(
                red: .random(in: 0...1),
                green: .random(in: 0...1),
                blue: .random(in: 0...1),
                alpha: 1
            )
        }
        backgroundColor = makeRandomColor()
        subviews.forEach { $0.backgroundColor = makeRandomColor() }
        return self
    }
}

extension UIViewController {
    var swiftUIView: some View {
        UIViewControllerSwiftUIView(self)
    }
    
    var randomColorForHierarchy: some View {
        view.setRandomBackground()
        return swiftUIView
    }
    
    var swiftUIViewWithNavigation: some View {
        UINavigationController(rootViewController: self).swiftUIView
    }
    
    var swiftUIViewPushed: some View {
        let navController = UINavigationController(
            rootViewController: UIViewController()
        )
        navController.pushViewController(self, animated: false)
        return navController.swiftUIView
    }
}

fileprivate struct UIViewControllerSwiftUIView: UIViewControllerRepresentable {
    private let viewController: UIViewController
    
    init(_ viewController: UIViewController) {
        self.viewController = viewController
    }
    
    func makeUIViewController(context: Context) -> some UIViewController {
        viewController
    }
    
    func updateUIViewController(
        _ uiViewController: UIViewControllerType,
        context: Context
    ) {
    }
}

fileprivate struct UIViewSwiftUIView: UIViewRepresentable {
    private let view: UIView
    
    init(_ view: UIView) {
        self.view = view
    }
    
    func makeUIView(context: Context) -> some UIView {
        view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
    }
}
#endif
