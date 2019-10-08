//
//  ViewController.swift
//  SqlitePowerFunction
//
//  Created by Ganesh Waje on 08/10/19.
//  Copyright © 2019 Ganesh Waje. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {
    
    @IBOutlet private weak var texfield1: UITextField!
    @IBOutlet private weak var texfield2: UITextField!
    @IBOutlet weak var resultLabel: UILabel!
    let database = DatabaseManager()

    @IBAction func submitButtonPressed(_ sender: Any) {
        guard let firstNumberString = self.texfield1.text,
            let firstNumber = Double(firstNumberString),
            let secondNumberString = self.texfield2.text,
            let secondNumber = Double(secondNumberString) else {
                self.resultLabel.text = "Enter valid text"
                return
        }
        
        
        if let answer = try? self.database?.findPower(firstNumber: firstNumber, secondNumber: secondNumber) {
            let result = "Power(\(firstNumber), \(secondNumber)) is \(answer)"
            print(result)
            self.resultLabel.text = result
            return
        } else {
            print("power failed")
        }
    }
}

