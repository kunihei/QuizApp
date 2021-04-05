//
//  MenuViewController.swift
//  Quiz
//
//  Created by 祥平 on 2021/03/30.
//

import UIKit
import Firebase
import FirebaseAuth
import EMAlertController

class MenuViewController: UIViewController {
    
    let getQuizuAnswer = GetQuizuAnswer()
    
    var changeColor = ChangeColor()
    var gradientLayer = CAGradientLayer()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //バックの色を決めている
        gradientLayer = changeColor.changeColor(topR: 0.88, topG: 0.56, topB: 0.78, topAlpha: 1.0, bottomR: 0.44, bottomG: 0.87, bottomB: 0.89, bottomAlpha: 1.0)
        gradientLayer.frame = view.bounds
        
        view.layer.insertSublayer(gradientLayer, at: 0)

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        getQuizuAnswer.quizuList = []
        getQuizuAnswer.MondaiLabel()
    }
    
    @IBAction func quizuChallenging(_ sender: Any) {
        if getQuizuAnswer.quizuList.isEmpty == true{
            //アラート
            let alert = EMAlertController(title: "問題の登録がありません", message: "問題を登録してから挑戦して下さい！")
            let doneAction = EMAlertAction(title: "OK", style: .normal)
            alert.addAction(doneAction)
            present(alert, animated: true, completion: nil)
            return
        }
        let quizuMenuVC = self.storyboard?.instantiateViewController(withIdentifier: "quizuMenu")
        self.navigationController?.pushViewController(quizuMenuVC!, animated: true)
    }
    
    @IBAction func setting(_ sender: Any) {
        
        if getQuizuAnswer.quizuList.isEmpty == true{
            //アラート
            let alert = EMAlertController(title: "編集する問題がありません", message: "問題を登録したら編集可能です！")
            let doneAction = EMAlertAction(title: "OK", style: .normal)
            alert.addAction(doneAction)
            present(alert, animated: true, completion: nil)
            return
        }
        let settingVC = self.storyboard?.instantiateViewController(withIdentifier: "setting") as? SettingViewController
        self.navigationController?.pushViewController(settingVC!, animated: true)
        
    }
    
    
    @IBAction func logout(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            UserDefaults.standard.removeObject(forKey: "userName")
            let loginVC = self.storyboard?.instantiateViewController(identifier: "loginVC") as! SignInViewController
            self.navigationController?.pushViewController(loginVC, animated: true)
        } catch let error as NSError {
            print("エラー", error)
        }
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
