//
//  SettingViewModel.swift
//  RepeatReminder
//
//  Created by 吉田郁吹 on 2023/12/28.
//

import Foundation

class SettingViewModel: ObservableObject {
    var db: DB!
    
    init() {
        self.db = DB.shared
    }
    
    
}
