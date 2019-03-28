//
//  ViewController.swift
//  HOZOMBOL
//
//  Created by Haitham Abdel Wahab on 3/6/19.
//  Copyright © 2019 IOSDeveloper. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout{


    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
     collectionView.delegate = self
     collectionView.dataSource = self
        
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell  {
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "Formcell", for: indexPath) as! FormCell
        
        if indexPath.row == 0 {
            cell.containerUserName.isHidden = true
            cell.actionBtn.setTitle("LOGIN", for: .normal)
            cell.slideBtn.setTitle("SIGN UP 👉🏻", for: .normal)
            cell.slideBtn.addTarget(self, action: #selector(slideToSignInCell(_:)), for: .touchUpInside)
            cell.actionBtn.addTarget(self, action: #selector(didPressSignIn(_:)), for: .touchUpInside)

        }else if indexPath.row == 1 {
            cell.containerUserName.isHidden = false
            cell.actionBtn.setTitle("SIGN UP", for: .normal)
            cell.slideBtn.setTitle("👈🏻 SIGN IN", for: .normal)
            cell.slideBtn.addTarget(self, action: #selector(slideToSignUpCell(_:)), for: .touchUpInside)
            cell.actionBtn.addTarget(self, action: #selector(didPressSignUp(_:)), for: .touchUpInside)

        }
        
       
        return cell
    }
    
    @objc func didPressSignIn(_ sender: UIButton) {
        let indexpath = IndexPath(row: 0, section: 0)
        let cell  = self.collectionView.cellForItem(at: indexpath) as! FormCell
        guard let emailAddress = cell.emailTF.text, let password = cell.passTF.text else {
            return
            
        }
        
        if (emailAddress.isEmpty == true  || password.isEmpty == true) {
            self.displayError(errorText: "Please Fill Empty Fields")
            
        } else {
        Auth.auth().signIn(withEmail: emailAddress, password: password) { (result, error) in
            if (error == nil) {
                self.dismiss(animated: true, completion: nil)
            } else {
                self.displayError(errorText: "Wrong Email or Password!") }}}}
    func displayError(errorText: String) {
        let alert = UIAlertController.init(title: "Error", message: errorText, preferredStyle: .alert)
        let dismissBtn = UIAlertAction.init(title: "Dismiss", style: .default, handler: nil)
       alert.addAction(dismissBtn)
        self.present(alert, animated: true, completion: nil)
    }
    @objc func didPressSignUp(_ sender : UIButton) {
        let indexpath = IndexPath(row: 1, section: 0)
        let cell  = self.collectionView.cellForItem(at: indexpath) as! FormCell
        guard let emailAddress = cell.emailTF.text, let password = cell.passTF.text else {
            return
        }
        
        
        if (emailAddress.isEmpty == true  || password.isEmpty == true) {
            self.displayError(errorText: "Please Fill Empty Fields")
            
        } else {
            
        
        Auth.auth().createUser(withEmail: emailAddress, password: password) {
            (result, error) in
            if (error == nil) {
                
                
                
                       let reference = Database.database().reference()
                guard let userId =
                    result?.user.uid , let userName = cell.userNameTF.text else {
                        return
                }
                self.dismiss(animated: true, completion: nil)

                
                let user = reference.child("users").child(userId)
                let dataArray :[String: Any] = ["username" : userName ]
                user.setValue(dataArray)
                
                
            } else {
                self.displayError(errorText: "Wrong Email or Password or Username") }}

        }
        
    }
    @objc   func slideToSignInCell (_ sender :UIButton){
        let indexpath = IndexPath(row: 1, section: 0)
        self.collectionView.scrollToItem(at: indexpath, at: [.centeredHorizontally], animated: true)
    }
    
    @objc   func slideToSignUpCell (_ sender :UIButton){
        let indexpath = IndexPath(row: 0, section: 0)
        self.collectionView.scrollToItem(at: indexpath, at: [.centeredHorizontally], animated: true)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
        
    }
    

}

