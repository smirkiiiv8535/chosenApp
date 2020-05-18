//
//  playingView.swift
//  chosenApp
//
//  Created by 林祐辰 on 2020/5/18.
//  Copyright © 2020 smirkiiiv. All rights reserved.
//

import UIKit

class playingView: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = false
        renderTimer()
        questionCollection.shuffle()
        renderQuestion()
    }


    var timer = Timer()
    var timerSecond = 120
    
    func renderTimer(){
    timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerHelper), userInfo: nil, repeats: true)
    }
    
    @objc func timerHelper(){
        timerSecond -= 1
         let countDownSec:Int = timerSecond % 60
         let countDownMin:Int = timerSecond / 60
         timerLabel.text = String(countDownMin) + ":" + String( format: "%02d", countDownSec )
        if(countDownSec == 0 && countDownMin == 0){
            finalGrade()
        }
    }
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var gradeLabel: UILabel!
    @IBOutlet weak var highGradeLabel: UILabel!
    @IBOutlet weak var qustionNum: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet var buttonCollection: [UIButton]!
    
    var rightAnswer = ""
    var questionNumber = 0
    
    var grade = 0
    var highGrade = 0
    
    
    @IBAction func checkAnswer(_ sender: UIButton) {

        questionNumber+=1

        if(sender.currentTitle == rightAnswer){
              grade += 10
              gradeLabel.text = "\(grade)"
        }

        if(questionNumber < 10){
           renderQuestion()
       }else{
            finalGrade()
        }
    }

    @IBAction func restartButton(_ sender: UIButton) {
        restartFunction()
    }

    func renderQuestion (){
        qustionNum.text = "第\(questionNumber+1)題"
        questionLabel.text = "\(questionCollection[questionNumber].question)"
        rightAnswer = questionCollection[questionNumber].answer
        questionCollection[questionNumber].options.shuffle()
        for i in 0...3{
            buttonCollection[i].setTitle(questionCollection[questionNumber].options[i], for: .normal)
        }

    }

    func popAlert (sendInTitleOne:String,sendInMessage:String,sendInTitleTwo:String){
              let alertTable = UIAlertController(title: sendInTitleOne, message: sendInMessage, preferredStyle: .alert)
              let alertButton = UIAlertAction(title: sendInTitleTwo, style: .default, handler: {(_)in
                  self.restartFunction()
              })
              alertTable.addAction(alertButton)
              present(alertTable,animated: true ,completion:nil)
          }

    func finalGrade(){
        timer.invalidate()
        if(grade >= 80 && grade<=100){
        popAlert (sendInTitleOne:" 總分 \(grade) 分",sendInMessage:"知識王4你ヽ(●´∀`●)ﾉ",sendInTitleTwo:"好棒棒!")
         saveGrade()
        }else if(grade >= 60 && grade < 80){
        popAlert (sendInTitleOne:" 總分 \(grade) 分",sendInMessage:"還行 (́◉◞౪◟◉‵)",sendInTitleTwo:"要不再來挑戰?")
        saveGrade()
        }else {
        popAlert (sendInTitleOne:" 總分 \(grade) 分",sendInMessage:"常識Bad (〒︿〒) ",sendInTitleTwo:"我要來雪恥!")
         saveGrade()
        }
    }
    
    
    func restartFunction(){
      questionNumber = 0
      qustionNum.text = "第\(questionNumber+1)題"
      grade = 0
      gradeLabel.text = "\(grade)"
      timerSecond = 120
      timerLabel.text = "2:00"
      renderTimer()
      questionCollection.shuffle()
      renderQuestion ()
    }

    
    let defaults = UserDefaults.standard
    struct Keys{
         static let historyGrade = "historyGrade"
     }
    
    func saveGrade(){
        if grade>highGrade{
        defaults.set(grade, forKey: Keys.historyGrade)
            highGrade = defaults.value(forKey: Keys.historyGrade) as? Int ?? 0
            
            highGradeLabel.text = "\(highGrade)"
        }
    }
    
   }
