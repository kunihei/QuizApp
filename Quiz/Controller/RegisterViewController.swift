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

class RegisterViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var verificationTextField: UITextField!
    
    var changeColor = ChangeColor()
    var gradientLayer = CAGradientLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textField.delegate = self
        passwordTextField.delegate = self
        verificationTextField.delegate = self
        
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
        
        //２つのフォームが入力されてる場合
        if textField.text != "" && passwordTextField.text != "" {
            //入力したパスワードが7文字以上の場合
            if (passwordTextField.text?.count)! > 6  {
                //会員登録開始
                Auth.auth().createUser(withEmail: textField.text!, password: passwordTextField.text!) { (user, error) in
                    //ログイン成功
                    if error == nil {
                        UserDefaults.standard.setValue(self.textField.text, forKey: "userName")
                        let menuVC = self.storyboard?.instantiateViewController(withIdentifier: "menuVC") as! MenuViewController
                        self.navigationController?.pushViewController(menuVC, animated: true)
                        self.textField.text = ""
                        self.passwordTextField.text = ""
                        self.verificationTextField.text = ""
                    }else{
                        //ログイン失敗
                        self.alert(title: "エラー", message: "ログイン失敗", actiontitle: "OK")
                        return
                    }
                }
                //入力したパスワードが6文字以下の場合
            } else {
                self.alert(title: "エラー", message: "7文字以上のパスワードを入力してください。", actiontitle: "OK")
            }
        }
        
    }
    
    //アラート
    func alert(title:String,message:String,actiontitle:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: actiontitle, style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        textField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        verificationTextField.resignFirstResponder()
    }
    
    @IBAction func login(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
}
