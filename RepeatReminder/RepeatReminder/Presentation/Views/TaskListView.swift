//
//  TaskListView.swift
//  RepeatReminder
//
//  Created by 吉田郁吹 on 2023/11/13.
//

import SwiftUI

struct TaskListView: View {
    var body: some View {
        ZStack{
            Color("BackgroundColor")
                .edgesIgnoringSafeArea(.all)
            Text("Color test")
                .foregroundColor(Color("TextColor"))
        }
    }
}

#Preview {
    TaskListView()
}
