//
//  Extensions.swift
//  SampleFood
//
//  Created by Pankaj Yadav on 10/08/22.
//

import Foundation
import UIKit

extension UIViewController {

  func showAlert(withTitle title: String, message : String) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let OKAction = UIAlertAction(title: "OK", style: .default) { action in
        print("You've pressed OK Button")
    }
    alertController.addAction(OKAction)
    self.present(alertController, animated: true, completion: nil)
  }
}
