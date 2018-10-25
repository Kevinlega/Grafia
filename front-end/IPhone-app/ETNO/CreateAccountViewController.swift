//
//  CreateAccountViewController.swift
//  ETNO
//
//  Created by Kevin Legarreta on 10/2/18.
//  Copyright © 2018 Los Duendes Malvados. All rights reserved.
//
import UIKit
import Foundation

class CreateAccountViewController: UIViewController {
    
    // Name: Full name of new user ; STRING
    // Email: User e-mail ; STRING
    // Password: User password that'll be hashed ; STRING
    // ConfirmPassword: Repeated user password for confirmation ; STRING
    
    // MARK: - Text Fields and Variables
    @IBOutlet weak var Name: UITextField!
    @IBOutlet weak var Email: UITextField!
    @IBOutlet weak var Password: UITextField!
    @IBOutlet weak var ConfirmPassword: UITextField!
   
    var UserCanBeAdded = false
    
    // MARK: - Create User Action (Button Press)
    
    // When 'Create Account' button is pressed.
    // Input validation:
    // (A) Are any of the fields empty?
    // (B) Is Email already registered?
    //      (1) Is it even an email?
    // (C) Do Passwords match?
    
    @IBAction func CanUserBeCreated(_ sender: Any) {
        let UserPassword = Password.text
        let UserName = Name.text
        let UserEmail = Email.text
        let UserConfirmPassword = ConfirmPassword.text
        
        if (UserName!.isEmpty || UserEmail!.isEmpty || UserPassword!.isEmpty || UserConfirmPassword!.isEmpty){
        
            self.present(Alert(title: "Error", message: "All fields are requiered.", Dismiss: "Dismiss"),animated: true, completion: nil)
            }
        else{ if(isRegistered(email: UserEmail!)){
                
                self.present(Alert(title: "Error", message: "Email is already in use.", Dismiss: "Dismiss"),animated: true, completion: nil)
                }
        else{ if(UserPassword! != UserConfirmPassword!){
            
                self.present(Alert(title: "Error", message: "Passwords do not match.", Dismiss: "Dismiss"),animated: true, completion: nil)
                }
        else{
                UserCanBeAdded = true
                }
            }
        }
    }
    
    // MARK: - Default Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Segue Function
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "BackToLogin"){
            let _ = segue.destination as! LoginViewController
        }
        else if (segue.identifier == "CreateAccount"){
            if UserCanBeAdded{
                
                // Finally register the user:
                // Salt and Hash password
                
                var UserPassword = Password.text
                let UserName = Name.text
                let UserEmail = Email.text
                
                let initialValue = generateRandomUInt()
                let Salt = saltGenerator(length: 5, initialValue: initialValue)
                UserPassword = LFSR(data: UserPassword!, initialValue: initialValue)
                UserPassword = saltAndHash(password: UserPassword!,salt: Salt)
                
                // maybe do while?
                if CreateAccount(name: UserName!, email: UserEmail!,password: UserPassword!, salt: Salt){
                    let _ = segue.destination as! LoginViewController
                }
                else{
                    self.present(Alert(title: "Could not register", message: "Try Again", Dismiss: "Dismiss"),animated: true, completion: nil)
                }
            }
        }
    }
}