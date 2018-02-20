//
//  AppDelegate.swift
//  TalkTime
//
//  Created by Liam Buchanan on 2/19/18.
//  Copyright © 2018 Liam Buchanan. All rights reserved.
//

import Cocoa

let TIME_INTERVALS: [TimeInterval] = [10, 30, 60, 120, 300]

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    @IBOutlet weak var settingsSlider: NSSlider!
    @IBOutlet weak var settingsSliderLabel: NSTextFieldCell!
    @IBOutlet weak var statusMenu: NSMenu!

    var speechSynth: NSSpeechSynthesizer!
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    var timeElapsed: TimeInterval! = 0
    var timeInterval: TimeInterval! = TIME_INTERVALS[0]
    var timer: Timer!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        statusItem.menu = statusMenu
        statusItem.image = NSImage(named: NSImage.Name(rawValue: "statusIcon"))
        statusItem.image?.isTemplate = true
        settingsSliderLabel.title = String(Int(timeInterval)) + " seconds"
        speechSynth = NSSpeechSynthesizer.init()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        if (timer != nil) {
            timer.invalidate()
        }
    }

    @IBAction func sliderActionReceived(_ sender: NSSlider) {
        timeInterval = TIME_INTERVALS[Int(sender.intValue)]
        settingsSliderLabel.title = String(Int(timeInterval)) + " seconds"
    }

    @IBAction func startClicked(_ sender: NSMenuItem) {
        timer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(timerFired), userInfo: nil, repeats: true)
        speechSynth.startSpeaking("start")
        settingsSlider.isEnabled = false
    }

    @IBAction func stopClicked(_ sender: NSMenuItem) {
        if (timer != nil) {
            timer.invalidate()
        }
        timeElapsed = 0
        settingsSlider.isEnabled = true
    }

    @IBAction func quitClicked(_ sender: NSMenuItem) {
        NSApplication.shared.terminate(self)
    }

    @objc func timerFired() {
        timeElapsed = timeElapsed + timeInterval
        speechSynth.startSpeaking(String(Int(timeElapsed)) + " seconds")
    }
}
