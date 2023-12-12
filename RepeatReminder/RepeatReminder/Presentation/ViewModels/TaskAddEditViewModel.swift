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
    @Published var task: Task
    
    init(isEditing: Bool){
        self.isEditing = isEditing
        self.task = Task(taskId:UUID().uuidString,name:"",deadline:Date(),
                          isLimitNotified:true,isPreNotified:true,
                          firstNotifiedNum:1,firstNotifiedRange:"時間",
                          intervalNotifiedNum:1,intervalNotifiedRange: "時間",
                          isCompleted:false,isDeleted:false)
    }
}
