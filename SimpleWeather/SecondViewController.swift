//
//  SecondViewController.swift
//  SimpleWeather
//
//  Created by Andrey on 23.09.14.
//  Copyright (c) 2014 Andrey. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBOutlet var city: UITextField!
    
    @IBAction func btn_addCity_Click(sender: UIButton) {
        weatherMng.addCity(city.text)
        self.view.endEditing(true)
        city.text = ""
        self.tabBarController?.selectedIndex = 0
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool { // called when 'return' key pressed. return NO to ignore.
        textField.resignFirstResponder();
        return true;
    }

    
}

