//
//  ViewController.swift
//  BoutTime
//
//  Created by Ievgeniia Bondini on 8/27/18.
//  Copyright © 2018 Ievgeniia Bondini. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var option1View: UIView!
    @IBOutlet weak var option2View: UIView!
    @IBOutlet weak var option3View: UIView!
    @IBOutlet weak var option4View: UIView!
    
    
    @IBOutlet weak var option1Label: UILabel!
    @IBOutlet weak var option2Label: UILabel!
    @IBOutlet weak var option3Label: UILabel!
    @IBOutlet weak var option4Label: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        setRadiusForOptionViews()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Actions
    @IBAction func shiftOption(_ sender: Any) {
        switch (sender as AnyObject).tag {
        case SelectedButtonTag.FirstDown.rawValue:
            switchOption(0, with: 1)
        case SelectedButtonTag.SecondUp.rawValue:
            switchOption(1, with: 0)
        case SelectedButtonTag.SecondDown.rawValue:
            switchOption(1, with: 2)
        case SelectedButtonTag.ThirdUp.rawValue:
            switchOption(2, with: 1)
        case SelectedButtonTag.ThirdDown.rawValue:
            switchOption(2, with: 3)
        case SelectedButtonTag.ForthUp.rawValue:
            switchOption(3, with: 2)
        default:
            print("default")
        }
    }
    
    func switchOption(_ option1: Int, with option2: Int) {
        var optionLabels = [option1Label, option2Label, option3Label, option4Label]
        let tmpOptionText = optionLabels[option2]?.text
        optionLabels[option2]?.text = optionLabels[option1]?.text
        optionLabels[option1]?.text = tmpOptionText
    }
    
    //MARK: Auxilary methods
    private func setRadiusForOptionViews(){
        option1View.layer.cornerRadius = 5
        option2View.layer.cornerRadius = 5
        option3View.layer.cornerRadius = 5
        option4View.layer.cornerRadius = 5
    }
}

