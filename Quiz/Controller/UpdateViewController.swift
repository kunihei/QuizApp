//
//  UpdateViewController.swift
//  Quiz
//
//  Created by 祥平 on 2021/03/30.
//

import UIKit
import Firebase
import FirebaseFirestore
import EMAlertController

class UpdateViewController: UIViewController {

    var idString = String()
    var mondaiLabel = String()
    var answerLabel = String()
    var selectList:[String] = []
    var vc = UIView()
    var selectTextViewArray:[UITextView] = []
    
    let getQuizu = GetQuizuAnswer()
    let getSelect = GetSelectPicker()
    
    @IBOutlet weak var mondaiTextView: UITextView!
    @IBOutlet weak var answerTextView: UITextView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        getQuizu.MondaiLabel()
        getSelect.SelectPicker()
        verticalScroll()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        mondaiTextView.text = mondaiLabel
        answerTextView.text = answerLabel
        for i in 0..<selectList.count{
            selectTextViewArray[i].text = selectList[i]
        }
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
    
    @IBAction func update(_ sender: Any) {
        //更新機能
        Firestore.firestore().collection("Quizu").document(idString).updateData(["answer":answerTextView.text as Any, "mondai":mondaiTextView.text as Any, "select1": selectTextViewArray[0].text as Any, "select2": selectTextViewArray[1].text as Any, "select3": selectTextViewArray[2].text as Any, "select4": selectTextViewArray[3].text as Any, "select5": selectTextViewArray[4].text as Any, "select6": selectTextViewArray[5].text as Any, "select7": selectTextViewArray[6].text as Any, "select8": selectTextViewArray[7].text as Any, "select9": selectTextViewArray[8].text as Any, "select10": selectTextViewArray[9].text as Any]) { (error) in
            if error != nil{
                print(error.debugDescription)
                return
            }
        }
        
        //アラート
        let alert = EMAlertController(icon: UIImage(named: "check"), title: "更新完了！", message: "更新が完了しました！")
        let doneAction = EMAlertAction(title: "OK", style: .normal)
        alert.addAction(doneAction)
        present(alert, animated: true, completion: nil)
        
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
