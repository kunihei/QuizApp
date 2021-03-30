//
//  SettingViewController.swift
//  Quiz
//
//  Created by 祥平 on 2021/03/30.
//

import UIKit
import Firebase
import FirebaseFirestore
import EMAlertController

class SettingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    @IBOutlet weak var tableView: UITableView!
    
    var db = Firestore.firestore()
    var idString = String()
    var vc = UIView()
    var selectButtonArray:[UIButton] = []
    
    let getQuizuList = GetQuizuAnswer()
    let getSelectList = GetSelectPicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getQuizuList.quizuList = []
        getSelectList.selectList = []
        getQuizuList.MondaiLabel()
        getSelectList.SelectPicker()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getQuizuList.quizuList.reverse()
        getSelectList.selectList.reverse()
        tableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getQuizuList.quizuList.count
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

       // 削除処理
        let deleteAction = UIContextualAction(style: .destructive, title: "削除") { (action, view, completionHandler) in
            self.idString = self.getQuizuList.quizuList[indexPath.row].documentID
            self.db.collection("Quizu").document(self.idString).delete(){
                error in
                if let error = error{
                    print("Error removing document: \(error)")
                }else{
                    self.navigationController?.popViewController(animated: true)
                }
            }
          // 実行結果に関わらず記述
          completionHandler(true)
        }
        // 定義したアクションをセット
        return UISwipeActionsConfiguration(actions: [deleteAction])
      }
    
    //セルの設定
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.selectionStyle = .none
        tableView.rowHeight = 60
        let mondaiLabel = cell.contentView.viewWithTag(1) as! UILabel
        mondaiLabel.numberOfLines = 0
        mondaiLabel.text = "\(self.getQuizuList.quizuList[indexPath.row].mondai)"
        return cell
    }
    
    //選択されたセルの設定
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.getSelectList.selectBtnList = []
        self.getSelectList.getSelectList(quizuCount: indexPath.row)
        let updateVC = self.storyboard?.instantiateViewController(withIdentifier: "updateVC") as! UpdateViewController
        updateVC.idString = self.getQuizuList.quizuList[indexPath.row].documentID
        updateVC.mondaiLabel = self.getQuizuList.quizuList[indexPath.row].mondai
        updateVC.answerLabel = self.getQuizuList.quizuList[indexPath.row].answer
        for i in 0..<getSelectList.selectArray.count {
            updateVC.selectList.append(self.getSelectList.selectArray[i])
        }
        self.navigationController?.pushViewController(updateVC, animated: true)
        self.tableView.reloadData()
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
