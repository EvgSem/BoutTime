//
//  ViewController.swift
//  BoutTime
//
//  Created by Ievgeniia Bondini on 8/27/18.
//  Copyright © 2018 Ievgeniia Bondini. All rights reserved.
//

import UIKit
import GameKit
import AudioToolbox

class ViewController: UIViewController {

    @IBOutlet weak var option1View: UIView!
    @IBOutlet weak var option2View: UIView!
    @IBOutlet weak var option3View: UIView!
    @IBOutlet weak var option4View: UIView!
    
    @IBOutlet weak var option1Label: UILabel!
    @IBOutlet weak var option2Label: UILabel!
    @IBOutlet weak var option3Label: UILabel!
    @IBOutlet weak var option4Label: UILabel!
    
    @IBOutlet weak var questionField: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var nextRoundButton: UIButton!
    
    
    @IBOutlet weak var shuffleLable: UILabel!

    var tapGestureForOption1 = UITapGestureRecognizer()
    var tapGestureForOption2 = UITapGestureRecognizer()
    var tapGestureForOption3 = UITapGestureRecognizer()
    var tapGestureForOption4 = UITapGestureRecognizer()
    
    
    var questionnaire : Questionnaire
    
    
    let questionsPerRound = 6
    var questionsAsked = 0
    var correctQuestions = 0
    var indexOfSelectedQuestion = 0
    
    var seconds = 60
    var timer = Timer()
    var isTimerRunning = false
    var isEndOfTheTour = false
    
    var correctAnswerSound: SystemSoundID = 0
    var wrongAnswerSound: SystemSoundID = 1
    
    required init?(coder aDecoder: NSCoder) {
        questionnaire = Questionnaire()
        questionnaire.genearteQuestions()
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addGesturesToOptionView()
        
        nextRoundButton.isHidden = true
        setRadiusForOptionViews()
        loadSounds()
        
        displayQuestion()
    }

    func displayQuestion() {
        isEndOfTheTour = false
        indexOfSelectedQuestion = GKRandomSource.sharedRandom().nextInt(upperBound: questionnaire.questions.count)
        let question = questionnaire.questions[indexOfSelectedQuestion]
        
        var optionLabels = [option1Label, option2Label, option3Label, option4Label]
        
        for i in 0..<question.optionsForQuestion.count {
            optionLabels[i]?.text = question.optionsForQuestion[i].name
        }
        questionsAsked += 1
        
        loadNextRound(delay: 60)
    }
    
    func loadNextRound(delay seconds: Int) {
        
        let localQuestionsAsked = questionsAsked
        let delay = Int64(NSEC_PER_SEC * UInt64(seconds))
        let dispatchTime = DispatchTime.now() + Double(delay) / Double(NSEC_PER_SEC)
        self.seconds = 60
        runTimer()
        DispatchQueue.main.asyncAfter(deadline: dispatchTime) {
            if localQuestionsAsked == self.questionsAsked {
                if self.questionnaire.questions.count > 0 {
                    self.checkAnswer()
                }
            }
        }
    }

    func nextRound() {
        if questionsAsked == questionsPerRound {
            displayScore()
        } else {
            displayQuestion()
        }
    }

