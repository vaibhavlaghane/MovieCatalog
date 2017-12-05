//
//  Utility.swift
//  MovieCatalog
//
//  Created by vlaghane on 12/5/17.
//  Copyright © 2017 Drones. All rights reserved.
//

import UIKit

class Utility: NSObject {


class func showAlertMessage(_ message: String, withTitle title: String, onClick completion: @escaping () -> Void) {
    let alert = UIAlertController(title: " \(title)", message: message, preferredStyle: .alert)
    //Add Buttons
    let okButton = UIAlertAction(title: "Ok", style: .default, handler: {(_ action: UIAlertAction) -> Void in
        //Handle button action here
        completion()
    })
    alert.addAction(okButton)
    
    var rootViewController = UIApplication.shared.keyWindow?.rootViewController
    if let navigationController = rootViewController as? UINavigationController {
        rootViewController = navigationController.viewControllers.first
    }
    if let tabBarController = rootViewController as? UITabBarController {
        rootViewController = tabBarController.selectedViewController
    }
    rootViewController?.present(alert, animated: true, completion: nil)
}

}
