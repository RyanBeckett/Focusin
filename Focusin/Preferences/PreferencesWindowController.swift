//
//  PreferencesWindowController.swift
//  Pomodoro
//
//  Created by Ryan Beckett on 29/4/20.
//  Copyright © 2020 Ryan Beckett. All rights reserved.
//

import Cocoa
import ServiceManagement

/* The delegate must implement the methods to take action for the new preferences */
protocol PreferencesDelegate {
    func preferencesDidUpdate()
}

class PreferencesWindowController: NSWindowController, NSWindowDelegate {
    
    var delegate: PreferencesDelegate?
    let defaults = UserDefaults.standard
    
    @IBOutlet weak var pomodoroDuration: NSTextField!
    @IBOutlet weak var shortBreakDuration: NSTextField!
    @IBOutlet weak var longBreakAfterXPomodoros: NSTextField!
    @IBOutlet weak var targetPomodoros: NSTextField!
    @IBOutlet weak var showNotifications: NSButton!
    @IBOutlet weak var showTimeInBar: NSButton!
    @IBOutlet weak var startAtLogin: NSButton!
    @IBOutlet weak var longBreadDuration: NSTextField!
    var closedWithButton: Bool = false
    let seconds: Int = 60
    
    let errorTitle = "Invalid value"
    let buttonTitle = "Ok"
    let errorPomodoro = "Pomodoro duration must be between 1 - 60"
    let errorBreak = "Break durations must be between 1 - 60"
    let errorTarget = "Target pomodoros must be between 1 - 99"
    let errorLongBreak = "Long break must be set between 1 - 99"
    
    let MIN_TIME = 1
    let MAX_TIME = 60
    let MIN_TARGET = 1
    let MAX_TARGET = 99
    
    override func windowDidLoad() {
        super.windowDidLoad()
        self.window?.center()
        self.window?.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
        loadPreferredSettings()
    }
    
    override var windowNibName: NSNib.Name {
        return NSNib.Name(rawValue: "PreferencesWindowController")
    }
    
    func loadPreferredSettings() {
        pomodoroDuration.integerValue = defaults.integer(forKey: Defaults.pomodoroKey)/seconds
        shortBreakDuration.integerValue = defaults.integer(forKey: Defaults.shortBreakKey)/seconds
        longBreadDuration.integerValue = defaults.integer(forKey: Defaults.longBreakKey)/seconds
        targetPomodoros.integerValue = defaults.integer(forKey: Defaults.targetKey)
        longBreakAfterXPomodoros.integerValue = defaults.integer(forKey: Defaults.longBreakAfterXPomodoros)
        showNotifications.state = NSControl.StateValue(rawValue: defaults.integer(forKey: Defaults.showNotificationsKey))
        showTimeInBar.integerValue = defaults.integer(forKey: Defaults.showTimeKey)
        startAtLogin.integerValue = defaults.integer(forKey: Defaults.startAtLogin)
    }
    
    
    /* Show an alert to the user */
    func dialogError(_ text: String) -> Bool {
        let alertDialogError: NSAlert = NSAlert()
        alertDialogError.messageText = errorTitle
        alertDialogError.informativeText = text
        alertDialogError.alertStyle = NSAlert.Style.warning
        alertDialogError.addButton(withTitle: buttonTitle)
        alertDialogError.runModal()
        return false
    }
    
    func windowShouldClose(_ sender: NSWindow) -> Bool {
        if !isValidSettings(){
            return false
        }
        saveSettings()
        delegate?.preferencesDidUpdate()
        return true
    }
    
    func isValidSettings() -> Bool{
        if(pomodoroDuration.integerValue < MIN_TIME || pomodoroDuration.integerValue > MAX_TIME) {
            return dialogError(errorPomodoro)
        } else if(shortBreakDuration.integerValue < MIN_TIME || shortBreakDuration.integerValue > MAX_TIME) {
            return dialogError(errorBreak)
        } else if(longBreadDuration.integerValue < MIN_TIME || longBreadDuration.integerValue > MAX_TIME) {
            return dialogError(errorBreak)
        } else if(targetPomodoros.integerValue < MIN_TARGET || targetPomodoros.integerValue > MAX_TARGET) {
            return dialogError(errorTarget)
        } else if(longBreakAfterXPomodoros.integerValue < MIN_TARGET || longBreakAfterXPomodoros.integerValue > MAX_TARGET) {
            return dialogError(errorLongBreak)
        }
        return true
    }
    
    func saveSettings() {
        defaults.setValue(pomodoroDuration.integerValue * seconds, forKey: Defaults.pomodoroKey)
        defaults.setValue(shortBreakDuration.integerValue * seconds, forKey: Defaults.shortBreakKey)
        defaults.setValue(longBreadDuration.integerValue * seconds, forKey: Defaults.longBreakKey)
        defaults.setValue(longBreakAfterXPomodoros.integerValue, forKey: Defaults.longBreakAfterXPomodoros)
        defaults.setValue(targetPomodoros.integerValue, forKey: Defaults.targetKey)
        defaults.setValue(showNotifications.state, forKey: Defaults.showNotificationsKey)
        defaults.setValue(showTimeInBar.state, forKey: Defaults.showTimeKey)
        defaults.setValue(startAtLogin.state, forKey: Defaults.startAtLogin)
        
        let launcherAppIdentifier = "com.albertoquesada.LauncherApplication"
        SMLoginItemSetEnabled(launcherAppIdentifier as CFString, startAtLogin.state == NSControl.StateValue.on)
    }
    
    
}
