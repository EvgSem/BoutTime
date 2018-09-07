//
//  Options.swift
//  BoutTime
//
//  Created by Ievgeniia Bondini on 9/2/18.
//  Copyright © 2018 Ievgeniia Bondini. All rights reserved.
//

import Foundation

enum President {
    
}

struct Option {
    var name: String
    var year: Int
    var url: String
}

enum QuestionnaireError: Error {
    
    case invalidResource
    case convertionFailure
}

class PlistConverter {
    static func dictionary(fromFile name: String, ofType type: String) throws -> [String: Any] {
        guard let path = Bundle.main.path(forResource: name, ofType: type) else {
            throw QuestionnaireError.invalidResource
        }
        guard let dictionary = NSDictionary(contentsOfFile: path) as? [String: Any] else {
            throw QuestionnaireError.convertionFailure
        }
        return dictionary
        
    }
}

class OptionsUnarchiver {
    static func questionOptions(from dictionary: [String: Any]) throws ->  [Option] {
        var options: [Option] =  []
        for (key, value) in dictionary {
            if let itemDictionary = value as? [String: Any], let index = itemDictionary["year"] as? Int, let url = itemDictionary["url"] as? String {
                let option = Option(name: key, year: index, url: url)
                options.append(option)
            }
        }
        return options
    }
}


class OptionsList {
    
    var questionOptions: [Option]?
    
    init() {
        
        do {
            let dictionary = try PlistConverter.dictionary(fromFile: "Presidents", ofType: "plist")
            questionOptions = try OptionsUnarchiver.questionOptions(from: dictionary)
        } catch let error {
            fatalError("\(error)")
        }
    }
    
}
