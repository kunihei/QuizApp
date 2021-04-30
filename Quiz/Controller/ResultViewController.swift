//
//  ResultViewController.swift
//  Quiz
//
//  Created by 祥平 on 2021/03/30.
//

import UIKit

class ResultViewController: UIViewController {

    var changeColor = ChangeColor()
    var gradientLayer = CAGradientLayer()
    var correctedCount = Int()
    var wornCount = Int()
    var beforeCount = Int()
    var averageCount = Int()
    
    @IBOutlet weak var correctLabel: UILabel!
    @IBOutlet weak var worngLabel: UILabel!
    @IBOutlet weak var maxlabel: UILabel!
    @IBOutlet weak var correctAverage: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //バックの色を決めている
        gradientLayer = changeColor.changeColor(topR: 0.45, topG: 0.67, topB: 0.98, topAlpha: 1.0, bottomR: 0.67, bottomG: 0.87, bottomB: 0.43, bottomAlpha: 1.0)
        gradientLayer.frame = view.bounds
        
        view.layer.insertSublayer(gradientLayer, at: 0)
        correctLabel.text = "\(correctedCount)問"
        worngLabel.text = "\(wornCount)問"
        correctAverage.text = "\(averageCount)%"
        //最高得点を保存する
        if UserDefaults.standard.object(forKey: "beforeCount") != nil{
            beforeCount = UserDefaults.standard.object(forKey: "beforeCount") as! Int
        }
        
        maxlabel.text = "\(beforeCount)問"
        //最高得点かどうかを判断する
        if beforeCount < correctedCount{
            UserDefaults.standard.set(correctedCount, forKey: "beforeCount")
        }else if beforeCount > correctedCount{
            UserDefaults.standard.set(beforeCount, forKey: "beforeCount")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func reset(_ sender: Any) {
        //最高得点をリセットする
        UserDefaults.standard.set(0, forKey: "beforeCount")
        beforeCount = UserDefaults.standard.object(forKey: "beforeCount") as! Int
        maxlabel.text = "\(beforeCount)問"
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
