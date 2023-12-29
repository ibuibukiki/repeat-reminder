//
//  TaskListView.swift
//  RepeatReminder
//
//  Created by 吉田郁吹 on 2023/11/13.
//

import SwiftUI

struct TaskListView: View {
    @ObservedObject var viewModel = TaskListViewModel()
    
    var body: some View {
        NavigationStack{
            ZStack(alignment:.top){
                Color("BackgroundColor")
                    .edgesIgnoringSafeArea(.all)
                VStack{
                    // 今日までのタスクを表示
                    VStack{
                        Text("今日までのタスク")
                            .foregroundColor(Color("BackgroundColor"))
                            .fontWeight(.bold)
                            .font(.title2)
                            .padding(.top,16)
                            .padding(.bottom,8)
                        ScrollView{
                            VStack(alignment:.leading,spacing:8){
                                ForEach(viewModel.todayTasks.indices, id: \.self) { index in
                                    Text(viewModel.todayTasks[index]).font(.title3)
                                }
                            }
                        }.foregroundColor(Color("TextColor"))
                            .padding()
                            .frame(width:296,height:168,alignment:.topLeading)
                            .background(Color("BackgroundColor"))
                            .cornerRadius(10)
                    }.frame(width:328,height:240,alignment:.top)
                        .background(Color("MainColor"))
                        .cornerRadius(15)
                        .compositingGroup()
                        .shadow(color:.gray,radius:5,x:0,y:8)
                        .padding(.bottom,24)
                    // ボタンを表示
                    HStack(spacing:24){
                        NavigationLink(
                            destination: SettingView()
                        ){
                            Text("設 定")
                                .fontWeight(.bold)
                                .font(.title2)
                                .foregroundColor(Color("ButtonColor"))
                                .frame(width:144,height:56)
                                .background(Color("BackgroundColor"))
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color("ButtonColor"), lineWidth: 4)
                                )
                                .compositingGroup()
                                .shadow(color:.gray,radius:5,x:0,y:8)
                        }
                        NavigationLink(
                            destination: TaskAddEditView(isEditing:false,task:nil)
                        ){
                            Text("追 加")
                                .fontWeight(.bold)
                                .font(.title2)
                                .foregroundColor(Color("BackgroundColor"))
                                .frame(width:144,height:56)
                                .background(Color("ButtonColor"))
                                .cornerRadius(10)
                                .compositingGroup()
                                .shadow(color:.gray,radius:5,x:0,y:8)
                        }
                    }.padding(.bottom,16)
                    // 今後のタスク一覧を表示
                    ScrollView {
                        VStack {
                            ForEach(viewModel.tasks.indices, id: \.self) { index in
                                let task = viewModel.tasks[index]
                                HStack(spacing:8){
                                    // タスクの情報を表示
                                    TaskCell(task:task)
                                    // ボタンを表示
                                    ClearButton(task:task,viewModel:viewModel)
                                }
                            }
                        }.padding(.leading,8)
                    }
                }.padding(.top,32)
            }.onAppear {
                viewModel.readTask()
            }
        }
    }
}

#Preview {
    TaskListView()
}
