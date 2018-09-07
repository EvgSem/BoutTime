//
//  FinalScoreViewController.swift
//  BoutTime
//
//  Created by Ievgeniia Bondini on 9/6/18.
//  Copyright © 2018 Ievgeniia Bondini. All rights reserved.
//

import UIKit

class FinalScoreViewController: UIViewController {

    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var playAgainButton: UIButton!
    
    var onDoneBlock : ((Bool) -> Void)?
    var score: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playAgainButton.layer.cornerRadius = 25
        if let score = score {
            scoreLabel.text = score
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    @IBAction func playAgain(_ sender: Any) {
        onDoneBlock!(true)
        dismiss(animated: true, completion: nil)
    }
}
