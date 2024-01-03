//
//  AppNotification.swift
//  RepeatReminder
//
//  Created by 吉田郁吹 on 2024/01/02.
//

import Foundation

struct AppNotification {
    var notificationId: String
    var taskId: String
    
    init(notificationId: String, taskId: String) {
        self.notificationId = notificationId
        self.taskId = taskId
    }
}
