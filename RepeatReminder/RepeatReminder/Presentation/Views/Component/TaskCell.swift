//
//  TaskCell.swift
//  RepeatReminder
//
//  Created by 吉田郁吹 on 2023/11/13.
//

import SwiftUI

struct TaskCell: View {
    @ObservedObject var viewModel = TaskCellViewModel()
    
    init(task: Task) {
        viewModel.setTask(task:task)
    }
    
    var body: some View {
        HStack{
            HStack(spacing:4){
                viewModel.remainingNumText
                Text(viewModel.remainingText)
                    .padding(.top,32)
                    .padding(.bottom,4)
            }
            .foregroundColor(Color("BackgroundColor"))
            .fontWeight(.bold)
            .padding(.leading,4)
            .frame(width:96)
            VStack(alignment:.leading,spacing:8){
                Text(viewModel.name)
                Text(viewModel.deadline)
            }.foregroundColor(Color("TextColor"))
                .padding(.leading,8)
                .padding(.trailing,8)
                .frame(width:160,height:88)
                .background(Color("BackgroundColor"))
                .cornerRadius(10)
        }.frame(width:272,height:96)
            .background(Color("MainColor"))
            .cornerRadius(15)
            .compositingGroup()
            .shadow(color:.gray,radius:5,x:0,y:8)
    }
}

#Preview {
    TaskListView()
}
