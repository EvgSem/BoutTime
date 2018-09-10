//
//  Questionnaire.swift
//  BoutTime
//
//  Created by Ievgeniia Bondini on 9/2/18.
//  Copyright © 2018 Ievgeniia Bondini. All rights reserved.
//

import Foundation
import GameKit



class Question {
    
    var fullOptionsList: OptionsList?
    var optionsForQuestion: [Option]
    var correctOrder: [Option]
    let numberOfOptions = 4
    
    
    init() {
        self.fullOptionsList = OptionsList()
        optionsForQuestion = [Option]()
        correctOrder = [Option]()
        generateOptions()
        correctOrder = optionsForQuestion.sorted(by: { $0.year < $1.year })
    }
    
    func generateOptions() {
        guard let fullOptionsList = fullOptionsList, var questionOptions = fullOptionsList.questionOptions else {
            fatalError()
        }
        
        for _ in 0..<numberOfOptions {
            let indexOfSelectedQuestion = GKRandomSource.sharedRandom().nextInt(upperBound: questionOptions.count)
            let option = questionOptions[indexOfSelectedQuestion]
            optionsForQuestion.append(option)
            questionOptions.remove(at: indexOfSelectedQuestion)
        }
    }
    
}

class Questionnaire {
    
    var questions:[Question] = [Question]()
    let numberOfQuestions = 6
    
    func genearteQuestions() {
        
        for _ in 0..<numberOfQuestions {
            questions.append(Question())
        }
    }
}
