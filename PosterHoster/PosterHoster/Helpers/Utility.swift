//
//  Utility.swift
//  PosterHoster
//
//  Created by Kartik Gupta on 14/05/22.
//

import Foundation
import UIKit

class Utility {
    static func showAlert(title: String? = Constants.emptyString, message: String, onController controller: UIViewController) {
        DispatchQueue.main.async {
            let alert = UIAlertController.init(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
            let dismissAction = UIAlertAction.init(title: Constants.okButtonTitle, style: UIAlertAction.Style.cancel, handler: nil)
            alert.addAction(dismissAction)
            controller.present(alert, animated: true, completion: nil)
        }
    }
}
