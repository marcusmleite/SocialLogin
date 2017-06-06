//
//  FeedVC.swift
//  omaLogin
//
//  Created by Rodrigo Vianna on 06/06/17.
//  Copyright © 2017 Rodrigo Vianna. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Firebase

class FeedVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func logout(_ sender: UIButton) {
        if (self.presentingViewController != nil) {
            self.dismiss(animated: false, completion: nil)
        }
        
        let _ = KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        
        try! FIRAuth.auth()?.signOut()
        print("RODRIGO: Keychain removida")
    }
}
