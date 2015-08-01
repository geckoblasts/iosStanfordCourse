//
//  ViewController.swift
//  StackCalculator
//
//  Created by Amalie Marie Pedersen on 30/06/15.
//  Copyright (c) 2015 Jacob Mulvad. All rights reserved.
//

import UIKit
import Darwin

class ViewController: UIViewController {

    
    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var history: UILabel!
    
    var userIsTyping = false
    var alreadyDecimal = false
    var cleared = true
    let π = M_PI
    
    var brain = CalculatorBrain()
    
    
    @IBAction func appendHistory(sender: UIButton) {
        if cleared {
            //history.text = sender.currentTitle!
            history.text = brain.description != "?" ? brain.description : ""
            cleared = false
        }
        else {
            //history.text = history.text! + sender.currentTitle!
            history.text = brain.description != "?" ? brain.description : ""
        }
    }
    
    @IBAction func clear() {
        brain.variableValues.removeValueForKey("M")
        displayValue = nil
        history.text = ""
        userIsTyping = false
        alreadyDecimal = false
        cleared = true
        brain.clearOpStack()
    }
    
    
    @IBAction func storeVariable(sender: UIButton) {
        if let variable = last(sender.currentTitle!) {
            if displayValue != nil {
                brain.variableValues["\(variable)"] = displayValue
                if let result = brain.evaluate() {
                    displayValue = result
                } else {
                    displayValue = nil
                }
            }
        }
        userIsTyping = false
    }
    
    @IBAction func getStoredVariable(sender: UIButton) {
        if userIsTyping {
            enter()
        }
        if let result = brain.pushOperand(sender.currentTitle!) {
            displayValue = result
        } else {
            displayValue = nil
        }
    }
    
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        checkStringForMultiplePeriods(display!.text!)
        
        if digit == "π" {
            display.text = "π"
            userIsTyping = true
        }
        else if digit == "." && alreadyDecimal {
            //don't add the digit (only one period is valid in a decimal number)
        }
        else if userIsTyping {
            display.text = display.text! + digit
        }
        else {
            display.text = digit
            userIsTyping = true
        }
        
        println("digit = \(digit)")
    }
    
    private func checkStringForMultiplePeriods(input: String) {
        var counter = 0
        for character in input {
            println(character)
            if character == "."{
                ++counter
            }
        }
        if counter >= 1 {
            self.alreadyDecimal = true
        }
    }
    
    @IBAction func operate(sender: UIButton) {
        if userIsTyping {
            enter()
        }
        if let operation = sender.currentTitle {
            if let result = brain.performOperation(operation) {
                displayValue = result
            } else {
                displayValue = nil
            }
        }
    }
    
    
    
    @IBAction func enter() {
        userIsTyping = false
        alreadyDecimal = false
        if displayValue != nil {
            if let result = brain.pushOperand(displayValue!) {
                displayValue = result
            } else {
                displayValue = nil
            }
        }
        if display.text == "π" {
            let tempResult = display.text!
            brain.variableValues["π"] = π
            if let result = brain.pushOperand(display.text!) {
                displayValue = result
            } else {
                displayValue = nil
            }
        }
        println(brain.description)
    }
    
    var displayValue: Double? {
        get{
            //interprets string into a double value number
            return NSNumberFormatter().numberFromString(display.text!)?.doubleValue
        }
        set{
            if newValue != nil {
                let numberFormatter = NSNumberFormatter()
                numberFormatter.numberStyle = .DecimalStyle
                numberFormatter.maximumFractionDigits = 5
                display.text = numberFormatter.stringFromNumber(newValue!)
            } else {
                display.text = ""
            }
            userIsTyping = false
            history.text = brain.description + " ="
        }
    }
}