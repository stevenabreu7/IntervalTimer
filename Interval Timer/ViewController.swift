//
//  ViewController.swift
//  Interval Timer
//
//  Created by Steven Abreu on 13/01/2017.
//  Copyright © 2017 stevenabreu. All rights reserved.
//

// active input not a number

import UIKit
import AVFoundation

class ViewController: UIViewController {

    var active = true
    var paused = true
    
    var atime = 0.0
    var rtime = 0.0
    
    var timer = Timer()
    var timerStart = Date()
    
    var time = 0.0
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBOutlet weak var activeInput: UITextField!
    @IBOutlet weak var restInput: UITextField!
    @IBOutlet weak var activeStepper: UIStepper!
    @IBOutlet weak var restStepper: UIStepper!
    
    @IBOutlet weak var endCircle: UIView!
    @IBOutlet weak var startCircle: UIView!
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var activityLabel: UILabel!
    
    @IBOutlet weak var progressCircle: CircleProgressView!
    
    @IBOutlet weak var startButton: UIButton!
    
    
    @IBAction func activeStepperChanged(_ sender: Any) {
        atime = activeStepper.value
        time = atime
        activeInput.text = String(Int(atime))
        timerLabel.text = String(Int(atime))
        progressCircle.progress = 1
    }
    
    @IBAction func restStepperChanged(_ sender: Any) {
        rtime = restStepper.value
        restInput.text = String(Int(rtime))
    }
    
    @IBAction func pauseTimer(_ sender: AnyObject) {
        paused = !paused
        //disable steppers when timer running
        if !paused {
            activeStepper.isUserInteractionEnabled = false
            restStepper.isUserInteractionEnabled = false
        }
    }
    
    @IBAction func endTimer(_ sender: AnyObject) {
        paused = true
        active = true
        //enable steppers when timer is ended
        activeStepper.isUserInteractionEnabled = true
        restStepper.isUserInteractionEnabled = true
        
        setActive()
        
        progressCircle.progress = 1
        timerLabel.text = String(Int(time))
    }
    
    
    func update() {
        if paused {
            if active {
                progressCircle.progress = time / atime
            } else {
                progressCircle.progress = time / rtime
            }
            return
        }
        
        time -= 1
        
        //switch active to rest, vice versa
        if time < 0 {
            active = !active
            progressCircle.progress = 1
            vibrate()
            if active {
                setActive()
            } else {
                setRest()
            }
        }
        
        //set progress circle
        if active {
            progressCircle.setProgress(time/atime, animated: true)
        } else {
            progressCircle.setProgress(time/rtime, animated: true)
        }
        
        //set timer label inside circle
        timerLabel.text = String(Int(time))
    }
    
    func setActive() {
        time = atime
        activityLabel.text = "ACTIVE"
    }
    
    func setRest() {
        time = rtime
        activityLabel.text = "REST"
    }
    
    func vibrate() {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //initial
        atime = Double(activeInput.text!)!
        rtime = Double(restInput.text!)!
        time = atime
        timerLabel.text = String(Int(atime))
        
        //UI
        startCircle.layer.cornerRadius = UIScreen.main.bounds.width * 0.15
        endCircle.layer.cornerRadius = startCircle.layer.cornerRadius
        startCircle.layer.borderColor = UIColor.white.cgColor
        endCircle.layer.borderColor = UIColor.white.cgColor
        
        //timer
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(update), userInfo: nil, repeats: true)
    }
}

