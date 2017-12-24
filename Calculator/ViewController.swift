//
//  ViewController.swift
//  Calculator
//
//  Created by Sai on 01/07/17.
//  Copyright © 2017 Sai. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var display: UILabel!
    var btnSound:AVAudioPlayer!
    
    var userIsInTheMiddleOfTyping=false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let path = Bundle.main.path(forResource: "btn", ofType: "wav")
        let soundUrl = URL(fileURLWithPath: path!)
        
        do{
            try btnSound = AVAudioPlayer(contentsOf: soundUrl)
            btnSound.prepareToPlay()
            print("yo")
        }catch let err as NSError {
            print(err.debugDescription)
        }
        
    }
    
    @IBAction func touchDigit(_ sender: UIButton) {
        playSound()
        let digit = sender.currentTitle! //optional string
        if userIsInTheMiddleOfTyping {
            let textCurrentlyInDisplay = display.text!
            display.text=textCurrentlyInDisplay+digit
        }else{
            display.text=digit
            userIsInTheMiddleOfTyping=true
        }
    }
    
    func playSound(){
        if btnSound.isPlaying{
            btnSound.stop()
        }
        btnSound.play()
    }
    
    var displayValue: Double{
        get{
            return Double(display.text!)!
        }
        set{
            display.text = String(newValue)
        }
    }

    
    private var brain=CalculatorBrain()
    
    @IBAction func performOperation(_ sender: UIButton) {
        if userIsInTheMiddleOfTyping {
            brain.setOperand(displayValue)
            userIsInTheMiddleOfTyping=false
        }
        
        if let mathematicalSymbol=sender.currentTitle{
            brain.performOperation(mathematicalSymbol)
        }
        if let result=brain.result{
            displayValue=result
        }
        

    }

}

