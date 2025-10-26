//
//  ViewController+Ext.swift
//  TestForInterview
//
//  Created by Max Potapov on 25.10.2025.
//

import UIKit

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension UIViewController {
    func setupThemeToggleButton() {
        let themeButton = UIBarButtonItem(image: UIImage(systemName: "circle.righthalf.filled"),
                                          style: .plain,
                                          target: self,
                                          action: #selector(toggleTheme))
        themeButton.tintColor = .tabBarReversed
        navigationItem.rightBarButtonItem = themeButton
    }
    
    @objc private func toggleTheme() {
        let currentStyle = UserConfigProvider.shared.currentTheme
        let newTheme: UIUserInterfaceStyle = currentStyle == .dark ? .light : .dark
        UserConfigProvider.shared.currentTheme = newTheme
    }
}

extension UIViewController {
    func showAlertWith(title: String, message: String,
                       firstButtonTitle: String? = nil,
                       firstButtonStyle: UIAlertAction.Style = .default,
                       secondButtonTitle: String? = nil,
                       secondButtonStyle: UIAlertAction.Style = .default,
                       withFirstCallback callBackFirst: ((UIAlertAction) -> Void)? = nil,
                       withSecondCallback callBackSecond: ((UIAlertAction) -> Void)? = nil) {
       let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)

        if let firstButtonTitle = firstButtonTitle {
            alertController.addAction(UIAlertAction(title: firstButtonTitle,
                                                    style: firstButtonStyle,
                                                    handler: callBackFirst))
        }

        if let secondButtonTitle = secondButtonTitle {
            alertController.addAction(UIAlertAction(title: secondButtonTitle,
                                                    style: secondButtonStyle,
                                                    handler: callBackSecond))
        }
        present(alertController, animated: true, completion: nil)
    }
}
