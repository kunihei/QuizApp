//
//  RegistQuizuViewController.swift
//  Quiz
//
//  Created by 祥平 on 2021/03/30.
//

import UIKit
import Firebase
import FirebaseFirestore
import EMAlertController

class RegistQuizuViewController: UIViewController {
    
    @IBOutlet weak var mondaiTextView: UITextView!
    @IBOutlet weak var answerTextView: UITextView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var vc = UIView()
    var selectTextViewArray:[UITextView] = []
    var userName = UserDefaults.standard.object(forKey: "userName")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        verticalScroll()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    //縦スクロール
    func verticalScroll() {
        //vcのframe
        vc.frame = CGRect(x: 0, y: 0, width: scrollView.frame.size.width, height: scrollView.frame.size.height * 2.2)
        //上部のスクロールビューに多数のテキストビューを配置
        for i in 0...9 {
            let textView = UITextView()
            //サイズ
            textView.frame = CGRect(x: 20, y: (i*70), width: 300, height: 55)
            //タグ
            textView.tag = i + 1
            
            textView.backgroundColor = .systemBlue
            textView.textColor = .white
            textView.font = UIFont.systemFont(ofSize: 18)
            
            selectTextViewArray.append(textView)
            //vcに載せる
            vc.addSubview(textView)
        }
        //スクロールビューにvcを配置
        scrollView.addSubview(vc)
        scrollView.contentSize = vc.bounds.size
    }
    
    @IBAction func touroku(_ sender: Any) {
        
        if mondaiTextView.text.isEmpty == true || answerTextView.text.isEmpty == true {
            //アラート
            let alert = EMAlertController(title: "エラー", message: "問題または答えが入力されていません")
            let doneAction = EMAlertAction(title: "OK", style: .normal)
            alert.addAction(doneAction)
            present(alert, animated: true, completion: nil)
            
            return
        }
        
        Firestore.firestore().collection("Quizu").document().setData(["answer":answerTextView.text as Any, "mondai":mondaiTextView.text as Any, "select1": selectTextViewArray[0].text as Any, "select2": selectTextViewArray[1].text as Any, "select3": selectTextViewArray[2].text as Any, "select4": selectTextViewArray[3].text as Any, "select5": selectTextViewArray[4].text as Any, "select6": selectTextViewArray[5].text as Any, "select7": selectTextViewArray[6].text as Any, "select8": selectTextViewArray[7].text as Any, "select9": selectTextViewArray[8].text as Any, "select10": selectTextViewArray[9].text as Any, "userName":userName as Any, "postDate":Date().timeIntervalSince1970])
        
        //アラート
        let alert = EMAlertController(icon: UIImage(named: "check"), title: "登録完了！", message: "さあ！問題を解いてみよう！")
        let doneAction = EMAlertAction(title: "OK", style: .normal)
        alert.addAction(doneAction)
        present(alert, animated: true, completion: nil)
        
        for i in 0..<selectTextViewArray.count{
            selectTextViewArray[i].text = ""
        }
        answerTextView.text = ""
        mondaiTextView.text = ""
        
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        answerTextView.resignFirstResponder()
        mondaiTextView.resignFirstResponder()
        for i in 0..<selectTextViewArray.count{
            selectTextViewArray[i].resignFirstResponder()
        }
    }
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
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
