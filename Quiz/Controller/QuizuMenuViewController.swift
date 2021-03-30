//
//  QuizuMenuViewController.swift
//  Quiz
//
//  Created by 祥平 on 2021/03/30.
//

import UIKit

class QuizuMenuViewController: UIViewController {

    var changeColor = ChangeColor()
    var gradientLayer = CAGradientLayer()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //バックの色を決めている
        gradientLayer = changeColor.changeColor(topR: 0.55, topG: 0.56, topB: 0.88, topAlpha: 1.0, bottomR: 0.78, bottomG: 0.34, bottomB: 0.70, bottomAlpha: 1.0)
        gradientLayer.frame = view.bounds
        
        view.layer.insertSublayer(gradientLayer, at: 0)


        // Do any additional setup after loading the view.
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
