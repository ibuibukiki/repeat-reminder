//
//  RepeatReminderApp.swift
//  RepeatReminder
//
//  Created by 吉田郁吹 on 2023/11/05.
//

import SwiftUI

@main
struct RepeatReminderApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            TaskListView()
        }
    }
}
