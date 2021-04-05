//
//  SignInViewController.swift
//  Quiz
//
//  Created by 祥平 on 2021/04/01.
//

import UIKit
import FirebaseAuth

class SignInViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var mailTextField: UITextField!
    @IBOutlet weak var passTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mailTextField.delegate = self
        passTextField.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func login(_ sender: Any) {
        
        //ちゃんと入力されてるかの確認
        if mailTextField.text != "" && passTextField.text != "" {
            Auth.auth().signIn(withEmail: mailTextField.text!, password: passTextField.text!) { (user, error) in
                if error == nil {
                    UserDefaults.standard.setValue(self.mailTextField.text, forKey: "userName")
                    //ホーム画面へ移行
                    let menuVC = self.storyboard?.instantiateViewController(withIdentifier: "menuVC") as! MenuViewController
                    self.navigationController?.pushViewController(menuVC, animated: true)
                    
                } else {
                    self.alert(title: "エラー", message: "メールアドレスまたはパスワードが間違ってます。", actiontitle: "OK")
                }
            }
        } else {
            self.alert(title: "エラー", message: "入力されてない箇所があります。", actiontitle: "OK")
        }
        
    }
    
    @IBAction func resetpass(_ sender: Any) {
        
        let remindPasswordAlert = UIAlertController(title: "パスワードをリセット", message: "メールアドレスを入力してください", preferredStyle: .alert)
        remindPasswordAlert.addAction(UIAlertAction(title: "キャンセル", style: .cancel, handler: nil))
        remindPasswordAlert.addAction(UIAlertAction(title: "リセット", style: .default, handler: { (action) in
            let resetEmail = remindPasswordAlert.textFields?.first?.text
            Auth.auth().sendPasswordReset(withEmail: resetEmail!, completion: { (error) in
                DispatchQueue.main.async {
                    if error != nil {
                        self.alert(title: "エラー", message: "このメールアドレスは登録されてません。", actiontitle: "OK")
                    } else {
                        self.alert(title: "メールを送信しました。", message: "メールでパスワードの再設定を行ってください。", actiontitle: "OK")
                        
                    }
                }
            })
        }))
        remindPasswordAlert.addTextField { (textField) in
            textField.placeholder = "test@gmail.com"
        }
        self.present(remindPasswordAlert, animated: true, completion: nil)
        
    }
    
    //アラート
    func alert(title:String,message:String,actiontitle:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: actiontitle, style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        mailTextField.resignFirstResponder()
        passTextField.resignFirstResponder()
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
