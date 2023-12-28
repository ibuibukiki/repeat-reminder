//
//  SettingListViewModel.swift
//  RepeatReminder
//
//  Created by 吉田郁吹 on 2023/12/28.
//

import Foundation

class SettingListViewModel: ObservableObject {
    @Published var model = SettingList()
    
    init(){
        readTask()
    }
    
    var completedTasks: [Task] {
        return model.completedTasks
    }
    
    var deletedTasks: [Task] {
        return model.deletedTasks
    }
    
    func readTask(){
        model.getCompletedTasks()
        model.getDeletedTasks()
    }
}
