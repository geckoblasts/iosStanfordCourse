//
//  GraphViewController.swift
//  StackCalculator
//
//  Created by Jacob Grud Mulvad on 09/08/15.
//  Copyright (c) 2015 Jacob Mulvad. All rights reserved.
//

import Foundation
import UIKit

class GraphViewController: UIViewController, GraphViewDataSource {
    
    //model:
    private var brain = CalculatorBrain()
    
    typealias PropertyList = AnyObject
    var program: PropertyList {
        get {
            return brain.program
        }
        set {
            brain.program = newValue
        }
    }
    
    @IBOutlet weak var graphView: GraphView! {
        didSet {
            graphView.dataSource = self
        }
    }
    
    func y(x: CGFloat) -> CGFloat? {
        brain.variableValues["M"] = Double(x)
        if let y = brain.evaluate() {
            return CGFloat(y)
        }
        return nil
    }
}