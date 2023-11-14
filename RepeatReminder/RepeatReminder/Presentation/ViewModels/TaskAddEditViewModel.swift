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
    
}
