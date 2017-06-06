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
import SwiftKeychainWrapper

class SignInVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailField: FancyField!
    @IBOutlet weak var passField: FancyField!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailField.delegate = self
        passField.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: .UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: .UIKeyboardDidHide, object: nil)
    
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    override func viewDidAppear(_ animated: Bool) {
        if let _ = KeychainWrapper.standard.string(forKey: KEY_UID){
            print("RODRIGO: ID Encontrado")
            performSegue(withIdentifier: "feedSegue", sender: nil)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Manipulacoes teclado
    func keyboardWillShow(notification: NSNotification){
        if let kbSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= kbSize.height
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification){
        if let kbSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0 {
                self.view.frame.origin.y += kbSize.height
            }
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func dismissKeyboard(){
        view.endEditing(true)
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
                if let user = user {
                    self.completeSignIn(id: user.uid)
                }
            }
        })
    }
    
    //MARK: Login via Email
    @IBAction func signInAction(_ sender: UIButton) {
        if let email = emailField.text, let pwd = passField.text {
            FIRAuth.auth()?.signIn(withEmail: email, password: pwd, completion: { (user, error) in
                if error == nil {
                    print("RODRIGO: Email - Usuário autenticado - FIREBASE")
                    if let user = user {
                    self.completeSignIn(id: user.uid)
                    }
                } else {
                    FIRAuth.auth()?.createUser(withEmail: email, password: pwd, completion: { (user, error) in
                        if error != nil{
                            print("RODRIGO: Email - Impossível autenticar - FIREBASE")
                        } else {
                            print("RODRIGO: Email - Usuário Criado - FIREBASE")
                            if let user = user {
                                self.completeSignIn(id: user.uid)
                            }
                        }
                    })
                }
            })
        }
    }

    func completeSignIn(id: String) {
       let keychainResult = KeychainWrapper.standard.set(id, forKey: KEY_UID)
        print("RODRIGO: Dados salvos. KEYCHAIN \(keychainResult)")
        performSegue(withIdentifier: "feedSegue", sender: nil)
    }
    
    

}

