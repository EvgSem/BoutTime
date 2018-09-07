//
//  EventInformationViewController.swift
//  BoutTime
//
//  Created by Ievgeniia Bondini on 9/5/18.
//  Copyright © 2018 Ievgeniia Bondini. All rights reserved.
//

import UIKit
import WebKit

class EventInformationViewController: UIViewController {
    
    var urlString: String?
    var onDoneBlock : ((Bool) -> Void)?
    
    @IBOutlet weak var eventWebView: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
       loadLinkInWebView()
    }

    @IBAction func dismiss(_ sender: Any) {
        onDoneBlock!(true)
        dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func loadLinkInWebView(){
        if let urlString = urlString {
            let url = URL(string: urlString)
            let requestObj = URLRequest(url: url!)
            eventWebView.load(requestObj)
        }
    }
  
}
