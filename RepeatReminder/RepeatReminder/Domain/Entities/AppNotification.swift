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
    var delay: Int
    var isLimit: Bool
    
    init(notificationId: String, taskId: String, delay: Int, isLimit: Bool) {
        self.notificationId = notificationId
        self.taskId = taskId
        self.delay = delay
        self.isLimit = isLimit
    }
}
