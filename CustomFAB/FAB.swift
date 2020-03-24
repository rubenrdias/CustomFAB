//
//  FAB.swift
//  CustomFAB
//
//  Created by Ruben Dias on 23/03/2020.
//  Copyright © 2020 Ruben Dias. All rights reserved.
//

import UIKit

class FAB: RoundButton {
    
    struct FABItem {
        let title: String
        let icon: String
        let color: UIColor?
        let action: Selector
    }
    
    static let buttonHeight: CGFloat = 50
    static let buttonPadding: CGFloat = 16
    static private var itemSpacing: CGFloat { return buttonHeight * 0.3 }
    static private var itemHeight: CGFloat { return buttonHeight * 0.9 }
    
    static private var baseAnimationDuration: TimeInterval { return Double(items.count) * itemAnimationDuration }
    static private let itemAnimationDuration: TimeInterval = 0.05
    static private var speedyAnimationsFactor: Double = 0.15
    
    var tabBarHeight: CGFloat = 0.0
    
    static var items = [FABItem]()
    
    private var itemButtons = [RoundButton]()
    private var itemButtonLabels = [UIButton]()
    
    private var isExpanded = false
    private var baseViewController: UIViewController?
    private var keyWindow: UIWindow!
        
    lazy var backgroundView: BlurredView = {
        let view = BlurredView()
        view.alpha = 0
        view.frame = keyWindow.frame
        view.isUserInteractionEnabled = true
        return view
    }()
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = UIColor.systemBlue
        tintColor = .white
        setImage(UIImage(named: "icon_plus")!.withRenderingMode(.alwaysTemplate), for: .normal)
        addTarget(self, action: #selector(btnTapped), for: .touchUpInside)
        
        createItems()
    }
    
    static func setItems(_ items: [FABItem]) {
        FAB.items.append(contentsOf: items)
    }
    
    @objc private func btnTapped() {
        keyWindow = UIApplication.shared.windows.filter{$0.isKeyWindow}.first!
        isExpanded ? dismissFAB(completion: nil) : expandFAB()
    }
    
    private func expandFAB() {
        moveToKeyWindow()

        showItems()
        UIView.animate(withDuration: FAB.baseAnimationDuration, animations: {
            self.transform = CGAffineTransform(rotationAngle: .pi/4)
            self.backgroundView.alpha = 1
        }) { _ in
            self.isExpanded = true
        }
    }
    
    private func moveToKeyWindow() {
        removeFromSuperview()
        
        keyWindow.addSubview(backgroundView)
        keyWindow.addSubview(self)
        
        let xPadding = FAB.buttonPadding
        let yPadding = tabBarHeight + FAB.buttonPadding
        NSLayoutConstraint.activate([
            rightAnchor.constraint(equalTo: keyWindow.rightAnchor, constant: -xPadding),
            bottomAnchor.constraint(equalTo: keyWindow.bottomAnchor, constant: -yPadding),
            heightAnchor.constraint(equalToConstant: FAB.buttonHeight),
            widthAnchor.constraint(equalToConstant: FAB.buttonHeight)
        ])
    }
    
    func showItems() {
        guard itemButtons.count > 0 else { return }
        
        showItemButton(completion: nil)
    }
    
