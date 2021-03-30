//
//  GetAuizu&Answer.swift
//  QuizuApp
//
//  Created by 祥平 on 2021/03/19.
//

import Foundation
import Firebase
import FirebaseFirestore

class GetQuizuAnswer{
    
    var db = Firestore.firestore()
    var quizuList:[QuizuModel] = []
    var currentUser = UserDefaults.standard.object(forKey: "userName")

    //自分自身の問題のデータを取得
    func MondaiLabel(){
        
        db.collection("Quizu").order(by: "postDate").addSnapshotListener { (snapShot, error) in
            if error != nil{
                print(error.debugDescription)
                return
            }
            
            if let snapShotDoc = snapShot?.documents{
                for doc in snapShotDoc{
                    let data = doc.data()
                    let id = doc.documentID
                    if self.currentUser as! String == (data["userName"] as? String)!{
                        if let userName = data["userName"] as? String, let mondai = data["mondai"] as? String, let answer = data["answer"] as? String, let id = id as? String{
                            self.quizuList.append(QuizuModel(mondai: mondai, answer: answer, userName: userName, documentID: id))
                        }
                    }
                }
            }
        }
    }
}
