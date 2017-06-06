//
//  ViewController.swift
//  omaLogin
//
//  Created by Rodrigo Vianna on 05/06/17.
//  Copyright © 2017 Rodrigo Vianna. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
import Firebase

class SignInVC: UIViewController {

    @IBOutlet weak var emailField: FancyField!
    @IBOutlet weak var passField: FancyField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    //MARK: Login via Facebook
    @IBAction func facebookLogin(_ sender: UIButton) {
        
        let facebookLogin = FBSDKLoginManager()
        
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if error != nil {
                print("RODRIGO: Nao autenticou com Facebook - \(error)")
            } else if result?.isCancelled == true {
                print("RODRIGO: Usuário cancelou")
            } else {
                print("RODRIGO: Autenticou")
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.firebaseAuth(credential)
            }
        }
    }
    
    //MARK: Autenticacao via Firebase
    func firebaseAuth(_ credential: FIRAuthCredential) {
        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
            if error != nil {
                print("RODRIGO: Nao autenticou FIREBASE")
            } else {
                print("RODRIGO: Autenticou - FIREBASE")
            }
        })
    }
    
    //MARK: Login via Email
    @IBAction func signInAction(_ sender: UIButton) {
        if let email = emailField.text, let pwd = passField.text {
            FIRAuth.auth()?.signIn(withEmail: email, password: pwd, completion: { (user, error) in
                if error == nil {
                    print("RODRIGO: Email - Usuário autenticado - FIREBASE")
                } else {
                    FIRAuth.auth()?.createUser(withEmail: email, password: pwd, completion: { (user, error) in
                        if error != nil{
                            print("RODRIGO: Email - Impossível autenticar - FIREBASE")
                        } else {
                            print("RODRIGO: Email - Usuário Criado - FIREBASE")
                        }
                    })
                }
            })
        }
        
        
    }
    
    
    

}

