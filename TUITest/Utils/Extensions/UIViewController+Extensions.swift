//
//  UIViewController+Extensions.swift
//  TUITest
//
//  Created by dushantsw on 2020-01-29.
//  Copyright © 2020 Spacetabs Ltd. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    /// Convenience method for showing a generic alert with Ok action to dismiss
    ///
    /// - Parameters:
    ///   - title: The title to display on the alert
    ///   - message: The message to display on the alert
    ///   - completion: block called on completion
    func displayAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        ac.addAction(cancelAction)
        self.present(ac, animated: true, completion: completion)
    }
}
