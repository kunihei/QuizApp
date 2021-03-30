//
//  ShuffleQuizuViewController.swift
//  Quiz
//
//  Created by 祥平 on 2021/03/30.
//

import UIKit
import Firebase
import FirebaseFirestore
import EMAlertController

class ShuffleQuizuViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    let getSelectPicker = GetSelectPicker()
    let getQuizuAnswer = GetQuizuAnswer()
    
    var db = Firestore.firestore()
    var pickerView: UIPickerView = UIPickerView()
    var answer = String()
    var quizuCount = 0
    var correctCount = 0
    var wrongCount = 0
    var averageCount = 0.0
    var averageTotal = 0.0
    
    @IBOutlet weak var mondaiLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var countMondai: UILabel!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var answerBtn: UIButton!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var resultBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nextBtn.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        resultBtn.isHidden = true
        answerBtn.isEnabled = true
        textView.text = "ここをタッチして正解を選んでください！"
        pickerView.selectRow(0, inComponent: 0, animated: true)
        getQuizuAnswer.MondaiLabel()
        getSelectPicker.SelectPicker()
        correctCount = 0
        wrongCount = 0
        quizuCount = 0
        getQuizuAnswer.quizuList = []
        getSelectPicker.selectArray = []
        questionLabel.text = "結果"
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        pickerView.dataSource = self
        pickerView.delegate = self
        doneBar()
        mondaiLabel.text = getQuizuAnswer.quizuList[quizuCount].mondai
        countMondai.text = "問題\(quizuCount + 1)"
        getSelectPicker.getSelectList(quizuCount: quizuCount)
        getSelectPicker.selectArray.shuffle()
        
    }
    
    //doneの生成
    func doneBar(){
        pickerView.showsSelectionIndicator = true
        // 決定バーの生成
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 35))
        let spacelItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        toolbar.setItems([spacelItem, doneItem], animated: true)
        textView.inputView = pickerView
        textView.inputAccessoryView = toolbar
        
    }
    
    @objc func done() {
        textView.endEditing(true)
        textView.text = "\(getSelectPicker.selectArray[pickerView.selectedRow(inComponent: 0)])"
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        getSelectPicker.selectArray.count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.textView.text = getSelectPicker.selectArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        let cellLabel = UILabel()
        cellLabel.frame = CGRect(x: 0, y: 0, width: pickerView.rowSize(forComponent: 0).width, height: pickerView.rowSize(forComponent: 0).height)
        cellLabel.textAlignment = .center
        cellLabel.font = UIFont.boldSystemFont(ofSize: 30)
        cellLabel.backgroundColor = UIColor.blue
        cellLabel.textColor = UIColor.white
        cellLabel.text = getSelectPicker.selectArray[row]
        
        return cellLabel
    }
    
    //次の問題に進める
    func nextQuiz(){
        if quizuCount < getQuizuAnswer.quizuList.count - 1{
            quizuCount += 1
            //問題を表示させる
            mondaiLabel.text = getQuizuAnswer.quizuList[quizuCount].mondai
            countMondai.text = "問題\(quizuCount + 1)"
        }
    }
    
    //最後の問題か判断
    func lastQuiz(){
        if quizuCount == getQuizuAnswer.quizuList.count - 1{
            countMondai.text = "問題終了"
            nextBtn.isHidden = true
            resultBtn.isHidden = false
            averageCount = Double(correctCount) / Double(getQuizuAnswer.quizuList.count)
            averageTotal = averageCount * 100.0
        }
    }
    
    //pickerViewの表示を消す
    func notPickerView(){
        textView.inputView = .none
        textView.inputAccessoryView = .none
        textView.isEditable = false
    }
    
    //画面遷移時、値を渡す
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "result"{
            let resultVC = segue.destination as! ResultViewController
            resultVC.correctedCount = correctCount
            resultVC.wornCount = wrongCount
            resultVC.averageCount = Int(averageTotal)
        }
    }
    
    //答え合わせの判断
    @IBAction func answer(_ sender: Any) {
        if textView.text == "ここをタッチして正解を選んでください！"{
            //アラート
            let alert = EMAlertController(title: "未選択", message: "選択肢から答えを選んで下さい！")
            let doneAction = EMAlertAction(title: "OK", style: .normal)
            alert.addAction(doneAction)
            present(alert, animated: true, completion: nil)
            
            return
        }
        if textView.text == getQuizuAnswer.quizuList[quizuCount].answer{
            questionLabel.text = "正解"
            correctCount += 1
        }else{
            questionLabel.text = "正解は「\(getQuizuAnswer.quizuList[quizuCount].answer)」"
            wrongCount += 1
        }
        answerBtn.isEnabled = false
        nextBtn.isHidden = false
        lastQuiz()
        notPickerView()
        getSelectPicker.selectBtnList = []
    }
    
    //次の問題に進める
    @IBAction func next(_ sender: Any) {
        nextQuiz()
        getSelectPicker.getSelectList(quizuCount: quizuCount)
        doneBar()
        getSelectPicker.selectArray.shuffle()
        textView.text = "ここをタッチして正解を選んでください！"
        pickerView.selectRow(0, inComponent: 0, animated: true)
        answerBtn.isEnabled = true
        nextBtn.isHidden = true
        questionLabel.text = "結果"
    }
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func result(_ sender: Any) {
        performSegue(withIdentifier: "result", sender: nil)
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
