//
//  RegisterViewController.swift
//  Quiz
//
//  Created by 祥平 on 2021/03/30.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestore
import EMAlertController

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var verificationTextField: UITextField!
    
    var changeColor = ChangeColor()
    var gradientLayer = CAGradientLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //バックの色を決めている
        gradientLayer = changeColor.changeColor(topR: 0.30, topG: 0.40, topB: 0.90, topAlpha: 1.0, bottomR: 0.80, bottomG: 0.60, bottomB: 0.20, bottomAlpha: 1.0)
        gradientLayer.frame = view.bounds
        
        view.layer.insertSublayer(gradientLayer, at: 0)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func login(){
        
        Auth.auth().signInAnonymously { (result, error) in
            if error != nil{
                print(error.debugDescription)
                return
            }
            
            let user = result?.user
            
            Firestore.firestore().collection("userAdmin").document().setData(["userName": self.textField.text as Any, "password": self.passwordTextField.text as Any])
            UserDefaults.standard.setValue(self.textField.text, forKey: "userName")
            let menuVC = self.storyboard?.instantiateViewController(identifier: "menuVC") as! MenuViewController
            self.navigationController?.pushViewController(menuVC, animated: true)
        }
        
    }
    
    @IBAction func done(_ sender: Any) {
        if passwordTextField.text != verificationTextField.text{
            let alert = EMAlertController(title: "エラー", message: "パスワードが一致していません！")
            let doneAction = EMAlertAction(title: "OK", style: .normal)
            alert.addAction(doneAction)
            present(alert, animated: true, completion: nil)
            
            return
        }
        
        if textField.text?.isEmpty != true && passwordTextField.text?.isEmpty != true && verificationTextField.text?.isEmpty != nil{
            login()
        }else{
            let alert = EMAlertController(title: "エラー", message: "名前を入力して下さい！")
            let doneAction = EMAlertAction(title: "OK", style: .normal)
            alert.addAction(doneAction)
            present(alert, animated: true, completion: nil)
            
            return
        }
        
        
    }

}
