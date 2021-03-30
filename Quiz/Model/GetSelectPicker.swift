//
//  GetSelectPicker.swift
//  QuizuApp
//
//  Created by 祥平 on 2021/03/19.
//

import Foundation
import Firebase
import FirebaseFirestore

class GetSelectPicker{
    
    var db = Firestore.firestore()
    var selectList:[SelectModel] = []
    var selectBtnList:[String] = []
    var selectArray:[String] = []
    var currentUser = UserDefaults.standard.object(forKey: "userName")
    
    //自分自身の選択肢のデータを取得
    func SelectPicker(){
        
        db.collection("Quizu").order(by: "postDate").addSnapshotListener { (snapShot2, error) in
            if error != nil{
                print(error.debugDescription)
                return
            }
            if let snapShotDoc = snapShot2?.documents{
                for doc in snapShotDoc{
                    let data = doc.data()
                    if self.currentUser as! String == (data["userName"] as? String)!{
                        if let userName = data["userName"] as? String,let select1 = data["select1"] as? String,let select2 = data["select2"] as? String,let select3 = data["select3"] as? String,let select4 = data["select4"] as? String,let select5 = data["select5"] as? String,let select6 = data["select6"] as? String,let select7 = data["select7"] as? String,let select8 = data["select8"] as? String,let select9 = data["select9"] as? String,let select10 = data["select10"] as? String {
                            self.selectList.append(SelectModel(userName: userName, select1: select1, select2: select2, select3: select3, select4: select4, select5: select5, select6: select6, select7: select7, select8: select8, select9: select9, select10: select10))
                        }
                    }
                }
            }
        }
    }
    
    //選択肢の要素取り出し
    func getSelectList(quizuCount:Int) {
        selectArray = []
        for i in 0..<selectList.count{
            if i == quizuCount{
                selectBtnList.append(selectList[quizuCount].select1)
                selectBtnList.append(selectList[quizuCount].select2)
                selectBtnList.append(selectList[quizuCount].select3)
                selectBtnList.append(selectList[quizuCount].select4)
                selectBtnList.append(selectList[quizuCount].select5)
                selectBtnList.append(selectList[quizuCount].select6)
                selectBtnList.append(selectList[quizuCount].select7)
                selectBtnList.append(selectList[quizuCount].select8)
                selectBtnList.append(selectList[quizuCount].select9)
                selectBtnList.append(selectList[quizuCount].select10)
            }
        }
        //空の配列を削除
        for i in 0..<selectBtnList.count{
            if selectBtnList[i].isEmpty != true{
                selectArray.append(selectBtnList[i])
            }
        }
    }
}
