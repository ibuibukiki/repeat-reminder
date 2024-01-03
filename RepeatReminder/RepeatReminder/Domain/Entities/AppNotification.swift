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
    var datetime: Date
    var isLimit: Bool
    
    init(notificationId: String, taskId: String, datetime: Date, isLimit: Bool) {
        self.notificationId = notificationId
        self.taskId = taskId
        self.datetime = datetime
        self.isLimit = isLimit
    }
}