    func checkAnswer() {
        isEndOfTheTour = true
        timer.invalidate()
        
        let optionLabels = [option1Label, option2Label, option3Label, option4Label]
        let selectedQuestion = questionnaire.questions[indexOfSelectedQuestion]
        var answer = true
        
        for i in 0..<optionLabels.count {
            if selectedQuestion.correctOrder[i].name != optionLabels[i]?.text! {
                answer = false
                break
            }
        }
        
        if answer {
            correctQuestions += 1
            playCorrectAnswerSound()
        } else {
            playWrongSoundSound()
        }
        
        showNextRoundButton(answer: answer)
    }
    
    
    func showNextRoundButton(answer: Bool) {
        if answer {
            nextRoundButton.setImage(#imageLiteral(resourceName: "next_round_success"), for: .normal)
        } else {
            nextRoundButton.setImage(#imageLiteral(resourceName: "next_round_fail"), for: .normal)
        }
        nextRoundButton.isHidden = false
    }
    
    func displayScore() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let modalViewController = storyBoard.instantiateViewController(withIdentifier: "FinalScoreViewController") as! FinalScoreViewController
        
        modalViewController.score = "\(correctQuestions)/\(questionsPerRound)"
        
        modalViewController.onDoneBlock = { result in
            self.playAgainButtonTapped()
        }
        
        self.present(modalViewController, animated:true, completion:nil)
        
    }
    
    //MARK: Actions
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            checkAnswer()
        }
    }
    
    @IBAction func nextRoundclicked(_ sender: Any) {
        nextRoundButton.isHidden = true
        self.questionnaire.questions.remove(at: self.indexOfSelectedQuestion)
        nextRound()
    }
    
    @IBAction func shiftOption(_ sender: Any) {
        switch (sender as AnyObject).tag {
        case SelectedButtonTag.FirstDown.rawValue:
            switchOption(0, withOption: 1)
        case SelectedButtonTag.SecondUp.rawValue:
            switchOption(1, withOption: 0)
        case SelectedButtonTag.SecondDown.rawValue:
            switchOption(1, withOption: 2)
        case SelectedButtonTag.ThirdUp.rawValue:
            switchOption(2, withOption: 1)
        case SelectedButtonTag.ThirdDown.rawValue:
            switchOption(2, withOption: 3)
        case SelectedButtonTag.ForthUp.rawValue:
            switchOption(3, withOption: 2)
        default:
            print("default")
        }
    }
    
    func playAgainButtonTapped() {
        
        questionsAsked = 0
        correctQuestions = 0
        indexOfSelectedQuestion = 0
        
        seconds = 60
        nextRoundButton.isHidden = true
        questionnaire.genearteQuestions()
        displayQuestion()
    }
    
    func switchOption(_ option1: Int, withOption option2: Int) {
        var optionLabels = [option1Label, option2Label, option3Label, option4Label]
        let tmpOptionText = optionLabels[option2]?.text
        optionLabels[option2]?.text = optionLabels[option1]?.text
        optionLabels[option1]?.text = tmpOptionText
        
        let selectedQuestion = questionnaire.questions[indexOfSelectedQuestion]
        let tmpOption = selectedQuestion.optionsForQuestion[option2]
        selectedQuestion.optionsForQuestion[option2] = selectedQuestion.optionsForQuestion[option1]
        selectedQuestion.optionsForQuestion[option1] = tmpOption
    }
    
    
    
    //MARK: Auxilary methods
    private func setRadiusForOptionViews(){
        let optionViews = [option1View, option2View, option3View, option4View]
        for view in optionViews {
            view?.layer.cornerRadius = 5
        }
        
        nextRoundButton.layer.cornerRadius = 25
    }
    
    func loadSounds() {
        let correctAnswerPath = Bundle.main.path(forResource: "CorrectDing", ofType: "wav")
        let correctAnswerSoundUrl = URL(fileURLWithPath: correctAnswerPath!)
        AudioServicesCreateSystemSoundID(correctAnswerSoundUrl as CFURL, &correctAnswerSound)
        
        let wrongAnswerPath = Bundle.main.path(forResource: "IncorrectBuzz", ofType: "wav")
        let wrongAnswerSoundUrl = URL(fileURLWithPath: wrongAnswerPath!)
        AudioServicesCreateSystemSoundID(wrongAnswerSoundUrl as CFURL, &wrongAnswerSound)
    }
    
    func playCorrectAnswerSound() {
        AudioServicesPlaySystemSound(correctAnswerSound)
    }
    
    func playWrongSoundSound() {
        AudioServicesPlaySystemSound(wrongAnswerSound)
    }
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(ViewController.updateTimer)), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        seconds -= 1
        timerLabel.text = "0:\(seconds)"
    }
    
    @objc func option1ViewTapped(_ sender: UITapGestureRecognizer) {
        
       showWikiWebPageForOption(0)
    }
    
    @objc func option2ViewTapped(_ sender: UITapGestureRecognizer) {
        
        showWikiWebPageForOption(1)
    }
    
    @objc func option3ViewTapped(_ sender: UITapGestureRecognizer) {
        showWikiWebPageForOption(2)
    }
    
    @objc func option4ViewTapped(_ sender: UITapGestureRecognizer) {
        
        showWikiWebPageForOption(3)
    }
    
    func showWikiWebPageForOption(_ option: Int){
        guard isEndOfTheTour else {
            return
        }
        let selectedQuestion = questionnaire.questions[indexOfSelectedQuestion]
        let option = selectedQuestion.optionsForQuestion[option]
        
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let modalViewController = storyBoard.instantiateViewController(withIdentifier: "EventInformationViewController") as! EventInformationViewController
        
        modalViewController.urlString = option.url
        
        self.present(modalViewController, animated:true, completion:nil)
    }
    
    func addGesturesToOptionView(){
        // TAP Gesture
        tapGestureForOption1 = UITapGestureRecognizer(target: self, action: #selector(ViewController.option1ViewTapped(_:)))
        tapGestureForOption1.numberOfTapsRequired = 1
        tapGestureForOption1.numberOfTouchesRequired = 1
        
        tapGestureForOption2 = UITapGestureRecognizer(target: self, action: #selector(ViewController.option2ViewTapped(_:)))
        tapGestureForOption2.numberOfTapsRequired = 1
        tapGestureForOption2.numberOfTouchesRequired = 1
        
        tapGestureForOption3 = UITapGestureRecognizer(target: self, action: #selector(ViewController.option3ViewTapped(_:)))
        tapGestureForOption3.numberOfTapsRequired = 1
        tapGestureForOption3.numberOfTouchesRequired = 1
        
        tapGestureForOption4 = UITapGestureRecognizer(target: self, action: #selector(ViewController.option4ViewTapped(_:)))
        tapGestureForOption4.numberOfTapsRequired = 1
        tapGestureForOption4.numberOfTouchesRequired = 1
        
        option1View.addGestureRecognizer(tapGestureForOption1)
        option1View.isUserInteractionEnabled = true
        
        option2View.addGestureRecognizer(tapGestureForOption2)
        option2View.isUserInteractionEnabled = true
        
        option3View.addGestureRecognizer(tapGestureForOption3)
        option3View.isUserInteractionEnabled = true
        
        option4View.addGestureRecognizer(tapGestureForOption4)
        option4View.isUserInteractionEnabled = true
    }
}
