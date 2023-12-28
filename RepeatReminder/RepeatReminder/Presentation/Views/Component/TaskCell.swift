//
//  TaskCell.swift
//  RepeatReminder
//
//  Created by 吉田郁吹 on 2023/11/13.
//

import SwiftUI

struct TaskCell: View {
    @ObservedObject var viewModel=TaskCellViewModel()
    
    init(task: Task) {
        viewModel.setTask(task:task)
    }
    
    var body: some View {
        HStack(spacing:8){
            // タスクの情報を表示
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
            // ボタンを表示
            VStack(spacing:4){
                ZStack {
                    NavigationLink(
                        destination: TaskAddEditView(isEditing:true,task:viewModel.task)
                    ){ EmptyView() }.opacity(0)
                    Image(systemName:"pencil.circle")
                        .foregroundColor(Color("ButtonColor"))
                        .font(.system(size:48))
                }
                Button(action:{
                    print("tap clear button")
                }){
                    Image(systemName:"checkmark.circle.fill")
                        .foregroundColor(Color("ButtonColor"))
                        .font(.system(size:48))
                }
            }
        }.background(Color("BackgroundColor"))
    }
}

#Preview {
    TaskListView()
}