    private func createItems() {
        if FAB.items.count == 0 {
            FAB.items.append(FABItem(title: "First Item", icon: "icon_heart", color: nil, action: #selector(firstItemPressed)))
            FAB.items.append(FABItem(title: "Second Item", icon: "icon_trophy", color: nil, action: #selector(secondItemPressed)))
        }
        
        FAB.items.forEach {
            let button = RoundButton()
            button.setImage(UIImage(named: $0.icon)!.withRenderingMode(.alwaysTemplate), for: .normal)
            if let color = $0.color {
                button.backgroundColor = color
                button.tintColor = .white
            }
            else {
                button.backgroundColor = UIColor.systemBackground
                button.tintColor = UIColor.systemGray
            }
            button.alpha = 0
            button.addTarget(self, action: $0.action, for: .touchUpInside)
            itemButtons.append(button)
            
            let labelButton = UIButton()
            let attributtedTitle = NSAttributedString(string: $0.title, attributes: [.foregroundColor: UIColor.white, .font: UIFont.systemFont(ofSize: 20, weight: .semibold)])
            labelButton.setAttributedTitle(attributtedTitle, for: .normal)
            labelButton.alpha = 0
            labelButton.addTarget(self, action: $0.action, for: .touchUpInside)
            itemButtonLabels.append(labelButton)
        }
    }
    
    private func showItemButton(withIndex index: Int = 0, completion: (()->())?) {
        let button = itemButtons[index]
        let buttonLabel = itemButtonLabels[index]
        addButtonToView(buttonWithIndex: index)
        
        UIView.animate(withDuration: FAB.itemAnimationDuration, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 15, options: .allowUserInteraction, animations: {
            button.alpha = 1
            button.transform = .identity
            buttonLabel.alpha = 1
        }) { _ in
            if index == self.itemButtons.count - 1 {
                completion?()
            }
            else {
                self.showItemButton(withIndex: index + 1, completion: nil)
            }
        }
    }
    
    private func addButtonToView(buttonWithIndex index: Int) {
        let button = itemButtons[index]
        let buttonLabel = itemButtonLabels[index]
        
        keyWindow.addSubview(button)
        keyWindow.addSubview(buttonLabel)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        buttonLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let itemBottomAnchor = index == 0 ? topAnchor : itemButtons[index-1].topAnchor
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: centerXAnchor),
            button.bottomAnchor.constraint(equalTo: itemBottomAnchor, constant: -FAB.itemSpacing),
            button.heightAnchor.constraint(equalToConstant: FAB.itemHeight),
            button.widthAnchor.constraint(equalToConstant: FAB.itemHeight)
        ])
        
        NSLayoutConstraint.activate([
            buttonLabel.centerYAnchor.constraint(equalTo: button.centerYAnchor),
            buttonLabel.rightAnchor.constraint(equalTo: button.leftAnchor, constant: -FAB.buttonPadding),
            buttonLabel.heightAnchor.constraint(equalToConstant: FAB.itemHeight)
        ])
        
        button.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
    }
    
    private func dismissFAB(isSpeedy: Bool = false, completion: (()->())? ) {
        hideItemButtons(startingWithIndex: itemButtons.count - 1, isSpeedy: isSpeedy) {
            let animationDuration = FAB.baseAnimationDuration * (isSpeedy ? FAB.speedyAnimationsFactor : 1)
            
            UIView.animate(withDuration: animationDuration, animations: {
                self.transform = .identity
                self.backgroundView.alpha = 0
            }) { _ in
                self.isExpanded = false
                self.moveToBaseController()
                completion?()
            }
        }
    }
    
    private func hideItemButtons(startingWithIndex index: Int, isSpeedy: Bool = false, completion: (()->())?) {
        let button = itemButtons[index]
        let buttonLabel = itemButtonLabels[index]
        let animationDuration = FAB.itemAnimationDuration * (isSpeedy ? FAB.speedyAnimationsFactor : 1)
        
        UIView.animate(withDuration: animationDuration, animations: {
            button.alpha = 0
            buttonLabel.alpha = 0
        }) { _ in
            button.removeFromSuperview()
            buttonLabel.removeFromSuperview()
            
            if index == 0 {
                completion?()
            }
            else {
                self.hideItemButtons(startingWithIndex: index - 1) { completion?() }
            }
        }
    }
    
    func addToController(_ vc: UIViewController) {
        baseViewController = vc
        
        if let tabBar = vc.tabBarController?.tabBar {
            tabBarHeight = tabBar.bounds.height
        }
        
        vc.view.addSubview(self)
        NSLayoutConstraint.activate([
            rightAnchor.constraint(equalTo: vc.view.rightAnchor, constant: -FAB.buttonPadding),
            bottomAnchor.constraint(equalTo: vc.view.safeAreaLayoutGuide.bottomAnchor, constant: -FAB.buttonPadding),
            heightAnchor.constraint(equalToConstant: FAB.buttonHeight),
            widthAnchor.constraint(equalToConstant: FAB.buttonHeight)
        ])
    }
    
    private func moveToBaseController() {
        guard let vc = baseViewController else { return }
        
        removeFromSuperview()
        backgroundView.removeFromSuperview()
        addToController(vc)
    }
    
    @objc private func firstItemPressed() {
        dismissFAB(isSpeedy: true) {
            self.presentSimpleAlert(message: "First Item pressed")
        }
    }
    
    @objc private func secondItemPressed() {
        dismissFAB(isSpeedy: true) {
            self.presentSimpleAlert(message: "Second Item pressed")
        }
    }
    
    private func presentSimpleAlert(message: String) {
        let alertController = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alertController.addAction(okAction)
        
        baseViewController?.present(alertController, animated: true, completion: nil)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
