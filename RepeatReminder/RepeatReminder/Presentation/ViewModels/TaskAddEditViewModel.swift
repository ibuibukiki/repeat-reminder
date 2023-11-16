//
//  TaskAddEditViewModel.swift
//  RepeatReminder
//
//  Created by 吉田郁吹 on 2023/11/14.
//

import Foundation
import SwiftUI

class TaskAddEditViewModel: ObservableObject,Identifiable {
    @Published var isEditing: Bool
    
    init(isEditing: Bool){
        self.isEditing = isEditing
    }
    
    @Published var name = ""
    @Published var deadline = Date()
    @Published var isLimitNotified = true
    @Published var isPreNotified = true
    @Published var firstNotifiedNum = 1
    @Published var firstNotifiedRange = "時間"
    @Published var intervalNotifiedNum = 1
    @Published var intervalNotifiedRange = "時間"
}
